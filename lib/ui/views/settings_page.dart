import 'package:flutter/material.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/services/export.dart';
import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showAnimation(SubscriptionProvider provider) {
    provider.setIsSubcriptionAnimating = true;
    Future.delayed(const Duration(seconds: 5), () {
      provider.setIsSubcriptionAnimating = false;
    });
  }

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
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          _plusBanner(context),
                          _appearanceSection(context),
                          _advancedSection(context),
                          _socialSection(context),
                          _ourTeamSection(context),
                          _legalSection(context),
                          _appInfoSection(context),
                        ],
                      ),
                      Consumer<SubscriptionProvider>(
                          builder: (context, provider, _) {
                        return Center(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: provider.isSubcriptionAnimating ? 1 : 0,
                            child: IgnorePointer(
                              child: Lottie.network(
                                  'https://assets6.lottiefiles.com/packages/lf20_5ki7ru7q.json',
                                  width: MediaQuery.of(context).size.width),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _plusBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Consumer<SubscriptionProvider>(
        builder: (context, provider, _) {
          final bool hasSubscription = provider.subscriptionDaysLeft.isNotEmpty;
          return InkWell(
            onTap: () async {
              if (hasSubscription) {
                if (provider.isSubcriptionAnimating) return;
                _showAnimation(provider);
              } else {
                final val = await showDialog(
                    context: context,
                    builder: (context) => const PlusSubscription());
                if (val != null) {
                  if (val) _showAnimation(provider);
                }
              }
            },
            borderRadius: BorderRadius.circular(30),
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).navigationBarTheme.indicatorColor),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!hasSubscription)
                      Text(
                        "Upgrade to",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: whiteColor),
                      ),
                    Consumer<DarkThemeProvider>(
                        builder: (context, provider, _) {
                      return GradientText(
                        " WallRio ",
                        style: Theme.of(context).textTheme.bodyMedium,
                        colors: gradientColorMap[provider.gradType]!,
                      );
                    }),
                    Text(
                      "Plus",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: whiteColor),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Image.asset(
                        "assets/plus_icon.png",
                        height: 18,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  !hasSubscription
                      ? "Unleash creativity with our exclusive subscription for stunning wallpapers. Ad-free, high-quality downloads. Elevate your screen's style."
                      : "Now You’re a Plus Member\nEnjoy Plus Collection & Ad-free Experience",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: whiteColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                if (hasSubscription)
                  Text(
                    "${provider.subscriptionDaysLeft} Days Left",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: whiteColor),
                    textAlign: TextAlign.center,
                  )
              ]),
            ),
          );
        },
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
          title: 'Instagram',
          subtitle: "Follow us on Instagram",
          onTap: () => launch("https://instagram.com/studio.teamshadow")),
      _getListTile(context,
          title: 'Twitter',
          subtitle: "Follow us on Twitter",
          onTap: () => launch(("https://twitter.com/TeamShadowST"))),
      _getListTile(context,
          title: 'Telegram',
          subtitle: "Join our community",
          onTap: () => launch(("https://t.me/TeamShadow_Studio"))),
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
          title: 'Suraj Karmakar',
          subtitle: "Android Developer",
          onTap: () => launch(("http://t.me/surajkrmkr"))),
      _getListTile(context,
          title: 'Piyush KPV',
          subtitle: "UX/UI Designer",
          onTap: () => launch(("http://t.me/piyuskpv"))),
      _getListTile(context,
          title: 'Sumit',
          subtitle: "Graphic Designer",
          onTap: () => launch(("http://t.me/sumi7t"))),
    ]);
  }

  Padding _appInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Consumer<WallRio>(builder: (context, provider, _) {
          return provider.isLoading
              ? const ShimmerWidget(height: 12, width: 60)
              : Text(
                  "Version ${provider.currentVersion}",
                  style: Theme.of(context).textTheme.bodySmall,
                );
        }),
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

  Widget _legalSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "Legal",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        _getListTile(context,
            onTap: () => launch(
                "https://doc-hosting.flycricket.io/wallrio-privacy-policy/74e93607-af2a-42e8-b23c-ae459cee92b3/privacy"),
            title: "Privacy Policy",
            subtitle: "more info"),
      ],
    );
  }

  static void launch(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalNonBrowserApplication);
}
