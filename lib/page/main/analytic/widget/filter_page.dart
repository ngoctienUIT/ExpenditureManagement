import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/models/filter.dart';
import 'package:expenditure_management/page/main/analytic/widget/item_filter.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:expenditure_management/constants/function/pick_function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({
    Key? key,
    required this.action,
    required this.filter,
  }) : super(key: key);
  final Function(Filter filter) action;
  final Filter filter;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  var numberFormat = NumberFormat.currency(locale: "vi_VI");
  TextEditingController moneyController = TextEditingController();
  TextEditingController finishMoneyController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  late Filter filter;
  late DateTimeRange range;

  @override
  void initState() {
    filter = widget.filter.copyWith();
    noteController.text = filter.note;
    moneyController.text = numberFormat.format(filter.money);
    finishMoneyController.text = numberFormat.format(filter.finishMoney);
    range = DateTimeRange(
      start: filter.time ?? DateTime.now(),
      end: filter.finishTime ?? DateTime.now(),
    );
    super.initState();
  }

  @override
  void dispose() {
    moneyController.dispose();
    finishMoneyController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('filter'),
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.action(filter.copyWith(
                money: moneyController.text.isEmpty
                    ? 0
                    : int.parse(
                        moneyController.text.replaceAll(RegExp(r'[^0-9]'), '')),
                finishMoney: finishMoneyController.text.isEmpty
                    ? 0
                    : int.parse(finishMoneyController.text
                        .replaceAll(RegExp(r'[^0-9]'), '')),
                note: noteController.text,
              ));
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('search'),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          )
        ],
      ),
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ItemFilter(
                text: AppLocalizations.of(context).translate('money'),
                value: filter.chooseIndex[0] == 0
                    ? AppLocalizations.of(context)
                        .translate(moneyList[filter.chooseIndex[0]])
                    : (filter.chooseIndex[0] == 3
                        ? "${moneyController.text} - ${finishMoneyController.text}"
                        : "${AppLocalizations.of(context).translate(moneyList[filter.chooseIndex[0]])} ${moneyController.text.isNotEmpty ? moneyController.text : numberFormat.format(filter.money)}"),
                list: moneyList,
                action: (value) async {
                  if (value != 0 && value != 3) {
                    await inputMoney(index: value);
                  } else if (value == 3) {
                    await inputMoney(check: true, index: value);
                  } else {
                    setState(() => filter.chooseIndex[0] = 0);
                  }
                },
              ),
              line(),
              ItemFilter(
                text: AppLocalizations.of(context).translate('time'),
                value: filter.chooseIndex[1] == 0
                    ? AppLocalizations.of(context)
                        .translate(timeList[filter.chooseIndex[1]])
                    : (filter.chooseIndex[1] == 3
                        ? "${DateFormat("dd/MM/yyyy").format(filter.time!)} - ${DateFormat("dd/MM/yyyy").format(filter.finishTime!)}"
                        : "${AppLocalizations.of(context).translate(timeList[filter.chooseIndex[1]])} ${DateFormat("dd/MM/yyyy").format(filter.time!)}"),
                list: timeList,
                action: (value) async {
                  if (value != 0 && value != 3) {
                    DateTime? picker = await selectDate(
                      context: context,
                      initialDate: DateTime.now(),
                    );
                    if (picker != null) {
                      filter.time = picker;
                      setState(() => filter.chooseIndex[1] = value);
                    }
                  } else if (value == 3) {
                    await pickDateRange();
                  } else {
                    setState(() => filter.chooseIndex[1] = value);
                  }
                },
              ),
              line(),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      AppLocalizations.of(context).translate('note'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        hintStyle: const TextStyle(fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText:
                            AppLocalizations.of(context).translate('note'),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ),
                ],
              ),
              line(),
              ItemFilter(
                text: AppLocalizations.of(context).translate('group'),
                value: AppLocalizations.of(context)
                    .translate(groupList[filter.chooseIndex[2]]),
                list: groupList,
                action: (value) {
                  setState(() => filter.chooseIndex[2] = value);
                },
              ),
              line()
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

  Future inputMoney({bool check = false, required int index}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: AlertDialog(
            content: SizedBox(
              height: check ? 250 : 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context).translate("enter_amount")),
                  const SizedBox(height: 10),
                  if (check)
                    const Text(
                      "Bắt đầu",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  TextField(
                    controller: moneyController,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyTextInputFormatter(locale: "vi")],
                    decoration: const InputDecoration(
                      hintText: '30.000 VND',
                    ),
                  ),
                  if (check) const SizedBox(height: 20),
                  if (check)
                    const Text(
                      "Kết thúc",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (check)
                    TextField(
                      controller: finishMoneyController,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(locale: "vi")
                      ],
                      decoration: const InputDecoration(
                        hintText: '30.000 VND',
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => filter.chooseIndex[0] = index);
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
      context: context,
      initialDateRange: range,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDateRange != null) {
      setState(() {
        range = newDateRange;
        filter.chooseIndex[1] = 3;
        filter.time = newDateRange.start;
        filter.finishTime = newDateRange.end;
      });
    }
  }
}
