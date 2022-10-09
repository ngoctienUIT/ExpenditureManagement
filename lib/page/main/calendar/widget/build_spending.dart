import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget buildSpending({List<Spending>? spendingList, DateTime? date}) {
  return spendingList != null
      ? (spendingList.isEmpty
          ? Center(
              child: Text(
                "Bạn không có bất kỳ chi tiêu nào\nvào ngày ${DateFormat("dd/MM/yyyy").format(date!)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            )
          : showListSpending(spendingList))
      : loadingListSpending();
}

Widget showListSpending(List<Spending> spendingList) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  return ListView.builder(
    itemCount: spendingList.length,
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

Widget loadingListSpending() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      );
    },
  );
}
