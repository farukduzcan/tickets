import 'package:flutter/material.dart';

import '../constants.dart';
import '../view/Category/CategoryCreate/category_create.dart';
import '../view/Category/CategoryList/category_list.dart';
import '../view/CreateTicket/components/body.dart';
import '../view/Customer/CustomerCreate/customer_create_body.dart';
import '../view/Customer/CustomerList/customerlist.dart';
import '../view/Dashboard/body.dart';
import '../view/Profile/ProfileScreen/profile_screen_body.dart';
import '../view/TicketList/ticket_list_body.dart';

class PageControl extends ChangeNotifier {
  static int currentIndex = 0;
  final List<PageData> pages = [
    PageData(
      screen: const DashboardBody(),
      appBarTitle: kHomeTitle,
      isActivated: true,
    ),
    PageData(
      screen: const CreateTicketBody(),
      appBarTitle: kTicketTitle,
      isActivated: false,
    ),
    PageData(
      screen: const TicketListBody(),
      appBarTitle: kTicketListTitle,
      isActivated: false,
    ),
    PageData(
      screen: const ProfileScreenBody(),
      appBarTitle: kProfileTitle,
      isActivated: false,
    ),
    PageData(
      screen: const CustomerListBody(),
      appBarTitle: kCustomerListTitle,
      isActivated: false,
    ),
    PageData(
      screen: const CreateCustomerBody(),
      appBarTitle: kCustomerCreateTitle,
      isActivated: false,
    ),
    PageData(
      screen: const CategoryListBody(),
      appBarTitle: kCategoryListTitle,
      isActivated: false,
    ),
    PageData(
      screen: const CreateCategoryBody(),
      appBarTitle: kCategoryCreateTitle,
      isActivated: false,
    ),
  ];

  void onItemTapped(int index) {
    for (int i = 0; i < pages.length; i++) {
      pages[i].isActivated = false;
    }
    currentIndex = index;
    pages[index].setActivated(true);
    notifyListeners();
  }

  PageData getCurrentPageData() {
    return pages[currentIndex];
  }
}

class PageData {
  Widget screen;
  String appBarTitle;
  bool isActivated;

  PageData({
    required this.screen,
    required this.appBarTitle,
    required this.isActivated,
  });
  void setActivated(bool activated) {
    isActivated = activated;
  }
}
