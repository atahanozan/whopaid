import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/pages/add_friend.dart';
import 'package:whopayed/pages/profile_settings_pages/security_page.dart';
import 'package:whopayed/pages/profile_settings_pages/settings_page.dart';
import 'package:whopayed/services/user_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whopayed/widgets/change_theme.dart';

class ProfilePageSettings extends StatefulWidget {
  const ProfilePageSettings({Key? key}) : super(key: key);

  @override
  State<ProfilePageSettings> createState() => _ProfilePageSettingsState();
}

class _ProfilePageSettingsState extends State<ProfilePageSettings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserServices _services = UserServices();
  late User? user;
  String? uid, name, email;
  String avatar = "";
  bool private = false;
  double finalWidth(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;

    return size;
  }

  String userName = "";

  @override
  void initState() {
    setState(() {
      user = _auth.currentUser;
      uid = user?.uid;
      email = user?.email;
      _firestore
          .collection("Users")
          .where("uid", isEqualTo: uid)
          .get()
          .then((snapshots) {
        for (var element in snapshots.docs) {
          setState(() {
            name = element["name"];
            userName = element["username"];
            avatar = element["avatar"];
            private = element["private"];
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: CustomColors.backGround(context),
                  actionsOverflowButtonSpacing: 10,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ayarlar",
                        style: CustomTextStyle.headerLarge(context),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red.shade800,
                          ))
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ChangeThemeButton(),
                      _settingButtons(
                        "Profil",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingsPage(uid: uid.toString()),
                            ),
                          );
                        },
                      ),
                      _settingButtons(
                        "Gizlilik ve Güvenlik",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SecurityPage(
                                uid: uid.toString(),
                                private: private,
                              ),
                            ),
                          );
                        },
                      ),
                      _settingButtons(
                        "Uygulama Ayarları",
                        () {
                          openAppSettings();
                        },
                      ),
                    ],
                  ),
                  actions: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(finalWidth(context), 20),
                      ),
                      onPressed: () {
                        _services.deleteAccount(
                            user!, context, user!.uid.toString());
                      },
                      child: const Text("Hesabı Sil!"),
                    ),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(finalWidth(context), 20),
                      ),
                      onPressed: () {
                        _services.logOut(user!, context);
                      },
                      child: const Text("Çıkış Yap"),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddFriendPage(
                    avatar: avatar,
                    username: userName,
                    name: name.toString(),
                    uid: uid.toString(),
                    email: email.toString(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person_add_alt),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
          ),
        ),
      ],
    );
  }

  Widget _settingButtons(
    String btnName,
    VoidCallback btnFunc,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColors.greenn(context),
            width: 0.3,
          ),
        ),
      ),
      child: TextButton(
        onPressed: btnFunc,
        child: Text(
          btnName,
          style: CustomTextStyle.bodyLarge(context),
        ),
      ),
    );
  }
}
