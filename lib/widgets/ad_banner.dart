import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd banner;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // banner = BannerAd(
    //   adUnitId: "${dotenv.env['AD_BANNER_UNIT_ID']}",
    //   size: AdSize.fullBanner,
    //   request: const AdRequest(),
    //   listener: BannerAdListener(onAdLoaded: (ad) {
    //     setState(() {
    //       isAdLoaded = true;
    //     });
    //     print('Ad loaded:${ad.adUnitId}');
    //   }, onAdFailedToLoad: (ad, error) {
    //     ad.dispose();
    //     print('failedToLoad');
    //   }),
    // );
    // banner.load();
  }

  @override
  Widget build(BuildContext context) {
    return isAdLoaded
        ? Container(
            height: 60,
            child: AdWidget(ad: banner),
            color: Colors.blueGrey,
          )
        : const SizedBox();
  }
}
