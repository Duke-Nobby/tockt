import 'package:cardwiser/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 44,
          titleTextStyle: TextStyle(color: ColorUtils.titleColor, fontSize: 17),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarContrastEnforced: true)),
      backgroundColor: ColorUtils.bodyColor);

  ThemeData get value => _themeData;

  void setThemeData(themeData) {
    _themeData = themeData;

    notifyListeners();
  }
}
