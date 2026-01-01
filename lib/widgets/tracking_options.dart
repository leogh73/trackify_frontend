import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import '../data/classes.dart';
import '../data/http_connection.dart';
import '../data/preferences.dart';
import '../data/services.dart';
import '../data/status.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';

import '../screens/claim.dart';
import '../screens/tracking_detail.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';
import '../widgets/dialog_toast.dart';

class TrackingOptions extends StatefulWidget {
  final ItemTracking tracking;
  final String option;
  final String action;
  final bool detail;
  const TrackingOptions({
    Key? key,
    required this.tracking,
    required this.option,
    required this.action,
    required this.detail,
  }) : super(key: key);

  @override
  State<TrackingOptions> createState() => _TrackingOptionsState();
}

class _TrackingOptionsState extends State<TrackingOptions> {
  bool premiumUser = false;
  AdInterstitial interstitialAd = AdInterstitial();

  TextEditingController renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  @override
  void dispose() {
    renameController.dispose();
    super.dispose();
  }

  dynamic selectProvider() {
    return widget.tracking.archived!
        ? Provider.of<ArchivedTrackings>(context, listen: false)
        : Provider.of<ActiveTrackings>(context, listen: false);
  }

  void screenPopToast(String message) {
    Navigator.pop(context);
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    if (!premiumUser && trackingsList.isNotEmpty) {
      interstitialAd.showInterstitialAd();
      ShowDialog.goPremiumDialog(context);
    }
    Provider.of<Status>(context, listen: false).restartListEnd();
    GlobalToast.displayToast(context, message);
  }

  void seeTrackingDetail() {
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
  }

  Future<Map<String, dynamic>> renameTracking(BuildContext ctx) async {
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    final editedTracking = ItemTracking(
      idSB: widget.tracking.idSB,
      idMDB: widget.tracking.idMDB,
      title: renameController.text,
      code: widget.tracking.code,
      service: widget.tracking.service,
      events: [],
      moreData: [],
      lastEvent: "Sample",
    );
    final Map<String, dynamic> successResponse = {
      "success": true,
      "edited": editedTracking
    };
    if (widget.tracking.archived!) {
      return successResponse;
    }
    final Object body = {
      'userId': userId,
      'trackingId': editedTracking.idMDB,
      'newTitle': editedTracking.title,
    };
    final Response response =
        await HttpConnection.requestHandler('/api/user/$userId/rename/', body);
    if (response.statusCode == 500) {
      if (ctx.mounted) {
        DialogError.show(ctx, 21, "");
      }
      return {"success": false};
    }
    if (!ctx.mounted) {
      return {"success": false};
    }
    return successResponse;
  }

  void renameTrackingDialog(bool isPortrait, double screenWidth, bool fullHD,
      List<ItemTracking> trackingsList, Map<int, dynamic> texts) {
    renameController.text = widget.tracking.title!;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
          contentPadding: const EdgeInsets.all(10),
          content: Container(
            width: 280,
            height: 170,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: isPortrait ? screenWidth * 0.68 : screenWidth * 0.52,
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          texts[198]!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  width: isPortrait ? screenWidth * 0.8 : screenWidth * 0.52,
                  child: TextFormField(
                    focusNode: FocusNode(),
                    decoration: InputDecoration(
                      labelText: texts[199],
                      contentPadding: const EdgeInsets.only(top: 5),
                    ),
                    controller: renameController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 39,
                        child: ElevatedButton(
                          child: Text(
                            texts[26]!,
                            style: const TextStyle(fontSize: 17),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 120,
                        height: 39,
                        child: ElevatedButton(
                          child: Text(
                            texts[187]!,
                            style: const TextStyle(fontSize: 17),
                          ),
                          onPressed: () async {
                            final BuildContext ctx = context;
                            final BuildContext dgCtx = dialogContext;
                            final Map<String, dynamic> result =
                                await renameTracking(ctx);
                            if (!dgCtx.mounted) {
                              return;
                            }
                            Navigator.pop(dgCtx);
                            if (result["success"] == false) {
                              return;
                            }
                            if (!premiumUser && trackingsList.isNotEmpty) {
                              interstitialAd.showInterstitialAd();
                              ShowDialog.goPremiumDialog(ctx);
                            }
                            selectProvider()
                                .updateRenamedTracking(result["edited"]);
                            GlobalToast.displayToast(ctx, texts[241]!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleSelectionMode() {
    dynamic provider = selectProvider();
    provider.toggleSelectionMode();
    provider.addSelected(widget.tracking);
    widget.tracking.selected = true;
  }

  void removeTracking(Map<int, dynamic> texts, BuildContext context) async {
    if (widget.detail) {
      Navigator.pop(context);
    }
    final BuildContext ctx = context;
    final bool success = await selectProvider()
        .removeTracking([widget.tracking], context, widget.tracking.checkError);
    if (!ctx.mounted || success == false) {
      return;
    }
    screenPopToast(texts[197]!);
  }

  void removeSelection(Map<int, dynamic> texts, BuildContext context) async {
    dynamic provider = selectProvider();
    bool success = await provider.removeSelection(context);
    provider.toggleSelectionMode();
    if (success == false) {
      return;
    }
    provider.clearSelection();
    screenPopToast(texts[196]!);
  }

  void archiveTracking(Map<int, dynamic> texts) async {
    if (widget.detail) {
      Navigator.pop(context);
    }
    final BuildContext ctx = context;
    final bool success = await Provider.of<ActiveTrackings>(ctx, listen: false)
        .removeTracking([widget.tracking], ctx, widget.tracking.checkError!);
    if (!ctx.mounted || success == false) {
      return;
    }
    widget.tracking.archived = true;
    Provider.of<ArchivedTrackings>(ctx, listen: false)
        .addTracking(widget.tracking, ctx);
    screenPopToast(texts[195]!);
  }

  void archiveSelection(Map<int, dynamic> texts, BuildContext context) async {
    dynamic provider = selectProvider();
    List<ItemTracking> selection = provider.selectionElements;
    final BuildContext ctx = context;
    bool success = await provider.removeSelection(ctx);
    if (success == false) {
      provider.toggleSelectionMode();
      return;
    }
    if (!ctx.mounted) {
      return;
    }
    for (ItemTracking t in selection) {
      t.selected = false;
      t.archived = true;
      Provider.of<ArchivedTrackings>(ctx, listen: false).addTracking(t, ctx);
    }
    provider.clearSelection();
    provider.toggleSelectionMode();
    screenPopToast(texts[194]!);
  }

  void seeServiceContact() {
    Provider.of<Services>(context, listen: false)
        .loadService(widget.tracking.service, context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceClaim(widget.tracking.service),
      ),
    );
    if (!premiumUser) {
      interstitialAd.showInterstitialAd();
      ShowDialog.goPremiumDialog(context);
    }
  }

  void displayDialog(String action, Map<int, dynamic> texts) async {
    VoidCallback dialogFunction;
    String buttonText = action == texts[190]! ? texts[189]! : texts[191]!;
    dialogFunction = action == texts[190]!
        ? () => widget.option == "menu" || widget.option == "elevatedButtons"
            ? archiveTracking(texts)
            : archiveSelection(texts, context)
        : () => widget.option == "menu" || widget.option == "elevatedButtons"
            ? removeTracking(texts, context)
            : removeSelection(texts, context);
    ShowDialog.actionConfirmation(
        context, action, buttonText, dialogFunction, texts);
  }

  optionMenu(String text, IconData icon) {
    return PopupMenuItem(
      value: text,
      height: 35,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 15),
            child: Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ),
        ],
      ),
    );
  }

  void togglePremium() {
    setState(() {
      premiumUser = !premiumUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumStatus = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    if (premiumUser != premiumStatus) {
      togglePremium();
    }
    final List<ItemTracking> trackingsList = context
        .select((ActiveTrackings activeTrackings) => activeTrackings.trackings);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;
    final Map<String, Map<String, dynamic>> buttons = {
      "iconButtons": {
        "rename": IconButton(
          icon: const Icon(Icons.edit),
          iconSize: 24,
          onPressed: () => renameTrackingDialog(
              isPortrait, screenWidth, fullHD, trackingsList, texts),
        ),
        "archive": IconButton(
            icon: const Icon(Icons.archive),
            iconSize: 24,
            onPressed: () => displayDialog(texts[189]!, texts)),
        "remove": IconButton(
          icon: const Icon(Icons.delete),
          iconSize: 24,
          onPressed: () => displayDialog(texts[192]!, texts),
        ),
      },
      "elevatedButtons": {
        "rename": Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => renameTrackingDialog(
                  isPortrait, screenWidth, fullHD, trackingsList, texts),
              child: Text(
                texts[187]!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        "archive": Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => displayDialog(texts[189]!, texts),
              child: Text(
                texts[189]!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        "remove": Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => displayDialog(texts[192]!, texts),
              child: Text(
                texts[191]!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      }
    };
    final String trackingType = widget.tracking.archived! ? "archived" : "main";
    final Map<String, dynamic> optionsList = {
      "main": {
        "menu": PopupMenuButton<String>(
          tooltip: texts["184"],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 2,
          onSelected: (String value) {
            if (value == texts[185]) {
              seeTrackingDetail();
            }
            if (value == texts[187]) {
              renameTrackingDialog(
                  isPortrait, screenWidth, fullHD, trackingsList, texts);
            }
            if (value == texts[188]) {
              toggleSelectionMode();
            }
            if (value == texts[189]) {
              displayDialog(texts[190]!, texts);
            }
            if (value == texts[191]) {
              displayDialog(texts[192]!, texts);
            }
            if (value == texts[193]) {
              seeServiceContact();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (widget.tracking.checkError == false)
              optionMenu(texts[185]!, Icons.info_outline),
            optionMenu(texts[187]!, Icons.edit),
            optionMenu(texts[188]!, Icons.select_all_sharp),
            if (!widget.tracking.checkError!)
              optionMenu(texts[189]!, Icons.archive),
            optionMenu(texts[191]!, Icons.delete),
            optionMenu(texts[193]!, Icons.warning),
          ],
        ),
        "buttons": buttons,
      },
      "archived": {
        "menu": PopupMenuButton<String>(
          tooltip: texts[184]!,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 2,
          onSelected: (String value) {
            if (value == texts[185]) {
              seeTrackingDetail();
            }
            if (value == texts[187]) {
              renameTrackingDialog(
                  isPortrait, screenWidth, fullHD, trackingsList, texts);
            }
            if (value == texts[188]) {
              toggleSelectionMode();
            }
            if (value == texts[191]) {
              displayDialog(texts[192]!, texts);
            }
            if (value == texts[193]) {
              seeServiceContact();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (!!widget.tracking.checkError!)
              optionMenu(texts[185]!, Icons.info_outline),
            optionMenu(texts[187]!, Icons.edit),
            optionMenu(texts[188]!, Icons.select_all_sharp),
            optionMenu(texts[191]!, Icons.delete),
          ],
        ),
        "buttons": buttons,
      }
    };

    return widget.action.isEmpty
        ? optionsList[trackingType][widget.option]
        : optionsList[trackingType]["buttons"][widget.option][widget.action];
  }
}
