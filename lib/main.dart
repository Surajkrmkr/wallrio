import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallrio/providers.dart';

import 'constants.dart';
import 'provider/dark_theme.dart';
import 'services/dark_mode_services.dart';
import 'ui/oauth/splash_page.dart';
import 'ui/theme/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().getData();
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseAnnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(context),
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
              home: const SplashPage());
        },
      ),
    );
  }
}
