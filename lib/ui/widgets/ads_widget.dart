import 'package:flutter/material.dart';
import 'package:wallrio/provider/export.dart';
import 'package:wallrio/services/packages/export.dart';
import 'package:wallrio/ui/views/export.dart';
import 'package:wallrio/ui/widgets/export.dart';

class AdsWidget extends StatefulWidget {
  final double bottomPadding;
  final AdSize size;
  const AdsWidget(
      {super.key, this.bottomPadding = 10, this.size = AdSize.banner});

  @override
  State<AdsWidget> createState() => _AdsWidgetState();

  static Widget getPlusDialog(BuildContext context,
      {required Function() onWatchAdClick}) {
    return AlertDialog(
      title: const Row(
        children: [
          Expanded(
              child: Text(
            "Unlock Wallpaper",
          )),
          CloseButton()
        ],
      ),
      content: Text(
        "Get access to the wallpapers by either watching an ad or purchasing the Plus Subscription, which offers unlimited downloads and access to the exclusive plus collection",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        Consumer<AdsProvider>(builder: (context, provider, _) {
          return provider.isRewardedAdLoading
              ? ShimmerWidget.withWidget(
                  FilledButton(
                      onPressed: onWatchAdClick, child: const Text("Watch AD")),
                  context)
              : FilledButton(
                  onPressed: onWatchAdClick, child: const Text("Watch AD"));
        }),
        OutlinedButton.icon(
            icon: const Icon(Icons.verified),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ));
            },
            label: const Text("Go Plus"))
      ],
    );
  }
}

class _AdsWidgetState extends State<AdsWidget> {
  @override
  void initState() {
    Provider.of<AdsProvider>(context, listen: false)
        .loadBannerAd(size: widget.size);
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<AdsProvider>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, provider, _) {
        return provider.isBannerLoaded
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: widget.bottomPadding),
                  width: provider.bannerAd!.size.width.toDouble(),
                  height: provider.bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: provider.bannerAd!),
                ),
              )
            : Container();
      },
    );
  }
}
