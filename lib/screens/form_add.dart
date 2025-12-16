import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../data/classes.dart';
import '../data/preferences.dart';
import '../data/services.dart';
import '../data/status.dart';
import '../data/trackings_active.dart';
import '../data/trackings_archived.dart';

import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/ad_banner.dart';
import '../widgets/dialog_error.dart';
import '../widgets/dialog_toast.dart';
import '../widgets/services_select.dart';

class FormAdd extends StatefulWidget {
  final ItemTracking? tracking;
  final String storeName;
  final String? shippingId;
  final String? title;
  final String? code;

  const FormAdd({
    Key? key,
    this.tracking,
    required this.storeName,
    this.shippingId,
    this.title,
    this.code,
  }) : super(key: key);

  @override
  FormAddState createState() => FormAddState();
}

class FormAddState extends State<FormAdd> {
  final AdInterstitial interstitialAd = AdInterstitial();
  late dynamic providerFunctions;

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final codeController = TextEditingController();
  final serviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.code != null) {
      final List<ServiceItemModel> servicesList =
          Provider.of<Services>(context, listen: false).itemModelList(true);
      codeValueHandler(context, widget.code!, servicesList);
    }
    if (widget.storeName == "Mercado Libre") {
      titleController.text = widget.title!;
      codeController.text =
          widget.code!.startsWith("MEL", 0) ? widget.shippingId! : widget.code!;
      providerFunctions = widget.tracking?.archived == true
          ? Provider.of<ArchivedTrackings>(context, listen: false)
          : Provider.of<ActiveTrackings>(context, listen: false);
      interstitialAd.createInterstitialAd();
    }
    codeFocus.addListener(() {
      if (codeFocus.hasFocus) {
        Provider.of<Services>(context, listen: false).toggleIsExpanded(false);
      }
    });
    titleFocus.addListener(() {
      if (titleFocus.hasFocus) {
        Provider.of<Services>(context, listen: false).toggleIsExpanded(false);
      }
    });
  }

  final FocusNode codeFocus = FocusNode();
  final FocusNode titleFocus = FocusNode();
  final FocusNode scanFocus = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    titleFocus.dispose();
    codeController.dispose();
    codeFocus.dispose();
    serviceController.dispose();
    scanFocus.dispose();
    super.dispose();
  }

  void pagePopMessage(bool premiumUser) {
    Navigator.pop(context);
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    if (!premiumUser && trackingsList.length > 1) {
      interstitialAd.showInterstitialAd();
      ShowDialog.goPremiumDialog(context);
    }
  }

  void addTracking(String? service, bool premiumUser) {
    if (formKey.currentState?.validate() == false || service == null) {
      DialogError.show(context, 3, "");
      return;
    }
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    if (trackingsList.indexWhere((t) =>
            t.code == codeController.text.trim() && t.service == service) !=
        -1) {
      DialogError.show(context, 22, "");
      return;
    }
    final Map<String, dynamic> newTracking = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "title": titleController.text,
      "code": codeController.text.trim(),
      "service": service,
    };
    Provider.of<ActiveTrackings>(context, listen: false)
        .addTracking(newTracking);
    pagePopMessage(premiumUser);
  }

  void renameTracking(
      String? service, String listView, bool premiumUser) async {
    if (formKey.currentState?.validate() == false || service == null) {
      DialogError.show(context, 3, "");
    } else {
      final ItemTracking editedTracking = ItemTracking(
        idSB: widget.tracking?.idSB,
        idMDB: widget.tracking?.idMDB,
        title: titleController.text,
        code: codeController.text,
        service: service,
        events: [],
        moreData: [],
        lastEvent: "Sample",
      );
      bool success =
          await providerFunctions.renameTracking(context, editedTracking);
      if (success == false) {
        return;
      }
      pagePopMessage(premiumUser);
    }
  }

  void codeValueHandler(
      BuildContext context, String value, List<ServiceItemModel> servicesList) {
    final BuildContext ctx = context;
    codeController.text = value;
    if (value.isEmpty || value.length < 4) {
      return;
    }
    Future.delayed(const Duration(seconds: 1), () async {
      if (!ctx.mounted) {
        return;
      }
      await Provider.of<Services>(context, listen: false)
          .autoDetectServices(ctx, value, servicesList);
      if (!ctx.mounted) {
        return;
      }
      Provider.of<Status>(ctx, listen: false).setCodeInput(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final ServiceItemModel? selectedService =
        context.select((Services services) => services.chosenService);
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    final List<ServiceItemModel> servicesList =
        Provider.of<Services>(context, listen: false).itemModelList(true);
    final String selectionMessage =
        Provider.of<Services>(context, listen: false).messageService;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD = MediaQuery.of(context).size.width *
            MediaQuery.of(context).devicePixelRatio >
        1079;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: Text(texts[13]!),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 26,
            onPressed: () => addTracking(selectedService!.name, premiumUser),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: premiumUser ? null : const AdNative("small"),
              ),
              Form(
                key: formKey,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  width: isPortrait ? screenWidth : screenWidth * 0.6,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                focusNode: codeFocus,
                                onChanged: (dynamic value) async {
                                  if (value == null) {
                                    return;
                                  }
                                  codeValueHandler(
                                      context, value, servicesList);
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: .8,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  hintText: texts[14],
                                  contentPadding:
                                      const EdgeInsets.only(left: 12),
                                ),
                                controller: codeController,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                validator: (String? value) {
                                  if (value == null || value.length < 5) {
                                    return texts[15];
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: isPortrait
                                  ? screenWidth * 0.32
                                  : screenWidth * 0.6 * 0.323,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final String code =
                                      await CodeHandler.scanBarcode(
                                          context, texts);
                                  if (!context.mounted) {
                                    return;
                                  }
                                  codeValueHandler(context, code, servicesList);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(MdiIcons.barcodeScan),
                                    const SizedBox(width: 7),
                                    Text(
                                      texts[244]!,
                                      style:
                                          TextStyle(fontSize: fullHD ? 17 : 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ServiceSelect(
                          false,
                          serviceController,
                          servicesList,
                          selectedService,
                          widget.tracking != null,
                        ),
                      ),
                      if (selectionMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Text(
                                selectionMessage,
                                maxLines: 8,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[400],
                                  fontSize: fullHD ? 17 : 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      TextFormField(
                        focusNode: titleFocus,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: .8,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          hintText: texts[16]!,
                          contentPadding: const EdgeInsets.only(left: 12),
                        ),
                        controller: titleController,
                        textInputAction: TextInputAction.next,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 39,
                              child: ElevatedButton(
                                child: Text(
                                  texts[18]!,
                                  style: TextStyle(fontSize: fullHD ? 17 : 16),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (!premiumUser &&
                                      trackingsList.isNotEmpty) {
                                    interstitialAd.showInterstitialAd();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 120,
                              height: 39,
                              child: ElevatedButton(
                                child: Text(
                                  texts[19]!,
                                  style: TextStyle(fontSize: fullHD ? 17 : 16),
                                ),
                                onPressed: () => addTracking(
                                    selectedService!.name, premiumUser),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!premiumUser && trackingsList.isNotEmpty)
                const AdNative("medium"),
              if (premiumUser) const SizedBox(width: 50, height: 120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}

class CodeHandler {
  static Future<String> scanBarcode(
      BuildContext context, Map<int, dynamic> texts) async {
    final BuildContext ctx = context;
    String? response;
    try {
      response = response = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        texts[26],
        true,
        ScanMode.BARCODE,
      );
    } catch (e) {
      if (ctx.mounted) {
        GlobalToast.displayToast(ctx, texts[246]);
      }
      return "";
    }
    if (response == "-1") {
      return "";
    }
    return response;
  }
}
