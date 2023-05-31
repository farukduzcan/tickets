// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tickets/view/Dashboard/components/dashboard_card.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Container(
        //   height: size.height * 0.15,
        //   decoration: BoxDecoration(
        //     boxShadow: kContainerBoxShodow,
        //     color: kPrimaryColor,
        //     borderRadius: const BorderRadius.only(
        //       bottomLeft: Radius.circular(40),
        //       bottomRight: Radius.circular(40),
        //     ),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 20.0, right: 20),
        //     child: TopIconAndText(
        //         icon: Icons.business_center_outlined,
        //         welcomeText: "Hoş geldin",
        //         nameText: UserModel.userData!.firstName!),
        //   ),
        // ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
              children: const [
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
          ),
        )
      ],
    );
  }
}
