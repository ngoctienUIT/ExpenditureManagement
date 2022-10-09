import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/calendar/widget/build_spending.dart';
import 'package:expenditure_management/page/main/calendar/widget/custom_table_calendar.dart';
import 'package:expenditure_management/page/main/calendar/widget/total_spending.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  var numberFormat = NumberFormat.currency(locale: "vi_VI");
  List<Spending>? _currentSpendingList;
  bool check = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whisperBackground,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("data")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.requireData.data() as Map<String, dynamic>;
                List<String> list = [];

                return StatefulBuilder(builder: (context, setState) {
                  if (data[DateFormat("MM_yyyy").format(_focusedDay)] != null) {
                    list = (data[DateFormat("MM_yyyy").format(_focusedDay)]
                            as List<dynamic>)
                        .map((e) => e.toString())
                        .toList();
                  }

                  return FutureBuilder(
                      future: SpendingFirebase.getSpendingList(list),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var dataSpending = snapshot.data;

                          List<Spending> spendingList = dataSpending!
                              .where((element) =>
                                  isSameDay(element.dateTime, _selectedDay))
                              .toList();
                          if (check) {
                            _currentSpendingList = spendingList;
                            check = false;
                          }

                          return Column(
                            children: [
                              customTableCalendar(
                                  focusedDay: _focusedDay,
                                  selectedDay: _selectedDay,
                                  dataSpending: dataSpending,
                                  onPageChanged: (focusedDay) =>
                                      setState(() => _focusedDay = focusedDay),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                      _focusedDay = focusedDay;
                                      _selectedDay = selectedDay;
                                      check = true;
                                    });
                                  }),
                              if (_currentSpendingList!.isNotEmpty)
                                totalSpending(
                                  spendingList: _currentSpendingList,
                                ),
                              Expanded(
                                child: buildSpending(
                                  spendingList: _currentSpendingList,
                                  date: _selectedDay,
                                ),
                              )
                            ],
                          );
                        }
                        return loadingData();
                      });
                });
              }
              return loadingData();
            }),
      ),
    );
  }

  Widget loadingData() {
    return Column(
      children: [
        customTableCalendar(
          focusedDay: _focusedDay,
          selectedDay: _selectedDay,
        ),
        totalSpending(),
        Expanded(child: buildSpending())
      ],
    );
  }
}
