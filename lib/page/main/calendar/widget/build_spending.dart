import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/edit_spending/edit_spending_page.dart';
import 'package:expenditure_management/page/main/home/widget/item_spending_widget.dart';
import 'package:expenditure_management/page/view_spending/view_spending_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildSpending extends StatelessWidget {
  const BuildSpending({Key? key, this.spendingList, this.date, this.change})
      : super(key: key);
  final List<Spending>? spendingList;
  final DateTime? date;
  final Function(Spending spending)? change;

  @override
  Widget build(BuildContext context) {
    return spendingList != null
        ? (spendingList!.isEmpty
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
            : showListSpending(spendingList!))
        : loadingItemSpending();
  }

  Widget showListSpending(List<Spending> spendingList) {
    var numberFormat = NumberFormat.currency(locale: "vi_VI");

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: spendingList.length,
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewSpendingPage(
                  spending: spendingList[index],
                ),
              ),
            );
          },
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
}
