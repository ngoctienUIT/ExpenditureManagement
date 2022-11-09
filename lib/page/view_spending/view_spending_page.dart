import 'dart:math';

import 'package:expenditure_management/constants/function/loading_animation.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/add_spending/widget/circle_text.dart';
import 'package:expenditure_management/page/edit_spending/edit_spending_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewSpendingPage extends StatefulWidget {
  const ViewSpendingPage({
    Key? key,
    required this.spending,
    this.delete,
    this.change,
  }) : super(key: key);
  final Spending spending;
  final Function(String id)? delete;
  final Function(Spending spending)? change;

  @override
  State<ViewSpendingPage> createState() => _ViewSpendingPageState();
}

class _ViewSpendingPageState extends State<ViewSpendingPage> {
  List<Color> colors = [];
  final numberFormat = NumberFormat.currency(locale: "vi_VI");
  late Spending spending;

  @override
  void initState() {
    for (var element in widget.spending.friends!) {
      colors.add(Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
          Random().nextInt(255), 1));
    }
    spending = widget.spending.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditSpendingPage(
                    spending: spending,
                    change: (spending) async {
                      try {
                        spending.image = await FirebaseStorage.instance
                            .ref()
                            .child("spending/${spending.id}.png")
                            .getDownloadURL();
                      } catch (_) {}
                      if (widget.change != null) {
                        widget.change!(spending);
                      }
                      setState(() {
                        this.spending = spending;
                      });
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              loadingAnimation(context);
              await SpendingFirebase.deleteSpending(spending);
              if (widget.delete != null) {
                widget.delete!(spending.id!);
              }
              if (!mounted) return;
              Navigator.pop(context);
              if (!mounted) return;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(
                      listType[spending.type]["image"]!,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      listType[spending.type]["title"]!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 60),
                    Text(
                      numberFormat.format(spending.money.abs()),
                      style: const TextStyle(fontSize: 25, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.calendar_month_rounded,
                        size: 30,
                        color: Color.fromRGBO(244, 131, 27, 1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat("dd/MM/yyyy - hh:mm")
                          .format(spending.dateTime),
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
                if (spending.note != null && spending.note!.isNotEmpty)
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.edit_note_rounded,
                          size: 30,
                          color: Color.fromRGBO(221, 96, 0, 1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        spending.note!,
                        maxLines: 10,
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                if (spending.location != null && spending.location!.isNotEmpty)
                  Row(
                    children: [
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 30,
                          color: Color.fromRGBO(99, 195, 40, 1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        spending.location!,
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                if (spending.friends != null && spending.friends!.isNotEmpty)
                  addFriend(),
                if (spending.friends != null && spending.friends!.isNotEmpty)
                  const SizedBox(height: 10),
                if (spending.image != null) Image.network(spending.image!)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addFriend() {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          const SizedBox(
            height: 50,
            width: 50,
            child: Icon(
              Icons.people,
              color: Color.fromRGBO(202, 31, 52, 1),
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          if (spending.friends!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: spending.friends!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Row(
                        children: [
                          circleText(
                            text: spending.friends![index][0],
                            color: colors[index],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            spending.friends![index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
