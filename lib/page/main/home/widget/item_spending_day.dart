import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/edit_spending/edit_spending_page.dart';
import 'package:expenditure_management/page/view_spending/view_spending_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ItemSpendingDay extends StatefulWidget {
  const ItemSpendingDay({Key? key, required this.spendingList})
      : super(key: key);
  final List<Spending> spendingList;

  @override
  State<ItemSpendingDay> createState() => _ItemSpendingDayState();
}

class _ItemSpendingDayState extends State<ItemSpendingDay> {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  @override
  Widget build(BuildContext context) {
    widget.spendingList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    var listDate = widget.spendingList
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day))
        .toList()
        .toSet()
        .toList();

    return listDate.isNotEmpty
        ? ListView.builder(
            itemCount: listDate.length,
            itemBuilder: (context, index) {
              var list = widget.spendingList
                  .where(
                      (element) => isSameDay(element.dateTime, listDate[index]))
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "${listDate[index].day}",
                              style: const TextStyle(fontSize: 30),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat("EEEE").format(listDate[index]),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(DateFormat("MMMM, yyyy")
                                    .format(listDate[index]))
                              ],
                            ),
                            const Spacer(),
                            Text(
                              numberFormat.format(list
                                  .map((e) => e.money)
                                  .reduce((value, element) => value + element)),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        height: 2,
                        color: Colors.black,
                        endIndent: 10,
                        indent: 10,
                      ),
                      Column(
                        children: List.generate(
                          list.length,
                          (index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewSpendingPage(spending: list[index]),
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => EditSpendingPage(
                              //       spending: list[index],
                              //       change: (spending) async {
                              //         try {
                              //           spending.image = await FirebaseStorage
                              //               .instance
                              //               .ref()
                              //               .child(
                              //                   "spending/${spending.id}.png")
                              //               .getDownloadURL();
                              //         } catch (_) {}
                              //
                              //         widget.spendingList.removeWhere(
                              //             (element) =>
                              //                 element.id!
                              //                     .compareTo(spending.id!) ==
                              //                 0);
                              //         setState(() {
                              //           widget.spendingList.add(spending);
                              //         });
                              //       },
                              //       delete: (id) {
                              //         setState(() {
                              //           widget.spendingList.removeWhere(
                              //               (element) =>
                              //                   element.id!.compareTo(id) == 0);
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    listType[widget.spendingList[0].type]
                                        ["image"]!,
                                    width: 40,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    listType[widget.spendingList[0].type]
                                        ["title"]!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    numberFormat.format(list[index].money),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(
            child: Text(
              "Không có dữ liệu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
  }
}
