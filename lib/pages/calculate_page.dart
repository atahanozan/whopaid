import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/custom_paddings.dart';
import 'package:whopayed/helper/text_styles.dart';
import 'package:whopayed/helper/texts.dart';
import 'package:whopayed/helper/utils.dart';
import 'package:whopayed/services/message_service.dart';
import 'package:whopayed/widgets/calculator_helperpage.dart';
import 'package:whopayed/widgets/google_ads_widget.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({
    Key? key,
    required this.uid,
    required this.username,
  }) : super(key: key);

  final String uid;
  final String username;

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _payController = TextEditingController();
  final MessageService _messageService = MessageService();
  Map<String, dynamic> names = {};
  Map<String, dynamic> friends = {};
  Map<String, dynamic> finalPayments = {};
  int peopleCount = 0;
  int perPay = 0;
  int totalPayment = 0;
  int page = 0;
  int payed = 0;
  int totalDue = 0;
  String pageValue = "TL";
  bool firstPage = true;
  List<int> pays = [];
  Map<String, int> debt = {};
  Map<String, int> payee = {};
  DateTime selectedDate = DateTime.now();

  bool calculateButtonVisibility = true;
  bool payDoneVisibility = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    _firestore
        .collection("Users")
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      for (var snap in snapshot.docs) {
        setState(() {
          names.addAll({
            widget.username: {
              "username": widget.username,
              "uid": widget.uid,
              "name": snap["name"],
              "statu": "",
              "payTo": "",
              "payment": 0,
            }
          });
          friends = snap["friends"];
          totalDue = snap["totaldue"];
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _payController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.greenn(context),
      appBar: AppBar(
        title: const Text(TextsTR.calcpgTitle),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        margin: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: CustomColors.backGround(context),
        ),
        child: Column(
          children: [
            const GoogleAdsWidget(),
            CustomPaddings.verticalPadding(10),
            Expanded(
              child: firstPage
                  ? Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Utils.imageBox(
                            "assets/start.png",
                          ),
                          CustomPaddings.verticalPadding(20),
                          Text(
                            TextsTR.calcpgStart,
                            style: CustomTextStyle.bodyLarge(context),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> namesIndex = names.values
                            .elementAt(peopleCount < names.length
                                ? peopleCount
                                : index);

                        List<dynamic> finalNames = names.keys.toList();
                        List<Widget> pages = [
                          _chooseFriends(finalNames),
                          _registerPayments(finalNames, namesIndex, context),
                          _finalPayments(),
                        ];
                        return pages[page];
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                if (firstPage) {
                  setState(() {
                    firstPage = false;
                  });
                } else {
                  if (page == 0) {
                    setState(() {
                      page = 1;
                    });
                  } else if (page == 1) {
                    if (names.length == 1) {
                      Utils.snackBar(context, TextsTR.calcpgErrChoosePerson);
                    } else {
                      if ((peopleCount - names.length) == 0) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => const AlertDialog(
                            backgroundColor: Colors.transparent,
                            content: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()),
                          ),
                        );
                        for (var element in names.entries) {
                          final Map<String, dynamic> detail = element.value;
                          setState(() {
                            pays.add(detail["payment"]);
                          });
                        }
                        Timer(const Duration(seconds: 3), () {
                          Navigator.pop(context);
                          setState(() {
                            page = 2;
                            perPay = (totalPayment ~/ pays.length);
                            totalDue += totalPayment;
                            for (var pp in names.entries) {
                              Map<String, dynamic> details = pp.value;
                              int save = (perPay - details["payment"]).toInt();
                              if (save < 0) {
                                setState(() {
                                  debt[pp.key] = save * -1;
                                  details["statu"] = "debt";
                                });
                              } else {
                                setState(() {
                                  payee[pp.key] = save;
                                  details["statu"] = "payee";
                                });
                              }
                            }
                          });
                          _firestore
                              .collection("Users")
                              .doc(widget.uid)
                              .update({
                            "totaldue": totalDue,
                          });
                        });
                      } else {
                        Utils.snackBar(
                          context,
                          TextsTR.calcpgErrLesPerson,
                        );
                      }
                    }
                  } else if (page == 2) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(
                firstPage
                    ? TextsTR.btnStart
                    : page == 2
                        ? TextsTR.btnEnd
                        : TextsTR.btnForward,
              ),
            ),
            CustomPaddings.verticalPadding(5),
            Visibility(
              visible: page == 1 ? true : false,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    page = 0;
                  });
                },
                child: const Text(TextsTR.btnBackward),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CalculatorHelperPage _finalPayments() {
    return CalculatorHelperPage(
      finalChild: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Utils.imageBox("assets/calculate.png"),
          CustomPaddings.verticalPadding(20),
          Visibility(
            visible: calculateButtonVisibility,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColors.browns,
              ),
              child: Column(
                children: [
                  Text(
                    TextsTR.calcpgCalculateExp,
                    style: CustomTextStyle.bodyLarge(context),
                    textAlign: TextAlign.center,
                  ),
                  CustomPaddings.verticalPadding(20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: CustomColors.backGround(context),
                    ),
                    onPressed: () {
                      if (debt.values.isNotEmpty && payee.values.isNotEmpty) {
                        int kalan = 0;
                        String debtKey = debt.keys.elementAt(0);
                        String payeeKey = payee.keys.elementAt(0);
                        int debtPayment = debt.values.elementAt(0);
                        int payeePayment = payee.values.elementAt(0);

                        setState(() {
                          int datetime = DateTime.now().millisecondsSinceEpoch;
                          kalan = payeePayment - debtPayment;
                          Map<String, dynamic> payeeDetail = names[payeeKey];

                          if (kalan == 0) {
                            setState(() {
                              payed += payeePayment;
                              debt.remove(debtKey);
                              payee.remove(payeeKey);
                              finalPayments.addAll({
                                datetime.toString(): {
                                  "username": payeeDetail["username"],
                                  "uid": payeeDetail["uid"],
                                  "payTo": debtKey,
                                  "payDue": payeePayment,
                                }
                              });
                            });
                          } else if (kalan < 0) {
                            setState(() {
                              payed += payeePayment;
                              payee.remove(payeeKey);
                              debt.update(debtKey, (value) => kalan * -1);
                              finalPayments.addAll({
                                datetime.toString(): {
                                  "username": payeeDetail["username"],
                                  "uid": payeeDetail["uid"],
                                  "payTo": debtKey,
                                  "payDue": payeePayment,
                                }
                              });
                            });
                          } else {
                            setState(() {
                              payed += payeePayment - kalan;
                              debt.remove(debtKey);
                              payee.update(payeeKey, (value) => kalan);
                              finalPayments.addAll({
                                datetime.toString(): {
                                  "username": payeeDetail["username"],
                                  "uid": payeeDetail["uid"],
                                  "payTo": debtKey,
                                  "payDue": payeePayment - kalan,
                                }
                              });
                            });
                          }
                        });
                      } else {
                        setState(() {
                          calculateButtonVisibility = false;
                          payDoneVisibility = true;
                        });
                      }
                    },
                    child: const Text(TextsTR.btnCalculate),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: payDoneVisibility,
            child: Text(
              TextsTR.calcpgWarnPaysDone,
              style: CustomTextStyle.headerSmall(context),
            ),
          ),
          CustomPaddings.verticalPadding(20),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TextsTR.calcpgPayments,
                style: CustomTextStyle.headerMidium(context),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    fixedSize: const Size.fromHeight(20)),
                onPressed: () {
                  if (finalPayments.isNotEmpty) {
                    Utils.snackBar(context, TextsTR.calcpgErrSendMessage);
                    _firestore.collection("Users").doc(widget.uid).update({
                      "totaldue": totalDue,
                    });
                    String finalDateTime =
                        selectedDate.toString().split(" ")[0];

                    for (var element in finalPayments.entries) {
                      int datetime = DateTime.now().millisecondsSinceEpoch;
                      final Map<String, dynamic> messageIndex = element.value;

                      _messageService.addMessage(
                        true,
                        widget.uid,
                        messageIndex["uid"],
                        "$finalDateTime tarihinde ki organizasyon için ${messageIndex["payTo"]} kişisine ${messageIndex["payDue"]} $pageValue tutarında ödeme yapmanız gerekmektedir.",
                        messageIndex["payTo"],
                        widget.username,
                        datetime,
                      );
                    }
                  } else {
                    Utils.snackBar(context, TextsTR.calcpgErrShare);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.send,
                      size: 20,
                      color: CustomColors.greenn(context),
                    ),
                    CustomPaddings.horizontalPadding(10),
                    Text(
                      TextsTR.btnShare,
                      style: CustomTextStyle.bodyLarge(context).copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomPaddings.verticalPadding(20),
          ListView.builder(
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: finalPayments.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> paymentDetails =
                  finalPayments.values.elementAt(index);

              return Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: CustomColors.darkRed,
                  ),
                ),
                child: TextsTR.calcpgResult(
                  paymentDetails["username"],
                  paymentDetails["payTo"],
                  paymentDetails["payDue"].toString(),
                  context,
                ),
              );
            },
          ),
          CustomPaddings.verticalPadding(30),
        ],
      ),
    );
  }

  CalculatorHelperPage _registerPayments(List<dynamic> finalNames,
      Map<String, dynamic> namesIndex, BuildContext context) {
    return CalculatorHelperPage(
      finalChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: names.isEmpty ? false : true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: CustomColors.greenn(context),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        TextsTR.calcpgBill,
                        style: CustomTextStyle.headerLarge(context),
                      ),
                      CustomPaddings.verticalPadding(20),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              TextsTR.calcpgPayFrom,
                              style: CustomTextStyle.headerSmall(context),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              TextsTR.calcpgTotal,
                              style: CustomTextStyle.headerSmall(context),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: names.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> nameDetail =
                              names.values.elementAt(index);
                          String name = nameDetail["username"];

                          int payment = nameDetail["payment"];

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? CustomColors.browns
                                  : Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    name,
                                    style: CustomTextStyle.bodyLarge(context),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "$payment $pageValue",
                                    style: CustomTextStyle.bodyLarge(context),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              TextsTR.calcpgTotal,
                              style: CustomTextStyle.headerSmall(context),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "$totalPayment $pageValue",
                              style: CustomTextStyle.headerSmall(context),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              TextsTR.calcpgPerPerson,
                              style: CustomTextStyle.bodyMidium(context),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${totalPayment ~/ names.length} $pageValue",
                              style: CustomTextStyle.bodyMidium(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomPaddings.verticalPadding(20),
          Visibility(
            visible: (peopleCount - finalNames.length) == 0 ? false : true,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CustomColors.browns,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ((peopleCount - finalNames.length) < 0)
                              ? Text(
                                  finalNames[peopleCount],
                                  style: CustomTextStyle.headerMidium(context),
                                  textAlign: TextAlign.right,
                                )
                              : const Text("")),
                      CustomPaddings.horizontalPadding(10),
                      const Text(":"),
                      CustomPaddings.horizontalPadding(10),
                      Expanded(
                        child: TextField(
                          scrollPadding: const EdgeInsets.only(bottom: 40),
                          controller: _payController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: CustomTextStyle.bodyLarge(context),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintStyle: CustomTextStyle.bodySmall(context),
                            errorStyle: CustomTextStyle.bodySmall(context),
                            labelStyle: CustomTextStyle.bodySmall(context),
                            helperStyle: CustomTextStyle.bodySmall(context),
                            prefixStyle: CustomTextStyle.bodySmall(context),
                            suffixStyle: CustomTextStyle.bodySmall(context),
                            counterStyle: CustomTextStyle.bodySmall(context),
                            floatingLabelStyle:
                                CustomTextStyle.bodySmall(context),
                            filled: true,
                            label: const Text(TextsTR.calcpgPayDue),
                          ),
                        ),
                      ),
                      CustomPaddings.horizontalPadding(10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: CustomColors.backGround(context),
                          ),
                          onPressed: () {
                            if (int.parse(_payController.text) >= 0) {
                              if ((peopleCount - finalNames.length) < 0) {
                                setState(() {
                                  totalPayment +=
                                      int.parse(_payController.text);
                                  namesIndex.update(
                                      "payment",
                                      (value) =>
                                          int.parse(_payController.text));

                                  _payController.clear();
                                  peopleCount++;
                                });
                              } else {
                                Utils.snackBar(
                                    context, TextsTR.calcpgErrOverPerson);
                              }
                            } else {
                              Utils.snackBar(
                                  context, TextsTR.calcpgErrRegisterPayment);
                            }
                          },
                          child: const Text(TextsTR.btnAdd),
                        ),
                      ),
                    ],
                  ),
                  DropdownButton(
                    dropdownColor: CustomColors.backGround(context),
                    items: [
                      DropdownMenuItem(
                        value: "TL",
                        child: Text(
                          "TL",
                          style: CustomTextStyle.bodyLarge(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "USD",
                        child: Text(
                          "USD",
                          style: CustomTextStyle.bodyLarge(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "EUR",
                        child: Text(
                          "EUR",
                          style: CustomTextStyle.bodyLarge(context),
                        ),
                      ),
                    ],
                    value: pageValue,
                    onChanged: (otherValue) {
                      setState(() {
                        pageValue = otherValue.toString();
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CalculatorHelperPage _chooseFriends(List<dynamic> finalNames) {
    return CalculatorHelperPage(
      finalChild: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: CustomColors.brown(context),
            ),
            child: Column(
              children: [
                Text(
                  selectedDate.toString().split(" ")[0],
                  style: CustomTextStyle.headerLarge(context)
                      .copyWith(color: CustomColors.blackTables),
                ),
                CustomPaddings.verticalPadding(10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: CustomColors.backGround(context),
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: const Text(TextsTR.calcpgWarnChsDat),
                ),
              ],
            ),
          ),
          const Divider(),
          Text(
            TextsTR.calcpgScdTitle,
            style: CustomTextStyle.headerLarge(context),
          ),
          CustomPaddings.verticalPadding(10),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: friends.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> friendsIndex =
                  friends.values.elementAt(index);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: finalNames.contains(friendsIndex["username"])
                      ? CustomColors.browns
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Utils.friendsListTile(
                    friendsIndex["avatar"], friendsIndex["username"], () {
                  if (finalNames.contains(friendsIndex["username"])) {
                    setState(() {
                      names.remove(friendsIndex["username"]);
                    });
                  } else {
                    setState(() {
                      names.addAll({
                        friendsIndex["username"]: {
                          "username": friendsIndex["username"],
                          "uid": friendsIndex["uid"],
                          "name": friendsIndex["name"],
                          "statu": "",
                          "payTo": "",
                          "payment": 0,
                        }
                      });
                    });
                  }
                },
                    finalNames.contains(friendsIndex["username"])
                        ? TextsTR.btnRemove
                        : TextsTR.btnAdd,
                    const Text(""),
                    context),
              );
            },
          ),
        ],
      ),
    );
  }
}
