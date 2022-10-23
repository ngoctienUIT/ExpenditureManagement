import 'package:expenditure_management/constants/app_colors.dart';
import 'package:expenditure_management/firebase_options.dart';
import 'package:expenditure_management/page/add_spending/add_spending_page.dart';
import 'package:expenditure_management/page/forgot/forgot_page.dart';
import 'package:expenditure_management/page/forgot/success_page.dart';
import 'package:expenditure_management/page/login/login_page.dart';
import 'package:expenditure_management/page/main/home/home_page.dart';
import 'package:expenditure_management/page/main/main_page.dart';
import 'package:expenditure_management/page/onboarding/onboarding_page.dart';
import 'package:expenditure_management/page/signup/signup_page.dart';
import 'package:expenditure_management/page/signup/verify/verify_page.dart';
import 'package:expenditure_management/setting/bloc/setting_cubit.dart';
import 'package:expenditure_management/setting/bloc/setting_state.dart';
import 'package:expenditure_management/setting/localization/app_localizations_setup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final int? language = prefs.getInt('language');
  final bool isDark = prefs.getBool("isDark") ?? false;
  runApp(MyApp(language: language, isDark: isDark));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.language, required this.isDark});
  final int? language;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingCubit>(
          create: (_) => SettingCubit(language: language, isDark: isDark),
        ),
      ],
      child: BlocBuilder<SettingCubit, SettingState>(
          buildWhen: (previous, current) => previous != current,
          builder: (_, settingState) {
            return MaterialApp(
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localizationsDelegates:
                  AppLocalizationsSetup.localizationsDelegates,
              localeResolutionCallback:
                  AppLocalizationsSetup.localeResolutionCallback,
              locale: settingState.locale,
              debugShowCheckedModeBanner: false,
              title: 'Spending Management',
              theme: settingState.isDark
                  ? ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.blue,
                    )
                  : ThemeData(
                      brightness: Brightness.light,
                      primarySwatch: Colors.blue,
                      scaffoldBackgroundColor: AppColors.whisperBackground,
                      bottomAppBarColor: AppColors.whisperBackground,
                    ),
              initialRoute: FirebaseAuth.instance.currentUser == null
                  ? "/"
                  : (FirebaseAuth.instance.currentUser!.emailVerified
                      ? '/main'
                      : '/verify'),
              routes: {
                '/': (context) => const OnboardingPage(),
                '/login': (context) => const LoginPage(),
                '/signup': (context) => const SignupPage(),
                '/home': (context) => const HomePage(),
                '/main': (context) => const MainPage(),
                '/forgot': (context) => const ForgotPage(),
                '/success': (context) => const SuccessPage(),
                '/verify': (context) => const VerifyPage(),
                '/add': (context) => const AddSpendingPage()
              },
            );
          }),
    );
  }
}
