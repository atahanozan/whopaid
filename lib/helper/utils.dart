import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';

class Utils {
  static ScaffoldFeatureController snackBar(
    BuildContext context,
    String text,
  ) {
    final snackbar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CustomColors.brown(context),
        content: Text(
          text,
          style: CustomTextStyle.bodyLarge(context),
        ),
      ),
    );

    return snackbar;
  }

  static Widget imageBox(String asset) {
    final imagebox = SizedBox(
      height: 200,
      width: 200,
      child: Image.asset(asset),
    );

    return imagebox;
  }

  static Widget bodyText(String text, BuildContext context) {
    final bodytext = Text(
      text,
      style: CustomTextStyle.bodyLarge(context),
      textAlign: TextAlign.center,
    );

    return bodytext;
  }

  static Widget friendsList(
    String uid,
    BuildContext context,
    Widget icon,
  ) {
    final friends = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where("uid", isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot data = snapshot.data!.docs[index];
                  Map<String, dynamic> friendslist = data["friends"];

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: friendslist.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> friendDetail =
                          friendslist.values.elementAt(index);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    friendDetail["avatar"],
                                  ),
                                ),
                              ),
                              child: const Text(""),
                            ),
                            CustomPaddings.horizontalPadding(10),
                            Expanded(
                              child: Text(
                                friendDetail["name"],
                                style: CustomTextStyle.bodyLarge(context),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    actionsOverflowButtonSpacing: 10,
                                    title: Text(
                                      TextsTR.utilsErrFriend,
                                      style:
                                          CustomTextStyle.headerSmall(context),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context).size.width,
                                              20),
                                        ),
                                        onPressed: () {
                                          friendslist.remove(
                                            friendslist.keys.elementAt(index),
                                          );
                                          FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(uid)
                                              .update({"friends": friendslist});
                                          Navigator.pop(context);
                                        },
                                        child: const Text(TextsTR.btnRemove),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context).size.width,
                                              20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(TextsTR.btnCancel),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: icon,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
      },
    );

    return friends;
  }

  static Widget chooseAvatar(
    String url,
    String value,
    VoidCallback setValue,
    Color borderColor,
  ) {
    final avatar = GestureDetector(
      onTap: setValue,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(url)),
            border: Border.all(
              color: borderColor,
              width: 5,
            )),
        child: Text(
          value,
          style: const TextStyle(color: Colors.transparent),
        ),
      ),
    );

    return avatar;
  }

  static Widget friendsListTile(
    String imageUrl,
    String title,
    VoidCallback funt,
    String btnName,
    Widget secondBtn,
    BuildContext context,
  ) {
    final listtile = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        horizontalTitleGap: 5,
        leading: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(imageUrl)),
          ),
          child: const Text(""),
        ),
        title: Text(
          title,
          style: CustomTextStyle.bodyMidium(context),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(20),
              ),
              onPressed: funt,
              child: Text(btnName),
            ),
            CustomPaddings.horizontalPadding(5),
            secondBtn,
          ],
        ),
      ),
    );

    return listtile;
  }

  static Widget rideElement(
    int index,
    String name,
    BuildContext context,
    String imgUrl,
    int totalDue,
    Widget likes,
  ) {
    String shortTotalDue =
        (totalDue < 1000 ? totalDue : "${(totalDue / 1000).round()}K")
            .toString();
    final rideelement = Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                index == 0 ? CustomColors.brown(context) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: index == 0 ? 100 : 50,
                width: index == 0 ? 100 : 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imgUrl),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: index == 0 ? 110 : 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: index == 0
                          ? CustomTextStyle.headerMidium(context)
                              .copyWith(color: CustomColors.backGround(context))
                          : CustomTextStyle.bodyLarge(context),
                    ),
                    TextsTR.utilsRideText(shortTotalDue, index, context),
                    CustomPaddings.verticalPadding(10),
                    likes,
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Text(
            "${index + 1}",
            style: GoogleFonts.grechenFuemen(
              fontSize: index == 0 ? 150 : 50,
              color: index == 0
                  ? CustomColors.greenn(context)
                  : CustomColors.brown(context),
            ),
          ),
        ),
      ],
    );

    return rideelement;
  }
}
