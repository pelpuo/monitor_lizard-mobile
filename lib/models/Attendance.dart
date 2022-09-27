import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  String uid;
  String employeeId;
  String organizationId;
  Timestamp date;
  Timestamp startTime;
  Timestamp endTime;
  String status;

  Attendance(
      {required this.uid,
      required this.employeeId,
      required this.organizationId,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'employeeId': employeeId,
      'employeeId': organizationId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }

  Attendance.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        employeeId = map["employeeId"],
        organizationId = map["organizationId"],
        date = map["date"],
        startTime = map["startTime"],
        endTime = map["endTime"],
        status = map["status"];

  Attendance.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        employeeId = doc.data()!["employeeId"],
        organizationId = doc.data()!["organizationId"],
        date = doc.data()!["date"],
        startTime = doc.data()!["startTime"],
        endTime = doc.data()!["endTime"],
        status = doc.data()!["status"];
}
