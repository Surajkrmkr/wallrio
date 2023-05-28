import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wallrio/ui/widgets/toast_widget.dart';

import '../../log.dart';
import '../../provider/auth.dart';
import '../views/navigation_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // bool _redirectCalled = false;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  // Future<void> _redirect() async {
  //   await Future.delayed(Duration.zero);
  //   if (_redirectCalled || !mounted) {
  //     return;
  //   }

  //   _redirectCalled = true;
  //   final session = Provider.of<AuthProvider>(context, listen: false)
  //       .supabase
  //       .auth
  //       .currentSession;
  //   FlutterNativeSplash.remove();
  //   if (session != null) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => const NavigationPage()));
  //   } else {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => const LoginPage()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return const NavigationPage();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const LoginPage();
          }
        });
  }
}
