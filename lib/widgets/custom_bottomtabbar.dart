import 'package:flutter/material.dart';
import 'package:whopayed/helper/custom_colors.dart';

class CustomBottomTabbar extends StatelessWidget {
  const CustomBottomTabbar({
    Key? key,
    required this.navbarItems,
  }) : super(key: key);

  final List<Widget> navbarItems;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: CustomColors.backGround(context),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: navbarItems,
        ),
      ),
    );
  }
}
