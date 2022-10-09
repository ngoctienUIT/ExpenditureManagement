import 'package:expenditure_management/models/spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

bool isSameMonth(DateTime day1, DateTime day2) =>
    day1.year == day2.year && day1.month == day2.month;

BorderSide customBorderSide() => const BorderSide(
    color: Colors.black12,
    width: 1.0,
    style: BorderStyle.solid,
    strokeAlign: StrokeAlign.inside);

Widget customTableCalendar(
    {required DateTime focusedDay,
    required DateTime selectedDay,
    List<Spending>? dataSpending,
    Function(DateTime)? onPageChanged,
    Function(DateTime, DateTime)? onDaySelected}) {
  return Card(
    child: TableCalendar(
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: focusedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onPageChanged: (focusedDay) {
        if (onPageChanged != null) onPageChanged(focusedDay);
      },
      onDaySelected: (mySelectedDay, myFocusedDay) {
        if (!isSameDay(selectedDay, mySelectedDay) &&
            isSameMonth(focusedDay, mySelectedDay) &&
            onDaySelected != null) onDaySelected(mySelectedDay, myFocusedDay);
      },
      eventLoader: (day) {
        return dataSpending != null
            ? dataSpending
                .where((element) => isSameDay(element.dateTime, day))
                .toList()
            : [];
      },
      calendarStyle: CalendarStyle(
        tableBorder: TableBorder(
          bottom: customBorderSide(),
          horizontalInside: customBorderSide(),
          verticalInside: customBorderSide(),
          left: customBorderSide(),
          right: customBorderSide(),
          top: customBorderSide(),
        ),
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.cyanAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        cellPadding: const EdgeInsets.all(0),
        selectedTextStyle: const TextStyle(color: Colors.green),
        todayDecoration: BoxDecoration(
          color: Colors.cyanAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0),
        ),
        outsideDaysVisible: true,
        todayTextStyle: const TextStyle(color: Colors.green),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        rightChevronPadding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        headerPadding: const EdgeInsets.all(0),
        headerMargin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black54,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        prioritizedBuilder: (context, day, focusedDay) {
          if (day.month != focusedDay.month || day.year != focusedDay.year) {
            return const SizedBox.shrink();
          }
          return null;
        },
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty && isSameMonth(focusedDay, day)) {
            return Positioned(
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (isSameDay(day, selectedDay) ||
                          isSameDay(day, DateTime.now()))
                      ? Colors.orange
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Text(events.length.toString()),
              ),
            );
          }
          return const SizedBox.shrink();
        },
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday ||
              day.weekday == DateTime.saturday) {
            return Center(
              child: Text(
                DateFormat.E().format(day),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return null;
        },
      ),
    ),
  );
}

/// lưu lại mẫu để có lỗi còn biết sữa :v

/*Card(
      child: TableCalendar(
        firstDay: DateTime.utc(2000),
        lastDay: DateTime.utc(2100),
        focusedDay: _focusedDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _format,
        onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
        onFormatChanged: (format) => setState(() => _format = format),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay) &&
              isSameMonth(_focusedDay, selectedDay)) {
            setState(() {
              _focusedDay = focusedDay;
              _selectedDay = selectedDay;
            });
          }
        },
        eventLoader: (day) {
          return dataSpending
              .where((element) => isSameDay(element.dateTime, day))
              .toList();
        },
        calendarBuilders: CalendarBuilders(
          prioritizedBuilder: (context, day, focusedDay) {
            if (day.month != focusedDay.month || day.year != focusedDay.year) {
              return const SizedBox.shrink();
            }
          },
          markerBuilder: (context, day, events) {
            if (events.isNotEmpty && isSameMonth(_focusedDay, day)) {
              return Positioned(
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (isSameDay(day, _selectedDay) ||
                            isSameDay(day, DateTime.now()))
                        ? Colors.orange
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Text(events.length.toString()),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          dowBuilder: (context, day) {
            if (day.weekday == DateTime.sunday ||
                day.weekday == DateTime.saturday) {
              return Center(
                child: Text(
                  DateFormat.E().format(day),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return null;
          },
        ),
      ),
    ),*/
