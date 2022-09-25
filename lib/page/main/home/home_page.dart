import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("info")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return Container();
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("data")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.requireData.data() as Map<String, dynamic>;
                List<String> list = [];

                if (data[DateFormat("MM_yyyy").format(DateTime.now())] !=
                    null) {
                  list = (data[DateFormat("MM_yyyy").format(DateTime.now())]
                          as List<dynamic>)
                      .map((e) => e.toString())
                      .toList();
                }

                return FutureBuilder(
                  future: SpendingFirebase.getSpendingList(list),
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                    return Container();
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
