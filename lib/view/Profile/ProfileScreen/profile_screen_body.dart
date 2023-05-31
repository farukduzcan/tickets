import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/user_model.dart';
import '../../../services/manage_info_services.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
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
    return Scaffold(
      body: Padding(
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
              Container(
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
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: kPrimaryLightColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () async {},
                    leading: const CircleAvatar(
                      backgroundColor: kPrimaryLightColor,
                      child: Icon(
                        Icons.edit,
                        color: Colors.black87,
                        size: 30,
                      ),
                    ),
                    title: const Text(
                      " Profili Düzenle",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
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
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: kPrimaryLightColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () async {},
                    leading: const CircleAvatar(
                      backgroundColor: kPrimaryLightColor,
                      child: Icon(
                        Icons.vpn_key,
                        color: Colors.black87,
                        size: 30,
                      ),
                    ),
                    title: const Text(
                      " Şifre Değiştir",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
