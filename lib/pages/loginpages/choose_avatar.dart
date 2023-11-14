import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/pages/navigation_page.dart';

class ChooseAvatarPage extends StatefulWidget {
  const ChooseAvatarPage({
    Key? key,
    required this.uid,
    required this.name,
    required this.email,
    required this.statu,
  }) : super(key: key);

  final String? uid;
  final String? name;
  final String? email;
  final String statu;

  @override
  State<ChooseAvatarPage> createState() => _ChooseAvatarPageState();
}

class _ChooseAvatarPageState extends State<ChooseAvatarPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String url = "";

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backGround(context),
      appBar: AppBar(
        foregroundColor: CustomColors.foreGround(context),
        iconTheme: IconThemeData(color: CustomColors.foreGround(context)),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            CustomPaddings.verticalPadding(50),
            Text(
              TextsTR.chsavtPgtitle,
              style: CustomTextStyle.headerLarge(context),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection("Avatars").snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? const CircularProgressIndicator()
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot data =
                                snapshot.data!.docs[index];

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  url = data["url"];
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(data["url"])),
                                  border: Border.all(
                                      color: url == data["url"]
                                          ? CustomColors.greenn(context)
                                          : Colors.transparent,
                                      width: 5),
                                ),
                                child: const Text(""),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (url == "") {
                  customSnackBar(TextsTR.chsavtPgErr);
                } else {
                  if (widget.statu == "new") {
                    setState(() {
                      _firestore.collection("Users").doc(widget.uid).update({
                        "avatar": url,
                      });
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavigationPage(
                          uid: widget.uid,
                          email: widget.email,
                          name: widget.name,
                        ),
                      ),
                    );
                  } else {
                    setState(() {
                      _firestore.collection("Users").doc(widget.uid).update({
                        "avatar": url,
                      });
                    });
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text(TextsTR.btnOkey),
            ),
          ],
        ),
      ),
    );
  }
}
