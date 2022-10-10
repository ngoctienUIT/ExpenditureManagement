import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/function/get_data_spending.dart';
import 'package:expenditure_management/constants/function/get_date.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/analytic/chart/column_chart.dart';
import 'package:expenditure_management/page/main/analytic/chart/pie_chart.dart';
import 'package:expenditure_management/page/main/analytic/custom_tabbar.dart';
import 'package:expenditure_management/page/main/analytic/show_date.dart';
import 'package:expenditure_management/page/main/calendar/widget/custom_table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AnalyticPage extends StatefulWidget {
  const AnalyticPage({Key? key}) : super(key: key);

  @override
  State<AnalyticPage> createState() => _AnalyticPageState();
}

class _AnalyticPageState extends State<AnalyticPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool chart = true;
  DateTime now = DateTime.now();
  String date = "";

  @override
  void initState() {
    date = getWeek(now);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      now = DateTime.now();
      setState(() {
        if (_tabController.index == 0) {
          date = getWeek(now);
        } else if (_tabController.index == 1) {
          date = getMonth(now);
        } else {
          date = getYear(now);
        }
      });
    });

    super.initState();
  }

  bool checkDate(DateTime date) {
    if (_tabController.index == 0) {
      int weekDay = now.weekday;
      DateTime firstDayOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: weekDay - 1));

      DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

      if (firstDayOfWeek.isBefore(date) && lastDayOfWeek.isAfter(date) ||
          isSameDay(firstDayOfWeek, date) ||
          isSameDay(lastDayOfWeek, date)) return true;
    } else if (_tabController.index == 1 && isSameMonth(date, now)) {
      return true;
    } else if (_tabController.index == 2 && date.year == now.year) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    "Spending",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              customTabBar(controller: _tabController),
              const SizedBox(height: 20),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("data")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data =
                          snapshot.requireData.data() as Map<String, dynamic>;
                      List<String> list = getDataSpending(
                        data: data,
                        index: _tabController.index,
                        date: now,
                      );

                      return FutureBuilder(
                          future: SpendingFirebase.getSpendingList(list),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var dataSpending = snapshot.data;

                              List<Spending> spendingList = dataSpending!
                                  .where(
                                      (element) => checkDate(element.dateTime))
                                  .toList();

                              for (var element in spendingList)
                                print(element.toMap());

                              return Card(
                                // elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                color: const Color(0xff2c4260),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    showDate(
                                      date: date,
                                      index: _tabController.index,
                                      now: now,
                                      action: (date, now) {
                                        setState(() {
                                          this.date = date;
                                          this.now = now;
                                        });
                                      },
                                    ),
                                    spendingList.isNotEmpty
                                        ? (chart
                                            ? const AspectRatio(
                                                aspectRatio: 1.7,
                                                child: ColumnChart(),
                                              )
                                            : MyPieChart(list: spendingList))
                                        : const SizedBox(
                                            height: 200,
                                            child: Center(
                                              child:
                                                  Text("Không có dữ liệu!"),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          });
                    }

                    return const Center(child: CircularProgressIndicator());
                  }),
              ElevatedButton(
                onPressed: () {
                  setState(() => chart = !chart);
                },
                child: const Text("change"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
