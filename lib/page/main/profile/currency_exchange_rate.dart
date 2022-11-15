import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expenditure_management/constants/function/extension.dart';
import 'package:expenditure_management/models/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class CurrencyExchangeRate extends StatefulWidget {
  const CurrencyExchangeRate({Key? key}) : super(key: key);

  @override
  State<CurrencyExchangeRate> createState() => _CurrencyExchangeRateState();
}

class _CurrencyExchangeRateState extends State<CurrencyExchangeRate> {
  final TextEditingController _moneyController = TextEditingController();
  String selectedValue = "VND";
  Map<String, dynamic> currency = {};
  List<Map<String, dynamic>> listCountry = [];

  @override
  void initState() {
    super.initState();
    _moneyController.text = "1";
    _moneyController.addListener(() => setState(() {}));
    APIService().getExchangeRate().then((value) {
      setState(() => currency = value);
    });
    APIService().getCountry().then((value) {
      setState(() => listCountry = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tra cứu tỷ giá"),
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _moneyController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    maxLength: 15,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: InputBorder.none,
                      hintText: "100.000",
                      counterText: "",
                      hintStyle: const TextStyle(fontSize: 20),
                      contentPadding: const EdgeInsets.all(10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 70,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      dropdownMaxHeight: 200,
                      hint: Text(
                        'VND',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      items: currency.entries
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item.key,
                              child: Text(
                                item.key,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        itemCount: currency.entries.length,
        itemBuilder: (context, index) {
          var country = listCountry
              .where((element) =>
                  element["currencyCode"] ==
                  currency.entries.elementAt(index).key)
              .toList();
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          Text(
                            currency.entries.elementAt(index).key,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            country.isNotEmpty
                                ? country[0]["countryName"]
                                : "N/A",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    const VerticalDivider(color: Colors.black, thickness: 1),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${(currency.entries.elementAt(index).value / currency[selectedValue] * int.parse(_moneyController.text.isNotEmpty ? _moneyController.text : "0"))}"
                                .formatByTNT(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              "1 $selectedValue ≈ "
                              "${"${currency.entries.elementAt(index).value / currency[selectedValue]}".formatByTNT()} "
                              "${currency.entries.elementAt(index).key}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl:
                          "https://countryflagsapi.com/png/${country.isNotEmpty ? country[0]["countryName"] : ""}",
                      width: 45,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 30,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 30,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            "N/A",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
