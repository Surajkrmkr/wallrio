import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallrio/log.dart';

class AdsProvider extends ChangeNotifier {
  final String bannerId = "ca-app-pub-4861691653340010/8536832813";
  final String rewardedId = "ca-app-pub-4861691653340010/4965253463";

  BannerAd? bannerAd;
  RewardedAd? rewardedAd;

  bool isBannerLoaded = false;
  bool isRewardedAdLoading = false;

  set setIsBannerLoaded(val) {
    isBannerLoaded = val;
    notifyListeners();
  }

  set setIsRewardedAdLoading(val) {
    isRewardedAdLoading = val;
    notifyListeners();
  }

  void loadBannerAd({required AdSize size}) {
    bannerAd = BannerAd(
      adUnitId: bannerId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setIsBannerLoaded = true;
        },
        onAdFailedToLoad: (ad, err) {
          logger.e('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadRewardedAd(BuildContext context, {required Function() onRewarded}) {
    setIsRewardedAdLoading = true;
    RewardedAd.load(
        adUnitId: rewardedId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                Navigator.pop(context);
                onRewarded();
              },
            );
            ad.show(onUserEarnedReward: (ad, reward) {
              logger.i(reward.amount);
              setIsRewardedAdLoading = false;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            logger.e('RewardedAd failed to load: $error');
            setIsRewardedAdLoading = false;
          },
        ));
  }

  @override
  void dispose() {
    bannerAd!.dispose();
    super.dispose();
  }
}