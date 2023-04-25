import 'package:flutter/material.dart';

const kDarkPrimaryColor = Color(0xFF1976D2);
const kPrimaryLightColor = Color(0xFFBBDEFB);
const kPrimaryColor = Color(0xFF2196F3);
const kAccentColor = Color(0xFF4CAF50);
const kPrimaryTextColor = Color(0xFF212121);
const kSecondaryTextColor = Color(0xFF757575);
const kDividerColor = Color(0xFFBDBDBD);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF000000);

Padding kPaddingAllMin = const Padding(padding: EdgeInsets.all(20));
Padding kPaddingAllMid = const Padding(padding: EdgeInsets.all(40));
Padding kPaddingAllMax = const Padding(padding: EdgeInsets.all(60));

double kMarginAllMin = 20;
double kMarginAllMid = 40;
double kMarginAllMax = 60;

ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kPrimaryColor,
  shape: const StarBorder(),
  elevation: 3,
  shadowColor: kPrimaryColor,
  padding: kPaddingAllMin.padding,
  textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

TextStyle kTitleStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
);

String kLoginTitle = "GİRİŞ YAP";
String kRegisterTitle = "KAYIT OL";
String validateMessage = "Bu alan boş bırakılamaz";
String kEmailHintText = "E-posta";
String kPasswordHintText = "Şifre";
String kLoginButtonTitle = "Giriş Yap";
String kNameHintText = "İsim";
String kSurnameHintText = "Soyisim";
String kPhoneHintText = "Telefon";
String kRegisterButtonTitle = "Kayıt Ol";
String accountQuestionsHave = "Hesabınız var mı? ";
String accountQuestions = "Hesabınız Yok mu? ";
