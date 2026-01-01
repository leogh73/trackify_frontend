import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../data/../data/preferences.dart';
import '../data/classes.dart';
import '../data/status.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/tracking_item.dart';
import '../widgets/tracking_sort.dart';

class TrackingList extends StatefulWidget {
  final List<ItemTracking> trackings;
  const TrackingList(this.trackings, {Key? key}) : super(key: key);

  @override
  State<TrackingList> createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  late ScrollController _scrollController;
  AdInterstitial interstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          (_scrollController.position.maxScrollExtent - 50.0)) {
        Provider.of<Status>(context, listen: false).toggleListEndStatus(true);
      } else {
        Provider.of<Status>(context, listen: false).toggleListEndStatus(false);
      }
    });
    interstitialAd.createInterstitialAd();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final String chosenView = context
        .select((UserPreferences userPreferences) => userPreferences.startList);
    final PageStorageKey<String> listKey = PageStorageKey<String>(chosenView);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool portraitfullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final bool landscapeFullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1919;
    return widget.trackings.isEmpty
        ? Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 60),
                    child: premiumUser ? null : const AdNative("small"),
                  ),
                  Icon(MdiIcons.packageVariantClosed, size: 80),
                  const SizedBox(width: 30, height: 30),
                  Text(
                    texts[203]!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10, height: 160),
                ],
              ),
            ),
          )
        : Column(
            children: [
              TrackingSort(widget.trackings[0].archived == false),
              Expanded(
                child: chosenView == "grid"
                    ? GridView.count(
                        key: listKey,
                        controller: _scrollController,
                        childAspectRatio: premiumUser
                            ? isPortrait
                                ? portraitfullHD
                                    ? 2 / 2.990
                                    : 2 / 3.312
                                : landscapeFullHD
                                    ? 2 / 2.010
                                    : 2 / 2.803
                            : isPortrait
                                ? portraitfullHD
                                    ? 2 / 4.602
                                    : 2 / 4.522
                                : landscapeFullHD
                                    ? 2 / 3.115
                                    : 2 / 4.548,
                        padding: const EdgeInsets.all(4),
                        crossAxisCount: isPortrait ? 2 : 3,
                        children: List.generate(
                          widget.trackings.length,
                          (index) => TrackingItem(
                            widget.trackings[index],
                            key: Key(widget.trackings[index].idSB.toString()),
                          ),
                        ),
                      )
                    : ListView.builder(
                        key: listKey,
                        padding:
                            const EdgeInsets.only(top: 8, right: 2, left: 2),
                        controller: _scrollController,
                        itemCount: widget.trackings.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            if (index == 0 && !premiumUser)
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: AdNative("small"),
                              ),
                            TrackingItem(
                              widget.trackings[index],
                              key: Key(widget.trackings[index].idSB.toString()),
                            )
                          ],
                        ),
                      ),
              ),
            ],
          );
  }
}
