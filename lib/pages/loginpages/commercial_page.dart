import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';

class CommercialPage extends StatefulWidget {
  const CommercialPage({super.key});

  @override
  State<CommercialPage> createState() => _CommercialPageState();
}

class _CommercialPageState extends State<CommercialPage> {
  Future<void> setComStatu() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("comStatu", true);
    });
  }

  List<String> pictures = [
    "assets/commercial/first.png",
    "assets/commercial/second.png",
    "assets/commercial/third.png",
  ];
  List<String> texts = [
    TextsTR.commercialpgFirst,
    TextsTR.commercialpgSecond,
    TextsTR.commercialpgThird,
  ];
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greenn(context),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                pictures[page],
              ),
            ),
            CustomPaddings.verticalPadding(30),
            Text(
              texts[page],
              textAlign: TextAlign.center,
              style: CustomTextStyle.bodyLarge(context)
                  .copyWith(color: CustomColors.backGround(context)),
            ),
            CustomPaddings.verticalPadding(20),
            const Divider(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.backGround(context),
                foregroundColor: CustomColors.greenn(context),
              ),
              onPressed: () {
                if (page < 2) {
                  setState(() {
                    page++;
                  });
                } else {
                  setComStatu();
                  Navigator.pushReplacementNamed(context, "/login");
                }
              },
              child: Text(page == 2 ? TextsTR.btnStart : TextsTR.btnForward),
            ),
          ],
        ),
      ),
    );
  }
}
