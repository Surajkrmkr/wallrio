import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../../provider/subscription.dart';
import '../../provider/wall_rio.dart';
import '../views/settings_page.dart';
import 'change_log.dart';
import 'primary_btn_widget.dart';
import 'shimmer_widget.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet({super.key});

  static void changeLog(context) =>
      showDialog(context: context, builder: (context) => const ChangeLog());

  void _settings(context) {
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 40),
      child: Wrap(
        runSpacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Consumer<AuthProvider>(
              builder: (context, provider, _) {
                return Row(children: [
                  provider.user.photoURL!.isEmpty
                      ? const Icon(Icons.account_circle_rounded)
                      : CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(provider.user.photoURL!),
                          backgroundColor: Theme.of(context).primaryColorDark,
                        ),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provider.user.displayName!,
                            style: Theme.of(context).textTheme.displayMedium),
                        Text("WallRio member",
                            style: Theme.of(context).textTheme.titleSmall)
                      ])
                ]);
              },
            ),
          ),
          PrimaryBtnWidget(
            btnText: 'SETTINGS',
            onTap: () => _settings(context),
          ),
          Consumer<WallRio>(
            builder: (context, provider, _) {
              return PrimaryBtnWidget(
                  btnText: provider.isUpdateAvailable ? 'UPDATE' : 'CHANGELOG',
                  onTap: () => changeLog(context));
            },
          ),
          Consumer<AuthProvider>(builder: (context, provider, _) {
            return provider.isLoading
                ? ShimmerWidget.withWidget(_buildSignOutBtn(context), context)
                : _buildSignOutBtn(context);
          }),
        ],
      ),
    );
  }

  PrimaryBtnWidget _buildSignOutBtn(BuildContext context) {
    return PrimaryBtnWidget(
        btnText: 'LOG OUT',
        onTap: () {
          Navigator.pop(context);
          Provider.of<SubscriptionProvider>(context, listen: false).clearData();
          Provider.of<AuthProvider>(context, listen: false).signOut();
        });
  }
}
