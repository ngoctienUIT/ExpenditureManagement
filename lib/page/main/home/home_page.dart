import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/page/main/home/view_list_spending_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenditure_management/models/user.dart' as myuser;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whisperBackground,
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("info")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  myuser.User user =
                      myuser.User.fromFirebase(snapshot.requireData);
                  return Material(
                    elevation: 1,
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Column(
                        children: [
                          const Spacer(),
                          const Text(
                            "Tiền của bạn",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            numberFormat.format(user.money),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Tháng này",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Số dư đầu",
                            style: TextStyle(fontSize: 18),
                          ),
                          Spacer(),
                          Text(
                            "+30.000.000",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Text(
                            "Số dư cuối",
                            style: TextStyle(fontSize: 18),
                          ),
                          Spacer(),
                          Text(
                            "+10.000.000",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        height: 2,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Spacer(),
                          Text(
                            "-20.000.000",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("data")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data =
                        snapshot.requireData.data() as Map<String, dynamic>;
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
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          return ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: listType.length,
                            itemBuilder: (context, index) {
                              if (index == 0 || index == 10) {
                                return const SizedBox.shrink();
                              } else {
                                var list = data!
                                    .where((element) => element.type == index)
                                    .toList();
                                if (list.isNotEmpty) {
                                  int sum = 0;
                                  for (var element in list) {
                                    sum += element.money;
                                  }

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewListSpendingPage(
                                                  spendingList: list),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 15),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              listType[index]["image"]!,
                                              width: 40,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              listType[index]["title"]!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              numberFormat.format(sum),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(Icons
                                                .arrow_forward_ios_outlined)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
