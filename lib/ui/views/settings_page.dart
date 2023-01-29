import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dark_theme.dart';
import '../theme/theme_data.dart';
import '../widgets/clear_cache_widget.dart';
import '../widgets/sliver_app_bar_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBarWidget(
                showLogo: false,
                showSearchBtn: false,
                centeredTitle: true,
                showBackBtn: true,
                text: "Settings"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _appearanceSection(context),
                    _advancedSection(context),
                    _socialSection(context),
                    _ourTeamSection(context),
                    _appInfoSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _appearanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Appearance",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        _darkModeTile(),
        ListTile(
          title: const Text('Customise your App'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          subtitle: Text(
            "Choose Gradient",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        _buildGradientUI(context),
      ],
    );
  }

  Consumer<DarkThemeProvider> _darkModeTile() {
    return Consumer<DarkThemeProvider>(
      builder: (context, provider, _) {
        return SwitchListTile(
          value: provider.darkTheme,
          onChanged: (bool val) {
            provider.darkTheme = val;
          },
          title: const Text('Dark Mode'),
          subtitle: Text(
            "Welcome to the Dark Mode",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      },
    );
  }

  Consumer _buildGradientUI(BuildContext context) {
    return Consumer<DarkThemeProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
              children: gradientColorMap.entries
                  .map((e) => InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: provider.gradType == e.key
                            ? () {}
                            : () => provider.gradType = e.key,
                        child: Ink(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: e.value),
                              border: Border.all(
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  width: 3,
                                  color: provider.gradType == e.key
                                      ? Theme.of(context).primaryColorLight
                                      : Colors.transparent)),
                        ),
                      ))
                  .toList()),
        );
      },
    );
  }

  Column _advancedSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      Text(
        "Advanced",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      _getListTile(context,
          title: 'Clear Cache',
          subtitle: "Clear Out Cache",
          onTap: () => showDialog(
              context: context, builder: (context) => const ClearCacheWidget()))
    ]);
  }

  Column _socialSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      Text(
        "Social",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      _getListTile(context,
          title: 'Instagram', subtitle: "Follow us on Instagram", onTap: () {}),
      _getListTile(context,
          title: 'Twitter', subtitle: "Follow us on Twitter", onTap: () {}),
      _getListTile(context,
          title: 'Telegram', subtitle: "Join our community", onTap: () {}),
    ]);
  }

  Column _ourTeamSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      Text(
        "Our Team",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      _getListTile(context,
          title: 'Suraj Karmakar', subtitle: "Android Developer", onTap: () {}),
      _getListTile(context,
          title: 'Piyush KPV', subtitle: "UX/UI Designer", onTap: () {}),
      _getListTile(context,
          title: 'Sumit', subtitle: "Graphic Designer", onTap: () {}),
    ]);
  }

  Padding _appInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          "Version 1.0.0.0",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          "Made With Love ❤️ In India",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ]),
    );
  }

  Widget _getListTile(context,
      {required String title,
      required String subtitle,
      required Function() onTap}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      dense: true,
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: onTap,
    );
  }
}
