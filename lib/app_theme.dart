import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/base/base_theme.dart';

class AppTheme {
  static final Map<String, MaterialColor> colors = Map.of(BaseTheme.colors);

  static void init() {
    // colors['primary'] = pink;
    // colors['secondary'] = gray;
  }
}

// To define new color developer should visit https://colors.eva.design/

const MaterialColor pink = MaterialColor(
  0xFFFF1F6A,
  <int, Color>{
    50: Color(0xFFFFD4D2),
    100: Color(0xFFFFD4D2),
    200: Color(0xFFFFA5A8),
    300: Color(0xFFFF788B),
    400: Color(0xFFFF577E),
    500: Color(0xFFFF1F6A),
    600: Color(0xFFDB166B),
    700: Color(0xFFB70F68),
    800: Color(0xFF930960),
    900: Color(0xFF7A055A),
  },
);
