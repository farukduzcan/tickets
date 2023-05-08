import 'package:flutter/material.dart';
import 'package:tickets/view/CreateTicket/components/body.dart';
import '../../components/drawer_bar.dart';
import '../../components/nav_bar.dart';
import '../../constants.dart';

class CreateTicketScreen extends StatelessWidget {
  const CreateTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kScaffoldBackgroundColor,
        drawerEdgeDragWidth: 60,
        drawer: const DrawerBar(),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          title: Text(kTicketTitle),
        ),
        body: const Body(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          isExtended: false,
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.close),
        ),
        bottomNavigationBar: const NavBar());
  }
}
