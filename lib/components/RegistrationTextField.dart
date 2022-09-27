import 'package:flutter/material.dart';
import 'package:monitor_lizard/constants/colors.dart';

class RegistrationTextField extends StatelessWidget {
  final TextEditingController textController;
  final Function onPressed;
  final TextInputType keyboardType;
  final String hintText;
  final Function validator;
  final FocusNode? focusNode;
  final bool hideText;
  final bool? autofocus;
  const RegistrationTextField(
      {Key? key,
      required this.textController,
      required this.hintText,
      required this.onPressed,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      required this.validator,
      this.autofocus = false,
      this.hideText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hideText,
      validator: (value) {
        return validator(value);
      },
      focusNode: focusNode,
      autofocus: autofocus!,
      controller: textController,
      keyboardType: keyboardType,
      onTap: () {
        onPressed();
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(18),
          border: InputBorder.none,
          fillColor: AppColors.appWhite,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.gray, fontSize: 18)),
    );
  }
}
