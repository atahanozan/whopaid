import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/pages/navigation_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool comStatu = false;

  Future<void> getComStatu() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      comStatu = prefs.getBool("comStatu") ?? false;
    });
  }

  void directionWithUser() {
    Timer(seconds, () {
      if (!comStatu) {
        Navigator.pushReplacementNamed(context, "/commercial");
      } else {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationPage(
                uid: user?.uid,
                email: user?.email,
                name: user?.displayName,
              ),
            ),
          );
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      }
    });
  }

  final Duration seconds = const Duration(seconds: 3);

  @override
  void initState() {
    setState(() {
      user = _auth.currentUser;
      getComStatu();
      directionWithUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: CustomColors.skinTones,
      ),
      child: Image.asset("assets/whopayed.gif"),
    );
  }
}
