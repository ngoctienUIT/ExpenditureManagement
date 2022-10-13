import 'package:expenditure_management/constants/app_styles.dart';
import 'package:flutter/material.dart';

Widget customTabBar({required TabController controller}) {
  return Container(
    height: 40,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(242, 243, 247, 1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TabBar(
        controller: controller,
        labelColor: Colors.black87,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelColor: const Color.fromRGBO(45, 216, 198, 1),
        unselectedLabelStyle: AppStyles.p,
        isScrollable: false,
        indicatorColor: Colors.red,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        tabs: const [
          Tab(text: "Weekly"),
          Tab(text: "Monthly"),
          Tab(text: "Yearly")
        ]),
  );
}
