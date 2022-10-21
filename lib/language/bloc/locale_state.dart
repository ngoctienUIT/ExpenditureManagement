import 'package:flutter/material.dart';

abstract class LocaleState {
  final Locale locale;
  const LocaleState(this.locale);
}

class SelectedLocale extends LocaleState {
  const SelectedLocale(Locale locale) : super(locale);
}
