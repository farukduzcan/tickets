import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String imageAssets;
  final String title;
  final int count;
  const DashboardCard({
    Key? key,
    required this.imageAssets,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () {},
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
        ),
      ),
    );
  }
}
