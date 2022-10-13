import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/function/get_data_spending.dart';
import 'package:expenditure_management/constants/function/get_date.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/analytic/chart/column_chart.dart';
import 'package:expenditure_management/page/main/analytic/chart/pie_chart.dart';
import 'package:expenditure_management/page/main/analytic/custom_tabbar.dart';
import 'package:expenditure_management/page/main/analytic/show_date.dart';
import 'package:expenditure_management/page/main/analytic/tabbar_chart.dart';
import 'package:expenditure_management/page/main/analytic/tabbar_type.dart';
import 'package:expenditure_management/page/main/calendar/widget/custom_table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnalyticPage extends StatefulWidget {
  const AnalyticPage({Key? key}) : super(key: key);

  @override
  State<AnalyticPage> createState() => _AnalyticPageState();
}

class _AnalyticPageState extends State<AnalyticPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _chartController;
  late TabController _typeController;
  bool chart = false;
  DateTime now = DateTime.now();
  String date = "";

  @override
  void initState() {
    date = getWeek(now);
    _tabController = TabController(length: 3, vsync: this);
    _chartController = TabController(length: 2, vsync: this);
    _typeController = TabController(length: 2, vsync: this);
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
    _chartController.addListener(() {
      setState(() {
        if (_chartController.index == 0) {
          chart = false;
        } else {
          chart = true;
        }
      });
    });
    _typeController.addListener(() {
      setState(() {});
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
                children: [
                  const Text(
                    "Spending",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 20,
                      color: Color.fromRGBO(180, 190, 190, 1),
                    ),
                  )
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

                              return Card(
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
                                    tabBarType(controller: _typeController),
                                    spendingList.isNotEmpty
                                        ? (chart
                                            ? MyPieChart(list: spendingList)
                                            : ColumnChart(
                                                index: _tabController.index,
                                                list: spendingList,
                                                dateTime: now,
                                              ))
                                        : const SizedBox(
                                            height: 200,
                                            child: Center(
                                              child:
                                                  Text("Không có dữ liệu!"),
                                            ),
                                          ),
                                    tabBarChart(controller: _chartController),
                                    const SizedBox(height: 10)
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
            ],
          ),
        ),
      ),
    );
  }
}
