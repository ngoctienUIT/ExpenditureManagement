import 'package:flutter/material.dart';

Widget settingItem(String text, Function action, IconData icon) {
  return InkWell(
    onTap: () {
      action();
    },
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(90),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(icon),
        ),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 18)),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios_outlined)
      ],
    ),
  );
}
