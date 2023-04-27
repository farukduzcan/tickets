// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tickets/constants.dart';
import 'package:tickets/view/Dashboard/components/dashboard_card.dart';
import 'package:tickets/view/Dashboard/components/top_icon_name.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: size.height * 0.15,
              decoration: BoxDecoration(
                boxShadow: kContainerBoxShodow,
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              child: TopIconAndText(
                  icon: Icons.business_center_outlined,
                  welcomeText: "Hoşgeldin",
                  nameText: "VeriPlus"),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        Expanded(
          child: GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            children: [
              DashboardCard(
                imageAssets: "assets/images/check.png",
                title: "Cevaplanan",
                count: 10,
              ),
              DashboardCard(
                imageAssets: "assets/images/time-left.png",
                title: "Cevap Bekleyen",
                count: 25,
              ),
              DashboardCard(
                imageAssets: "assets/images/complate.png",
                title: "Tamamlanan",
                count: 50,
              ),
              DashboardCard(
                imageAssets: "assets/images/complate.png",
                title: "Tamamlanan",
                count: 50,
              ),
              DashboardCard(
                imageAssets: "assets/images/complate.png",
                title: "Tamamlanan",
                count: 50,
              ),
              DashboardCard(
                imageAssets: "assets/images/complate.png",
                title: "Tamamlanan",
                count: 50,
              ),
              DashboardCard(
                imageAssets: "assets/images/complate.png",
                title: "Tamamlanan",
                count: 50,
              ),
              DashboardCard(
                imageAssets: "assets/images/complate.png",
                title: "Tamamlanan",
                count: 50,
              ),
            ],
          ),
        )
      ],
    );
  }
}


