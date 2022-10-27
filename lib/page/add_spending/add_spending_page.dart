import 'dart:io';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/constants/function/loading_animation.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/add_spending/choose_type.dart';
import 'package:expenditure_management/page/add_spending/widget/item_spending.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  int? type;
  XFile? image;
  bool more = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('add_spending'),
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              Spending spending = Spending(
                  money: ([29, 30, 34, 36, 37, 40].contains(type!) ? 1 : (-1)) *
                      int.parse(_money.text.replaceAll(RegExp(r'[^0-9]'), '')),
                  type: type!,
                  dateTime: DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  ),
                  note: _note.text,
                  image: image!.path);
              loadingAnimation(context);
              await SpendingFirebase.addSpending(spending);
              if (!mounted) return;
              Navigator.pop(context);
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('save'),
              style: AppStyles.p,
            ),
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
                  hintText: "100.000 VND",
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
                                    type == null
                                        ? "assets/icons/question_mark.png"
                                        : listType[type!]["image"]!,
                                    width: 35,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChooseType(action: (index) {
                                              setState(() => type = index);
                                            }),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Text(
                                            type == null
                                                ? AppLocalizations.of(context)
                                                    .translate('type')
                                                : listType[type!]["title"]!,
                                            style: AppStyles.p,
                                          ),
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
                              line(),
                              itemSpending(
                                icon: Icons.calendar_month_rounded,
                                text: DateFormat("dd/MM/yyyy")
                                    .format(selectedDate),
                                action: () {
                                  _selectDate(context);
                                },
                              ),
                              line(),
                              itemSpending(
                                icon: Icons.access_time_rounded,
                                text:
                                    "${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}",
                                action: () {
                                  _selectTime(context);
                                },
                              ),
                              line(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
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
                                        hintText: AppLocalizations.of(context)
                                            .translate('note'),
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
                    if (more)
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
                                itemSpending(
                                  icon: Icons.location_on_outlined,
                                  text: "Khánh Hòa",
                                  action: () {},
                                ),
                                line(),
                                const SizedBox(height: 10),
                                if (image != null)
                                  Column(
                                    children: [
                                      Image.file(
                                        File(image!.path),
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      const SizedBox(height: 10)
                                    ],
                                  ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    onPressed: () => pickImage(),
                                    icon: const Icon(Icons.image, size: 35),
                                    label: Text(
                                      image == null ? "Thêm ảnh" : "Thay thế",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() => more = !more);
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              more
                                  ? AppLocalizations.of(context)
                                      .translate('hide_away')
                                  : AppLocalizations.of(context)
                                      .translate('more_details'),
                              style: AppStyles.p),
                          Icon(
                            more ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget line() {
    return const Divider(
      color: Colors.grey,
      thickness: 0.5,
      endIndent: 10,
      indent: 10,
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
      setState(() => selectedTime = picked);
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
      setState(() => selectedDate = picked);
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => this.image = image);
      }
    } on PlatformException catch (_) {}
  }
}
