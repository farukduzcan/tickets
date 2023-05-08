// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants.dart';

class TextFieldContainer extends StatefulWidget {
  final Color? color;
  final Widget child;
  final List<BoxShadow>? boxshodow;
  const TextFieldContainer({
    Key? key,
    this.color = kPrimaryLightColor,
    required this.child,
    this.boxshodow,
  }) : super(key: key);

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        boxShadow: kFieldBoxShodow,
        color: widget.color,
        borderRadius: BorderRadius.circular(29),
      ),
      child: widget.child,
    );
  }
}
