import 'dart:math';
import 'package:expenditure_management/models/spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerAnimation() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 25,
      width: Random().nextInt(30) + 90,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

Widget totalSpending({List<Spending>? spendingList}) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  return Card(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Row(
        children: [
          const Spacer(),
          Column(
            children: [
              const Text("Thu nhập", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              spendingList != null
                  ? const Text(
                      "0",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : shimmerAnimation()
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Text("Chi tiêu", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              spendingList != null
                  ? Text(
                      spendingList.isNotEmpty
                          ? numberFormat.format(spendingList
                              .map((e) => e.money)
                              .reduce((value, element) => value + element))
                          : "0",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : shimmerAnimation()
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Text("Tổng", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              spendingList != null
                  ? Text(
                      spendingList.isNotEmpty
                          ? "-${numberFormat.format(spendingList.map((e) => e.money).reduce((value, element) => value + element))}"
                          : "0",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : shimmerAnimation()
            ],
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
