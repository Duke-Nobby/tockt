import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LocaleProvider extends ChangeNotifier {
  late var _locale;

  Locale get value => _locale;

  void setLocale(locale) {
    _locale = locale;
    notifyListeners();
  }

  LocaleProvider(local) {
    if (local == 'zh') {
      _locale = const Locale('zh', "CN");
    } else {
      _locale = const Locale('en', 'US');
    }
  }

}
