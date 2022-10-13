import 'package:expenditure_management/page/main/analytic/widget/filter_page.dart';
import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FilterPage(),
              ),
            );
          },
          icon: const Icon(
            Icons.tune_rounded,
            color: Colors.black,
          ),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () {
          close(context, "result");
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      );

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Text("TNT $index");
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Text("TNT $index");
      },
    );
  }

  @override
  String? get searchFieldLabel => "Tìm kiếm";

  @override
  // TODO: implement searchFieldStyle
  TextStyle? get searchFieldStyle =>
      const TextStyle(color: Colors.black54, fontSize: 18);
}
