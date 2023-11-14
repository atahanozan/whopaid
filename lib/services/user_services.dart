import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/helper/utils.dart';
import 'package:whopayed/pages/loginpages/userinfo.dart';
import 'package:whopayed/pages/navigation_page.dart';

class UserServices {
  Future<void> createUserWithEmail(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user?.uid)
          .set({
        "private": false,
        "aboutself": "Hakkımda",
        "likes": [],
        "totaldue": 0,
        "friends": {},
        "notifications": {},
        "uid": userCredential.user?.uid.toString(),
        "username": email.split("@").elementAt(0),
        "name": name,
        "email": email,
      }).then((value) {
        userCredential.user?.updateDisplayName(name);
        final User cUser = userCredential.user!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(
              uid: cUser.uid,
              email: cUser.email.toString(),
              name: name,
              username: email.split("@").elementAt(0),
            ),
          ),
        );
      });
    } on FirebaseAuthException catch (err) {
      if (context.mounted) {
        switch (err.code) {
          case "email-already-in-use":
            Utils.snackBar(
                context, "Bu e-mail ile daha önce bir kullanıcı açılmış.");
            break;
          case "invalid-email":
            Utils.snackBar(context, "Geçersiz e-mail adresi");
            break;
          case "operation-not-allowed":
            Utils.snackBar(context,
                "Bu e-mail adresi veri tabanına uygun değildir. Lütfen farklı bir e-mail adresi ile kayıt olmayı deneyiniz.");
            break;
          case "weak-password":
            Utils.snackBar(context,
                "Şifreniz en az 6 karakterden oluşmalı ve harf ve rakam içermelidir.");
            break;
          default:
        }
      }
    }
  }

  Future<bool> checkUser(String userName) async {
    var user = await FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: userName)
        .get();
    return user.docs.isEmpty ? true : false;
  }

  Future<void> loginWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(
            (value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationPage(
                  uid: value.user?.uid,
                  email: value.user?.email,
                  name: value.user?.displayName,
                ),
              ),
            ),
          );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case "user-disabled":
            Utils.snackBar(context, "Kullanıcı hesabı silinmiş.");
            break;
          case "invalid-email":
            Utils.snackBar(context, "Geçersiz e-mail adresi");
            break;
          case "user-not-found":
            Utils.snackBar(context, "Kullanıcı bulunamadı.");
            break;
          case "wrong-password":
            Utils.snackBar(context, "Hatalı şifre.");
            break;
          default:
        }
      }
    }
  }

  Future<void> deleteAccount(
    User user,
    BuildContext context,
    String uid,
  ) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actionsOverflowButtonSpacing: 10,
        title: Text(
          TextsTR.askDeleteAcc,
          style: CustomTextStyle.headerMidium(context),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 20),
            ),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, "/login");
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(uid)
                  .delete();

              user.delete();
            },
            child: const Text(TextsTR.btnYes),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(TextsTR.btnNo),
          ),
        ],
      ),
    );
  }

  Future<void> logOut(User user, BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actionsOverflowButtonSpacing: 10,
        title: Text(
          TextsTR.askLogout,
          style: CustomTextStyle.headerMidium(context),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 20),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
            child: const Text(TextsTR.btnYes),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(TextsTR.btnNo),
          ),
        ],
      ),
    );
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .whenComplete(
            () => Navigator.pushReplacementNamed(context, "/login"),
          );
    } on FirebaseAuthException catch (errors) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CustomColors.brown(context),
            content: Text(
              "${errors.message}",
              style: CustomTextStyle.bodyLarge(context),
            ),
          ),
        );
      }
    }
  }
}
