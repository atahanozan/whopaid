import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/services/user_services.dart';
import 'package:whopayed/widgets/custom_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _controller = TextEditingController();
  final UserServices _userServices = UserServices();

  ScaffoldFeatureController customSnackBar(String content) {
    final snackBar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CustomColors.brown(context),
        content: Text(
          content,
          style: CustomTextStyle.bodyLarge(context),
        ),
      ),
    );
    return snackBar;
  }

  @override
  void dispose() {
    _controller.dispose();
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
              TextsTR.frgtpssPgForgotPass,
              style: CustomTextStyle.headerLarge(context).copyWith(
                fontSize: 40,
              ),
            ),
            CustomPaddings.verticalPadding(30),
            CustomTextField(
              controller: _controller,
              finalLabel: TextsTR.lgnPgEmail,
              finalType: TextInputType.emailAddress,
              obsecureStatu: false,
            ),
            CustomPaddings.verticalPadding(30),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isEmpty) {
                  customSnackBar(TextsTR.lgnPgErrEmail);
                } else {
                  _userServices.forgotPassword(_controller.text, context);
                }
              },
              child: const Text(TextsTR.btnSend),
            ),
          ],
        ),
      ),
    );
  }
}
