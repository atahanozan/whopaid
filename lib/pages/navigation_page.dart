import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/pages/calculate_page.dart';
import 'package:whopayed/pages/messages_page.dart';
import 'package:whopayed/pages/notifications_page.dart';
import 'package:whopayed/pages/profile_page.dart';
import 'package:whopayed/pages/ride_page.dart';
import 'package:whopayed/widgets/custom_bottomtabbar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({
    Key? key,
    this.uid,
    this.name,
    this.email,
  }) : super(key: key);

  final String? uid;
  final String? name;
  final String? email;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String? uid, email;
  String avatar = "";
  String name = "";
  String userName = "";
  String fCMToken = "";

  Future<void> getfCMToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fCMToken = prefs.getString("fCMToken") ?? "";
      _firestore.collection("Users").doc(widget.uid).update({
        "fCMToken": fCMToken,
      });
    });
  }

  List<Widget> pages = [
    const RidePage(
      uid: "",
    )
  ];

  Map<String, dynamic> friends = {};
  Map<String, dynamic> notifications = {};
  int messages = 0;
  int notificationsCount = 0;

  List<String> headers = [
    "Gezinti",
    "Profil",
  ];

  List<String> titles = [
    "Gezinti",
    "Profil",
  ];

  int _index = 0;

  @override
  void initState() {
    getfCMToken();
    setState(() {
      user = _auth.currentUser;
      uid = user?.uid;
      email = user?.email;

      _firestore
          .collection("Users")
          .where("email", isEqualTo: email)
          .get()
          .then((snapshot) {
        for (var data in snapshot.docs) {
          setState(() {
            friends = data["friends"] ?? {};
            avatar = data["avatar"];
            name = data["name"];
            userName = data["username"];
            notifications = data["notifications"];
            notificationsCount = notifications.length;
            pages = [
              RidePage(
                uid: uid.toString(),
              ),
              ProfilePage(
                uid: uid.toString(),
              ),
            ];
          });
        }
      });
      _firestore
          .collection("Messages")
          .where("sentUid", isEqualTo: uid)
          .where("read", isEqualTo: false)
          .get()
          .then((snapshot) {
        setState(() {
          messages = snapshot.docs.length;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greenn(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(titles[_index]),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                notificationsCount = 0;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationPage(
                    uid: uid.toString(),
                  ),
                ),
              );
            },
            icon: Stack(
              children: [
                SvgPicture.asset(
                  "assets/icons/notification.svg",
                  colorFilter: ColorFilter.mode(
                    CustomColors.backGround(context),
                    BlendMode.srcIn,
                  ),
                ),
                notificationsCount == 0
                    ? const Text("")
                    : Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: CustomColors.darkRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          notificationsCount.toString(),
                          style: CustomTextStyle.bodyMidium(context).copyWith(
                              color: CustomColors.backGround(context)),
                        ),
                      ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                messages = 0;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MessagesPages(uid: uid.toString()),
                ),
              );
            },
            icon: Stack(
              children: [
                SvgPicture.asset(
                  "assets/icons/message.svg",
                  colorFilter: ColorFilter.mode(
                    CustomColors.backGround(context),
                    BlendMode.srcIn,
                  ),
                ),
                messages == 0
                    ? const Text("")
                    : Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: CustomColors.darkRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          messages.toString(),
                          style: CustomTextStyle.bodyMidium(context).copyWith(
                              color: CustomColors.backGround(context)),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CalculatePage(
                uid: uid.toString(),
                username: userName,
              ),
            ),
          );
        },
        child: const FaIcon(FontAwesomeIcons.calculator),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomTabbar(
        navbarItems: [
          IconButton(
            onPressed: () {
              setState(() {
                _index = 0;
              });
            },
            icon: SvgPicture.asset(
              _index == 0
                  ? "assets/icons/home_filled.svg"
                  : "assets/icons/home_outlined.svg",
              colorFilter: ColorFilter.mode(
                CustomColors.greenn(context),
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _index = 1;
              });
            },
            icon: SvgPicture.asset(
              _index == 1
                  ? "assets/icons/profile_filled.svg"
                  : "assets/icons/profile_outlined.svg",
              colorFilter: ColorFilter.mode(
                CustomColors.greenn(context),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: CustomColors.backGround(context),
        ),
        child: pages.elementAt(_index),
      ),
    );
  }
}
