import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/model/darktheme_provider.dart';

class ChangeThemeButton extends StatefulWidget {
  const ChangeThemeButton({super.key});

  @override
  State<ChangeThemeButton> createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);

    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColors.greenn(context),
            width: 0.3,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            themeChange.darkTheme ? "Aydınlık Tema" : "Karanlık Tema",
            style: CustomTextStyle.bodyLarge(context),
          ),
          Switch(
            value: themeChange.darkTheme,
            onChanged: (value) {
              setState(() {
                themeChange.darkTheme = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
