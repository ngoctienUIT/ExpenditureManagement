import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/page/signup/gender_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expenditure_management/models/user.dart' as myuser;
import 'package:intl/intl.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({Key? key}) : super(key: key);

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whisperBackground,
      appBar: AppBar(
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Account",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("info")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            myuser.User user = myuser.User.fromFirebase(snapshot.requireData);
            final nameController = TextEditingController(text: user.name);
            final moneyController = TextEditingController(
              text: NumberFormat.currency(locale: "vi_VI").format(user.money),
            );
            bool gender = user.gender;

            return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {},
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Image.network(
                                user.avatar,
                                width: 170,
                              ),
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: Icon(Icons.image, size: 30),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tên",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: nameController,
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Tiền",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: moneyController,
                              inputFormatters: [
                                CurrencyTextInputFormatter(locale: "vi")
                              ],
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Ngày sinh",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const TextField(),
                            const SizedBox(height: 30),
                            const Text(
                              "Giới tính",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                const Spacer(),
                                genderWidget(
                                    currentGender: gender,
                                    gender: true,
                                    action: () {
                                      if (!gender) {
                                        setState(() {
                                          gender = true;
                                        });
                                      }
                                    }),
                                const Spacer(),
                                genderWidget(
                                    currentGender: gender,
                                    gender: false,
                                    action: () {
                                      if (gender) {
                                        setState(() {
                                          gender = false;
                                        });
                                      }
                                    }),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 30),
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
                                onPressed: () async {},
                                child: Text("Lưu", style: AppStyles.p),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
