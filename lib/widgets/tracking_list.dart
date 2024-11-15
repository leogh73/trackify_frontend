import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/tracking_item.dart';
import '../widgets/ad_native.dart';

import '../data/../data/preferences.dart';
import '../data/classes.dart';
import '../data/status.dart';

import 'ad_interstitial.dart';

class TrackingList extends StatefulWidget {
  final List<ItemTracking> trackingsData;
  const TrackingList(this.trackingsData, {Key? key}) : super(key: key);

  @override
  State<TrackingList> createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  late ScrollController _controller;
  AdInterstitial interstitialAd = AdInterstitial();

  scrollListener() {
    if (_controller.offset == _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      Provider.of<Status>(context, listen: false).toggleListEndStatus(true);
    } else {
      Provider.of<Status>(context, listen: false).toggleListEndStatus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(scrollListener);
    interstitialAd.createInterstitialAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final String chosenView = Provider.of<UserPreferences>(context).startList;
    final PageStorageKey<String> listKey = PageStorageKey<String>(chosenView);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool portraitfullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final bool landscapeFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1919;
    return widget.trackingsData.length == 0
        ? Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    child: premiumUser ? null : AdNative("small"),
                    padding: EdgeInsets.only(top: 10, bottom: 60),
                  ),
                  Icon(Icons.local_shipping_outlined, size: 80),
                  SizedBox(width: 30, height: 30),
                  Text(
                    'No hay seguimientos',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 10, height: 160),
                ],
              ),
            ),
          )
        : chosenView == "grid"
            ? GridView.count(
                key: listKey,
                childAspectRatio: isPortrait
                    ? portraitfullHD
                        ? 2 / 4.449
                        : 2 / 4.622
                    : landscapeFullHD
                        ? 2 / 4.025
                        : 2 / 4.288,
                padding: const EdgeInsets.all(4),
                crossAxisCount: isPortrait ? 2 : 3,
                children: List.generate(
                  widget.trackingsData.length,
                  (index) => TrackingItem(widget.trackingsData[index]),
                ),
              )
            : ListView.builder(
                key: listKey,
                padding: const EdgeInsets.only(top: 8, right: 2, left: 2),
                controller: _controller,
                itemCount: widget.trackingsData.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    if (index == 0 && !premiumUser)
                      if (!premiumUser)
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: AdNative("small"),
                        ),
                    TrackingItem(widget.trackingsData[index])
                  ],
                ),
              );
  }
}
