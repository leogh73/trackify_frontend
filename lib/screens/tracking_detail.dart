import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/classes.dart';
import '../providers/preferences.dart';
import '../providers/status.dart';
import '../providers/tracking_functions.dart';

import '../screens/tracking_more.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/ad_banner.dart';
import '../widgets/options_tracking.dart';
import '../widgets/events_list.dart';

class TrackingDetail extends StatefulWidget {
  final ItemTracking tracking;
  const TrackingDetail(this.tracking, {Key? key}) : super(key: key);

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

AdInterstitial interstitialAd = AdInterstitial();

class _TrackingDetailState extends State<TrackingDetail> {
  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    bool checking = Provider.of<Status>(context).checkingStatus;
    bool endList = Provider.of<Status>(context).endOfEvents;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    String screenList = widget.tracking.archived! ? "archived" : "main";
    List<Map<String, String>> events = widget.tracking.events;

    return WillPopScope(
      onWillPop: () => Future.value(!checking),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 1.0,
          title: Text(
            widget.tracking.title!,
            maxLines: 2,
            style: TextStyle(fontSize: fullHD ? 18 : 17),
          ),
          actions: [
            OptionsTracking(
              tracking: widget.tracking,
              menu: true,
              action: '',
              detail: true,
            ),
            if (screenList == "search")
              PopupMenuButton<String>(
                // padding: EdgeInsets.zero,
                tooltip: 'Opciones',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                elevation: 2,
                // icon: Icon(Icons.more_vert),
                onSelected: (String value) {
                  switch (value) {
                    case 'Más datos':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrackingMore(
                            widget.tracking.moreData,
                          ),
                        ),
                      );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Más datos",
                    height: 35,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 15),
                          child: Icon(
                            Icons.info,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.zero,
                          child: Text("Más datos"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        body: Column(
          children: [
            if (checking)
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 25, bottom: 20, right: 6),
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Text(
                    'Verificando...',
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
            Expanded(
              child: EventsList(events, widget.tracking.service),
            ),
          ],
        ),
        floatingActionButton: checking || endList
            ? null
            : FloatingActionButton(
                heroTag: 'events',
                onPressed: () => {
                  if (!premiumUser) interstitialAd.showInterstitialAd(),
                  TrackingFunctions.searchUpdates(context, widget.tracking),
                },
                child: const Icon(Icons.update, size: 29),
              ),
        bottomNavigationBar: premiumUser ? const SizedBox() : const AdBanner(),
      ),
    );
  }
}
