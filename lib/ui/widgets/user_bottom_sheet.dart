import 'package:flutter/material.dart';

import '../views/settings_page.dart';
import 'primary_btn_widget.dart';

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
            child: Row(children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    "https://gitlab.com/piyushkpv/wallrio_wall_data/-/raw/main/Assests/Ellipse%2013.png"),
              ),
              const SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Suraj Karmakar",
                    style: Theme.of(context).textTheme.displayMedium),
                Text("pro user", style: Theme.of(context).textTheme.titleSmall)
              ])
            ]),
          ),
          PrimaryBtnWidget(
            btnText: 'Settings',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage())),
          ),
          PrimaryBtnWidget(btnText: 'Changelog', onTap: () {}),
          PrimaryBtnWidget(btnText: 'Log Out', onTap: () {}),
        ],
      ),
    );
  }
}
