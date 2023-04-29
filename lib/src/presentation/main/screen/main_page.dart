import 'package:expenditure_management/src/presentation/main/widget/item_bottom_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/function/on_will_pop.dart';
import '../../../core/function/route_function.dart';
import '../../../core/setting/localization/app_localizations.dart';
import '../../add_spending/screen/add_spending_page.dart';
import '../../analytic/screen/analytic_page.dart';
import '../../calendar/screen/calendar_page.dart';
import '../../home/screen/home_page.dart';
import '../../profile/screen/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentTab = 0;
  List<Widget> screens = [
    const HomePage(),
    const CalendarPage(),
    const AnalyticPage(),
    const ProfilePage()
  ];

  DateTime? currentBackPressTime;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => onWillPop(
          action: (now) => currentBackPressTime = now,
          currentBackPressTime: currentBackPressTime,
        ),
        child: PageStorage(bucket: bucket, child: screens[currentTab]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            createRoute(screen: const AddSpendingPage()),
          );
        },
        child: Icon(
          Icons.add_rounded,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('home'),
                    index: 0,
                    current: currentTab,
                    icon: FontAwesomeIcons.house,
                    action: () {
                      setState(() => currentTab = 0);
                    },
                  ),
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('calendar'),
                    index: 1,
                    current: currentTab,
                    size: 28,
                    icon: Icons.calendar_month_outlined,
                    action: () {
                      setState(() => currentTab = 1);
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('analytic'),
                    index: 2,
                    current: currentTab,
                    icon: FontAwesomeIcons.chartPie,
                    action: () {
                      setState(() => currentTab = 2);
                    },
                  ),
                  itemBottomTab(
                    text: AppLocalizations.of(context).translate('account'),
                    index: 3,
                    current: currentTab,
                    icon: currentTab == 3
                        ? FontAwesomeIcons.userLarge
                        : FontAwesomeIcons.user,
                    action: () {
                      setState(() => currentTab = 3);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
