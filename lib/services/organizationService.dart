import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitor_lizard/models/Organization.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrganizationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference organizationRef =
      FirebaseFirestore.instance.collection("organization");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Read Organization
  Future getOrganization(String organizationId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection("organization").doc(organizationId).get();

      if (snapshot.exists) {
        print("!#_____Retrieved organization_____#!");
        return Organization.fromDocumentSnapshot(snapshot);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Get organization by code
  Future getOrganizationByCode(String organizationCode) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("organization")
          .where("uniqueCode", isEqualTo: organizationCode)
          .get();

      if (snapshot.docs[0].exists) {
        print("!#_____Retrieved organization_____#!");
        return Organization.fromDocumentSnapshot(snapshot.docs[0]);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
