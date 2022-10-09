import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/function/get_date.dart';
import 'package:expenditure_management/page/main/analytic/chart/pie_chart.dart';
import 'package:expenditure_management/page/main/analytic/show_date.dart';
import 'package:flutter/material.dart';
import 'package:expenditure_management/constants/app_styles.dart';

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
              Container(
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(242, 243, 247, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black87,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    unselectedLabelColor: const Color.fromRGBO(45, 216, 198, 1),
                    unselectedLabelStyle: AppStyles.p,
                    isScrollable: false,
                    indicatorColor: Colors.red,
                    indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    tabs: const [
                      Tab(text: "Weekly"),
                      Tab(text: "Monthly"),
                      Tab(text: "Yearly")
                    ]),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: null,
                    builder: (context, snapshot) {
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
                              action: (date) {
                                setState(() => this.date = date);
                              },
                            ),
                            chart ? const MyPieChart() : const MyPieChart(),
                          ],
                        ),
                      );
                    }),
              ),
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
