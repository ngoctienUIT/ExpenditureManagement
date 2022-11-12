import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        children: [
          Image.asset("assets/logo/logo.png", width: 150),
          const SizedBox(height: 15),
          const Text(
            "Spending Manager",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text("${AppLocalizations.of(context).translate('version')} 1.0.0"),
          const SizedBox(height: 5),
          Text(
            "${AppLocalizations.of(context).translate('developed_by')} Trần Ngọc Tiến",
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.black26, height: 1),
          const SizedBox(height: 20),
          InkWell(
            onTap: () async {
              var url = 'https://www.facebook.com/ngoctien.TNT/';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              }
            },
            child: SizedBox(
              width: 300,
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.facebook,
                    color: Colors.blue,
                    size: 40,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${AppLocalizations.of(context).translate('contact_me_via')} Facebook",
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () async {
              var url = 'https://twitter.com/ngoctienTNT';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              }
            },
            child: SizedBox(
              width: 300,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${AppLocalizations.of(context).translate('contact_me_via')} Twitter",
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () async {
              String email = 'ngoctienTNT.vn@gmail.com';
              String subject = 'Spending Manager';
              String body = 'Hello Tran Ngoc Tien';

              String emailUrl = "mailto:$email?subject=$subject&body=$body";

              if (await canLaunchUrlString(emailUrl)) {
                await launchUrlString(emailUrl);
              }
            },
            child: SizedBox(
              width: 300,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${AppLocalizations.of(context).translate('contact_me_via')} Email",
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
