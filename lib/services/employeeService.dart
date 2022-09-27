import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monitor_lizard/models/Employee.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference employeeRef =
      FirebaseFirestore.instance.collection("employee");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create employee
  Future<String> addEmployee(Employee employee) async {
    try {
      await _firestore
          .collection("employee")
          .doc(_auth.currentUser!.uid)
          .set(employee.toMap());

      print("!#_____Added New Employee_____#!");
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  // Read Employee
  getEmployee() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("employee")
          .doc(_auth.currentUser!.uid)
          .get();
      Employee employee = Employee.fromDocumentSnapshot(snapshot);
      return employee;
    } catch (e) {
      print(e.toString());
    }
  }

  // Update Employee/User
}
