import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/navigation.dart';
import 'package:wallrio/provider/wall_rio.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/views/home_page.dart';
import 'package:wallrio/ui/views/navigation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarIconBrightness: darkThemeProvider.amoledTheme
        //     ? Brightness.light
        //     : darkThemeProvider.darkTheme
        //         ? Brightness.light
        //         : Brightness.dark,
        // statusBarBrightness: darkThemeProvider.amoledTheme
        //     ? Brightness.light
        //     : darkThemeProvider.darkTheme
        //         ? Brightness.light
        //         : Brightness.dark));
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => WallRio()),
        ),
        ChangeNotifierProvider(
          create: ((context) => Navigation()),
        ),
      ],
      child: MaterialApp(
          title: 'Wall Rio',
          theme: WallRioThemeData.getLightThemeData(),
          darkTheme: WallRioThemeData.getDarkThemeData(),
          themeMode: ThemeMode.light,
          home: const NavigationPage()),
    );
  }
}
