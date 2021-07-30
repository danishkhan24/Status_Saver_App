import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class FacebookAd {
  bool _isInterstitialAdLoaded = false;

  FacebookAd() {
    FacebookAudienceNetwork.init(
        testingId: "0f9315ba-1dbc-4fc7-aa91-0a847c29f945");
  }

  loadInterstitialAd() {
    print("inside load Interstitial Ad");

    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          loadInterstitialAd();
        }
      },
    );
  }

  showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstitial Ad not loaded yet!");
  }

  Widget bannerAd = FacebookBannerAd(
    placementId: "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID",
    bannerSize: BannerSize.STANDARD,
    keepAlive: true,
    listener: (result, value) {
      switch (result) {
        case BannerAdResult.ERROR:
          print("Error: $value");
          break;
        case BannerAdResult.LOADED:
          print("Loaded: $value");
          break;
        case BannerAdResult.CLICKED:
          print("Clicked: $value");
          break;
        case BannerAdResult.LOGGING_IMPRESSION:
          print("Logging Impression: $value");
          break;
      }
    },
  );

  final nativeAd = FacebookNativeAd(
    placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
    adType: NativeAdType.NATIVE_BANNER_AD,
    bannerAdSize: NativeBannerAdSize.HEIGHT_100,
    width: double.infinity,
    backgroundColor: Colors.blue,
    titleColor: Colors.white,
    descriptionColor: Colors.white,
    buttonColor: Colors.deepPurple,
    buttonTitleColor: Colors.white,
    buttonBorderColor: Colors.white,
    listener: (result, value) {
      print("Native Banner Ad: $result --> $value");
    },
  );
}
