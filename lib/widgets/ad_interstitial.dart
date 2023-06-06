import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdInterstitial {
  bool isLoaded = false;
  InterstitialAd? _interstitialAd;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "${dotenv.env['AD_INTERSTITIAL_UNIT_ID']}",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            // debugPrint('$ad loaded.');
            _interstitialAd = ad;
            isLoaded = true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  void showInterstitialAd() {
    if (!isLoaded || _interstitialAd == null) return;
    // print("SHOW INTERSTITIAL AD!");
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        // print('$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        // print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
