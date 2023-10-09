import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/view_card.dart';
import 'package:trackify/widgets/view_grid.dart';
import 'package:trackify/widgets/view_row.dart';

import '../providers/classes.dart';
import '../providers/preferences.dart';
import '../providers/trackings_active.dart';
import '../providers/trackings_archived.dart';
import '../providers/status.dart';

import '../screens/tracking_detail.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/check_tracking.dart';
import 'options_tracking.dart';

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

  void _seeTrackingDetail(bool premiumUser) {
    if (!premiumUser) interstitialAd.showInterstitialAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingDetail(widget.tracking),
      ),
    );
    Provider.of<Status>(context, listen: false).resetEndOfEventsStatus();
  }

  void _toggleSelectionMode(selectionMode) {
    if (!selectionMode) {
      providerFunctions.addSelected(widget.tracking);
    }
    widget.tracking.selected = !widget.tracking.selected!;
    providerFunctions.toggleSelectionMode();
  }

  void _trackingClick() {
    widget.tracking.selected!
        ? providerFunctions.removeSelected(widget.tracking.idSB)
        : providerFunctions.addSelected(widget.tracking);
    widget.tracking.selected = !widget.tracking.selected!;
  }

  void _clickItem(selectionMode, premiumUser) {
    if (selectionMode && widget.tracking.checkError != null) {
      _trackingClick();
    } else if (!selectionMode && !widget.tracking.checkError!) {
      _seeTrackingDetail(premiumUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic providerData = widget.tracking.archived!
        ? Provider.of<ArchivedTrackings>(context)
        : Provider.of<ActiveTrackings>(context);
    final bool selectionMode = providerData.selectionModeStatus;
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final String chosenView = Provider.of<UserPreferences>(context).startList;
    final Map<String, dynamic> trackingWidget = {
      "row": ViewRow(),
      "card": ViewCard(),
      "grid": ViewGrid(),
    };
    return widget.tracking.checkError == null
        ? CheckTracking(widget.tracking)
        : widget.tracking.checkError == true
            ? trackingWidget[chosenView].widget(
                context,
                widget.tracking,
                () => _clickItem(selectionMode, premiumUser),
                () => _toggleSelectionMode(selectionMode),
                screenWidth,
                "ERROR",
                SizedBox(
                  width: 38,
                  child: IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () {
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
                OptionsTracking(
                  tracking: widget.tracking,
                  menu: true,
                  action: '',
                  detail: false,
                ),
              )
            : trackingWidget[chosenView].widget(
                context,
                widget.tracking,
                () => _clickItem(selectionMode, premiumUser),
                () => _toggleSelectionMode(selectionMode),
                screenWidth,
                widget.tracking.title!,
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
                OptionsTracking(
                  tracking: widget.tracking,
                  menu: true,
                  action: '',
                  detail: false,
                ),
              );
  }
}
