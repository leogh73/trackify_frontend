import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdNative extends StatefulWidget {
  final String size;
  const AdNative(this.size, {super.key});

  @override
  State<AdNative> createState() => _AdNativeState();
}

class _AdNativeState extends State<AdNative> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  void _load() {
    setState(() {
      _isLoaded = false;
    });
    _nativeAd = NativeAd(
      adUnitId: "${dotenv.env['AD_NATIVE_UNIT_ID']}",
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          // print("NATIVE_AD_SHOWED");
          // print('$NativeAd loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // print("NATIVE_AD_FAILED_$error");
          // print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdClicked: (ad) {},
        onAdImpression: (ad) {},
        onAdClosed: (ad) {},
        onAdOpened: (ad) {},
        onAdWillDismissScreen: (ad) {},
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
      //     // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType:
            widget.size == "small" ? TemplateType.small : TemplateType.medium,
        // Optional: Customize the ad's style.
        // mainBackgroundColor: Colors.blueGrey,
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 3, left: 3),
            height: widget.size == "small" ? 90 : 180,
            child: AdWidget(ad: _nativeAd!),
          )
        : const SizedBox();
  }
}
