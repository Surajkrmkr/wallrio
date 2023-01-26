import 'package:flutter/material.dart';

class WallRioThemeData {
  static getLightThemeData() => ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: whiteColor,
      fontFamily: 'POCOTech',
      canvasColor: Colors.transparent,
      appBarTheme:
          const AppBarTheme(color: whiteColor, surfaceTintColor: whiteColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: blackColor,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
          backgroundColor: blackColor.withOpacity(0.05),
          side: BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          selectedColor: blackColor,
          surfaceTintColor: whiteColor,
          showCheckmark: false),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E2E2E)),
          displayMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E2E2E)),
          bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      colorScheme: const ColorScheme.light());

  static getDarkThemeData() =>
      ThemeData(brightness: Brightness.dark, useMaterial3: true);
}

const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
