import 'package:flutter/material.dart';

class WallRioThemeData {
  static getLightThemeData() => ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      backgroundColor: whiteColor,
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
      textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E2E2E)),
          headline2: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E2E2E)),
          bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          bodyText2: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)));

  static getDarkThemeData() =>
      ThemeData(brightness: Brightness.dark, useMaterial3: true);
}

const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
