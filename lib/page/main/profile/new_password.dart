import 'package:expenditure_management/page/login/widget/custom_button.dart';
import 'package:expenditure_management/page/login/widget/input_password.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hide = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Text(
                "Nhập mật khẩu mới",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                textAlign: TextAlign.center,
                "Vui lòng nhập vào mật khẩu mới của bạn",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 50),
              inputPassword(
                hint: AppLocalizations.of(context).translate('password'),
                controller: _passwordController,
                hide: hide,
                action: () {
                  setState(() => hide = !hide);
                },
              ),
              const SizedBox(height: 20),
              inputPassword(
                action: () {
                  setState(() {
                    hide = !hide;
                  });
                },
                hint:
                    AppLocalizations.of(context).translate('confirm_password'),
                controller: _confirmPasswordController,
                password: _passwordController,
                hide: hide,
              ),
              const SizedBox(height: 30),
              customButton(
                action: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      var user = FirebaseAuth.instance.currentUser;

                      user!.updatePassword(_passwordController.text).then((_) {
                        var snackBar = const SnackBar(
                            content: Text('Đổi mật khẩu thành công'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }).catchError((error) {
                        var snackBar =
                            SnackBar(content: Text(error.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    } catch (_) {}
                    return;
                  }
                },
                text: AppLocalizations.of(context).translate('submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
