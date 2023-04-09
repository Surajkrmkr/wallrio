import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../provider/auth.dart';
import '../theme/theme_data.dart' as theme;
import '../views/navigation_page.dart';
import '../widgets/primary_btn_widget.dart';
import '../widgets/shimmer_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;
  @override
  void initState() {
    _authStateSubscription =
        provider.Provider.of<AuthProvider>(context, listen: false)
            .supabase
            .auth
            .onAuthStateChange
            .listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NavigationPage()));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Image.asset("assets/login_bg.png")),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                  Colors.transparent
                ])),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Welcome to",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GradientText(
                "WallRio",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(fontSize: 35),
                colors: theme.gradientColorMap[theme.GradientType.defaultType]!,
              ),
              Text("Team Shadow",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(bottom: 60),
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: provider.Consumer<AuthProvider>(
                  builder: (context, provider, _) {
                    return provider.isLoading
                        ? ShimmerWidget.withWidget(
                            _buildSignInBtn(provider), context)
                        : _buildSignInBtn(provider);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PrimaryBtnWidget _buildSignInBtn(AuthProvider provider) {
    return PrimaryBtnWidget(
      btnText: "SIGN-IN",
      onTap: provider.signIn,
    );
  }
}
