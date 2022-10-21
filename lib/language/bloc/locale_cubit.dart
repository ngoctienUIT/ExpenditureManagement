import 'dart:io' show Platform;
import 'package:expenditure_management/language/bloc/locale_state.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<LocaleState> {
  int? language;

  LocaleCubit({this.language})
      : super(
          SelectedLocale(
            language == null
                ? Locale(
                    Platform.localeName.split('_')[0] == "vi" ? "vi" : "en")
                : (language == 0 ? const Locale('vi') : const Locale('en')),
          ),
        );

  void toVietnamese() => emit(const SelectedLocale(Locale('vi')));

  void toEnglish() => emit(const SelectedLocale(Locale('en')));
}
