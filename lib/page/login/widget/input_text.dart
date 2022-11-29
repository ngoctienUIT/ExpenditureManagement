import 'package:flutter/material.dart';
import 'package:expenditure_management/constants/app_styles.dart';

class InputText extends StatelessWidget {
  const InputText({
    Key? key,
    required this.hint,
    this.error,
    required this.controller,
    required this.validator,
    this.inputType,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  final String hint;
  final String? error;
  final TextEditingController controller;
  final int validator;
  final TextInputType? inputType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: AppStyles.p,
      keyboardType: inputType,
      textCapitalization: textCapitalization,
      validator: (value) {
        if (validator == 0 &&
            (value!.isEmpty ||
                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value))) {
          return 'Enter a valid email!';
        } else if (validator == 1 && value!.isEmpty) {
          return 'Enter a valid name';
        } else if (validator == 2 && value!.isEmpty) {
          return 'Enter a valid OTP';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
        hintStyle: AppStyles.p,
        filled: true,
        errorText: error,
        fillColor: Theme.of(context).backgroundColor,
        hintText: hint,
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
