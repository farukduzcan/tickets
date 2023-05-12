import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tickets/services/user_info_services.dart';
import 'package:tickets/view/Login/login_screen.dart';

import 'constants.dart';
import 'home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> checkTokenValidity() async {
    UserInfoServices userInfoServices = UserInfoServices();
    var response = await userInfoServices.user();
    var isTokenValid = UserInfoServices.isTokenValid;
    return isTokenValid;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return FutureBuilder<bool>(
      future: checkTokenValidity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Token geçerliliği kontrol ediliyor, yükleniyor göster
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // Token geçerlilik kontrolü tamamlandı
          if (snapshot.data!) {
            // Token geçerli ise HomeScreen'e yönlendir
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ticket',
              theme: ThemeData(
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: Colors.white,
              ),
              home: const HomeScreen(),
            );
          } else {
            // Token geçerli değil ise LoginScreen'e yönlendir
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ticket',
              theme: ThemeData(
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: Colors.white,
              ),
              home: const LoginScreen(),
            );
          }
        } else {
          // Token geçerlilik kontrolünde hata oluştu
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ticket',
            theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: const Text("Hata Oluştu"), // Hata ekranı gösterilebilir
          );
        }
      },
    );
  }
}
