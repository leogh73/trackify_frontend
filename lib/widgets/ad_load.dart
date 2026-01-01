import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AppLifecycleReactor {
//   final AdOpen adOpenInstance;
//   AppLifecycleReactor({required this.adOpenInstance});

//   void listenToAppStateChanges() {
//     AppStateEventNotifier.startListening();
//     AppStateEventNotifier.appStateStream
//         .forEach((state) => _onAppStateChanged(state));
//   }

//   void _onAppStateChanged(AppState appState) {
//     if (appState == AppState.foreground) {
//       adOpenInstance.showAdIfAvailable();
//     }
//   }
// }

class AdOpen {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  Duration maxCacheDuration = const Duration(hours: 4);
  DateTime? _appOpenLoadTime;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: "${dotenv.env['AD_LOAD_UNIT_ID']}",
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          // print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showIfAvailable() {
    if (!isAdAvailable) {
      // print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      // print('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      // print('Maximum cache duration exceeded. Reloading...');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        // print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        // print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
