import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/constants/function/loading_animation.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/controls/spending_firebase.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/page/add_spending/choose_type.dart';
import 'package:expenditure_management/page/add_spending/widget/input_spending.dart';
import 'package:expenditure_management/page/add_spending/widget/item_spending.dart';
import 'package:expenditure_management/page/add_spending/widget/more_button.dart';
import 'package:expenditure_management/page/login/widget/custom_button.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class EditSpendingPage extends StatefulWidget {
  const EditSpendingPage({
    Key? key,
    required this.spending,
    this.change,
    this.delete,
  }) : super(key: key);
  final Spending spending;
  final Function(Spending spending)? change;
  final Function(String id)? delete;

  @override
  State<EditSpendingPage> createState() => _EditSpendingPageState();
}

class _EditSpendingPageState extends State<EditSpendingPage> {
  final _money = TextEditingController();
  final _note = TextEditingController();
  final _location = TextEditingController();
  final _friend = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int? type;
  XFile? image;
  bool more = false;
  String? typeName;
  int coefficient = 1;
  List<String> friends = [];

  @override
  void dispose() {
    _money.dispose();
    _note.dispose();
    _location.dispose();
    _friend.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _money.text = NumberFormat.currency(locale: "vi_VI")
        .format(widget.spending.money.abs());
    _location.text = widget.spending.location ?? "";
    friends = widget.spending.friends ?? [];
    if (widget.spending.note != null) {
      _note.text = widget.spending.note!;
    }
    selectedDate = widget.spending.dateTime;
    selectedTime = TimeOfDay(
      hour: widget.spending.dateTime.hour,
      minute: widget.spending.dateTime.minute,
    );
    type = widget.spending.type;
    typeName = widget.spending.typeName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('edit_spending')),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              String moneyString =
                  _money.text.replaceAll(RegExp(r'[^0-9]'), '');
              if (type != null &&
                  moneyString.isNotEmpty &&
                  moneyString.compareTo("0") != 0) {
                int money = int.parse(moneyString);
                Spending spending = Spending(
                  id: widget.spending.id,
                  money: type == 41
                      ? coefficient * money
                      : ([29, 30, 34, 36, 37, 40].contains(type!)
                          ? 1
                          : (-1) * money),
                  type: type!,
                  typeName: typeName,
                  dateTime: DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  ),
                  note: _note.text,
                  image: widget.spending.image,
                  location: _location.text,
                  friends: friends,
                );
                loadingAnimation(context);
                await SpendingFirebase.updateSpending(
                    spending,
                    widget.spending.dateTime,
                    image != null ? File(image!.path) : null);
                if (widget.change != null) {
                  widget.change!(spending);
                }
                if (!mounted) return;
                Navigator.pop(context);
                if (!mounted) return;
                Navigator.pop(context);
              } else if (type == null) {
                Fluttertoast.showToast(msg: "Vui lòng chọn loại");
              } else {
                Fluttertoast.showToast(
                    msg: "Vui lòng nhập vào số tiền hợp lệ");
              }
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[\\s0-9a-zA-Z]")),
                  CurrencyTextInputFormatter(locale: "vi")
                ],
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
                    addSpending(),
                    if (more) moreSpending(),
                    MoreButton(
                      action: () {
                        setState(() => more = !more);
                      },
                      more: more,
                    ),
                    SizedBox(
                      width: 100,
                      child: customButton(
                        text: "Xóa",
                        action: () async {
                          loadingAnimation(context);
                          await SpendingFirebase.deleteSpending(
                              widget.spending);
                          widget.delete!(widget.spending.id!);
                          if (!mounted) return;
                          Navigator.pop(context);
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
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

  Widget addSpending() {
    return Padding(
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
                            builder: (context) => ChooseType(
                              action: (index, coefficient, name) {
                                setState(() => type = index);
                              },
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            type == null
                                ? AppLocalizations.of(context).translate('type')
                                : listType[type!]["title"]!,
                            style: AppStyles.p,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              line(),
              itemSpending(
                color: const Color.fromRGBO(244, 131, 27, 1),
                icon: Icons.calendar_month_rounded,
                text: DateFormat("dd/MM/yyyy").format(selectedDate),
                action: () {
                  _selectDate(context);
                },
              ),
              line(),
              itemSpending(
                color: const Color.fromRGBO(241, 186, 5, 1),
                icon: Icons.access_time_rounded,
                text:
                    "${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}",
                action: () {
                  _selectTime(context);
                },
              ),
              line(),
              inputSpending(
                icon: Icons.edit,
                color: const Color.fromRGBO(221, 96, 0, 1),
                controller: _note,
                keyboardType: TextInputType.multiline,
                hintText: AppLocalizations.of(context).translate('note'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moreSpending() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              inputSpending(
                icon: Icons.location_on_outlined,
                color: const Color.fromRGBO(99, 195, 40, 1),
                controller: _location,
                textInputAction: TextInputAction.done,
                hintText: AppLocalizations.of(context).translate('location'),
              ),
              line(),
              inputSpending(
                icon: Icons.people,
                color: const Color.fromRGBO(202, 31, 52, 1),
                controller: _friend,
                hintText: AppLocalizations.of(context).translate('friend'),
                textInputAction: TextInputAction.done,
                action: (value) {
                  friends.add(value);
                  setState(() => _friend.text = "");
                },
              ),
              if (friends.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 40, right: 5),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Text(
                          friends[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() => friends.removeAt(index));
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        )
                      ],
                    );
                  },
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
              if (image == null && widget.spending.image != null)
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.spending.image!,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                    image == null && widget.spending.image == null
                        ? AppLocalizations.of(context).translate('add_picture')
                        : AppLocalizations.of(context).translate('replace'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
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
