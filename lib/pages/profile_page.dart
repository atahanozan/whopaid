import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/utils.dart';
import 'package:whopayed/widgets/google_ads_widget.dart';
import 'package:whopayed/widgets/profile_settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
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
                    Map<String, dynamic> friends = data["friends"];

                    return Container(
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const GoogleAdsWidget(),
                          CustomPaddings.verticalPadding(10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(data["avatar"]),
                                    ),
                                  ),
                                ),
                                CustomPaddings.verticalPadding(10),
                                Text(
                                  data["name"],
                                  style: CustomTextStyle.headerLarge(context),
                                ),
                                CustomPaddings.verticalPadding(5),
                                Text(
                                  data["username"],
                                  style: CustomTextStyle.bodyMidium(context),
                                ),
                                const Icon(
                                  Icons.circle,
                                  size: 10,
                                ),
                                Text(
                                  data["aboutself"] == "Hakkımda"
                                      ? ""
                                      : data["aboutself"],
                                  style: CustomTextStyle.bodySmall(context),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          const ProfilePageSettings(),
                          CustomPaddings.verticalPadding(20),
                          Text(
                            "Arkadaşlar",
                            style: CustomTextStyle.headerSmall(context),
                          ),
                          CustomPaddings.verticalPadding(20),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> friendsDetail =
                                  friends.values.elementAt(index);
                              return friends.isEmpty
                                  ? const CircularProgressIndicator()
                                  : Utils.friendsListTile(
                                      friendsDetail["avatar"],
                                      friendsDetail["name"],
                                      () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            actionsOverflowButtonSpacing: 10,
                                            title: Text(
                                              "Arkadaş listesinden çıkar?",
                                              style:
                                                  CustomTextStyle.headerSmall(
                                                      context),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      20),
                                                ),
                                                onPressed: () {
                                                  friends.remove(
                                                    friends.keys
                                                        .elementAt(index),
                                                  );
                                                  FirebaseFirestore.instance
                                                      .collection("Users")
                                                      .doc(widget.uid)
                                                      .update(
                                                          {"friends": friends});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Çıkar"),
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  fixedSize: Size(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      20),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("İptal"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      "Sil",
                                      const Text(""),
                                      context,
                                    );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
