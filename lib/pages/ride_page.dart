import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/utils.dart';
import 'package:whopayed/widgets/google_ads_widget.dart';

class RidePage extends StatefulWidget {
  const RidePage({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Bütçe Savaşları",
                style: GoogleFonts.prata(
                  fontSize: 38,
                  color: CustomColors.foreGround(context),
                ),
              ),
            ),
            const GoogleAdsWidget(),
            CustomPaddings.verticalPadding(10),
            Expanded(
              child: StreamBuilder(
                stream: _firestore
                    .collection("Users")
                    .orderBy("totaldue", descending: true)
                    .where("private", isEqualTo: false)
                    .where("totaldue", isGreaterThanOrEqualTo: 1000)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot data =
                                snapshot.data!.docs[index];
                            List<dynamic> likes = data["likes"];

                            return Utils.rideElement(
                              index,
                              data["name"],
                              context,
                              data["avatar"],
                              data["totaldue"],
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (likes.contains(widget.uid)) {
                                        setState(() {
                                          likes.remove(widget.uid);
                                          _firestore
                                              .collection("Users")
                                              .doc(data["uid"])
                                              .update({
                                            "likes": likes,
                                          });
                                        });
                                      } else {
                                        setState(() {
                                          likes.add(widget.uid);
                                          _firestore
                                              .collection("Users")
                                              .doc(data["uid"])
                                              .update({
                                            "likes": likes,
                                          });
                                        });
                                      }
                                    },
                                    child: Icon(
                                      !likes.contains(widget.uid)
                                          ? Icons.favorite_outline
                                          : Icons.favorite,
                                      color: likes.contains(widget.uid)
                                          ? CustomColors.darkRed
                                          : index == 0
                                              ? CustomColors.backGround(context)
                                              : CustomColors.foreGround(
                                                  context),
                                    ),
                                  ),
                                  CustomPaddings.horizontalPadding(10),
                                  Text(
                                    likes.length.toString(),
                                    style: index == 0
                                        ? CustomTextStyle.bodySmall(context)
                                            .copyWith(
                                                color: CustomColors.backGround(
                                                    context))
                                        : CustomTextStyle.bodySmall(context),
                                  ),
                                ],
                              ),
                            );
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
