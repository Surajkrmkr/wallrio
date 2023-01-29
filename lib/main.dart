import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/provider/wall_action.dart';
import 'package:wallrio/provider/wall_details.dart';
import 'package:wallrio/provider/navigation.dart';
import 'package:wallrio/provider/wall_rio.dart';
import 'package:wallrio/ui/theme/theme_data.dart';
import 'package:wallrio/ui/views/navigation_page.dart';

import 'provider/dark_theme.dart';
import 'provider/favourite.dart';
import 'services/dark_mode_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().getData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => DarkThemeProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => WallRio()),
        ),
        ChangeNotifierProvider(
          create: ((context) => Navigation()),
        ),
        ChangeNotifierProvider(
          create: ((context) => WallDetails()),
        ),
        ChangeNotifierProvider(
          create: ((context) => WallActionProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => FavouriteProvider()),
        )
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, provider, _) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  provider.darkTheme ? Brightness.light : Brightness.dark,
              statusBarBrightness:
                  provider.darkTheme ? Brightness.light : Brightness.dark));
          return MaterialApp(
              title: 'Wall Rio',
              theme: WallRioThemeData.getLightThemeData(
                  context: context, isDarkTheme: false),
              darkTheme: WallRioThemeData.getLightThemeData(
                  context: context, isDarkTheme: true),
              themeMode: provider.darkTheme ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: const NavigationPage());
        },
      ),
    );
  }
}
