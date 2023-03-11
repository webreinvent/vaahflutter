import 'package:flutter/material.dart';

class BaseTheme {
  static const Map<String, MaterialColor> colors = {
    'primary': _primary,
    'secondary': _secondary,
    'info': _info,
    'success': _success,
    'warning': _warning,
    'danger': _danger,
    'help': _help,
    'white': _white,
    'black': _black,
  };
}

const MaterialColor _primary = MaterialColor(
  0xFF3366FF,
  <int, Color>{
    50: Color(0xFFD6E4FF),
    100: Color(0xFFD6E4FF),
    200: Color(0xFFADC8FF),
    300: Color(0xFF84A9FF),
    400: Color(0xFF6690FF),
    500: Color(0xFF3366FF),
    600: Color(0xFF254EDB),
    700: Color(0xFF1939B7),
    800: Color(0xFF102693),
    900: Color(0xFF091A7A),
  },
);

const MaterialColor _secondary = MaterialColor(
  0xFF787878,
  <int, Color>{
    50: Color(0xFFF8F8F8),
    100: Color(0xFFF8F8F8),
    200: Color(0xFFF1F1F1),
    300: Color(0xFFD6D6D6),
    400: Color(0xFFAEAEAE),
    500: Color(0xFF787878),
    600: Color(0xFF675759),
    700: Color(0xFF563C40),
    800: Color(0xFF45262E),
    900: Color(0xFF391723),
  },
);

const MaterialColor _success = MaterialColor(
  0xFF4FB52D,
  <int, Color>{
    50: Color(0xFFE9FBD5),
    100: Color(0xFFE9FBD5),
    200: Color(0xFFCFF7AD),
    300: Color(0xFFA8E87F),
    400: Color(0xFF81D25B),
    500: Color(0xFF4FB52D),
    600: Color(0xFF369B20),
    700: Color(0xFF228216),
    800: Color(0xFF11680E),
    900: Color(0xFF08560B),
  },
);

const MaterialColor _info = MaterialColor(
  0xFF4CA8FF,
  <int, Color>{
    50: Color(0xFFDBF4FF),
    100: Color(0xFFDBF4FF),
    200: Color(0xFFB7E7FF),
    300: Color(0xFF93D5FF),
    400: Color(0xFF78C4FF),
    500: Color(0xFF4CA8FF),
    600: Color(0xFF3783DB),
    700: Color(0xFF2662B7),
    800: Color(0xFF184493),
    900: Color(0xFF0E2F7A),
  },
);

const MaterialColor _warning = MaterialColor(
  0xFFFFBF00,
  <int, Color>{
    50: Color(0xFFFFF7CC),
    100: Color(0xFFFFF7CC),
    200: Color(0xFFFFED99),
    300: Color(0xFFFFE066),
    400: Color(0xFFFFD33F),
    500: Color(0xFFFFBF00),
    600: Color(0xFFDB9E00),
    700: Color(0xFFB77F00),
    800: Color(0xFF936300),
    900: Color(0xFF7A4E00),
  },
);

const MaterialColor _danger = MaterialColor(
  0xFFFF382D,
  <int, Color>{
    50: Color(0xFFFFE5D5),
    100: Color(0xFFFFE5D5),
    200: Color(0xFFFFC4AB),
    300: Color(0xFFFF9C81),
    400: Color(0xFFFF7661),
    500: Color(0xFFFF382D),
    600: Color(0xFFDB2026),
    700: Color(0xFFB71629),
    800: Color(0xFF930E28),
    900: Color(0xFF7A0828),
  },
);

const MaterialColor _help = MaterialColor(
  0xFFBE00FF,
  <int, Color>{
    50: Color(0xFFFFCCFD),
    100: Color(0xFFFFCCFD),
    200: Color(0xFFFA99FF),
    300: Color(0xFFED66FF),
    400: Color(0xFFDB3FFF),
    500: Color(0xFFBE00FF),
    600: Color(0xFF9300DB),
    700: Color(0xFF6E00B7),
    800: Color(0xFF4E0093),
    900: Color(0xFF38007A),
  },
);

const MaterialColor _white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

const MaterialColor _black = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFFF2F2F2),
    100: Color(0xFFF2F2F2),
    200: Color(0xFFE5E5E5),
    300: Color(0xFFB2B2B2),
    400: Color(0xFF666666),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
