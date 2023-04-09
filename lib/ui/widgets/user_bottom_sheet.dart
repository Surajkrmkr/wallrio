import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../views/settings_page.dart';
import 'primary_btn_widget.dart';
import 'shimmer_widget.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet({super.key});

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
                  provider.user.picture.isEmpty
                      ? const Icon(Icons.account_circle_rounded)
                      : CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(provider.user.picture),
                        ),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provider.user.fullName,
                            style: Theme.of(context).textTheme.displayMedium),
                        Text("pro user",
                            style: Theme.of(context).textTheme.titleSmall)
                      ])
                ]);
              },
            ),
          ),
          PrimaryBtnWidget(
            btnText: 'Settings',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
          PrimaryBtnWidget(btnText: 'Changelog', onTap: () {}),
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
        btnText: 'Log Out',
        onTap: () =>
            Provider.of<AuthProvider>(context, listen: false).signOut(context));
  }
}
