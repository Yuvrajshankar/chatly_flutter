import 'package:flutter/material.dart';

// light
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xfffbfbfd),
    primary: Color(0xffd9d9d9),
    secondary: Colors.black,
    tertiary: Colors.white,
    primaryContainer: Colors.grey[600],
  ),
);

// dark
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xff181a1b),
    primary: Color(0xff1f2223),
    secondary: Colors.white,
    // secondary: Color(0xff808080),
    tertiary: Colors.black,
    primaryContainer: Colors.grey,
  ),
);
