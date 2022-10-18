import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/page/main/home/widget/item_spending_widget.dart';
import 'package:expenditure_management/page/main/home/widget/summary_spending.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whisperBackground,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("data")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.requireData.data() as Map<String, dynamic>;
              List<String> list = [];

              if (data[DateFormat("MM_yyyy").format(DateTime.now())] != null) {
                list = (data[DateFormat("MM_yyyy").format(DateTime.now())]
                        as List<dynamic>)
                    .map((e) => e.toString())
                    .toList();
              }

              return FutureBuilder(
                future: SpendingFirebase.getSpendingList(list),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var spendingList = snapshot.data;
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Tháng này",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        summarySpending(spendingList: spendingList),
                        const SizedBox(height: 10),
                        const Text(
                          "Danh sách chi tiêu tháng này",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: itemSpendingWidget(spendingList: spendingList),
                        ),
                      ],
                    );
                  }

                  return loading();
                },
              );
            }
            return loading();
          },
        ),
      ),
    );
  }

  Widget loading() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Tháng này",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        summarySpending(),
        const SizedBox(height: 10),
        const Text(
          "Danh sách chi tiêu tháng này",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Expanded(child: itemSpendingWidget()),
      ],
    );
  }
}
