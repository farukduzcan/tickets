import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:tickets/constants.dart';
import 'package:tickets/services/manage_info_services.dart';
import 'package:tickets/view/Category/CategoryCreate/category_create.dart';
import 'package:tickets/view/Category/CategoryList/category_list.dart';
import 'package:tickets/view/CreateTicket/components/body.dart';
import 'package:tickets/view/Customer/CustomerCreate/customer_create_body.dart';
import 'package:tickets/view/Customer/CustomerList/customerlist.dart';
import 'package:tickets/view/Dashboard/body.dart';
import 'package:tickets/view/Login/login_screen.dart';
import 'package:tickets/view/Profile/ProfileScreen/profile_screen_body.dart';
import 'package:tickets/view/TicketList/ticket_list_body.dart';

import 'components/drawer_item.dart';
import 'components/page_control.dart';
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
  PageControl pageControl = PageControl();
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
      //    _toggleRotation();
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

  int navbarIndex(int index) {
    switch (index) {
      case 0:
        return 0;

      case 2:
        return 1;

      case 3:
        return 2;
      default:
        return -1;
    }
  }

  List<Widget>? appBarActions(int index) {
    switch (index) {
      case 4:
        return [];
      default:
        return null;
    }
  }

  String? companyName;
  @override
  initState() {
    super.initState();
    manageInfo();
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
        companyName = "  Müşteri";
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
            title: Text(
              pageControl.getCurrentPageData().appBarTitle,
            ),
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
                Container(
                  width: 233,
                  color: kPrimaryColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 15, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 30,
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
                            Column(
                              children: [
                                Text(
                                  "$companyName",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                      "  ${UserModel.userData!.firstName!} ${UserModel.userData!.lastName!}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: double.infinity,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
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
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    children: [
                      DrawerItem(
                        isSelected: pageControl.pages[0].isActivated,
                        title: kHomeTitle,
                        press: () {
                          setState(() {
                            pageControl.onItemTapped(0);
                          });
                          Navigator.pop(context);
                        },
                        icon: Icons.home,
                      ),
                      DrawerItem(
                        isSelected: pageControl.pages[3].isActivated,
                        title: kProfileTitle,
                        press: () {
                          setState(() {
                            pageControl.onItemTapped(3);
                          });
                          Navigator.pop(context);
                        },
                        icon: Icons.person,
                      ),
                      ExpansionTile(
                          initiallyExpanded: pageControl.pages[1].isActivated ||
                                  pageControl.pages[2].isActivated
                              ? true
                              : false,
                          collapsedIconColor: Colors.white,
                          childrenPadding: const EdgeInsets.only(left: 20),
                          leading: const Icon(
                            Icons.outgoing_mail,
                            color: Colors.white,
                          ),
                          iconColor: Colors.white,
                          shape: const StadiumBorder(),
                          title: const Text("Talep İşlemleri",
                              style: TextStyle(color: Colors.white)),
                          children: [
                            DrawerItem(
                              isSelected: pageControl.pages[2].isActivated,
                              title: kTicketListTitle,
                              press: () {
                                setState(() {
                                  pageControl.onItemTapped(2);
                                });
                                Navigator.pop(context);
                              },
                              icon: Icons.mail,
                            ),
                            DrawerItem(
                              isSelected: pageControl.pages[1].isActivated,
                              title: kTicketTitle,
                              press: () {
                                setState(() {
                                  pageControl.onItemTapped(1);
                                });
                                Navigator.pop(context);
                              },
                              icon: Icons.add_box,
                            ),
                          ]),
                      UserModel.userData!.role == 2
                          ? ExpansionTile(
                              initiallyExpanded:
                                  pageControl.pages[4].isActivated ||
                                          pageControl.pages[5].isActivated
                                      ? true
                                      : false,
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
                                    isSelected:
                                        pageControl.pages[4].isActivated,
                                    title: kCustomerListTitle,
                                    press: () {
                                      setState(() {
                                        pageControl.onItemTapped(4);
                                      });
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.people_alt_rounded,
                                  ),
                                  DrawerItem(
                                    isSelected:
                                        pageControl.pages[5].isActivated,
                                    title: "Müşteri Oluştur",
                                    press: () {
                                      setState(() {
                                        pageControl.onItemTapped(5);
                                      });
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.person_add_alt_1,
                                  ),
                                ])
                          : const SizedBox(),
                      UserModel.userData!.role == 2
                          ? ExpansionTile(
                              initiallyExpanded:
                                  pageControl.pages[6].isActivated ||
                                          pageControl.pages[7].isActivated
                                      ? true
                                      : false,
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
                                    isSelected:
                                        pageControl.pages[6].isActivated,
                                    title: kCategoryListTitle,
                                    press: () {
                                      setState(() {
                                        pageControl.onItemTapped(6);
                                      });
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.list_alt_outlined,
                                  ),
                                  DrawerItem(
                                    isSelected:
                                        pageControl.pages[7].isActivated,
                                    title: kCategoryCreateTitle,
                                    press: () {
                                      setState(() {
                                        pageControl.onItemTapped(7);
                                      });
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.add_box,
                                  ),
                                ])
                          : const SizedBox(),
                      DrawerItem(
                        isSelected: false,
                        title: kLogoutTitle,
                        press: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            barrierDismissible: false,
                            title: QuickAlertConstant.logout,
                            text: QuickAlertConstant.logoutMessage,
                            confirmBtnText: QuickAlertConstant.yes,
                            cancelBtnText: QuickAlertConstant.no,
                            confirmBtnColor: Colors.green,
                            showCancelBtn: true,
                            cancelBtnTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            onConfirmBtnTap: () async {
                              await deleteToken();
                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) =>
                                    false, // Geri tuşuna basıldığında hiçbir sayfa kalmadığı için false döndür
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: kPrimaryColor,
                  child: Center(
                    child: Text(
                      kVersionTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: pageControl.getCurrentPageData().screen,
          bottomNavigationBar: isKeyboardVisible == false
              ? Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: kPrimaryColor,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: GNav(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: kPrimaryColor,
                      color: Colors.white,
                      activeColor: Colors.white,
                      tabBackgroundColor: Colors.white24,
                      gap: 8,
                      rippleColor: Colors.white,
                      selectedIndex: navbarIndex(PageControl.currentIndex),
                      tabs: [
                        GButton(
                          icon: Icons.home_outlined,
                          text: 'Home',
                          active: pageControl.pages[0].isActivated,
                          onPressed: () {
                            setState(() {
                              pageControl.onItemTapped(0);
                            });
                          },
                        ),
                        GButton(
                          icon: Icons.mail_outline_outlined,
                          text: kTicketListTitle,
                          active: pageControl.pages[2].isActivated,
                          onPressed: () {
                            setState(() {
                              pageControl.onItemTapped(2);
                            });
                          },
                        ),
                        GButton(
                          icon: Icons.person,
                          text: kProfileTitle,
                          active: pageControl.pages[3].isActivated,
                          onPressed: () {
                            setState(() {
                              pageControl.onItemTapped(3);
                            });
                          },
                        ),
                      ]),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
