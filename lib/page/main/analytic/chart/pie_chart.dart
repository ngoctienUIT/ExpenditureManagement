import 'dart:math';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({Key? key, required this.list}) : super(key: key);
  final List<Spending> list;

  @override
  State<StatefulWidget> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int touchedIndex = 0;
  int sum = 1;
  List<Color> listColor = [];

  @override
  void initState() {
    sum = widget.list
        .map((e) => e.money)
        .reduce((value, element) => value + element);
    for (int i = 0; i < listType.length; i++) {
      listColor.add(
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections()),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> pieChartList = [];
    for (int i = 0; i < listType.length; i++) {
      if (![0, 10, 21, 27, 35, 38].contains(i)) {
        List<Spending> spendingList =
            widget.list.where((element) => element.type == i).toList();
        if (spendingList.isNotEmpty) {
          final isTouched = i == touchedIndex;
          final fontSize = isTouched ? 20.0 : 16.0;
          final radius = isTouched ? 110.0 : 100.0;
          final widgetSize = isTouched ? 55.0 : 40.0;

          int sumSpending = spendingList
              .map((e) => e.money)
              .reduce((value, element) => value + element);

          pieChartList.add(
            PieChartSectionData(
              color: listColor[i],
              value: (sumSpending / sum) * 100,
              title: "",
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
              ),
              badgeWidget: _Badge(
                listType[i]["image"]!,
                size: widgetSize,
                borderColor: const Color(0xff0293ee),
              ),
              badgePositionPercentageOffset: .98,
            ),
          );
        }
      }
    }
    return pieChartList;
  }
}

class _Badge extends StatelessWidget {
  final String imgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.imgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(imgAsset, fit: BoxFit.contain),
      ),
    );
  }
}
