import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final app_theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF85977F),
      // ···
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      // ···
      // titleLarge: GoogleFonts.hachiMaruPop(
      //   fontSize: 20,
      //   fontWeight: FontWeight.bold,
      //   color: Color(0xFF85977F),
      // ),
      //titleSmall: GoogleFonts.hachiMaruPop(),
      titleMedium: GoogleFonts.hachiMaruPop(),
      titleLarge: GoogleFonts.hachiMaruPop(),
      bodySmall: GoogleFonts.hachiMaruPop(),
      bodyMedium: GoogleFonts.hachiMaruPop(),
      bodyLarge: GoogleFonts.hachiMaruPop(),
      displaySmall: GoogleFonts.hachiMaruPop(),
      displayMedium: GoogleFonts.hachiMaruPop(),
      labelSmall: GoogleFonts.hachiMaruPop(),
      labelMedium: GoogleFonts.hachiMaruPop(),
      labelLarge: GoogleFonts.hachiMaruPop(),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? GoogleFonts.hachiMaruPop(color: Color(0xFF243120), fontSize: 12)
              : GoogleFonts.hachiMaruPop(
                  color: Color(0xFF85977F), fontSize: 12)),
    ));
