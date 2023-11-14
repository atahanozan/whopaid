import 'package:flutter/material.dart';
import 'package:whopayed/helper/text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.finalLabel,
    required this.finalType,
    this.suffixIcon,
    this.finalColor,
    this.customCapital = TextCapitalization.none,
    required this.obsecureStatu,
  }) : super(key: key);

  final TextEditingController controller;
  final String finalLabel;
  final TextInputType finalType;
  final Widget? suffixIcon;
  final bool obsecureStatu;
  final Color? finalColor;
  final TextCapitalization customCapital;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureStatu,
      textCapitalization: customCapital,
      keyboardType: finalType,
      style: CustomTextStyle.bodyLarge(context),
      decoration: InputDecoration(
        fillColor: finalColor,
        focusColor: finalColor,
        hoverColor: finalColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintStyle: CustomTextStyle.bodySmall(context),
        errorStyle: CustomTextStyle.bodySmall(context),
        labelStyle: CustomTextStyle.bodySmall(context),
        helperStyle: CustomTextStyle.bodySmall(context),
        prefixStyle: CustomTextStyle.bodySmall(context),
        suffixStyle: CustomTextStyle.bodySmall(context),
        counterStyle: CustomTextStyle.bodySmall(context),
        floatingLabelStyle: CustomTextStyle.bodySmall(context),
        label: Text(finalLabel),
        filled: true,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
