import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:monitor_lizard/constants/states.dart';
import 'package:monitor_lizard/models/Attendance.dart';
import 'package:monitor_lizard/models/Employee.dart';
import 'package:monitor_lizard/models/Organization.dart';
import 'package:monitor_lizard/services/attendanceService.dart';
import 'package:monitor_lizard/services/authService.dart';
import 'package:monitor_lizard/services/employeeService.dart';
import 'package:monitor_lizard/services/organizationService.dart';
import 'package:location/location.dart';

class AttendanceProvider extends ChangeNotifier {
  Employee? employee;
  Organization? organization;
  Attendance? currentLog;
  List<Attendance> allLogs = [];
  AuthService authService = AuthService();
  EmployeeService employeeService = EmployeeService();
  OrganizationService organizationService = OrganizationService();
  AttendanceService attendanceService = AttendanceService();
  DateTime currentTime = DateTime.now();
  bool runningLate = false;
  bool atWork = false;

  double distanceToOffice = 0;

  Location location = Location();
  LocationData? userLocation;

  double timePercentage = 0;

  bool isWorkingHours = false;

  retrieveEmployeeData() async {
    try {
      employee = await employeeService.getEmployee();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  retrieveOrganizationData() async {
    try {
      organization = await organizationService
          .getOrganization(employee?.organizationId ?? "");
      print(organization);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Time Related
  trackTime() async {
    try {
      DateTime startTime =
          organization?.startingTime.toDate() ?? DateTime.now();
      DateTime closingTime =
          organization?.closingTime.toDate() ?? DateTime.now();
      calculatePercentage(startTime, closingTime, currentTime, isWorkingHours);

      Timer.periodic(const Duration(seconds: 10), (timer) {
        currentTime = DateTime.now();

        checkIsWorkingHours(startTime, closingTime, currentTime);
        calculatePercentage(
            startTime, closingTime, currentTime, isWorkingHours);
        print("Time percentage: $timePercentage");
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  checkIsWorkingHours(DateTime startTime, DateTime endTime, DateTime now) {
    if (((now.hour > startTime.hour) ||
            (now.hour == startTime.hour && now.minute >= startTime.minute)) &&
        ((now.hour < endTime.hour) ||
            (now.hour == endTime.hour && now.minute <= endTime.minute))) {
      isWorkingHours = true;
      print("This was true");
    } else {
      isWorkingHours = false;
      print("This was false");
    }
    notifyListeners();
  }

  calculatePercentage(
      DateTime startTime, DateTime endTime, DateTime now, bool isWorkingHours) {
    int nowMinutes = now.hour * 60 + now.minute;
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    int dayMinutes = 24 * 60;

    if (isWorkingHours) {
      timePercentage =
          (nowMinutes - startMinutes) / (endMinutes - startMinutes);
    } else {
      int worklessHours = dayMinutes - (endMinutes - startMinutes);

      if (nowMinutes > endMinutes) {
        int timeAfterWork = nowMinutes - endMinutes;
        timePercentage = timeAfterWork / worklessHours;
      } else if (nowMinutes < startMinutes) {
        int timeBeforeWork = (dayMinutes - endMinutes) + nowMinutes;
        timePercentage = timeBeforeWork / worklessHours;
      }
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Location Related
  trackUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      location.onLocationChanged.listen((LocationData currentLocation) {
        userLocation = currentLocation;
        print(
            "User Location: (${userLocation!.latitude}, ${userLocation!.longitude})");

        // Other location related activities;
        print(
            "Organization Location: (${organization?.location.latitude}:${organization?.location.longitude}})");
        double dist = _coordinateDistance(
            organization?.location.latitude ?? 0,
            organization?.location.longitude ?? 0,
            userLocation?.latitude ?? 0,
            userLocation?.longitude ?? 0);
        distanceToOffice = double.parse(dist.toStringAsFixed(2));
        print("Distanct to office: $distanceToOffice");

        // Check for when user is at office
        int distanceThresholdInMetres = 80;
        logAttendance(distanceThresholdInMetres / 1000);
        if (distanceToOffice < distanceThresholdInMetres / 1000) {
          atWork = true;
        } else if (distanceToOffice > distanceThresholdInMetres / 1000 &&
            isWorkingHours) {
          if (currentLog == null) {
            runningLate = true;
          }
          atWork = false;
          print("User is running late");
        } else {
          runningLate = false;
        }

        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  checkCurrentLogExists() async {
    try {
      currentLog = await attendanceService.getAttendanceLog(DateTime.now());
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  logAttendance(double distanceThreshold) async {
    // If user has reached office, check if they have an attendance log for that day,
    //otherwise create one with data from that day
    if (currentLog != null) {
      print("There is a log in firebase");
    }

    if (distanceToOffice <= distanceThreshold && currentLog == null) {
      print("User has reached office");
      // Create Log for day:
      Attendance newLog = Attendance(
          uid: "",
          employeeId: FirebaseAuth.instance.currentUser!.uid,
          organizationId: organization?.uid ?? "",
          date: Timestamp.fromDate(currentTime),
          startTime: Timestamp.fromDate(currentTime),
          endTime: Timestamp.fromDate(currentTime),
          status: EmployeeStates.IN_OFFICE);
      currentLog = newLog;
      await attendanceService.addAttendanceLog(newLog, currentTime);
    } else if (distanceToOffice > distanceThreshold &&
        currentLog?.status == EmployeeStates.IN_OFFICE) {
      print("User has left office");
      await attendanceService.logEndTime(currentTime, currentTime);
      currentLog?.endTime = Timestamp.fromDate(currentTime);
      currentLog?.status = EmployeeStates.OUT_OF_OFFICE;
    }
    notifyListeners();
  }

  retrieveAllLogs() async {
    List<Attendance>? temp = await attendanceService.getAllAttendanceLogs();
    if (temp != null) {
      allLogs = temp;
    }
    notifyListeners();
  }
}
