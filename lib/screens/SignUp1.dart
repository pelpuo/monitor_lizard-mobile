import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/components/AppButton.dart';
import 'package:monitor_lizard/components/RegistrationTextField.dart';
import 'package:monitor_lizard/components/mySnackbar.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:monitor_lizard/providers/AuthProvider.dart';
import 'package:monitor_lizard/services/authService.dart';
import 'package:provider/provider.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({Key? key}) : super(key: key);

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
                  const Text("Sign In",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 16,
                  ),
                  RegistrationTextField(
                      textController: firstNameController,
                      hintText: "First Name",
                      validator: (String value) {
                        if (value.trim() == "") {
                          return 'This field must be filled';
                        } else {
                          return null;
                        }
                      },
                      onPressed: () {}),
                  const SizedBox(height: 12),
                  RegistrationTextField(
                      textController: lastNameController,
                      hintText: "Last Name",
                      validator: (String value) {
                        if (value.trim() == "") {
                          return 'This field must be filled';
                        } else {
                          return null;
                        }
                      },
                      onPressed: () {}),
                  const SizedBox(height: 12),
                  RegistrationTextField(
                      textController: emailController,
                      hintText: "Email",
                      validator: (String value) {
                        if (value.trim() == "") {
                          return 'This field must be filled';
                        } else {
                          return null;
                        }
                      },
                      onPressed: () {}),
                  const SizedBox(height: 12),
                  RegistrationTextField(
                      textController: passwordController,
                      hintText: "Password",
                      validator: (String value) {
                        if (value.trim() == "") {
                          return 'This field must be filled';
                        } else {
                          return null;
                        }
                      },
                      hideText: true,
                      onPressed: () {}),
                  const SizedBox(height: 12),
                  RegistrationTextField(
                      textController: confirmPasswordController,
                      hintText: "Confirm Password",
                      validator: (String value) {
                        if (value.trim() == "") {
                          return 'This field must be filled';
                        } else {
                          return null;
                        }
                      },
                      hideText: true,
                      onPressed: () {}),
                ],
              ),
            )),
            AppButton(
              prompt: "Sign Up",
              onPressed: () async {
                final isValid = formKey.currentState!.validate();
                if (!isValid) {
                  return;
                }

                if (passwordController.text.trim() !=
                    confirmPasswordController.text.trim()) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(mySnackbar("Passwords do not match"));
                  return;
                }

                final registerErrors = await auth.registerUser(
                    firstNameController.text.trim(),
                    lastNameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim());

                if (registerErrors != "") {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(mySnackbar(registerErrors));
                  return;
                } else {
                  auth.setAuthState("signUp2");
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
