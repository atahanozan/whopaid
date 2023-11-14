import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/pages/loginpages/choose_avatar.dart';
import 'package:whopayed/services/user_services.dart';
import 'package:whopayed/widgets/custom_textfield.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({
    Key? key,
    required this.email,
    required this.uid,
    required this.username,
    required this.name,
  }) : super(key: key);

  final String? username;
  final String? uid;
  final String? email;
  final String? name;

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final UserServices _services = UserServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? nameErr;
  String? usernameErr;
  bool outlnBtn = false;

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backGround(context),
      appBar: AppBar(
        foregroundColor: CustomColors.foreGround(context),
        iconTheme: IconThemeData(color: CustomColors.foreGround(context)),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              TextsTR.rgstrPgRegister,
              style: CustomTextStyle.headerLarge(context).copyWith(
                fontSize: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                TextsTR.rgstrPgRegisterSub,
                style: CustomTextStyle.bodySmall(context),
                textAlign: TextAlign.center,
              ),
            ),
            CustomPaddings.verticalPadding(30),
            CustomTextField(
              controller: _nameController,
              finalLabel: TextsTR.rgstrPgNameSur,
              finalType: TextInputType.name,
              obsecureStatu: false,
              errText: nameErr,
            ),
            CustomPaddings.verticalPadding(10),
            CustomTextField(
              controller: _userNameController,
              finalLabel: widget.username.toString(),
              finalType: TextInputType.name,
              obsecureStatu: false,
              errText: usernameErr,
            ),
            CustomPaddings.verticalPadding(30),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty) {
                  setState(() {
                    nameErr = "Lütfen isim bilgisini giriniz.";
                  });
                  Timer(const Duration(seconds: 2), () {
                    setState(() {
                      nameErr = null;
                    });
                  });
                } else if (_userNameController.text.isEmpty) {
                  _firestore.collection("Users").doc(widget.uid).update({
                    "name": _nameController.text,
                  }).whenComplete(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChooseAvatarPage(
                          uid: widget.uid,
                          name: _nameController.text,
                          email: widget.email,
                          statu: "new",
                        ),
                      ),
                    ),
                  );
                } else {
                  _services.checkUser(_userNameController.text).then((value) {
                    if (value) {
                      _firestore.collection("Users").doc(widget.uid).update({
                        "name": _nameController.text,
                        "username": _userNameController.text,
                      }).whenComplete(
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChooseAvatarPage(
                              uid: widget.uid,
                              name: _nameController.text,
                              email: widget.email,
                              statu: "new",
                            ),
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        usernameErr =
                            "Girdiğiniz kullanıcı farklı bir abonelikte kullanılmaktadır.";
                        outlnBtn = true;
                        Timer(const Duration(seconds: 2), () {
                          setState(() {
                            usernameErr = null;
                          });
                        });
                      });
                    }
                  });
                }
              },
              child: const Text(TextsTR.btnForward),
            ),
            CustomPaddings.verticalPadding(10),
            Visibility(
              visible: outlnBtn,
              child: OutlinedButton(
                onPressed: () {
                  if (_nameController.text.isEmpty) {
                    setState(() {
                      nameErr = "Lütfen isim bilgisini giriniz.";
                    });
                    Timer(const Duration(seconds: 2), () {
                      setState(() {
                        nameErr = null;
                      });
                    });
                  } else {
                    _firestore.collection("Users").doc(widget.uid).update({
                      "name": _nameController.text,
                    }).whenComplete(
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChooseAvatarPage(
                            uid: widget.uid,
                            name: _nameController.text,
                            email: widget.email,
                            statu: "new",
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text("${widget.username} ile devam et"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
