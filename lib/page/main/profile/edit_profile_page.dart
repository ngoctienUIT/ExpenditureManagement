import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/constants/function/loading_animation.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/page/main/profile/widget/show_birthday.dart';
import 'package:expenditure_management/page/signup/gender_widget.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:expenditure_management/models/user.dart' as myuser;
import 'package:shimmer/shimmer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          AppLocalizations.of(context).translate('account'),
          style: const TextStyle(color: Colors.black),
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
            File? image;
            DateTime selectedDate =
                DateFormat("dd/MM/yyyy").parse(user.birthday);

            return StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      showAvatar(
                        image: image,
                        url: user.avatar,
                        getImage: (file) => setState(() => image = file),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textProfile(AppLocalizations.of(context)
                                .translate('full_name')),
                            TextField(
                              controller: nameController,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            textProfile(AppLocalizations.of(context)
                                .translate('monthly_money')),
                            TextField(
                              controller: moneyController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              inputFormatters: [
                                CurrencyTextInputFormatter(locale: "vi")
                              ],
                            ),
                            const SizedBox(height: 30),
                            textProfile(AppLocalizations.of(context)
                                .translate('birthday')),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null && picked != selectedDate) {
                                  setState(() => selectedDate = picked);
                                }
                              },
                              child: showBirthday(selectedDate),
                            ),
                            const SizedBox(height: 30),
                            textProfile(AppLocalizations.of(context)
                                .translate('gender')),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                const Spacer(),
                                genderWidget(
                                    currentGender: gender,
                                    gender: true,
                                    action: () {
                                      if (!gender) {
                                        setState(() => gender = true);
                                      }
                                    }),
                                const Spacer(),
                                genderWidget(
                                    currentGender: gender,
                                    gender: false,
                                    action: () {
                                      if (gender) {
                                        setState(() => gender = false);
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
                                onPressed: () async {
                                  loadingAnimation(context);
                                  await SpendingFirebase.updateInfo(
                                    user: user.copyWith(
                                      name: nameController.text.trim(),
                                      money: int.parse(moneyController.text
                                          .replaceAll(RegExp(r'[^0-9]'), '')),
                                      gender: gender,
                                      birthday: DateFormat("dd/MM/yyyy")
                                          .format(selectedDate),
                                    ),
                                    image: image,
                                  );
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)
                                          .translate("success"));
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('save'),
                                  style: AppStyles.p,
                                ),
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

  Widget textProfile(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
    );
  }

  Widget showAvatar({
    File? image,
    required String url,
    required Function(File) getImage,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(90),
      onTap: () async {
        try {
          var pickImage =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (pickImage == null) return;
          final cropImage = await ImageCropper().cropImage(
            sourcePath: pickImage.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            aspectRatioPresets: [CropAspectRatioPreset.square],
          );
          if (cropImage == null) return;
          getImage(File(cropImage.path));
        } on PlatformException catch (_) {}
      },
      child: Stack(
        children: [
          ClipOval(
            child: image == null
                ? CachedNetworkImage(
                    imageUrl: url,
                    width: 170,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return loadingInfo(width: 150, height: 150, radius: 90);
                    },
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image.file(image, width: 170),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Image.asset(
              "assets/icons/image.png",
              width: 35,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }

  Widget loadingInfo(
      {required double width, required double height, double radius = 5}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
