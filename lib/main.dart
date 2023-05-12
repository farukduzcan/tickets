import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/home.dart';
import 'package:tickets/models/user_model.dart';
import 'package:tickets/view/Login/login_screen.dart';

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
