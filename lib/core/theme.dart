import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF85977F),
    // ···
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 30, fontFamily: 'Hachi Maru Pop'),
    displayMedium: TextStyle(fontFamily: 'Hachi Maru Pop'),
    displaySmall: TextStyle(fontFamily: 'Hachi Maru Pop'),
    headlineLarge: TextStyle(fontFamily: 'Hachi Maru Pop'),
    headlineMedium: TextStyle(fontFamily: 'Hachi Maru Pop'),
    headlineSmall: TextStyle(fontFamily: 'Hachi Maru Pop'),
    titleMedium: TextStyle(fontFamily: 'Hachi Maru Pop'),
    titleLarge: TextStyle(fontFamily: 'Hachi Maru Pop'),
    labelLarge: TextStyle(fontFamily: 'Hachi Maru Pop'),
    labelMedium: TextStyle(fontFamily: 'Hachi Maru Pop'),
    labelSmall: TextStyle(fontFamily: 'Hachi Maru Pop'),
    bodySmall: TextStyle(fontFamily: 'Hachi Maru Pop'),
    bodyMedium: TextStyle(fontFamily: 'Hachi Maru Pop'),
    bodyLarge: TextStyle(fontFamily: 'Hachi Maru Pop'),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) => states.contains(MaterialState.selected)
          ? const TextStyle(
              color: Color(0xFF243120),
              fontSize: 12,
              fontFamily: 'Hachi Maru Pop')
          : const TextStyle(
              color: Color(0xFF85977F),
              fontSize: 12,
              fontFamily: 'Hachi Maru Pop'),
    ),
  ),
);
