import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/home/view_list_spending_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

Widget itemSpendingWidget({List<Spending>? spendingList}) {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  return spendingList != null
      ? ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: listType.length,
          itemBuilder: (context, index) {
            if (index == 0 || index == 10) {
              return const SizedBox.shrink();
            } else {
              var list = spendingList!
                  .where((element) => element.type == index)
                  .toList();
              if (list.isNotEmpty) {
                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewListSpendingPage(spendingList: list),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Row(
                        children: [
                          Image.asset(
                            listType[index]["image"]!,
                            width: 40,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            listType[index]["title"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            numberFormat.format(list
                                .map((e) => e.money)
                                .reduce((value, element) => value + element)),
                            style: const TextStyle(fontSize: 16),
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
        )
      : ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
