import 'dart:math';

import 'package:expenditure_management/constants/function/loading_animation.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/add_spending/widget/circle_text.dart';
import 'package:expenditure_management/page/edit_spending/edit_spending_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewSpendingPage extends StatefulWidget {
  const ViewSpendingPage({Key? key, required this.spending}) : super(key: key);
  final Spending spending;

  @override
  State<ViewSpendingPage> createState() => _ViewSpendingPageState();
}

class _ViewSpendingPageState extends State<ViewSpendingPage> {
  List<Color> colors = [];

  @override
  void initState() {
    for (var element in widget.spending.friends!) {
      colors.add(Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
          Random().nextInt(255), 1));
    }
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
                    builder: (context) =>
                        EditSpendingPage(spending: widget.spending),
                  ),
                );
              },
              icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () async {
              loadingAnimation(context);
              await SpendingFirebase.deleteSpending(widget.spending);
              // widget.delete!(spending.id!);
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
                      listType[widget.spending.type]["image"]!,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      listType[widget.spending.type]["title"]!,
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
                      widget.spending.money.abs().toString(),
                      style: const TextStyle(fontSize: 25, color: Colors.red),
                    ),
                  ],
                ),
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
                          .format(widget.spending.dateTime),
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
                if (widget.spending.note != null)
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
                        widget.spending.note!,
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                if (widget.spending.location != null)
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
                        widget.spending.location!,
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                if (widget.spending.friends != null &&
                    widget.spending.friends!.isNotEmpty)
                  addFriend(),
                if (widget.spending.friends != null &&
                    widget.spending.friends!.isNotEmpty)
                  const SizedBox(height: 10),
                if (widget.spending.image != null)
                  Image.network(widget.spending.image!)
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
          if (widget.spending.friends!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.spending.friends!.length,
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
                            text: widget.spending.friends![index][0],
                            color: colors[index],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.spending.friends![index],
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
