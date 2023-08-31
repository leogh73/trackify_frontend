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
    _loadAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    setState(() {
      _isLoaded = false;
    });
    _nativeAd = NativeAd(
      adUnitId: "${dotenv.env['AD_NATIVE_UNIT_ID']}",
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print("NATIVE_AD_SHOWED");
          // print('$NativeAd loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print("NATIVE_AD_FAILED_$error");
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

  // Future<void> loadAd() async {
  //   _nativeAd = NativeAd(
  //     adUnitId: "${dotenv.env['AD_NATIVE_UNIT_ID']}",
  //     listener: NativeAdListener(
  //       onAdLoaded: (ad) {
  //         debugPrint('$NativeAd loaded.');
  //         setState(() {
  //           _isLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         // Dispose the ad here to free resources.
  //         debugPrint('$NativeAd failed to load: $error');
  //         ad.dispose();
  //       },
  //     ),
  //     request: const AdRequest(),
  //     // Styling
  //     nativeTemplateStyle: NativeTemplateStyle(
  //         // Required: Choose a template.
  //         templateType: TemplateType.medium,
  //         // Optional: Customize the ad's style.
  //         mainBackgroundColor: Colors.blueGrey,
  //         cornerRadius: 10.0,
  //         callToActionTextStyle: NativeTemplateTextStyle(
  //             textColor: Colors.cyan,
  //             backgroundColor: Colors.red,
  //             style: NativeTemplateFontStyle.monospace,
  //             size: 16.0),
  //         primaryTextStyle: NativeTemplateTextStyle(
  //             textColor: Colors.red,
  //             backgroundColor: Colors.cyan,
  //             style: NativeTemplateFontStyle.italic,
  //             size: 16.0),
  //         secondaryTextStyle: NativeTemplateTextStyle(
  //             textColor: Colors.green,
  //             backgroundColor: Colors.black,
  //             style: NativeTemplateFontStyle.bold,
  //             size: 16.0),
  //         tertiaryTextStyle: NativeTemplateTextStyle(
  //             textColor: Colors.brown,
  //             backgroundColor: Colors.amber,
  //             style: NativeTemplateFontStyle.normal,
  //             size: 16.0)),
  //   );
  //   _nativeAd?.load();
  // }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Container(
            child: AdWidget(ad: _nativeAd!),
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 3, left: 3),
            height: widget.size == "small" ? 90 : 180,
          )
        : const SizedBox();
  }
}
