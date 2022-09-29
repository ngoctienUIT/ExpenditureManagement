import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/calendar/widget/build_spending.dart';
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
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

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

                if (data[DateFormat("MM_yyyy").format(_selectedDay)] != null) {
                  list = (data[DateFormat("MM_yyyy").format(_selectedDay)]
                          as List<dynamic>)
                      .map((e) => e.toString())
                      .toList();
                }

                return StatefulBuilder(builder: (context, setState) {
                  return FutureBuilder(
                      future: SpendingFirebase.getSpendingList(list),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var dataSpending = snapshot.data;

                          List<Spending> spendingList = dataSpending!
                              .where((element) =>
                                  isSameDay(element.dateTime, _selectedDay))
                              .toList();

                          return Column(
                            children: [
                              Card(
                                child: TableCalendar(
                                  firstDay: DateTime.utc(2000),
                                  lastDay: DateTime.utc(2100),
                                  focusedDay: _focusedDay,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(_selectedDay, day),
                                  calendarFormat: _format,
                                  onPageChanged: (focusedDay) =>
                                      _focusedDay = focusedDay,
                                  onFormatChanged: (format) =>
                                      setState(() => _format = format),
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  onDaySelected: (selectedDay, focusedDay) {
                                    if (!isSameDay(_selectedDay, selectedDay)) {
                                      setState(() {
                                        _focusedDay = focusedDay;
                                        _selectedDay = selectedDay;
                                      });
                                    }
                                  },
                                  eventLoader: (day) {
                                    return dataSpending
                                        .where((element) =>
                                            isSameDay(element.dateTime, day))
                                        .toList();
                                  },
                                  calendarBuilders: CalendarBuilders(
                                    markerBuilder: (context, day, events) {
                                      if (events.isNotEmpty) {
                                        return Positioned(
                                          right: 0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: (isSameDay(
                                                          day, _selectedDay) ||
                                                      isSameDay(
                                                          day, DateTime.now()))
                                                  ? Colors.orange
                                                  : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                            ),
                                            child:
                                                Text(events.length.toString()),
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                    dowBuilder: (context, day) {
                                      if (day.weekday == DateTime.sunday ||
                                          day.weekday == DateTime.saturday) {
                                        return Center(
                                          child: Text(
                                            DateFormat.E().format(day),
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              totalSpending(spendingList),
                              Expanded(child: buildSpending(spendingList))
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      });
                });
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
