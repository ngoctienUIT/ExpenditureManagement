import 'package:flutter/material.dart';

Widget circleText({required String text, required Color color}) {
  return Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(90),
    ),
    child: Center(
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
