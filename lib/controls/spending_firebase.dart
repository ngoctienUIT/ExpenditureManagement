import 'dart:io';
import 'package:expenditure_management/models/spending.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:expenditure_management/models/user.dart' as myuser;

class SpendingFirebase {
  static Future addSpending(Spending spending) async {
    var firestoreSpending =
        FirebaseFirestore.instance.collection("spending").doc();

    var firestoreData = FirebaseFirestore.instance
        .collection("data")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await firestoreSpending.set(spending.toMap());

    await firestoreData.get().then((value) {
      List<String> dataSpending = [];
      if (value.exists) {
        var data = value.data() as Map<String, dynamic>;
        if (data[DateFormat("MM_yyyy").format(spending.dateTime)] != null) {
          dataSpending = (data[DateFormat("MM_yyyy").format(spending.dateTime)]
                  as List<dynamic>)
              .map((e) => e.toString())
              .toList();
          dataSpending.add(firestoreSpending.id);
          firestoreData.update(
              {DateFormat("MM_yyyy").format(spending.dateTime): dataSpending});
        } else {
          dataSpending.add(firestoreSpending.id);
          data.addAll(
              {DateFormat("MM_yyyy").format(spending.dateTime): dataSpending});
          firestoreData.set(data);
        }
      } else {
        dataSpending.add(firestoreSpending.id);
        firestoreData.set(
            {DateFormat("MM_yyyy").format(spending.dateTime): dataSpending});
      }
    });
  }

  static Future<List<Spending>> getSpendingList(List<String> list) async {
    List<Spending> spendingList = [];
    for (var element in list) {
      await FirebaseFirestore.instance
          .collection("spending")
          .doc(element)
          .get()
          .then((value) {
        Spending spending = Spending.fromFirebase(value);
        spendingList.add(spending);
      });
    }
    return spendingList;
  }

  static Future updateInfo({required myuser.User user, File? image}) async {
    if (image != null) {
      user.avatar = await uploadImage(
        folder: "avatar",
        name: "${FirebaseAuth.instance.currentUser!.uid}.png",
        image: image,
      );
    }
    FirebaseFirestore.instance
        .collection("info")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(user.toMap());
  }

  static Future<String> uploadImage(
      {required String folder,
      required String name,
      required File image}) async {
    Reference upload = FirebaseStorage.instance.ref().child("$folder/$name");
    await upload.putFile(image);
    return await upload.getDownloadURL();
  }
}
