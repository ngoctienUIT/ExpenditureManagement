import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/language/bloc/locale_cubit.dart';
import 'package:expenditure_management/language/localization/app_localizations.dart';
import 'package:expenditure_management/page/main/setting/edit_profile_page.dart';
import 'package:expenditure_management/page/main/setting/widget/info_widget.dart';
import 'package:expenditure_management/page/main/setting/widget/setting_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expenditure_management/models/user.dart' as myuser;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");
  int language = 0;
  bool darkMode = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      language = value.getInt('language') ??
          (Platform.localeName.split('_')[0] == "vi" ? 0 : 1);
    });
    super.initState();
  }

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
                  return infoWidget(user: user);
                }
                return infoWidget();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      settingItem(
                        text: AppLocalizations.of(context).translate('account'),
                        action: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilePage(),
                            ),
                          );
                        },
                        icon: FontAwesomeIcons.solidUser,
                        color: const Color.fromRGBO(0, 150, 255, 1),
                      ),
                      const SizedBox(height: 20),
                      settingItem(
                        text:
                            AppLocalizations.of(context).translate('language'),
                        action: _showBottomSheet,
                        icon: Icons.translate_outlined,
                        color: const Color.fromRGBO(233, 116, 81, 1),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(90),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              FontAwesomeIcons.solidMoon,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context).translate('dark_mode'),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Spacer(),
                          FlutterSwitch(
                            height: 30,
                            width: 60,
                            value: darkMode,
                            onToggle: (value) {
                              setState(() => darkMode = value);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      settingItem(
                        text: AppLocalizations.of(context).translate('about'),
                        action: () {},
                        icon: FontAwesomeIcons.circleInfo,
                        color: const Color.fromRGBO(79, 121, 66, 1),
                      ),
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
                          child: Text(
                            AppLocalizations.of(context).translate('logout'),
                            style: AppStyles.p,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(left: 20),
          width: double.infinity,
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  changeLanguage(0);
                },
                child: Row(
                  children: [
                    Image.asset("assets/images/vietnam.png", width: 70),
                    const Spacer(),
                    const Text(
                      "Tiếng Việt",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: 0,
                      groupValue: language,
                      onChanged: (value) {
                        changeLanguage(0);
                      },
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  changeLanguage(1);
                },
                child: Row(
                  children: [
                    Image.asset("assets/images/english.png", width: 70),
                    const Spacer(),
                    const Text(
                      "English",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Radio(
                      value: 1,
                      groupValue: language,
                      onChanged: (value) {
                        changeLanguage(1);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future changeLanguage(int lang) async {
    if (lang == 0) {
      BlocProvider.of<LocaleCubit>(context).toVietnamese();
    } else {
      BlocProvider.of<LocaleCubit>(context).toEnglish();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', lang);
    if (!mounted) return;

    setState(() => language = lang);
    Navigator.pop(context);
  }
}
