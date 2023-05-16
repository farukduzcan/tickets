import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:tickets/constants.dart';
import 'package:tickets/view/CreateTicket/components/body.dart';
import 'package:tickets/view/Dashboard/components/body.dart';
import 'package:tickets/view/Login/login_screen.dart';
import 'package:tickets/view/TicketList/ticket_list_body.dart';

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
  Size get size => MediaQuery.of(context).size;
  //Navigasyon Barı İçin
  bool isKeyboardActived = false;
  int currentIndex = 0;
  final screens = [
    const DashboardBody(),
    const CreateTicketBody(),
    const TicketListBody(),
  ];
  final isActivated = [
    true,
    false,
    false,
    false,
  ];

  void onItemTapped(int index) {
    setState(() {
      for (int i = 0; i < isActivated.length; i++) {
        isActivated[i] = false;
      }
      currentIndex = index;
      isActivated[index] = true;
      _toggleRotation();
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
      title: Text(kTicketListTitle),
    ),
  ];

  //Animasyon için

  AnimationController? _animationController;

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
    if (currentIndex == 1) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: appBars[currentIndex],
          resizeToAvoidBottomInset: false,
          backgroundColor: kScaffoldBackgroundColor,
          drawerEdgeDragWidth: 60,
          drawer: const DrawerBar(),
          body: screens[currentIndex],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              currentIndex == 1 ? onItemTapped(0) : onItemTapped(1);
            },
            backgroundColor: kPrimaryColor,
            child: AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController!.value * 1.23 * pi,
                  child: child,
                );
              },
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),

          // navigation bar
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
              height: isKeyboardVisible ? size.height * 0 : size.height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      NavBarItem(
                        isActive: isActivated[0],
                        icon: Icons.home_outlined,
                        title: kHomeTitle,
                        press: () {
                          onItemTapped(0);
                        },
                      ),
                      NavBarItem(
                          isActive: isActivated[2],
                          icon: Icons.mail_outline_outlined,
                          title: kTicketListTitle,
                          press: () {
                            onItemTapped(2);
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      NavBarItem(
                          isActive: isActivated[1],
                          icon: Icons.settings_outlined,
                          title: kSettingsTitle,
                          press: () {
                            onItemTapped(1);
                          }),
                      NavBarItem(
                          isActive: isActivated[3],
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
      },
    );
  }
}
