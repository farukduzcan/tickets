import 'package:flutter/material.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/view/Dashboard/components/body.dart';

import '../../components/nav_bar_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[20],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Text('Tickets'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {},
              ),
            ],
          ),
        ),
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
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    NavBarItem(
                        icon: Icons.dashboard_outlined,
                        title: 'Dashboard',
                        press: () {}),
                    NavBarItem(
                        icon: Icons.person_outline,
                        title: 'Profile',
                        press: () {}),
                  ],
                ),
                Row(
                  children: [
                    NavBarItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        press: () {}),
                    NavBarItem(
                        icon: Icons.logout_outlined,
                        title: 'Logout',
                        press: () {}),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
