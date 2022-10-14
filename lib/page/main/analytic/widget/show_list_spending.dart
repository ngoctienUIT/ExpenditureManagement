import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget showListSpending({required List<Spending> list}) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");
  int sum =
      list.map((e) => e.money).reduce((value, element) => value + element);

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: listType.length,
    itemBuilder: (context, index) {
      if ([0, 10, 21, 27, 35, 38].contains(index)) {
        return const SizedBox.shrink();
      } else {
        List<Spending> spendingList =
            list.where((element) => element.type == index).toList();
        if (spendingList.isNotEmpty) {
          int sumSpending = spendingList
              .map((e) => e.money)
              .reduce((value, element) => value + element);

          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {},
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  children: [
                    Image.asset(
                      listType[index]["image"]!,
                      width: 40,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        listType[index]["title"]!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      numberFormat.format(sumSpending),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${((sumSpending / sum) * 100).toStringAsFixed(2)}%",
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    },
  );
}
