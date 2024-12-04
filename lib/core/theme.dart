import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF85977F),
      // ···
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.hachiMaruPop(),
      displaySmall: GoogleFonts.hachiMaruPop(),
      headlineLarge: GoogleFonts.hachiMaruPop(),
      headlineMedium: GoogleFonts.hachiMaruPop(),
      headlineSmall: GoogleFonts.hachiMaruPop(),
      titleMedium: GoogleFonts.hachiMaruPop(),
      titleLarge: GoogleFonts.hachiMaruPop(),
      labelLarge: GoogleFonts.hachiMaruPop(),
      labelMedium: GoogleFonts.hachiMaruPop(),
      labelSmall: GoogleFonts.hachiMaruPop(),
      bodySmall: GoogleFonts.hachiMaruPop(),
      bodyMedium: GoogleFonts.hachiMaruPop(),
      bodyLarge: GoogleFonts.hachiMaruPop(),
      // displayMedium: GoogleFonts.bellota(),
      // displaySmall: GoogleFonts.bellota(),
      // headlineLarge: GoogleFonts.bellota(),
      // headlineMedium: GoogleFonts.bellota(),
      // headlineSmall: GoogleFonts.bellota(),
      // titleMedium: GoogleFonts.bellota(),
      // titleLarge: GoogleFonts.bellota(),
      // labelLarge: GoogleFonts.bellota(),
      // labelMedium: GoogleFonts.bellota(),
      // labelSmall: GoogleFonts.bellota(),
      // bodySmall: GoogleFonts.bellota(),
      // bodyMedium: GoogleFonts.bellota(),
      // bodyLarge: GoogleFonts.bellota(),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? GoogleFonts.hachiMaruPop(
                  color: const Color(0xFF243120), fontSize: 12)
              : GoogleFonts.hachiMaruPop(
                  color: const Color(0xFF85977F), fontSize: 12)),
    ));
