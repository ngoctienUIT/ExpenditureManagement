import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildItemResults(List<Spending>? spendingList) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  return ListView.builder(
    itemCount: spendingList!.length,
    itemBuilder: (context, index) {
      return InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              children: [
                Image.asset(
                  listType[spendingList[index].type]["image"]!,
                  width: 40,
                ),
                const SizedBox(width: 10),
                Text(
                  listType[spendingList[index].type]["title"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  numberFormat.format(spendingList[index].money),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_ios_outlined)
              ],
            ),
          ),
        ),
      );
    },
  );
}
