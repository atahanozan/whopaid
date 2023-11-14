import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whopayed/helper/custom_colors.dart';

class CustomTextStyle {
  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.quicksand(
      color: CustomColors.foreGround(context),
      fontSize: 12,
    );
  }

  static TextStyle bodyMidium(BuildContext context) {
    return GoogleFonts.quicksand(
      color: CustomColors.foreGround(context),
      fontSize: 14,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.quicksand(
      color: CustomColors.foreGround(context),
      fontSize: 16,
    );
  }

  static TextStyle headerSmall(BuildContext context) {
    return GoogleFonts.quicksand(
      color: CustomColors.foreGround(context),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle headerMidium(BuildContext context) {
    return GoogleFonts.quicksand(
      color: CustomColors.foreGround(context),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle headerLarge(BuildContext context) {
    return GoogleFonts.quicksand(
      color: CustomColors.foreGround(context),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }
}
