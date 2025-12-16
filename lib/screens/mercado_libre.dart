import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:trackify/widgets/dialog_toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../data/classes.dart';
import '../data/trackings_active.dart';
import '../data/preferences.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/mercado_libre_check.dart';

class MercadoLibre extends StatefulWidget {
  const MercadoLibre({Key? key}) : super(key: key);

  @override
  State<MercadoLibre> createState() => _MercadoLibreState();
}

class _MercadoLibreState extends State<MercadoLibre> {
  late bool isLoggedIn = false;

  AdInterstitial adInterstitial = AdInterstitial();

  @override
  void initState() {
    super.initState();
    adInterstitial.createInterstitialAd();
  }

  Text screenText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }

  Center mercadoLibreScreen(
    BuildContext context,
    String text1,
    String text2,
    String button,
    VoidCallback function,
    bool premiumUser,
    List<ItemTracking> trackingsList,
  ) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 80),
              child: premiumUser ? null : const AdNative("small"),
            ),
            SizedBox(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  screenText(text1),
                  screenText(text2),
                  ElevatedButton(
                    onPressed: function,
                    child: screenText(button),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10, height: 80),
            if (!premiumUser && trackingsList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: premiumUser ? null : const AdNative("medium"),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final bool meLiStatus = context.select(
        (UserPreferences userPreferences) => userPreferences.meLiStatus);
    final bool errorMeLiCheck = context.select(
        (UserPreferences userPreferences) => userPreferences.errorMeLiCheck);
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MercadoLibre"),
          titleSpacing: 1.0,
          actions: [
            IconButton(
              icon: meLiStatus
                  ? const Icon(Icons.logout)
                  : const Icon(Icons.login),
              onPressed: () {
                if (!premiumUser && trackingsList.isNotEmpty) {
                  adInterstitial.showInterstitialAd();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MercadoLibreSite(
                        meLiStatus ? "logout" : "login", context),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Container(
                  padding: const EdgeInsets.only(top: 3),
                  height: 46,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart, size: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(texts[66]!,
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ])),
              Container(
                  padding: const EdgeInsets.only(top: 3),
                  height: 46,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(texts[67]!,
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ])),
            ],
          ),
        ),
        body: meLiStatus
            ? errorMeLiCheck
                ? mercadoLibreScreen(
                    context,
                    texts[62]!,
                    texts[63]!,
                    texts[64]!,
                    () => Provider.of<UserPreferences>(context, listen: false)
                        .toggleMeLiErrorStatus(false),
                    premiumUser,
                    trackingsList,
                  )
                : const TabBarView(
                    children: [
                      MercadoLibreCheck("buyer"),
                      MercadoLibreCheck("seller"),
                    ],
                  )
            : mercadoLibreScreen(
                context,
                texts[62]!,
                texts[65]!,
                texts[38]!,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MercadoLibreSite("login", context),
                    ),
                  );
                  if (!premiumUser && trackingsList.isNotEmpty) {
                    adInterstitial.showInterstitialAd();
                    ShowDialog.goPremiumDialog(context);
                  }
                },
                premiumUser,
                trackingsList,
              ),
        bottomNavigationBar: premiumUser ? null : const AdBanner(),
      ),
    );
  }
}

class MercadoLibreSite extends StatefulWidget {
  final String action;
  final BuildContext context;
  const MercadoLibreSite(this.action, this.context, {Key? key})
      : super(key: key);

  @override
  MercadoLibreSiteState createState() => MercadoLibreSiteState();
}

class MercadoLibreSiteState extends State<MercadoLibreSite> {
  late final WebViewController _controller;
  String currentUrl = '';

  void urlChangeHandler(BuildContext context, String url) {
    if (widget.action == "login" && url.contains("code=")) {
      setState(() {
        currentUrl = url;
      });
      RegExp regExp = url.contains("&state")
          ? RegExp(r'code=([^]*?)&state=')
          : RegExp("code=(.*)");
      String? code = regExp.firstMatch(url)?[1];
      Provider.of<UserPreferences>(context, listen: false)
          .initializeMeLi(context, code!);
    } else if (widget.action == "logout" &&
        (url.startsWith("https://www.mercadolibre.com.ar/"))) {
      Provider.of<UserPreferences>(context, listen: false)
          .toggleMeLiStatus(false);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    String destinationUrl = widget.action == "login"
        ? "https://auth.mercadolibre.com.ar/authorization?response_type=code&client_id=${dotenv.env['ML_CLIENT_ID']}&redirect_uri=https://trackear.vercel.app"
        : 'https://myaccount.mercadolibre.com.ar/';

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (!request.url.contains('mercadolibre.com') &&
                !request.url.contains("trackear.vercel.app")) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            if (change.url == currentUrl) {
              return;
            }
            urlChangeHandler(widget.context, change.url!);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(destinationUrl));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final bool meLiStatus = context.select(
        (UserPreferences userPreferences) => userPreferences.meLiStatus);
    return Scaffold(
      appBar: AppBar(
        title: meLiStatus
            ? const Text("Salir de MercadoLibre")
            : const Text("Acceder a MercadoLibre"),
        titleSpacing: 1.0,
      ),
      body: WebViewWidget(controller: _controller),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
