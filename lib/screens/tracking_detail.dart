import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackify/data/trackings_active.dart';
import 'package:trackify/data/trackings_archived.dart';
import 'package:trackify/widgets/tracking_buttons.dart';
import 'package:trackify/widgets/tracking_claim.dart';

import '../data/classes.dart';
import '../data/preferences.dart';
import '../data/status.dart';
import '../data/tracking_functions.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/ad_banner.dart';
import '../widgets/dialog_toast.dart';
import '../widgets/tracking_events_list.dart';
import '../widgets/tracking_options.dart';
import '../widgets/tracking_other_data.dart';
import '../widgets/tracking_summary.dart';
import '../widgets/tracking_url.dart';

class TrackingDetail extends StatefulWidget {
  final ItemTracking? tracking;
  const TrackingDetail(this.tracking, {Key? key}) : super(key: key);

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail> {
  late ScrollController _controller;
  AdInterstitial interstitialAd = AdInterstitial();

  _scrollListener() {
    if (_controller.offset == _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      Provider.of<Status>(context, listen: false).toggleEventsEndStatus(true);
    } else {
      Provider.of<Status>(context, listen: false).toggleEventsEndStatus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget trackingStats(
    bool premiumUser,
    bool isPortrait,
    double screenWidth,
    Map<int, dynamic> texts,
  ) {
    final ItemTracking trk = widget.tracking!;
    final String startDate = trk.startCheck!.split(" - ")[0];
    final String startTime = trk.startCheck!.split(" - ")[1];
    final String formattedStart =
        TrackingFunctions.formatEventDate(context, startDate);
    final String formattedStartDate = "$formattedStart - $startTime";
    final String checkDate = trk.lastCheck!.split(" - ")[0];
    final String checkTime = trk.lastCheck!.split(" - ")[1];
    final String formattedCheck =
        TrackingFunctions.formatEventDate(context, checkDate);
    final String formattedCheckDate = "$formattedCheck - $checkTime";
    final List<List<dynamic>> dataList = [
      [
        MdiIcons.truckFast,
        Icons.numbers,
        MdiIcons.calendar,
        MdiIcons.checkNetworkOutline,
        MdiIcons.calendarClock,
        MdiIcons.calendarMultipleCheck,
        MdiIcons.informationBoxOutline
      ],
      [
        texts[259]!,
        texts[14]!,
        texts[260]!,
        texts[176]!,
        texts[250],
        texts[261]!,
        texts[87]!
      ],
      [
        trk.service,
        trk.code,
        formattedStartDate,
        formattedCheckDate,
        TrackingFunctions.daysInTransit(context, trk.events[0]["date"]!,
            trk.events[trk.events.length - 1]["date"]!),
        trk.events.length.toString(),
        texts[262][trk.status],
      ],
    ];
    const Widget smallAd = Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: AdNative("small"),
    );
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          if (!premiumUser) smallAd,
          SizedBox(
            width: isPortrait ? screenWidth : screenWidth * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: dataList[0]
                      .map((d) => SizedBox(
                          height: 45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(d, size: 24)],
                          )))
                      .toList(),
                ),
                Column(
                  children: dataList[1]
                      .map((d) => SizedBox(
                          height: 45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                d,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            ],
                          )))
                      .toList(),
                ),
                SizedBox(
                  width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.25,
                  child: Column(
                    children: dataList[2]
                        .map((d) => SizedBox(
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  d,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis),
                                )
                              ],
                            )))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          if (!premiumUser) smallAd,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final bool checking =
        context.select((Status status) => status.checkingStatus);
    final bool endList = context.select((Status status) => status.endOfEvents);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final ItemTracking? tracking = widget.tracking!.archived == true
        ? context.select((ArchivedTrackings archivedTrackings) =>
            archivedTrackings.trackings.firstWhere(
                (t) => t.idMDB == widget.tracking!.idMDB,
                orElse: () => ItemTracking(
                    code: "", service: "", events: [], moreData: [])))
        : context.select((ActiveTrackings activeTrackings) => activeTrackings
            .trackings
            .firstWhere((t) => t.idMDB == widget.tracking!.idMDB,
                orElse: () =>
                    ItemTracking(code: "", service: "", events: [], moreData: [])));
    final String serviceName = tracking!.service;
    final Widget divider = Divider(
      color: Theme.of(context).primaryColor,
      thickness: 1.5,
      height: 1.5,
    );
    return PopScope(
      canPop: !checking,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 1.0,
          title: Text(
            tracking.code.isEmpty ? texts[124]! : tracking.title,
            maxLines: 2,
            style: TextStyle(fontSize: fullHD ? 18 : 17),
          ),
          actions: [
            if (tracking.code.isNotEmpty)
              TrackingOptions(
                tracking: tracking,
                option: "iconButtons",
                action: 'rename',
                detail: true,
              ),
          ],
        ),
        body: tracking.code.isEmpty && tracking.events.isEmpty
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!premiumUser)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 60),
                          child: AdNative("small"),
                        ),
                      Center(
                        child: Text(
                          texts[124]!,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      if (!premiumUser)
                        const Padding(
                          padding: EdgeInsets.only(top: 60, bottom: 10),
                          child: AdNative("small"),
                        )
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: [
                    if (checking)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 25, bottom: 20, right: 6),
                            child: const SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Text(
                            texts[69]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: fullHD ? 16 : 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Divider(
                              height: 1,
                              color: Theme.of(context).primaryColor,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    TrackingSummary(tracking),
                    divider,
                    TrackingEventsList(tracking.events, serviceName),
                    divider,
                    TrackingOtherData(tracking.moreData!),
                    divider,
                    TrackingUrl(serviceName, tracking.code, tracking.url),
                    divider,
                    TrackingClaim(serviceName),
                    divider,
                    TrackingDetaiilButtons(tracking)
                  ],
                ),
              ),
        floatingActionButton: checking || endList
            ? null
            : FloatingActionButton(
                heroTag: 'events',
                onPressed: () {
                  if (!premiumUser) {
                    interstitialAd.showInterstitialAd();
                    ShowDialog.goPremiumDialog(context);
                  }
                  TrackingFunctions.searchUpdates(context, tracking);
                },
                child: const Icon(Icons.update, size: 29),
              ),
        bottomNavigationBar: premiumUser ? null : const AdBanner(),
      ),
    );
  }
}
