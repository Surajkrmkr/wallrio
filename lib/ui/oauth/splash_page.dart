import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../../log.dart';
import '../../provider/subscription.dart';
import '../views/navigation_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // InAppUpdate.checkForUpdate().then((updateInfo) async {
    //   if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
    //     await InAppUpdate.performImmediateUpdate();
    //   }
    // }, onError: (error) {
    //   logger.e(error);
    // });
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.authStateChanges().listen((event) {
      if (mounted && event != null) {
        Provider.of<SubscriptionProvider>(context, listen: false)
            .checkPastPurchases(email: event.email!);
      }
    });
    Future.delayed(Duration.zero,
        () => _checkSubscription(firebaseAuth.currentUser!.email!));
    super.initState();
  }

  void _checkSubscription(String email) async {
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    _checkPastPurchases(subscriptionProvider, email);
    subscriptionProvider.checkSupportForIAP();
    subscriptionProvider.successPurchasedStream.listen((event) {
      if (mounted && event) {
        Navigator.pop(context, true);
      }
    });
    FlutterNativeSplash.remove();
  }

  Future<void> _checkPastPurchases(
          SubscriptionProvider subscriptionProvider, String email) async =>
      await subscriptionProvider.checkPastPurchases(email: email);

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
            return Consumer<SubscriptionProvider>(
                builder: (context, provider, _) {
              return provider.isSubscriptionLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const NavigationPage();
            });
          } else if (snapshot.hasError) {
            logger.e(snapshot.error);
            return const LoginPage();
          } else {
            return const LoginPage();
          }
        });
  }
}
