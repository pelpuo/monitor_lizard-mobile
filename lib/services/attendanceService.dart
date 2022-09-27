import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitor_lizard/constants/states.dart';
import 'package:monitor_lizard/models/Attendance.dart';
import 'package:monitor_lizard/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference employeeRef =
      FirebaseFirestore.instance.collection("attendance");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create attendance log
  Future<String> addAttendanceLog(
      Attendance attendanceData, DateTime date) async {
    String id =
        "${date.day}-${date.month}-${date.year}_${_auth.currentUser?.uid ?? "0"}";
    try {
      await _firestore
          .collection("attendance")
          .doc(id)
          .set(attendanceData.toMap());

      print("!#_____Added New Attendance log_____#!");
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> logEndTime(DateTime endTime, DateTime date) async {
    String id =
        "${date.day}-${date.month}-${date.year}_${_auth.currentUser?.uid ?? "0"}";
    try {
      await _firestore.collection("attendance").doc(id).update({
        "endTime": Timestamp.fromDate(endTime),
        "status": EmployeeStates.OUT_OF_OFFICE
      });

      print("!#_____Logged End time_____#!");
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  // Check Attendance log
  checkAttendanceLog(DateTime date) async {
    try {
      String id =
          "${date.day}-${date.month}-${date.year}_${_auth.currentUser?.uid ?? "0"}";

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("attendance").doc(id).get();
      // Attendance attendanceData = Attendance.fromDocumentSnapshot(snapshot);
      // return attendanceData;
      if (snapshot.exists) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
  }

  // Read Attendance log
  getAttendanceLog(DateTime date) async {
    try {
      String id =
          "${date.day}-${date.month}-${date.year}_${_auth.currentUser?.uid ?? "0"}";

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("attendance").doc(id).get();
      Attendance attendanceData = Attendance.fromDocumentSnapshot(snapshot);
      return attendanceData;
    } catch (e) {
      print(e.toString());
    }
  }

  // Read Attendance log
  getAllAttendanceLogs() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("attendance")
          .where("employeeId", isEqualTo: _auth.currentUser?.uid ?? "0")
          .get();

      List<Attendance> attendanceData = snapshot.docs
          .map((docSnapshot) => Attendance.fromDocumentSnapshot(docSnapshot))
          .toList();

      print("Number of attendance logs is ${attendanceData.length}");
      return attendanceData;
    } catch (e) {
      print(e.toString());
    }
  }
}
