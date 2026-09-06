import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallrio/model/export.dart';
import 'package:wallrio/services/consent_manager.dart';
import 'package:wallrio/ui/widgets/simple_banner_ad_widget.dart';

class InlineBannerAdWidget extends StatefulWidget {
  final double verticalPadding;
  final String screenName;
  final String placementName;
  final String adUnitId;

  const InlineBannerAdWidget({
    super.key,
    this.verticalPadding = 18.0,
    this.screenName = 'Feed',
    this.placementName = 'InlineBanner',
    this.adUnitId = BannerAdUnits.homepageGridBanner,
  });

  @override
  State<InlineBannerAdWidget> createState() => _InlineBannerAdWidgetState();
}

class _InlineBannerAdWidgetState extends State<InlineBannerAdWidget>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  bool get wantKeepAlive => _isAdLoaded;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    if (UserProfile.plusMember || !ConsentManager.instance.canRequestAds) {
      return;
    }

    final unitId = BannerAdUnits.resolveAdUnitId(widget.adUnitId);

    _bannerAd = BannerAd(
      adUnitId: unitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
            });
          }
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (UserProfile.plusMember || !_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final adWidth = _bannerAd!.size.width.toDouble();
    final adHeight = _bannerAd!.size.height.toDouble().clamp(48.0, 60.0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xDD1E1E28)
                : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            width: adWidth,
            height: adHeight,
            child: AdWidget(
              key: ValueKey(_bannerAd.hashCode),
              ad: _bannerAd!,
            ),
          ),
        ),
      ),
    );
  }
}

