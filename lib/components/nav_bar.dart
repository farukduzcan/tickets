import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tickets/components/nav_bar_item.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/models/user_model.dart';
import 'package:tickets/view/Login/login_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
                    setState(() {});
                  },
                ),
                NavBarItem(
                    icon: Icons.person_outline,
                    title: kProfileTitle,
                    press: () {}),
              ],
            ),
            Row(
              children: [
                NavBarItem(
                    icon: Icons.settings_outlined,
                    title: kSettingsTitle,
                    press: () {}),
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
                              color: Colors.black, fontWeight: FontWeight.bold),
                          //cancelBtnColor: Colors.green,
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
                      //await deleteToken();
                      // ignore: use_build_context_synchronously
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) {
                      //     return const LoginScreen();
                      //   }),
                      // );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
