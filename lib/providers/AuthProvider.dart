import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:monitor_lizard/models/Employee.dart';
import 'package:monitor_lizard/models/Organization.dart';
import 'package:monitor_lizard/services/authService.dart';
import 'package:monitor_lizard/services/employeeService.dart';
import 'package:monitor_lizard/services/organizationService.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  String authState = "signIn";
  bool signUpComplete = false;
  String firstName_ = "";
  String lastName_ = "";
  UserCredential? currentUser;
  AuthService authService = AuthService();
  EmployeeService employeeService = EmployeeService();
  OrganizationService organizationService = OrganizationService();

  setAuthState(String state) {
    authState = state;
    notifyListeners();
  }

  Future<String> registerUser(
      String firstName, String lastName, String email, String password) async {
    String signUpErrors =
        await authService.signUpWithEmailPassword(email, password);

    if (signUpErrors != "") {
      print("111111111111111111111111111111111");
      print(signUpErrors);
      return signUpErrors;
    }

    firstName_ = firstName;
    lastName_ = lastName;

    await authService.signInWithEmailPassword(email, password);
    await authService.editCredentials(firstName: firstName, lastName: lastName);

    notifyListeners();
    return "";
  }

  Future setUserOrganization(String code) async {
    Organization? organization =
        await organizationService.getOrganizationByCode(code);
    if (organization == null) {
      return "Invalid organization code entered";
    }

    print("Organization is: $organization");

    List<String> name =
        FirebaseAuth.instance.currentUser!.displayName!.split(" ");

    Employee newUser = Employee(
        uid: FirebaseAuth.instance.currentUser?.uid ?? "",
        firstName: name[0],
        lastName: name[1],
        isVerified: false,
        email: FirebaseAuth.instance.currentUser?.email ?? "",
        organizationId: organization.uid);

    String errors = await employeeService.addEmployee(newUser);

    if (errors != "") {
      return "Failed to add user to organization";
    }

    authState = "authenticated";

    notifyListeners();
    return "";
  }
}
