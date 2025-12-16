import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../data/classes.dart';
import '../data/services.dart';
import '../data/tracking_functions.dart';
import '../data/trackings_active.dart';
import '../data/status.dart';
import '../data/preferences.dart';

import '../screens/form_add.dart';
import '../screens/search.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';
import '../widgets/drawer.dart';
import '../widgets/style_options.dart';
import '../widgets/tracking_list.dart';
import '../widgets/tracking_options.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (!mounted) {
          return;
        }
        TrackingFunctions.syncronizeUserData(context);
      },
    );
  }

  Future<void> scanBarcodeMain(String errorText) async {
    final BuildContext ctx = context;
    final String result = await CodeHandler.scanBarcode(context, errorText);
    if (result.isEmpty) {
      return;
    }
    if (!ctx.mounted) {
      return;
    }
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) => FormAdd(storeName: "", code: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    final bool endOfList = context.select((Status status) => status.endOfList);
    final bool selectionMode = context.select(
        (ActiveTrackings activeTrackings) => activeTrackings.selectionMode);
    final List<ItemTracking> selection = context.select(
        (ActiveTrackings activeTrackings) => activeTrackings.selectionElements);
    final List<ItemTracking> trackingsList =
        context.watch<ActiveTrackings>().trackings;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final ItemTracking sampleTracking = ItemTracking(
      code: '',
      service: '',
      events: [],
      moreData: [],
      archived: false,
    );
    final List<String> languages = ["Español", "English"];
    final List<Widget> floatingActionButtons = [
      Padding(
        padding: isPortrait
            ? const EdgeInsets.only(bottom: 7)
            : const EdgeInsets.only(right: 7),
        child: FloatingActionButton(
          onPressed: () => scanBarcodeMain(texts[146]!),
          heroTag: "herotag1",
          child: Icon(MdiIcons.barcodeScan),
        ),
      ),
      Padding(
        padding: isPortrait
            ? const EdgeInsets.only(top: 7)
            : const EdgeInsets.only(left: 7),
        child: SizedBox(
          width: 65.0,
          height: 65.0,
          child: FloatingActionButton(
            heroTag: "herotag2",
            onPressed: () {
              Provider.of<Services>(context, listen: false).clearStartService();
              Provider.of<Services>(context, listen: false).clearFilteredList();
              Provider.of<Services>(context, listen: false)
                  .clearDetectedServices();
              Provider.of<Services>(context, listen: false)
                  .toggleIsExpanded(false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FormAdd(
                    storeName: "",
                  ),
                ),
              );
            },
            child: Icon(MdiIcons.packageVariantClosedPlus, size: 37),
          ),
        ),
      ),
    ];
    return userId.isEmpty
        ? Scaffold(
            appBar: AppBar(title: Text(texts[2]!)),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!premiumUser)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 30),
                      child: AdNative("medium"),
                    ),
                  const Icon(Icons.error, size: 80),
                  const SizedBox(height: 20),
                  const Text(
                    'ERROR',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: Text(
                      texts[3]!,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 145,
                    height: 45,
                    child: ElevatedButton(
                      child: Text(
                        texts[4]!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () => Phoenix.rebirth(context),
                    ),
                  ),
                  if (!premiumUser)
                    const Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 8),
                      child: AdNative("medium"),
                    ),
                ],
              ),
            ),
          )
        : Scaffold(
            drawer: const DrawerWidget(),
            appBar: selectionMode
                ? AppBar(
                    titleSpacing: 1.0,
                    leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Provider.of<ActiveTrackings>(context, listen: false)
                              .toggleSelectionMode();
                        }),
                    title: Text(
                      '${selection.length}/${trackingsList.length}',
                      style: const TextStyle(fontSize: 19),
                    ),
                    actions: [
                      if (selection.isNotEmpty) ...[
                        TrackingOptions(
                          tracking: sampleTracking,
                          menu: false,
                          action: 'archive',
                          detail: false,
                        ),
                        TrackingOptions(
                          tracking: sampleTracking,
                          menu: false,
                          action: 'remove',
                          detail: false,
                        ),
                      ],
                      IconButton(
                        icon: const Icon(Icons.select_all),
                        onPressed: () {
                          Provider.of<ActiveTrackings>(context, listen: false)
                              .selectAll();
                        },
                      ),
                    ],
                  )
                : AppBar(
                    titleSpacing: 1.0,
                    title: Text(texts[5]!),
                    actions: <Widget>[
                      IconButton(
                        tooltip: texts[6],
                        icon: const Icon(Icons.search),
                        iconSize: 27,
                        onPressed: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const Search("active"),
                            ),
                          ),
                        },
                      ),
                      const StyleOptions(),
                      PopupMenuButton<String>(
                        constraints: const BoxConstraints.expand(
                            width: 140, height: 100),
                        icon: const Icon(Icons.language),
                        iconSize: 27,
                        tooltip: texts[7],
                        onSelected: (String value) {
                          if (value == texts[0]) {
                            return;
                          }
                          Provider.of<UserPreferences>(context, listen: false)
                              .changeLanguage(value.toLowerCase());
                        },
                        itemBuilder: (BuildContext context) => languages
                            .map(
                              (lang) => PopupMenuItem<String>(
                                padding: const EdgeInsets.only(left: 20),
                                value: lang,
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(width: 75, child: Text(lang)),
                                    if (texts[0] == lang)
                                      Icon(
                                        Icons.check,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
            body: TrackingList(trackingsList),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: selectionMode || endOfList
                ? null
                : isPortrait
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: floatingActionButtons)
                    : Container(
                        alignment: Alignment.center,
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: floatingActionButtons,
                        ),
                      ),
            bottomNavigationBar: premiumUser ? null : const AdBanner(),
          );
  }
}
