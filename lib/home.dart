// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:tickets/constants.dart';
import 'package:tickets/view/CreateTicket/create_ticket_screen.dart';
import 'package:tickets/view/Dashboard/dashboard_screen.dart';
import 'package:tickets/view/Login/login_screen.dart';

import '../../components/drawer_bar.dart';
import 'components/nav_bar_item.dart';
import 'models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //Navigasyon Barı İçin
  int currentIndex = 0;
  final screens = [
    const DashboardScreen(),
    const CreateTicketScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  //App Bar İçin
  final appBars = [
    AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      title: Text(kHomeTitle),
    ),
    AppBar(
      centerTitle: true,
      shadowColor: kPrimaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(29),
          bottomRight: Radius.circular(29),
        ),
      ),
      backgroundColor: kPrimaryColor,
      title: Text(kTicketTitle),
    ),
  ];

  //Animasyon için

  AnimationController? _animationController;
  bool _isRotated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    if (_isRotated) {
      _animationController?.reverse();
    } else {
      _animationController?.forward();
    }
    _isRotated = !_isRotated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBars[currentIndex],
      resizeToAvoidBottomInset: false,
      backgroundColor: kScaffoldBackgroundColor,
      drawerEdgeDragWidth: 60,
      drawer: const DrawerBar(),
      body: screens[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleRotation();
          currentIndex == 1 ? onItemTapped(0) : onItemTapped(1);
        },
        backgroundColor: kPrimaryColor,
        child: AnimatedBuilder(
          animation: _animationController!,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animationController!.value * 2.23 * pi,
              child: child,
            );
          },
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
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
                    icon: Icons.home_outlined,
                    title: kHomeTitle,
                    press: () {
                      onItemTapped(0);
                    },
                  ),
                  NavBarItem(
                      icon: Icons.person_outline,
                      title: kProfileTitle,
                      press: () {
                        onItemTapped(1);
                      }),
                ],
              ),
              Row(
                children: [
                  NavBarItem(
                      icon: Icons.settings_outlined,
                      title: kSettingsTitle,
                      press: () {
                        onItemTapped(1);
                      }),
                  NavBarItem(
                      icon: Icons.logout_outlined,
                      title: kLogoutTitle,
                      press: () async {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: "Çıkış Yap",
                            text: "Çıkış Yapmak İstediğinize Emin Misiniz?",
                            confirmBtnText: "Evet",
                            cancelBtnText: "Hayır",
                            confirmBtnColor: Colors.green,
                            showCancelBtn: true,
                            cancelBtnTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            onConfirmBtnTap: () async {
                              await deleteToken();
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }),
                              );
                            },
                            onCancelBtnTap: () {
                              Navigator.pop(context);
                            });
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
