import 'package:flutter/material.dart';
import 'package:wallrio/model/export.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/services/firebase/export.dart';
import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/oauth/export.dart';
import 'package:wallrio/ui/views/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _checkInAppUpdate();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.authStateChanges().listen((event) {
      if (mounted && event != null) {
        Provider.of<SubscriptionProvider>(context, listen: false)
            .checkPastPurchases(email: event.email!);
      }
    });

    Future.delayed(Duration.zero, () {
      Provider.of<SubscriptionProvider>(context, listen: false)
          .checkSupportForIAP();
      firebaseAuth.currentUser != null
          ? _checkSubscription(firebaseAuth.currentUser!.email!)
          : {};
    });
    FlutterNativeSplash.remove();
    super.initState();
  }

  void _checkSubscription(String email) async {
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    subscriptionProvider.checkPastPurchases(email: email);
    subscriptionProvider.successPurchasedStream.listen((event) {
      if (mounted && event) {
        Navigator.pop(context, true);
      }
    });
  }

  void _checkInAppUpdate() {
    InAppUpdate.checkForUpdate().then((updateInfo) async {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    }, onError: (error) {
      logger.e(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final Size size = MediaQuery.of(context).size;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _getShimmer(size);
          } else if (snapshot.hasData) {
            UserProfile.setUserData(snapshot.data!);
            return Consumer<SubscriptionProvider>(
                builder: (context, provider, _) {
              return provider.isSubscriptionLoading
                  ? _getShimmer(size)
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

  Widget _getShimmer(Size size) => Scaffold(
        body: ShimmerWidget(
          height: size.height,
          width: size.width,
          radius: 0,
        ),
      );
}
