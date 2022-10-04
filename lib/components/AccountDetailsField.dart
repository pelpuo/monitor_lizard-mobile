import 'package:flutter/material.dart';
import 'package:monitor_lizard/constants/colors.dart';

class AccountDetailsField extends StatelessWidget {
  final String prompt;
  final String value;
  const AccountDetailsField(
      {Key? key, required this.prompt, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prompt,
              style: const TextStyle(color: AppColors.gray),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.dark,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
