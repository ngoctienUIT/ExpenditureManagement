import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/calendar/widget/custom_table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ColumnChart extends StatefulWidget {
  const ColumnChart(
      {Key? key,
      required this.index,
      required this.list,
      required this.dateTime})
      : super(key: key);
  final int index;
  final List<Spending> list;
  final DateTime dateTime;

  @override
  State<StatefulWidget> createState() => ColumnChartState();
}

class ColumnChartState extends State<ColumnChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  double max = 0;
  List<int> money = [];

  double roundNumber(double number) {
    double div = 10;
    while (number / div >= 10) {
      div *= 10;
    }
    int y =
        int.tryParse((number / div).toString().split('.')[0].substring(0, 1))!;
    return (y + 1) * div;
  }

  List<int> renderListMoney() {
    if (widget.index == 0) {
      return List.generate(7, (index) {
        int weekDay = widget.dateTime.weekday;
        DateTime firstDayOfWeek =
            widget.dateTime.subtract(Duration(days: weekDay - 1));
        List<Spending> spendingList = widget.list
            .where((element) => isSameDay(
                element.dateTime, firstDayOfWeek.add(Duration(days: index))))
            .toList();
        return spendingList.isEmpty
            ? 0
            : spendingList
                .map((e) => e.money)
                .reduce((value, element) => value + element);
      });
    } else if (widget.index == 1) {
    } else {
      return List.generate(12, (index) {
        List<Spending> spendingList = widget.list
            .where((element) => isSameMonth(
                element.dateTime, DateTime(widget.dateTime.year, (index + 1))))
            .toList();
        return spendingList.isEmpty
            ? 0
            : spendingList
                .map((e) => e.money)
                .reduce((value, element) => value + element);
        // return 1;
      });
    }
    return [];
  }

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  @override
  Widget build(BuildContext context) {
    money = renderListMoney();
    max = (money.reduce((curr, next) => curr > next ? curr : next)).toDouble();
    max = roundNumber(max);

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          mainBarData(),
          swapAnimationDuration: animDuration,
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: _barsGradient,
          borderSide: isTouched
              ? const BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    int column = 7;
    if (widget.index == 1) {
    } else if (widget.index == 2) {
      column = 12;
    }
    return List.generate(
      column,
      (i) =>
          makeGroupData(i, money[i].toDouble(), isTouched: i == touchedIndex),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      maxY: max,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay = "";
              if (widget.index == 0) {
                weekDay = listDayOfWeek[group.x.toInt()];
              } else if (widget.index == 1) {
              } else {
                weekDay = listMonthOfYear[group.x.toInt()];
              }
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: "${((rod.toY - 1) / 1000).toStringAsFixed(0)}K",
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitles,
            reservedSize: 30,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: FlGridData(show: true),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text("${(value / 1000).toStringAsFixed(0)}K", style: style),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String title = "";
    if (widget.index == 0) {
      title = listDayOfWeekAcronym[value.toInt()];
    } else if (widget.index == 1) {
    } else {
      // title = listMonthOfYearAcronym[value.toInt()];
      title = (value.toInt() + 1).toString();
    }

    Widget text = Text(title, style: style);
    return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: text);
  }
}
