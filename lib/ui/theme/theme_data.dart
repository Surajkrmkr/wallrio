import 'package:flutter/material.dart';

class WallRioThemeData {
  static getLightThemeData(
          {required bool isDarkTheme, required BuildContext context}) =>
      ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: isDarkTheme ? bgDarkColor : whiteColor,
          fontFamily: 'POCOTech',
          canvasColor: Colors.transparent,
          appBarTheme: AppBarTheme(
              color: isDarkTheme ? bgDarkColor : whiteColor,
              surfaceTintColor: isDarkTheme ? bgDarkColor : whiteColor),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: isDarkTheme ? bgDarkColor : whiteColor,
            indicatorColor: isDarkTheme ? bgDarkAccentColor : blackColor,
            // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            iconTheme: MaterialStateProperty.resolveWith(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return const IconThemeData(color: whiteColor);
                }
                return IconThemeData(
                    color: isDarkTheme ? whiteColor : blackColor);
              },
            ),
            elevation: 0,
          ),
          // switchTheme: SwitchThemeData(
          //   trackColor: MaterialStateProperty.all(
          //       isDarkTheme ? bgDarkAccentColor : blackColor),
          // ),
          dialogBackgroundColor: isDarkTheme ? bgDarkColor : whiteColor,
          listTileTheme: ListTileThemeData(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: isDarkTheme ? bgDarkAccentColor : blackColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          primaryColorLight: isDarkTheme ? whiteColor : blackColor,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: isDarkTheme ? bgDarkColor : whiteColor),
          chipTheme: ChipThemeData(
              backgroundColor: isDarkTheme
                  ? whiteColor.withOpacity(0.05)
                  : blackColor.withOpacity(0.05),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              selectedColor: isDarkTheme ? whiteColor : blackColor,
              surfaceTintColor: isDarkTheme ? blackColor : whiteColor,
              showCheckmark: false),
          textTheme: TextTheme(
              displayLarge: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: isDarkTheme ? whiteColor : const Color(0xFF2E2E2E)),
              displayMedium: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDarkTheme ? whiteColor : const Color(0xFF2E2E2E)),
              bodyLarge:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              bodyMedium:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light());

  static getDarkThemeData() =>
      ThemeData(brightness: Brightness.dark, useMaterial3: true);
}

const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color bgDarkColor = Color(0xFF0A0A1E);
const Color bgDarkAccentColor = Color(0xFF2B2B52);
