import 'package:flutter/material.dart';
import 'package:monitor_lizard/constants/colors.dart';

class AppButton extends StatelessWidget {
  final String prompt;
  final Function onPressed;
  const AppButton({Key? key, required this.prompt, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
              padding: MaterialStateProperty.all(const EdgeInsets.all(18)),
              backgroundColor: MaterialStateProperty.all(AppColors.green)),
          onPressed: () => onPressed(),
          child: Text(
            prompt,
            style: TextStyle(color: AppColors.appWhite, fontSize: 16),
          )),
    );
  }
}
