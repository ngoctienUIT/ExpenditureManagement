import 'package:expenditure_management/firebase_options.dart';
import 'package:expenditure_management/language/bloc/locale_cubit.dart';
import 'package:expenditure_management/language/bloc/locale_state.dart';
import 'package:expenditure_management/language/localization/app_localizations_setup.dart';
import 'package:expenditure_management/page/add_spending/add_spending_page.dart';
import 'package:expenditure_management/page/forgot/forgot_page.dart';
import 'package:expenditure_management/page/forgot/success_page.dart';
import 'package:expenditure_management/page/login/login_page.dart';
import 'package:expenditure_management/page/main/home/home_page.dart';
import 'package:expenditure_management/page/main/main_page.dart';
import 'package:expenditure_management/page/onboarding/onboarding_page.dart';
import 'package:expenditure_management/page/signup/signup_page.dart';
import 'package:expenditure_management/page/signup/verify/verify_page.dart';
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
  runApp(MyApp(language: language));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.language});
  final int? language;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(language: language),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
          buildWhen: (previous, current) => previous != current,
          builder: (_, localeState) {
            return MaterialApp(
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localizationsDelegates:
                  AppLocalizationsSetup.localizationsDelegates,
              localeResolutionCallback:
                  AppLocalizationsSetup.localeResolutionCallback,
              locale: localeState.locale,
              debugShowCheckedModeBanner: false,
              title: 'Spending Management',
              theme: ThemeData(
                primarySwatch: Colors.blue,
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
