import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/main/home/widget/item_spending_widget.dart';
import 'package:expenditure_management/page/main/home/widget/summary_spending.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("data")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> list = [];

              if (snapshot.requireData.data() != null) {
                var data = snapshot.requireData.data() as Map<String, dynamic>;

                if (data[DateFormat("MM_yyyy").format(DateTime.now())] !=
                    null) {
                  list = (data[DateFormat("MM_yyyy").format(DateTime.now())]
                          as List<dynamic>)
                      .map((e) => e.toString())
                      .toList();
                }
              }

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("spending")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var spendingList = snapshot.data!.docs
                        .where((element) => list.contains(element.id))
                        .map((e) => Spending.fromFirebase(e))
                        .toList();

                    if (spendingList.isEmpty) {
                      return body(spendingList: spendingList);
                    } else {
                      return SingleChildScrollView(
                          child: body(spendingList: spendingList));
                    }
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

  Widget body({List<Spending>? spendingList}) {
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
        SummarySpending(spendingList: spendingList),
        const SizedBox(height: 10),
        const Text(
          "Danh sách chi tiêu tháng này",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        spendingList!.isNotEmpty
            ? ItemSpendingWidget(spendingList: spendingList)
            : const Expanded(
                child: Center(
                  child: Text(
                    "Không có dữ liệu tháng này!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ],
    );
  }

  Widget loading() {
    return SingleChildScrollView(
      child: Column(
        children: const [
          SizedBox(height: 10),
          Text(
            "Tháng này",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SummarySpending(),
          SizedBox(height: 10),
          Text(
            "Danh sách chi tiêu tháng này",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          ItemSpendingWidget(),
        ],
      ),
    );
  }
}
