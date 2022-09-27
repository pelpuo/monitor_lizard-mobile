import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monitor_lizard/components/AppButton.dart';
import 'package:monitor_lizard/components/RegistrationTextField.dart';
import 'package:monitor_lizard/components/mySnackbar.dart';
import 'package:monitor_lizard/constants/colors.dart';
import 'package:monitor_lizard/providers/AttendanceProvider.dart';
import 'package:monitor_lizard/providers/AuthProvider.dart';
import 'package:monitor_lizard/services/authService.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<AuthProvider>(
      builder: ((context, auth, child) => Padding(
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
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 16,
                      ),
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
                          hideText: true,
                          validator: (String value) {
                            if (value.trim() == "") {
                              return 'This field must be filled';
                            } else {
                              return null;
                            }
                          },
                          onPressed: () {}),
                    ],
                  ),
                )),
                AppButton(
                  prompt: "Sign In",
                  onPressed: () async {
                    final isValid = formKey.currentState!.validate();

                    if (!isValid) {
                      return;
                    }

                    String authErrors = await context
                        .read<AuthService>()
                        .signInWithEmailPassword(emailController.text.trim(),
                            passwordController.text.trim());
                    print("The auth errors are: $authErrors");
                    // ignore: use_build_context_synchronously
                    // await context
                    //     .read<AttendanceProvider>()
                    //     .retrieveEmployeeData();
                    // // ignore: use_build_context_synchronously
                    // await context
                    //     .read<AttendanceProvider>()
                    //     .retrieveOrganizationData();

                    if (authErrors == "") {
                      auth.setAuthState("authenticated");
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                          .showSnackBar(mySnackbar(authErrors));
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16, color: AppColors.gray),
                    ),
                    TextButton(
                        onPressed: () {
                          auth.setAuthState("signUp1");
                        },
                        child: const Text(
                          "Sign Up",
                          style:
                              TextStyle(color: AppColors.green, fontSize: 16),
                        ))
                  ],
                )
              ],
            ),
          )),
    ));
  }
}
