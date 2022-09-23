import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/add_spending/widget/item_spending.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSpendingPage extends StatefulWidget {
  const AddSpendingPage({Key? key}) : super(key: key);

  @override
  State<AddSpendingPage> createState() => _AddSpendingPageState();
}

class _AddSpendingPageState extends State<AddSpendingPage> {
  final _money = TextEditingController();
  final _note = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whisperBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Thêm giao dịch",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              Spending spending = Spending(
                money: int.parse(_money.text.replaceAll(RegExp(r'[^0-9]'), '')),
                type: 1,
                dateTime: DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ),
                note: _note.text,
              );

              await SpendingFirebase.addSpending(spending);
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text("Lưu", style: AppStyles.p),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.close_outlined, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: 100,
              color: Colors.white,
              child: TextFormField(
                controller: _money,
                inputFormatters: [CurrencyTextInputFormatter(locale: "vi")],
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: InputBorder.none,
                  hintText: "100.000",
                  hintStyle: const TextStyle(fontSize: 20),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icon/question_mark.png",
                                    width: 35,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Text("Loại", style: AppStyles.p),
                                          const Spacer(),
                                          const Icon(
                                              Icons.arrow_forward_ios_rounded),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                endIndent: 10,
                                indent: 10,
                              ),
                              itemSpending(
                                icon: Icons.calendar_month_rounded,
                                text: DateFormat("dd/MM/yyyy")
                                    .format(selectedDate),
                                action: () {
                                  _selectDate(context);
                                },
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                endIndent: 10,
                                indent: 10,
                              ),
                              itemSpending(
                                icon: Icons.access_time_rounded,
                                text:
                                    "${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}",
                                action: () {
                                  _selectTime(context);
                                },
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.edit,
                                      color: Colors.grey, size: 30),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _note,
                                      maxLines: 10,
                                      minLines: 1,
                                      style: AppStyles.p,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Ghi chú",
                                        hintStyle: AppStyles.p,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Thêm chi tiết",
                        style: AppStyles.p,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
