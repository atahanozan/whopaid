import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/pages/loginpages/choose_avatar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutselfController = TextEditingController();
  final TextEditingController _emptyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _aboutselfController.dispose();
    _emptyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greenn(context),
      appBar: AppBar(
        title: const Text(TextsTR.sttngsPgTitle),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
              .collection("Users")
              .where("uid", isEqualTo: widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot data = snapshot.data!.docs[index];

                      return Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(data["avatar"]),
                              ),
                              color: Colors.red,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChooseAvatarPage(
                                    uid: data["uid"],
                                    name: data["name"],
                                    email: data["email"],
                                    statu: "old",
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              TextsTR.btnEdit,
                              style: CustomTextStyle.bodyMidium(context)
                                  .copyWith(color: Colors.blue),
                            ),
                          ),
                          CustomPaddings.verticalPadding(25),
                          _customTextField(
                            data,
                            "name",
                            TextsTR.rgstrPgNameSur,
                            _nameController,
                            false,
                          ),
                          CustomPaddings.verticalPadding(10),
                          _customTextField(
                            data,
                            "aboutself",
                            TextsTR.sttngsPgAboutSelf,
                            _aboutselfController,
                            false,
                          ),
                          CustomPaddings.verticalPadding(35),
                          _customTextField(
                            data,
                            "email",
                            TextsTR.lgnPgEmail,
                            _emptyController,
                            true,
                          ),
                          CustomPaddings.verticalPadding(10),
                          _customTextField(
                            data,
                            "username",
                            TextsTR.sttngsPgUserName,
                            _emptyController,
                            true,
                          ),
                          CustomPaddings.verticalPadding(10),
                          _customTextField(
                            data,
                            "totaldue",
                            TextsTR.sttngsPgTotalDue,
                            _emptyController,
                            true,
                          ),
                          CustomPaddings.verticalPadding(10),
                          ElevatedButton(
                            onPressed: () {
                              if (_nameController.text.isNotEmpty &&
                                  _aboutselfController.text.isNotEmpty) {
                                setState(() {
                                  _firestore
                                      .collection("Users")
                                      .doc(widget.uid)
                                      .update({
                                    "name": _nameController.text,
                                    "aboutself": _aboutselfController.text,
                                  });
                                });
                                Navigator.pop(context);
                              } else if (_nameController.text.isNotEmpty) {
                                setState(() {
                                  _firestore
                                      .collection("Users")
                                      .doc(widget.uid)
                                      .update({
                                    "name": _nameController.text,
                                  });
                                });
                                Navigator.pop(context);
                              } else if (_aboutselfController.text.isNotEmpty) {
                                setState(() {
                                  _firestore
                                      .collection("Users")
                                      .doc(widget.uid)
                                      .update({
                                    "aboutself": _aboutselfController.text,
                                  });
                                });
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(TextsTR.btnSave),
                          ),
                        ],
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  Column _customTextField(
    QueryDocumentSnapshot<Object?> data,
    String dataName,
    String title,
    TextEditingController controller,
    bool readonly,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CustomTextStyle.bodyMidium(context)
              .copyWith(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          maxLength: 200,
          style: CustomTextStyle.bodyLarge(context),
          readOnly: readonly,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: data[dataName].toString(),
            hintStyle: CustomTextStyle.bodyLarge(context),
          ),
        ),
      ],
    );
  }
}
