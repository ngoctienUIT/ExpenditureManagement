import 'package:expenditure_management/constants/function/pick_function.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget pickImageWidget({
  required Function(XFile? file) gallery,
  required Function(XFile? file) camera,
}) {
  return IntrinsicHeight(
    child: Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () async {
              var file = await pickImage(true);
              gallery(file);
            },
            icon: const Icon(Icons.image, size: 30),
          ),
        ),
        const VerticalDivider(
          color: Colors.black54,
          thickness: 1,
          indent: 5,
          endIndent: 5,
        ),
        Expanded(
          child: IconButton(
            onPressed: () async {
              var file = await pickImage(false);
              camera(file);
            },
            icon: const Icon(Icons.camera_alt, size: 30),
          ),
        ),
      ],
    ),
  );
}