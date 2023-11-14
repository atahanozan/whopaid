import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:whopayed/helper/custom_colors.dart';
import 'package:whopayed/helper/utils.dart';

class GoogleAdsWidget extends StatefulWidget {
  const GoogleAdsWidget({super.key});

  @override
  State<GoogleAdsWidget> createState() => _GoogleAdsWidgetState();
}

class _GoogleAdsWidgetState extends State<GoogleAdsWidget> {
  late BannerAd bannerAd;
  bool isLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/6300978111";

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          Utils.snackBar(context, error.message);
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  void initState() {
    initBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: CustomColors.backGround(context),
            ),
            child: SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            ),
          )
        : const SizedBox();
  }
}
