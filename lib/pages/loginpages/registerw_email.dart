import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/services/user_services.dart';
import 'package:whopayed/widgets/custom_textfield.dart';

class RegisterWithEmailPage extends StatefulWidget {
  const RegisterWithEmailPage({Key? key}) : super(key: key);

  @override
  State<RegisterWithEmailPage> createState() => _RegisterWithEmailPageState();
}

class _RegisterWithEmailPageState extends State<RegisterWithEmailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserServices _services = UserServices();
  bool passwordStatu = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
            ),
            CustomPaddings.verticalPadding(10),
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
                    ? const Icon(
                        Icons.lock,
                      )
                    : const Icon(Icons.lock_open),
              ),
              obsecureStatu: !passwordStatu,
            ),
            CustomPaddings.verticalPadding(10),
            CustomPaddings.verticalPadding(10),
            CustomPaddings.verticalPadding(30),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty) {
                  customSnackBar(TextsTR.rgstrPgErrNameSur);
                } else if (_emailController.text.isEmpty) {
                  customSnackBar(TextsTR.lgnPgErrEmail);
                } else if (_passwordController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  customSnackBar(TextsTR.lgnPgErrPassword);
                } else {
                  _services.createUserWithEmail(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                    context,
                  );
                }
              },
              child: const Text(TextsTR.btnRegister),
            ),
          ],
        ),
      ),
    );
  }
}
