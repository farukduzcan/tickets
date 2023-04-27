import 'package:flutter/material.dart';

import '../../../constants.dart';

class DashboardCard extends StatelessWidget {
  String imageAssets;
  String title;
  int count;
  DashboardCard({
    Key? key,
    required this.imageAssets,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          boxShadow: kCardBoxShodow,
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(13)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAssets, width: 80, height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Text(title),
          ),
          Text(count.toString()),
        ],
      ),
    );
  }
}
