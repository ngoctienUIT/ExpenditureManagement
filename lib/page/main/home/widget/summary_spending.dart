import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget summarySpending({List<Spending>? spendingList}) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  return spendingList != null
      ? FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("wallet")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.requireData.data();
              var wallet = data![DateFormat("MM_yyyy").format(DateTime.now())];
              int sum = spendingList
                  .map((e) => e.money)
                  .reduce((value, element) => value + element);
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Số dư đầu",
                              style: TextStyle(fontSize: 18),
                            ),
                            const Spacer(),
                            Text(
                              numberFormat.format(wallet),
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              "Số dư cuối",
                              style: TextStyle(fontSize: 18),
                            ),
                            const Spacer(),
                            Text(
                              numberFormat.format(wallet + sum),
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              "${sum > 0 ? "+" : ""}${numberFormat.format(sum)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return loadingSummary();
          })
      : loadingSummary();
}

Widget loadingSummary() {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Số dư đầu",
                  style: TextStyle(fontSize: 18),
                ),
                const Spacer(),
                textLoading()
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Số dư cuối",
                  style: TextStyle(fontSize: 18),
                ),
                const Spacer(),
                textLoading()
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            Row(
              children: [const Spacer(), textLoading()],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget textLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 25,
      width: Random().nextInt(50) + 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}
