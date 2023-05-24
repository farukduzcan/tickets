import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/home.dart';
import 'package:tickets/models/user_model.dart';
import 'package:tickets/view/Login/login_screen.dart';
import 'package:tickets/view/TicketList/ticket_details_body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserModel.userToken = await getToken();
  await loadUserData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/ticket_details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is int) {
            return TicketDetailsBody(id: args);
          } else {
            return const LoginScreen();
          }
        },
      },
      debugShowCheckedModeBanner: false,
      title: 'Ticket',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: UserModel.userToken != null
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
