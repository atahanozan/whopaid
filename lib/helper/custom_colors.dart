import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whopayed/model/darktheme_provider.dart';

class CustomColors {
  static Color greenn(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    return themeChange.darkTheme
        ? const Color(0xff6ab29b)
        : const Color(0xff186049);
  }

  static Color backGround(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    return themeChange.darkTheme
        ? const Color(0xff212121)
        : const Color(0xffFAFAFA);
  }

  static Color foreGround(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    return themeChange.darkTheme
        ? const Color(0xffFAFAFA)
        : const Color(0xff212121);
  }

  static Color brown(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    return themeChange.darkTheme
        ? const Color(0xffe4d5c7)
        : const Color(0xff95877A);
  }

  static const Color darkGreens = Color(0xff186049);
  static const Color midiumGreens = Color(0xff247158);
  static const Color lightGreens = Color(0xff6ab29b);
  static const Color blackTables = Color(0xff212121);
  static const Color whiteTables = Color(0xffFAFAFA);
  static const Color skinTones = Color(0xffe4d5c7);
  static const Color browns = Color(0xff95877A);
  static const Color darkRed = Color(0xffB71C1C);
}
