import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/text_styles.dart';

class ThemeClass {
  static const THEME_STATUS = "THEMESTATU";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }

  static ThemeData selectedTheme(bool isDark, BuildContext context) {
    final lighttheme = ThemeData(
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: CustomColors.greenn(context),
      ),
      dialogBackgroundColor: CustomColors.backGround(context),
      dividerColor: CustomColors.foreGround(context),
      iconTheme: IconThemeData(
        color: CustomColors.foreGround(context),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: CustomColors.foreGround(context),
        ),
      ),
      scaffoldBackgroundColor: CustomColors.backGround(context),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: CustomColors.backGround(context),
        titleTextStyle: CustomTextStyle.headerLarge(context).copyWith(
          color: CustomColors.backGround(context),
        ),
        iconTheme: IconThemeData(
          color: CustomColors.backGround(context),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.greenn(context),
          foregroundColor: CustomColors.backGround(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: CustomTextStyle.bodyLarge(context),
          fixedSize: Size(MediaQuery.of(context).size.width, 50),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            foregroundColor: CustomColors.greenn(context),
            side: BorderSide(
              color: CustomColors.greenn(context),
            ),
            textStyle: CustomTextStyle.bodyLarge(context),
            fixedSize: Size(MediaQuery.of(context).size.width, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomColors.greenn(context),
        foregroundColor: CustomColors.backGround(context),
      ),
    );
    return lighttheme;
  }
}
