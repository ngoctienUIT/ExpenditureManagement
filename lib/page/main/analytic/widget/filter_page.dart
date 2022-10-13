import 'package:flutter/material.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Bộ lọc",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Tìm kiếm",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: const [
                SizedBox(width: 70, child: Text("Số tiền")),
                Expanded(child: TextField())
              ],
            ),
            Row(
              children: const [
                SizedBox(width: 70, child: Text("Ví")),
                Expanded(child: TextField())
              ],
            ),
            Row(
              children: const [
                SizedBox(width: 70, child: Text("Thời gian")),
                Expanded(child: TextField())
              ],
            ),
            Row(
              children: const [
                SizedBox(width: 70, child: Text("Ghi chú")),
                Expanded(child: TextField())
              ],
            ),
            Row(
              children: const [
                SizedBox(width: 70, child: Text("Nhóm")),
                Expanded(child: TextField())
              ],
            ),
          ],
        ),
      ),
    );
  }
}
