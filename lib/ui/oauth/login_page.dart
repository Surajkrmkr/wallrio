import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../provider/auth.dart';
import '../theme/theme_data.dart' as theme;
import '../widgets/primary_btn_widget.dart';
import '../widgets/shimmer_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => exit(0),
        child: Stack(
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
                  colors:
                      theme.gradientColorMap[theme.GradientType.defaultType]!,
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
      ),
    );
  }

  PrimaryBtnWidget _buildSignInBtn(AuthProvider provider) {
    return PrimaryBtnWidget(
      btnText: "SIGN IN",
      onTap: provider.signIn,
      icon: Image.asset("assets/google_logo.png"),
    );
  }
}
