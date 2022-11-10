import 'package:flutter/material.dart';

Widget removeIcon({required Function action}) {
  return InkWell(
    onTap: () {
      action();
    },
    child: Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        color: Colors.grey,
      ),
      child: const Icon(Icons.close, size: 15),
    ),
  );
}
