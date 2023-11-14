import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/services/user_services.dart';
import 'package:whopayed/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserServices _services = UserServices();
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

  bool passwordStatu = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backGround(context),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              TextsTR.lgnPgLogin,
              style: CustomTextStyle.headerLarge(context).copyWith(
                fontSize: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                TextsTR.lgnPgLoginSub,
                style: CustomTextStyle.bodySmall(context),
                textAlign: TextAlign.center,
              ),
            ),
            CustomPaddings.verticalPadding(30),
            CustomTextField(
              controller: _emailController,
              finalLabel: TextsTR.lgnPgEmail,
              finalType: TextInputType.emailAddress,
              obsecureStatu: false,
            ),
            CustomPaddings.verticalPadding(10),
            CustomTextField(
              controller: _passwordController,
              finalLabel: TextsTR.lgnPgPassword,
              finalType: TextInputType.text,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    passwordStatu = !passwordStatu;
                  });
                },
                icon: passwordStatu == false
                    ? const Icon(Icons.lock_open)
                    : const Icon(Icons.lock),
              ),
              obsecureStatu: passwordStatu,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/forgotpass");
                },
                child: Text(
                  TextsTR.btnForgotPassword,
                  style: CustomTextStyle.bodySmall(context)
                      .copyWith(color: Colors.blue),
                ),
              ),
            ),
            CustomPaddings.verticalPadding(30),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isEmpty) {
                  customSnackBar(TextsTR.lgnPgErrEmail);
                } else if (_passwordController.text.isEmpty) {
                  customSnackBar(TextsTR.lgnPgErrPassword);
                } else {
                  _services.loginWithEmail(
                    _emailController.text,
                    _passwordController.text,
                    context,
                  );
                }
              },
              child: const Text(TextsTR.btnLogin),
            ),
            CustomPaddings.verticalPadding(10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              child: const Text(TextsTR.btnRegister),
            ),
          ],
        ),
      ),
    );
  }
}
