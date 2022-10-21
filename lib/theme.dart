import 'package:flutter/material.dart';

import 'vaahextendflutter/base/base_theme.dart';

class AppTheme {
  static const MaterialColor primaryColor = BaseTheme.primaryColor;
  static const MaterialColor infoColor = BaseTheme.infoColor;
  static const MaterialColor successColor = BaseTheme.successColor;
  static const MaterialColor warningColor = BaseTheme.warningColor;
  static const MaterialColor dangerColor = BaseTheme.dangerColor;
  static const MaterialColor whiteColor = BaseTheme.whiteColor;
  static const MaterialColor blackColor = BaseTheme.blackColor;
}

// extends, implements, with

// class AppThemeNew {
//   static Map<String, MaterialColor>? colors;

//   static init() {
//     Map<String, MaterialColor> tempColors = BaseThemeNew.colors;
//     if (tempColors.containsKey('newPrimaryColor')) {
//       tempColors.update('newPrimaryColor', (value) => newPrimaryColor);
//     } else {
//       Map<String, MaterialColor> color = {'newPrimaryColor': newPrimaryColor};
//       tempColors.addAll(color);
//     }
//     colors = tempColors;
//   }
// }

// const MaterialColor newPrimaryColor = MaterialColor(
//   0xFF4FB52D,
//   <int, Color>{
//     50: Color(0xFFE9FBD5),
//     100: Color(0xFFE9FBD5),
//     200: Color(0xFFCFF7AD),
//     300: Color(0xFFA8E87F),
//     400: Color(0xFF81D25B),
//     500: Color(0xFF4FB52D),
//     600: Color(0xFF369B20),
//     700: Color(0xFF228216),
//     800: Color(0xFF11680E),
//     900: Color(0xFF08560B),
//   },
// );
