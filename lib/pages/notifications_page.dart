import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/helper/utils.dart';
import 'package:whopayed/widgets/google_ads_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int dateTime = DateTime.now().millisecondsSinceEpoch;
  List<dynamic> userNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const GoogleAdsWidget(),
      backgroundColor: CustomColors.greenn(context),
      appBar: AppBar(
        title: const Text(TextsTR.ntfPgTitle),
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where("uid", isEqualTo: widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot data = snapshot.data!.docs[index];
                      Map<String, dynamic> notifications =
                          data["notifications"];
                      Map<String, dynamic> friends = data["friends"];
                      for (var element in friends.values) {
                        userNames.add(element["username"]);
                      }

                      return notifications.isEmpty
                          ? Center(
                              child: Text(
                                TextsTR.ntfPgErr,
                                style: CustomTextStyle.bodyLarge(context),
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                notifications.keys.toList().sort();

                                Map<String, dynamic> notificationDetail =
                                    notifications.values.elementAt(index);

                                return Utils.friendsListTile(
                                  notificationDetail["avatar"],
                                  "${notificationDetail["name"]} kisişi seni ekledi",
                                  () {
                                    setState(() {
                                      notifications.remove(
                                          notifications.keys.elementAt(index));
                                      FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(widget.uid)
                                          .update({
                                        "notifications": notifications,
                                      });
                                    });
                                  },
                                  "Tamam",
                                  userNames.contains(
                                          notificationDetail["username"])
                                      ? const Text("")
                                      : OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            fixedSize:
                                                const Size.fromHeight(20),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              dateTime++;
                                              friends.addAll({
                                                dateTime.toString(): {
                                                  "uid":
                                                      notificationDetail["uid"],
                                                  "username":
                                                      notificationDetail[
                                                          "username"],
                                                  "name": notificationDetail[
                                                      "name"],
                                                  "avatar": notificationDetail[
                                                      "avatar"],
                                                  "email": notificationDetail[
                                                      "email"],
                                                }
                                              });
                                              notifications.remove(notifications
                                                  .keys
                                                  .elementAt(index));
                                              userNames.add(notificationDetail[
                                                  "username"]);
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(widget.uid)
                                                  .update({
                                                "friends": friends,
                                                "notifications": notifications,
                                              });
                                            });
                                          },
                                          child: const Text(TextsTR.btnAdd),
                                        ),
                                  context,
                                );
                              },
                            );
                    },
                  );
          },
        ),
      ),
    );
  }
}
