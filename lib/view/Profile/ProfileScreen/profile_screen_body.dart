import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tickets/view/Profile/ChangePassword/change_password_screen.dart';
import 'package:tickets/view/Profile/UpdateProfile/update_profile_screen.dart';

import '../../../constants.dart';
import '../../../models/user_model.dart';
import '../../../services/manage_info_services.dart';
import '../../Login/login_screen.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? companyName;
  @override
  void initState() {
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
        companyName = "Müşteri";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await manageInfo();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(children: [
              Text(
                " $companyName",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  top: 10,
                ),
                child: CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: 45,
                  child: ClipOval(
                    child: Icon(
                      UserModel.userData!.role == 2
                          ? Icons.business_outlined
                          : Icons.person,
                      color: Colors.black,
                      size: 45,
                    ),
                  ),
                ),
              ),
              const Text(
                " Kullanıcı Bilgileri",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Adı: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(UserModel.userData!.firstName!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Soyadı: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(UserModel.userData!.lastName!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Mail Adresi: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(UserModel.userData!.email!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                ),
              ),
              Column(
                children: [
                  ProfileButton(
                      icon: Icons.edit,
                      title: " Profil Güncelle",
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdateProfileBody(),
                          ),
                        );
                        _refreshIndicatorKey.currentState?.show();
                      }),
                  ProfileButton(
                    icon: Icons.vpn_key,
                    title: " Şifre Değiştir",
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordBody(),
                        ),
                      );
                    },
                  ),
                  ProfileButton(
                    icon: Icons.logout_outlined,
                    title: "Çıkış Yap",
                    onPressed: () {
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
                            color: Colors.black, fontWeight: FontWeight.bold),
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
                    isTrailing: false,
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final bool isTrailing;
  final IconData icon;
  final String title;
  final Function onPressed;
  const ProfileButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.isTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: kCardBoxShodow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          trailing: isTrailing
              ? const Icon(Icons.arrow_circle_right_rounded,
                  color: kPrimaryColor)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: () async {
            onPressed();
          },
          leading: CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
