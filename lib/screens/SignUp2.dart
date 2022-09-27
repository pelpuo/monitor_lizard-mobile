import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/components/AppButton.dart';
import 'package:monitor_lizard/components/RegistrationTextField.dart';
import 'package:monitor_lizard/components/mySnackbar.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:monitor_lizard/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key}) : super(key: key);

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final formKey = GlobalKey<FormState>();
  TextEditingController uniqueCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<AuthProvider>(
      builder: (context, auth, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Column(
          children: [
            Expanded(
                child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sign Up",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Enter your oraganization's unique code",
                      style: TextStyle(fontSize: 16, color: AppColors.gray)),
                  const SizedBox(height: 16),
                  RegistrationTextField(
                      textController: uniqueCodeController,
                      validator: (String value) {
                        if (value.trim() == "") {
                          return 'This field must be filled';
                        } else {
                          return null;
                        }
                      },
                      hintText: "Unique code",
                      onPressed: () {}),
                  const SizedBox(height: 12),
                ],
              ),
            )),
            AppButton(
              prompt: "Create Account",
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                String errors = await auth
                    .setUserOrganization(uniqueCodeController.text.trim());

                if (errors != "") {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(mySnackbar(errors));
                  return;
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 16, color: AppColors.gray),
                ),
                TextButton(
                    onPressed: () {
                      auth.setAuthState("signIn");
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: AppColors.green, fontSize: 16),
                    ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
