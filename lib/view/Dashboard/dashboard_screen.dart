import 'package:flutter/material.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/view/Dashboard/components/body.dart';
import '../../components/drawer_bar.dart';
import '../../components/nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kScaffoldBackgroundColor,
        drawerEdgeDragWidth: 60,
        drawer: const DrawerBar(),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: const Body(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const NavBar());
  }
}
