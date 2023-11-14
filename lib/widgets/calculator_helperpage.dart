import 'package:flutter/material.dart';

class CalculatorHelperPage extends StatelessWidget {
  const CalculatorHelperPage({Key? key, required this.finalChild})
      : super(key: key);

  final Widget finalChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: finalChild,
    );
  }
}
