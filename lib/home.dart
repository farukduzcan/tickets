import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:tickets/constants.dart';
import 'package:tickets/services/manage_info_services.dart';
import 'package:tickets/view/Category/CategoryCreate/category_create.dart';
import 'package:tickets/view/Category/CategoryList/category_list.dart';
import 'package:tickets/view/CreateTicket/components/body.dart';
import 'package:tickets/view/Customer/CustomerCreate/customer_create_body.dart';
import 'package:tickets/view/Customer/CustomerList/customerlist.dart';
import 'package:tickets/view/Dashboard/components/body.dart';
import 'package:tickets/view/Login/login_screen.dart';
import 'package:tickets/view/Profile/ProfileScreen/profile_screen_body.dart';
import 'package:tickets/view/TicketList/ticket_list_body.dart';

import 'components/drawer_item.dart';
import 'components/nav_bar_item.dart';
import 'models/user_model.dart';

class HomeScreen extends StatefulWidget {
  static String? companyName;

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Size get size => MediaQuery.of(context).size;
  bool isExpandedDrawer = false;
  //Navigasyon Barı İçin
  bool isKeyboardActived = false;
  int currentIndex = 0;
  final screens = [
    const DashboardBody(), //anasayfa 0. İndex
    const CreateTicketBody(), //ticket oluşturma 1. İndex
    const TicketListBody(), //ticket listesi 2. İndex
    const ProfileScreenBody(), //profil 3. İndex
    const CustomerListBody(), //müşteri listesi 4. İndex
    const CreateCustomerBody(), //müşteri oluşturma 5. İndex
    const CategoryListBody(), //kategori listesi 6. İndex
    const CreateCategoryBody(), //kategori oluşturma 7. İndex
  ];
  final isActivated = [
    true, //anasayfa 0. İndex
    false, //ticket oluşturma 1. İndex
    false, //ticket listesi 2. İndex
    false, //profil 3. İndex
    false, //müşteri listesi 4. İndex
    false, //müşteri oluşturma 5. İndex
    false, //kategori listesi 6. İndex
    false, //kategori oluşturma 7. İndex
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

  List<String> appBarTitle = [
    kHomeTitle, //anasayfa 0. İndex
    kTicketTitle, //ticket oluşturma 1. İndex
    kTicketListTitle, //ticket listesi 2. İndex
    kProfileTitle, //profil 3. İndex
    kCustomerListTitle, //müşteri listesi 4. İndex
    kCustomerCreateTitle, //müşteri oluşturma 5. İndex
    kCategoryListTitle, //kategori listesi 6. İndex
    kCategoryCreateTitle, //kategori oluşturma 7. İndex
  ];

  List<Widget>? appBarActions(int index) {
    switch (index) {
      case 4:
        return [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              splashRadius: 20,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCustomerBody(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add_alt),
              color: Colors.white,
            ),
          )
        ];
      case 5:
        return [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              splashRadius: 20,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCategoryBody(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              color: Colors.white,
            ),
          )
        ];
      default:
        return null;
    }
  }
  //Animasyon için

  AnimationController? _animationController;
  String? companyName;
  @override
  initState() {
    super.initState();
    manageInfo();
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

  Future<void> manageInfo() async {
    if (UserModel.userData!.role == 2) {
      var manageInfo = ManageInfoServices();
      // ignore: unused_local_variable
      var response = await manageInfo.manageinfo();
      setState(() {
        companyName = response!.data!.name;
      });
    } else {
      setState(() {
        companyName = "Müşteri";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            actions: appBarActions(currentIndex),
            centerTitle: true,
            shadowColor: kPrimaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(29),
                bottomRight: Radius.circular(29),
              ),
            ),
            backgroundColor: kPrimaryColor,
            title: Text(appBarTitle[currentIndex]),
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: kScaffoldBackgroundColor,
          drawerEdgeDragWidth: 233,
          drawer: Drawer(
            backgroundColor: kPrimaryColor,
            width: 233,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 2,
                          top: 30,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: ClipOval(
                                child: Icon(
                                  UserModel.userData!.role == 2
                                      ? Icons.business_outlined
                                      : Icons.person,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                            Text(
                              "    $companyName",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text(
                            "${UserModel.userData!.firstName!} ${UserModel.userData!.lastName!}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ),
                      Text(
                        UserModel.userData!.email!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 2),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    children: [
                      DrawerItem(
                        isSelected: isActivated[0],
                        title: kHomeTitle,
                        press: () {
                          onItemTapped(0);
                          Navigator.pop(context);
                        },
                        icon: Icons.home,
                      ),
                      DrawerItem(
                        isSelected: isActivated[2],
                        title: kTicketListTitle,
                        press: () {
                          onItemTapped(2);
                          Navigator.pop(context);
                        },
                        icon: Icons.mail,
                      ),
                      DrawerItem(
                        isSelected: isActivated[3],
                        title: kProfileTitle,
                        press: () {
                          onItemTapped(3);
                          Navigator.pop(context);
                        },
                        icon: Icons.person,
                      ),
                      ExpansionTile(
                          onExpansionChanged: (value) {
                            setState(() {
                              isExpandedDrawer = value;
                            });
                          },
                          initiallyExpanded: isExpandedDrawer,
                          collapsedIconColor: Colors.white,
                          childrenPadding: const EdgeInsets.only(left: 20),
                          leading: const Icon(
                            Icons.person_search_rounded,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white,
                          shape: const StadiumBorder(),
                          title: const Text("Müşteri İşlemleri",
                              style: TextStyle(color: Colors.white)),
                          children: [
                            DrawerItem(
                              isSelected: isActivated[4],
                              title: kCustomerListTitle,
                              press: () {
                                onItemTapped(4);
                                Navigator.pop(context);
                              },
                              icon: Icons.people_alt_rounded,
                            ),
                            DrawerItem(
                              isSelected: isActivated[5],
                              title: "Müşteri Oluştur",
                              press: () {
                                onItemTapped(5);
                                Navigator.pop(context);
                              },
                              icon: Icons.person_add_alt_1,
                            ),
                          ]),
                      ExpansionTile(
                          onExpansionChanged: (value) {
                            setState(() {
                              isExpandedDrawer = value;
                            });
                          },
                          initiallyExpanded: isExpandedDrawer,
                          collapsedIconColor: Colors.white,
                          childrenPadding: const EdgeInsets.only(left: 20),
                          leading: const Icon(
                            Icons.category,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white,
                          shape: const StadiumBorder(),
                          title: const Text("Kategori İşlemleri",
                              style: TextStyle(color: Colors.white)),
                          children: [
                            DrawerItem(
                              isSelected: isActivated[6],
                              title: kCategoryListTitle,
                              press: () {
                                onItemTapped(6);
                                Navigator.pop(context);
                              },
                              icon: Icons.list_alt_outlined,
                            ),
                            DrawerItem(
                              isSelected: isActivated[7],
                              title: kCategoryCreateTitle,
                              press: () {
                                onItemTapped(7);
                                Navigator.pop(context);
                              },
                              icon: Icons.add_box,
                            ),
                          ]),
                      DrawerItem(
                        isSelected: false,
                        title: kLogoutTitle,
                        press: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            barrierDismissible: false,
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
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginScreen();
                                  },
                                ),
                              );
                            },
                            onCancelBtnTap: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        icon: Icons.logout_outlined,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    kVersionTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NavBarItem(
                        width: size.width * 0.10,
                        isActive: isActivated[0],
                        icon: Icons.home_outlined,
                        title: kHomeTitle,
                        press: () {
                          onItemTapped(0);
                        },
                      ),
                      NavBarItem(
                          width: size.width * 0.10,
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
                          width: size.width * 0.10,
                          isActive: isActivated[3],
                          icon: Icons.person_outline_outlined,
                          title: kProfileTitle,
                          press: () {
                            onItemTapped(3);
                          }),
                      NavBarItem(
                          width: size.width * 0.10,
                          isActive: false,
                          icon: Icons.logout_outlined,
                          title: kLogoutTitle,
                          press: () async {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              barrierDismissible: false,
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
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const LoginScreen();
                                    },
                                  ),
                                );
                              },
                              onCancelBtnTap: () {
                                Navigator.pop(context);
                              },
                            );
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
