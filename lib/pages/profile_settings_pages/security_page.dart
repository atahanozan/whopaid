import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({
    Key? key,
    required this.uid,
    required this.private,
  }) : super(key: key);

  final String uid;
  final bool private;

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool lastPrivate = false;
  @override
  void initState() {
    lastPrivate = widget.private;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greenn(context),
      appBar: AppBar(
        title: const Text(TextsTR.scrtPgTitle),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: CustomColors.backGround(context),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TextsTR.scrtPgScdTitle,
                    style: CustomTextStyle.headerSmall(context),
                  ),
                  CustomPaddings.verticalPadding(10),
                  Text(
                    TextsTR.scrtPgExplain,
                    style: CustomTextStyle.bodyMidium(context),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  lastPrivate = !lastPrivate;
                  _firestore.collection("Users").doc(widget.uid).update({
                    "private": lastPrivate,
                  });
                });
              },
              icon: Icon(!lastPrivate ? Icons.circle_outlined : Icons.circle),
            ),
          ],
        ),
      ),
    );
  }
}
