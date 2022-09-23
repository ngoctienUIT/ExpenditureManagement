import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:flutter/material.dart';

class ChooseType extends StatelessWidget {
  const ChooseType({Key? key, required this.action}) : super(key: key);
  final Function(int) action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whisperBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Loại chi tiêu",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: listType.length,
        itemBuilder: (context, index) {
          if (index == 0 || index == 10) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 15),
              child: Text(
                listType[index]["title"]!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return InkWell(
            onTap: () {
              action(index);
              Navigator.pop(context);
            },
            child: Material(
              elevation: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 60,
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset(
                      listType[index]["image"]!,
                      width: 40,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      listType[index]["title"]!,
                      style: AppStyles.p,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
