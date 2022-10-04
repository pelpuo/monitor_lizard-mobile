import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:monitor_lizard/components/AccountDetailsField.dart';
import 'package:monitor_lizard/components/AppButton.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:monitor_lizard/providers/AttendanceProvider.dart';
import 'package:provider/provider.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({Key? key}) : super(key: key);

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  TextEditingController firstNameController =
      TextEditingController(text: "John");
  TextEditingController lastNameController = TextEditingController(text: "Doe");
  TextEditingController emailController =
      TextEditingController(text: "jdoe@example.com");
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: const Text(
            "Account Details",
          ),
          centerTitle: true,
          foregroundColor: AppColors.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<AttendanceProvider>(
          builder: (context, attendance, child) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo_lg.png",
                    width: 96,
                  ),
                  const Text("Monitor Lizard",
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    "User Details",
                    style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AccountDetailsField(
                      prompt: "First Name:",
                      value: attendance.employee?.firstName ?? ""),
                  AccountDetailsField(
                      prompt: "Last Name:",
                      value: attendance.employee?.lastName ?? ""),
                  AccountDetailsField(
                      prompt: "email:",
                      value: attendance.employee?.email ?? ""),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    "Organization Details",
                    style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AccountDetailsField(
                      prompt: "Organization Name:",
                      value: attendance.organization?.name ?? ""),
                  AccountDetailsField(
                      prompt: "Industry:",
                      value: attendance.organization?.industry ?? ""),
                  AccountDetailsField(
                      prompt: "Country:",
                      value: attendance.organization?.country ?? ""),
                  AccountDetailsField(
                      prompt: "Start Time:",
                      value: DateFormat('HH:mm').format(
                          attendance.organization?.startingTime.toDate() ??
                              DateTime.now())),
                  AccountDetailsField(
                      prompt: "Closing Time:",
                      value: DateFormat('HH:mm').format(
                          attendance.organization?.closingTime.toDate() ??
                              DateTime.now())),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    "Organization Code",
                    style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AccountDetailsField(
                      prompt: "Organization Code:",
                      value: attendance.organization?.uniqueCode ?? ""),
                ],
              ),
            ),
          ),
        ));
  }
}
