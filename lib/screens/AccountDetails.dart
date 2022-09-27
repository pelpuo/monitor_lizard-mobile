import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/components/AccountDetailsField.dart';
import 'package:monitor_lizard/components/AppButton.dart';
import 'package:monitor_lizard/constants/colors.dart';

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(color: AppColors.green, fontSize: 16),
                      )),
                ),
                AccountDetailsField(
                    prompt: "First Name", fieldController: firstNameController),
                const SizedBox(
                  height: 12,
                ),
                AccountDetailsField(
                    prompt: "Last Name", fieldController: lastNameController),
                const SizedBox(
                  height: 12,
                ),
                AccountDetailsField(
                    prompt: "Email", fieldController: emailController),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  "Careful! Only edit your password if you feel your account has been compromised",
                  style: TextStyle(color: AppColors.pink, fontSize: 14),
                ),
                const SizedBox(
                  height: 12,
                ),
                AccountDetailsField(
                    prompt: "Password", fieldController: passwordController),
                const SizedBox(
                  height: 12,
                ),
                AccountDetailsField(
                    prompt: "Confirm Password",
                    fieldController: confirmPasswordController),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ));
  }
}
