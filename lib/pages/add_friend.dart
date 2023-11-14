import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/helper/utils.dart';
import 'package:whopayed/services/notification_service.dart';
import 'package:whopayed/widgets/custom_textfield.dart';
import 'package:whopayed/widgets/google_ads_widget.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({
    Key? key,
    required this.avatar,
    required this.username,
    required this.name,
    required this.uid,
    required this.email,
  }) : super(key: key);

  final String name;
  final String username;
  final String uid;
  final String email;
  final String avatar;

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> friends = {};

  List<dynamic> userNames = [];

  int dateTime = DateTime.now().millisecondsSinceEpoch;

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

  String userName = "";
  String myUsername = "";

  @override
  void initState() {
    _firestore
        .collection("Users")
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      for (var element in snapshot.docs) {
        setState(() {
          friends = element["friends"];
          for (var usernames in friends.values) {
            setState(() {
              userNames.add(usernames["username"]);
            });
          }
          myUsername = element["username"];
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const GoogleAdsWidget(),
      backgroundColor: CustomColors.greenn(context),
      appBar: AppBar(
        title: const Text(TextsTR.addfrPgTitle),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: CustomColors.backGround(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _controller,
                    finalLabel: TextsTR.txtfldSearch,
                    finalType: TextInputType.text,
                    obsecureStatu: false,
                  ),
                ),
                CustomPaddings.horizontalPadding(10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size.fromHeight(20),
                  ),
                  onPressed: () {
                    setState(() {
                      userName = _controller.text;
                    });
                  },
                  child: const Text(TextsTR.txtfldSearch),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("username", isEqualTo: userName)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Text(
                          TextsTR.txtfldSearch,
                          style: CustomTextStyle.bodyLarge(context),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot data =
                                snapshot.data!.docs[index];
                            Map<String, dynamic> notification =
                                data["notifications"];
                            Map<String, dynamic> notificationSent = {
                              "message": {
                                "token": data["fCMToken"],
                                "notification": {
                                  "title": "Biri Sizi Ekledi",
                                  "body":
                                      "Bir kullanıcı sizi arkadaş olarak ekledi. Hemen kontrol edin."
                                },
                                "data": {
                                  "firstName": data["name"],
                                  "lastName": data["name"],
                                  "eMail": data["email"],
                                  "webSite": data["email"],
                                }
                              }
                            };

                            return Utils.friendsListTile(
                                data["avatar"], data["name"], () {
                              if (userNames.contains(_controller.text)) {
                                setState(() {
                                  friends.remove(
                                    friends.keys.elementAt(
                                      userNames.indexOf(_controller.text),
                                    ),
                                  );
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(widget.uid)
                                      .update({
                                    "friends": friends,
                                  });
                                  userNames.remove(_controller.text);
                                });
                                Navigator.pop(context);
                              } else if (myUsername == _controller.text) {
                                customSnackBar(TextsTR.addfrPgErr);
                              } else if (!userNames
                                  .contains(_controller.text)) {
                                setState(() {
                                  dateTime++;
                                  notification.addAll(
                                    {
                                      dateTime.toString(): {
                                        "uid": widget.uid,
                                        "username": widget.username,
                                        "name": widget.name,
                                        "avatar": widget.avatar,
                                        "email": widget.email,
                                      },
                                    },
                                  );
                                  friends.addAll({
                                    dateTime.toString(): {
                                      "uid": data["uid"],
                                      "username": data["username"],
                                      "avatar": data["avatar"],
                                      "name": data["name"],
                                      "email": data["email"],
                                    }
                                  });
                                  userNames.add(_controller.text);
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(data["uid"])
                                      .update({
                                    "notifications": notification,
                                  });
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(widget.uid)
                                      .update({
                                    "friends": friends,
                                  });
                                  FirebaseApi()
                                      .sendNotification(notificationSent);
                                });
                                Navigator.pop(context);
                              }
                            },
                                userNames.contains(_controller.text)
                                    ? TextsTR.btnDelete
                                    : TextsTR.btnAdd,
                                const Text(""),
                                context);
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
