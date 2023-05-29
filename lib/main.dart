import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/home.dart';
import 'package:tickets/models/user_model.dart';
import 'package:tickets/services/user_info_services.dart';
import 'package:tickets/view/Login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserModel.userToken = await getToken();
  await loadUserData();
  UserInfoServices userInfoServices = UserInfoServices();
  // ignore: unused_local_variable
  var result = await userInfoServices.user();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  tokenvalidMain() {
    if (UserModel.userToken != null) {
      if (UserInfoServices.isTokenValid == true) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    } else {
      return const LoginScreen();
    }
  }

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
      home: tokenvalidMain(),
    );
  }
}
