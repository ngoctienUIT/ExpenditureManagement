import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/page/main/setting/edit_profile_page.dart';
import 'package:expenditure_management/page/main/setting/widget/setting_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expenditure_management/models/user.dart' as myuser;
import 'package:intl/intl.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");
  bool language = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whisperBackground,
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("info")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  myuser.User user =
                      myuser.User.fromFirebase(snapshot.requireData);
                  return Column(
                    children: [
                      Material(
                        elevation: 2,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipOval(
                        child: Image.network(
                          user.avatar,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Tiền hàng tháng"),
                      const SizedBox(height: 10),
                      Text(
                        numberFormat.format(user.money),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  settingItem("Account", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  }, FontAwesomeIcons.user),
                  const SizedBox(height: 20),
                  settingItem("Language", () {}, Icons.translate_outlined),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(90),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(FontAwesomeIcons.moon),
                      ),
                      const SizedBox(width: 10),
                      const Text("Dark Mode", style: TextStyle(fontSize: 18)),
                      const Spacer(),
                      Switch(
                        value: language,
                        onChanged: (value) {
                          setState(() => language = value);
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  settingItem("About", () {}, FontAwesomeIcons.circleInfo),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonLogin,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                        await FacebookAuth.instance.logOut();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      },
                      child: Text("Đăng xuất", style: AppStyles.p),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
