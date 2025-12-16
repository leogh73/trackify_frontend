import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/data/tracking_functions.dart';
import 'package:trackify/widgets/dialog_toast.dart';

import '../data/classes.dart';
import '../data/preferences.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';
import '../data/status.dart';
import '../data/services.dart';

import '../screens/tracking_detail.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/tracking_check.dart';
import '../widgets/tracking_options.dart';
import '../widgets/view_card.dart';
import '../widgets/view_grid.dart';
import '../widgets/view_row.dart';

class TrackingItem extends StatefulWidget {
  final ItemTracking tracking;
  const TrackingItem(this.tracking, {Key? key}) : super(key: key);

  @override
  State<TrackingItem> createState() => _TrackingItemState();
}

class _TrackingItemState extends State<TrackingItem> {
  bool expand = false;
  late dynamic providerFunctions;
  AdInterstitial interstitialAd = AdInterstitial();

  @override
  void initState() {
    super.initState();
    providerFunctions = widget.tracking.archived!
        ? Provider.of<ArchivedTrackings>(context, listen: false)
        : Provider.of<ActiveTrackings>(context, listen: false);
    interstitialAd.createInterstitialAd();
  }

  seeTrackingDetail(premiumUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingDetail(widget.tracking),
      ),
    );
    if (!premiumUser) {
      interstitialAd.showInterstitialAd();
      ShowDialog.goPremiumDialog(context);
    }
    Provider.of<Status>(context, listen: false).resetEndOfEventsStatus();
  }

  void toggleSelectionMode(selectionMode) {
    if (!selectionMode) {
      providerFunctions.addSelected(widget.tracking);
    }
    widget.tracking.selected = !widget.tracking.selected!;
    providerFunctions.toggleSelectionMode();
  }

  void trackingClick() {
    widget.tracking.selected!
        ? providerFunctions.removeSelected(widget.tracking.idSB)
        : providerFunctions.addSelected(widget.tracking);
    widget.tracking.selected = !widget.tracking.selected!;
  }

  void clickItem(selectionMode, premiumUser) {
    if (selectionMode && widget.tracking.checkError != null) {
      trackingClick();
    } else if (!selectionMode && !widget.tracking.checkError!) {
      seeTrackingDetail(premiumUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final dynamic providerData = widget.tracking.archived!
        ? Provider.of<ArchivedTrackings>(context)
        : Provider.of<ActiveTrackings>(context);
    final bool selectionMode = providerData.selectionModeStatus;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final String chosenView = context
        .select((UserPreferences userPreferences) => userPreferences.startList);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Map<String, dynamic> trackingWidget = {
      "row": ViewRow(),
      "card": ViewCard(),
      "grid": ViewGrid(),
    };
    final Image serviceLogo = Image.network(
        Provider.of<Services>(context, listen: false)
            .servicesData[widget.tracking.service]['logoUrl']);
    return widget.tracking.checkError == null
        ? TrackingCheck(widget.tracking)
        : widget.tracking.checkError == true
            ? trackingWidget[chosenView].widget(
                context,
                serviceLogo,
                widget.tracking,
                "",
                () => clickItem(selectionMode, premiumUser),
                () => toggleSelectionMode(selectionMode),
                screenWidth,
                "ERROR",
                SizedBox(
                  width: 38,
                  child: IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () {
                      if (!premiumUser && trackingsList.length > 1) {
                        interstitialAd.showInterstitialAd();
                        ShowDialog.goPremiumDialog(context);
                      }
                      setState(() {
                        widget.tracking.checkError = null;
                      });
                    },
                  ),
                ),
                expand,
                selectionMode,
                isPortrait,
                premiumUser,
                fullHD,
                TrackingOptions(
                  tracking: widget.tracking,
                  menu: true,
                  action: '',
                  detail: false,
                ),
              )
            : trackingWidget[chosenView].widget(
                context,
                serviceLogo,
                widget.tracking,
                TrackingFunctions.daysInTransit(
                  context,
                  widget.tracking.events[0]["date"]!,
                  widget.tracking.events[widget.tracking.events.length - 1]
                      ["date"]!,
                ),
                () => clickItem(selectionMode, premiumUser),
                () => toggleSelectionMode(selectionMode),
                screenWidth,
                widget.tracking.title,
                SizedBox(
                  width: 38,
                  child: IconButton(
                    icon: Icon(expand ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        expand = !expand;
                      });
                    },
                  ),
                ),
                expand,
                selectionMode,
                isPortrait,
                premiumUser,
                fullHD,
                TrackingOptions(
                  tracking: widget.tracking,
                  menu: true,
                  action: '',
                  detail: false,
                ),
              );
  }
}
