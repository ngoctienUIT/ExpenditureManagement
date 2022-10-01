import 'package:expenditure_management/models/spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

bool isSameMonth(DateTime day1, DateTime day2) =>
    day1.year == day2.year && day1.month == day2.month;

Widget customTableCalendar({
  required DateTime focusedDay,
  required DateTime selectedDay,
  required CalendarFormat format,
  List<Spending>? dataSpending,
  Function(DateTime)? onPageChanged,
  Function(DateTime, DateTime)? onDaySelected,
  Function(CalendarFormat)? onFormatChanged,
}) {
  return Card(
    child: TableCalendar(
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: focusedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      calendarFormat: format,
      onPageChanged: (focusedDay) {
        if (onPageChanged != null) onPageChanged(focusedDay);
      },
      onFormatChanged: (format) {
        if (onFormatChanged != null) onFormatChanged(format);
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
