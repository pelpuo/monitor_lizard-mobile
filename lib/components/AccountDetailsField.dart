import 'package:flutter/material.dart';
import 'package:monitor_lizard/constants/colors.dart';

class AccountDetailsField extends StatelessWidget {
  final String prompt;
  final TextEditingController fieldController;
  final bool obscure;
  const AccountDetailsField(
      {Key? key,
      required this.prompt,
      required this.fieldController,
      this.obscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prompt,
          style: const TextStyle(fontSize: 16, color: AppColors.gray),
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
            controller: fieldController,
            obscureText: obscure,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ))
      ],
    );
  }
}
