import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  String uid;
  String name;
  String industry;
  String country;
  String uniqueCode;
  Timestamp startingTime;
  Timestamp closingTime;
  GeoPoint location;

  Organization(
      {required this.uid,
      required this.name,
      required this.industry,
      required this.country,
      required this.uniqueCode,
      required this.startingTime,
      required this.closingTime,
      required this.location});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'industry': industry,
      'country': country,
      'startingTime': startingTime,
      'closingTime': closingTime,
      'location': location,
    };
  }

  Organization.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        name = map["name"],
        industry = map["industry"],
        country = map["country"],
        uniqueCode = map["uniqueCode"],
        startingTime = map["startingTime"],
        closingTime = map["closingTime"],
        location = map["location"];

  Organization.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        name = doc.data()!["name"],
        industry = doc.data()!["industry"],
        country = doc.data()!["country"],
        uniqueCode = doc.data()!["uniqueCode"],
        startingTime = doc.data()!["startingTime"],
        closingTime = doc.data()!["closingTime"],
        location = doc.data()!["location"];
}
