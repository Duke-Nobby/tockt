import 'package:tockt/utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum FontType {
  bold, //粗体
  regular, //正常
  medium, //正常加重
  semi_bold //偏粗体
}

class CommonTextStyle extends TextStyle {
  static hintStyle({
    Color color = ColorUtils.hintColor,
    FontType fontType = FontType.regular,
    double fontSize = 14,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: fontSize,
      color: color,
    );
  }

  static blackStyle({
    Color color = ColorUtils.mainTextColor,
    FontType fontType = FontType.regular,
    double fontSize = 14,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: fontSize,
      color: color,
    );
  }

  static topicStyle({
    Color color = ColorUtils.topicTextColor,
    FontType fontType = FontType.regular,
    double fontSize = 14,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: fontSize,
      color: color,
    );
  }

  static whiteStyle({
    Color color = const Color(0xFFFFFFFF),
    FontType fontType = FontType.regular,
    double fontSize = 14,
  }) {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: fontSize,
      color: color,
    );
  }
}
