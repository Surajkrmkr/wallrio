import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/firebase_options.dart';
import 'package:wallrio/providers.dart';
import 'provider/dark_theme.dart';
import 'services/dark_mode_services.dart';
import 'services/notification.dart';
import 'ui/oauth/splash_page.dart';
import 'ui/theme/theme_data.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await ThemeService().getData();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  await NotificationService().init();
  await MobileAds.instance.initialize();

  if (kReleaseMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

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
              title: 'WallRio',
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
