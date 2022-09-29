import 'package:expenditure_management/models/spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget totalSpending(List<Spending> spendingList) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  return Card(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Row(
        children: [
          const Spacer(),
          Column(
            children: const [
              Text("Thu nhập", style: TextStyle(fontSize: 16)),
              Text(
                "0",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Text("Chi tiêu", style: TextStyle(fontSize: 16)),
              Text(
                spendingList.isNotEmpty
                    ? numberFormat.format(spendingList
                        .map((e) => e.money)
                        .reduce((value, element) => value + element))
                    : "0",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Text("Tổng", style: TextStyle(fontSize: 16)),
              Text(
                spendingList.isNotEmpty
                    ? "-${numberFormat.format(spendingList.map((e) => e.money).reduce((value, element) => value + element))}"
                    : "0",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
