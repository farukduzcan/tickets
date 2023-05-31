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
const kScaffoldBackgroundColor = Color.fromARGB(255, 255, 255, 255);

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

List<BoxShadow> kCardBoxShodow = [
  BoxShadow(
    offset: const Offset(0, 10),
    blurRadius: 50,
    color: kPrimaryTextColor.withOpacity(0.15),
  ),
];

List<BoxShadow> kContainerBoxShodow = [
  BoxShadow(
    spreadRadius: 10, // yayılma miktarı
    offset: const Offset(0, 20),
    blurRadius: 50, //Gölgelik yarıçapı (50 = gölgelik yarıçapı)
    color: kPrimaryColor.withOpacity(
        0.23), //Gölgelik rengi ve saydamlık değeri (0.23 = saydamlık değeri)
  ),
];

List<BoxShadow> kFieldBoxShodow = [
  BoxShadow(
    blurStyle: BlurStyle.normal,
    color: kPrimaryLightColor.withOpacity(0.5),
    spreadRadius: 3, //gölgenin yayılma miktarı
    blurRadius: 7,
    offset: const Offset(
        0, 3), // changes position of shadow değiştiriyor gölgenin konumunu
  ),
];

TextStyle kTitleStyle = const TextStyle(
  fontSize: 30,
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
String kCompanyName = "Şirket Ünvanı";
String kPhoneHintText = "Telefon";
String kRegisterButtonTitle = "Kayıt Ol";
String accountQuestionsHave = "Hesabınız var mı? ";
String accountQuestions = "Hesabınız Yok mu? ";

String kForgotPassword = "Şifremi Unuttum";
String kForgotPasswordSubTitle =
    " Şifrenizi sıfırlamak için e-posta adresinizi giriniz.";
String kForgotPasswordSendCode = "Kodu Gönder";
String kForgotPasswordLoadingText = "Kod Gönderiliyor...";
String kForgetConfirmTitle = "KOD DOĞRULAMA";
String kForgetConfirmSubtitle =
    "Şifrenizi sıfırlamak için lütfen e-posta adresinize gönderilen aktivasyon kodunu giriniz.";
String kForgetResetTitle = "ŞİFRE SIFIRLAMA";
String kForgetResetSubtitle = "Yeni şifrenizi giriniz.";
String kForgetResetButton = "Şifreyi Sıfırla";
String kForgetResetLoadingText = "Şifre Sıfırlanıyor...";
String kResetPasswordSuccess = "Şifreniz başarıyla değiştirildi.";

String kHomeTitle = "Anasayfa";
String kProfileTitle = "Profil";
String kSettingsTitle = "Ayarlar";
String kLogoutTitle = "Çıkış Yap";
String kLoginLoadingText = "Giriş Yapılıyor...";
String kRegisterLoadingText = "Kayıt Yapılıyor...";
String kLoginSuccessText = "Giriş Başarılı";
String kRegisterSuccessText = "Kayıt Başarılı";
String kLoginErrorText = "Giriş Başarısız";
String kRegisterErrorText = "Kayıt Başarısız";
String kLoginErrorTitle = "Giriş Hatası";
String kRegisterErrorTitle = "Kayıt Hatası";
String kLoginErrorEthernet = "İnternet bağlantınızı kontrol ediniz.";
String kRegisterErrorSubtitle = "Kayıt olurken bir hata oluştu";
String kErrorTitle = "Bir Hata Oluştu";
String kConfirmTitle = "Hesap Aktifleştirme";
String kConfirmSubtitle =
    "Hesabınızı aktifleştirmek için lütfen e-posta adresinize gönderilen aktivasyon kodunu giriniz.";
String kConfirincorrect = "Aktivasyon kodu hatalı";
String kConfirmSuccess = "Aktivasyon kodu doğru";
String kOk = "Tamam";
String kAlertSuccssesTitle = "Başarılı";
String kConfirmSuccessSubtitle = "Hesabınız başarıyla aktifleştirildi.";
String kAlertConfirmLoadingTitle = "Aktivasyon Kodu Gönderiliyor...";
String kAlertConfirmLoadingText = "Lütfen bekleyiniz.";

String kTicketTitle = "Talep Oluştur";
String kCatocoryTitle = "Kategori Seçiniz";
String kCustomerTitle = "Müşteri Seçiniz";
String kCreateTicketTitle = "Konu Başlığı Giriniz";
String kCreateTicketDescription = "Açıklama Giriniz";
String kCreateTicketFileAdd = "Dosya Ekle";
String kCreateTicketButton = "Gönder";
String kCreateTicketLoadingText = "Gönderiliyor...";
String kCreateTicketSuccessText = "Talebiniz başarıyla oluşturuldu.";
String kCreateTicketErrorText = "Talep oluşturulurken bir hata oluştu.";

String kTicketListTitle = "Taleplerim";
String kCustomerListTitle = "Müşterilerim";
String kCategoryListTitle = "Kategorilerim";
String kCustomerCreateTitle = "Müşteri Kayıt";
String kCategoryCreateTitle = "Kategori Oluştur";
String kTicketListDetailsTitle = "Talep Detayı";
String kTicketActionReply = "Yanıtla";

String kUpdateProfileTitle = "Profil Düzenle";

String kVersionTitle = "V 1.1.5";
