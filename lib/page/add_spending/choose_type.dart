import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/constants/list.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class ChooseType extends StatefulWidget {
  const ChooseType({Key? key, required this.action}) : super(key: key);
  final Function(int index, int coefficient, String? name) action;

  @override
  State<ChooseType> createState() => _ChooseTypeState();
}

class _ChooseTypeState extends State<ChooseType> with TickerProviderStateMixin {
  late TabController _tabController;
  final _name = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Loại chi tiêu",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: listType.length,
        itemBuilder: (context, index) {
          if ([0, 10, 21, 27, 35, 38].contains(index)) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 15),
              child: Text(
                listType[index]["title"]!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return InkWell(
            onTap: () async {
              if (index != 41) {
                widget.action(index, _tabController.index == 0 ? -1 : 1, null);
                Navigator.pop(context);
              } else {
                await showNewType();
                _name.text = "";
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const NewTypePage(),
                //   ),
                // );
              }
            },
            child: Material(
              elevation: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 60,
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset(
                      listType[index]["image"]!,
                      width: 40,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      listType[index]["title"]!,
                      style: AppStyles.p,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget customTab() {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(242, 243, 247, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
          controller: _tabController,
          labelColor: Colors.black87,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelColor: const Color.fromRGBO(45, 216, 198, 1),
          unselectedLabelStyle: AppStyles.p,
          isScrollable: false,
          indicatorColor: Colors.red,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          tabs: [
            Tab(text: AppLocalizations.of(context).translate('spending')),
            Tab(text: AppLocalizations.of(context).translate('income')),
          ]),
    );
  }

  Future showNewType() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(AppLocalizations.of(context).translate('new_type')),
          ),
          content: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                customTab(),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _name,
                  maxLines: 10,
                  minLines: 1,
                  style: AppStyles.p,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        AppLocalizations.of(context).translate('type_name'),
                    hintStyle: AppStyles.p,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    widget.action(
                        41, _tabController.index == 0 ? -1 : 1, _name.text);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
