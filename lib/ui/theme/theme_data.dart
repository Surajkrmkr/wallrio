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
          switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(
                  isDarkTheme ? whiteColor : blackColor),
              trackColor: MaterialStateProperty.all(
                  isDarkTheme ? bgDarkAccentColor : whiteColor)),
          dialogTheme: DialogTheme(
              backgroundColor: isDarkTheme ? bgDarkColor : whiteColor,
              surfaceTintColor: Colors.transparent),
          listTileTheme: ListTileThemeData(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: isDarkTheme ? bgDarkAccentColor : blackColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          primaryColor: isDarkTheme ? bgDarkColor : whiteColor,
          primaryColorLight: isDarkTheme ? whiteColor : blackColor,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: isDarkTheme ? bgDarkColor : whiteColor,
              surfaceTintColor: Colors.transparent),
          filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      isDarkTheme ? bgDarkAccentColor : blackColor),
                  foregroundColor: MaterialStateProperty.all(whiteColor))),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                      isDarkTheme ? whiteColor : blackColor),
                  overlayColor: MaterialStateProperty.all(isDarkTheme
                      ? blackColor.withOpacity(0.1)
                      : whiteColor.withOpacity(0.4)))),
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
          colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light());

  static getDarkThemeData() =>
      ThemeData(brightness: Brightness.dark, useMaterial3: true);
}

const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color bgDarkColor = Color(0xFF0A0A1E);
const Color bgDarkAccentColor = Color(0xFF2B2B52);

const Map<GradientType, List<Color>> gradientColorMap = {
  GradientType.defaultType: [Color(0xFFFF4949), Color(0xFF5344FF)],
  GradientType.mild: [Color(0xFF67B26F), Color(0xFF4ca2cd)],
  GradientType.sunset: [Color(0xFFee0979), Color(0xFFff6a00)],
  GradientType.radar: [Color(0xFFA770EF), Color(0xFFCF8BF3), Color(0xFFFDB99B)],
  GradientType.viceCity: [Color(0xFF3494E6), Color(0xFFEC6EAD)],
  GradientType.bradyFun: [Color(0xFF00c3ff), Color(0xFFffff1c)],
  GradientType.bloodRed: [Color(0xFFf85032), Color(0xFFe73827)],
  GradientType.sherbert: [Color(0xFFf79d00), Color(0xFF64f38c)],
  GradientType.grapeFruit: [Color(0xFFe96443), Color(0xFF64f38c)],
  GradientType.sweetMorning: [Color(0xFFff5f6d), Color(0xFFffc371)],
};

enum GradientType {
  defaultType,
  viceCity,
  mild,
  sunset,
  radar,
  bradyFun,
  bloodRed,
  sherbert,
  grapeFruit,
  sweetMorning
}

extension ColorExtensions on String {
  Color toColor() {
    if (contains("black")) {
      return Colors.black;
    } else if (contains("red")) {
      return Colors.redAccent;
    } else if (contains("orange")) {
      return Colors.orangeAccent;
    } else if (contains("blue")) {
      return Colors.blueAccent;
    } else if (contains("cyan")) {
      return Colors.cyanAccent;
    } else if (contains("indigo")) {
      return Colors.indigoAccent;
    } else if (contains("green")) {
      return Colors.greenAccent;
    } else if (contains("pink")) {
      return Colors.pinkAccent;
    } else if (contains("purple")) {
      return Colors.deepPurpleAccent;
    } else if (contains("teal")) {
      return Colors.tealAccent;
    } else if (contains("brown")) {
      return Colors.brown;
    } else if (contains("yellow")) {
      return Colors.deepOrangeAccent;
    }
    return Colors.black;
  }
}