import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String uid;
  String organizationId;
  String firstName;
  String lastName;
  String email;
  bool isVerified;

  Employee(
      {required this.uid,
      required this.organizationId,
      required this.firstName,
      required this.email,
      required this.isVerified,
      required this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'organizationId': organizationId,
      'firstName': firstName,
      'email': email,
      'lastName': lastName,
      'isVerified': isVerified
    };
  }

  Employee.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        firstName = map["firstName"],
        lastName = map["lastName"],
        email = map["email"],
        isVerified = map["isVerified"],
        organizationId = map["organizationId"];

  Employee.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        firstName = doc.data()!["firstName"],
        lastName = doc.data()!["lastName"],
        email = doc.data()!["email"],
        isVerified = doc.data()!["isVerified"],
        organizationId = doc.data()!["organizationId"];
}
