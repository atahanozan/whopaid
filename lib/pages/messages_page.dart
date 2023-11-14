import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/widgets/google_ads_widget.dart';

class MessagesPages extends StatefulWidget {
  const MessagesPages({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<MessagesPages> createState() => _MessagesPagesState();
}

class _MessagesPagesState extends State<MessagesPages> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const GoogleAdsWidget(),
      backgroundColor: CustomColors.greenn(context),
      appBar: AppBar(
        title: const Text(TextsTR.msgPgTitle),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: CustomColors.backGround(context),
        ),
        child: StreamBuilder(
          stream: _firestore
              .collection("Messages")
              .where("sentUid", isEqualTo: widget.uid)
              .orderBy("datetime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot data = snapshot.data!.docs[index];
                      _firestore.collection("Messages").doc(data.id).update({
                        "read": true,
                      });

                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: CustomColors.brown(context),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data["sender"],
                                    style: CustomTextStyle.headerSmall(context)
                                        .copyWith(
                                            color: CustomColors.blackTables),
                                  ),
                                  Text(
                                    data["message"],
                                    style: CustomTextStyle.bodyLarge(context)
                                        .copyWith(
                                            color: CustomColors.blackTables),
                                  ),
                                ],
                              ),
                            ),
                            CustomPaddings.horizontalPadding(10),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size.fromHeight(20),
                              ),
                              onPressed: () {
                                _firestore
                                    .collection("Messages")
                                    .doc(data.id)
                                    .delete();
                              },
                              child: const Text(TextsTR.btnDelete),
                            ),
                          ],
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
