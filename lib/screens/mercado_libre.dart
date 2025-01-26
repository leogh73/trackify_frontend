import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../data/../data/preferences.dart';

import '../data/classes.dart';
import '../data/trackings_active.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/ad_native.dart';
import '../widgets/mercado_libre_check.dart';
import '../widgets/ad_banner.dart';

class MercadoLibre extends StatelessWidget {
  final AdInterstitial adInterstitial;
  MercadoLibre(this.adInterstitial, {Key? key}) : super(key: key);

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
  ) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              child: premiumUser ? null : AdNative("small"),
              padding: EdgeInsets.only(top: 10, bottom: 100),
            ),
            Container(
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  screenText(text1),
                  screenText(text2),
                  ElevatedButton(
                    child: screenText(button),
                    onPressed: function,
                  )
                ],
              ),
            ),
            SizedBox(width: 10, height: 170),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final bool meLiStatus = Provider.of<UserPreferences>(context).meLiStatus;
    final bool errorMeLiCheck =
        Provider.of<UserPreferences>(context).errorMeLiCheck;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context).trackings;
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
                if (!premiumUser && trackingsList.isNotEmpty)
                  adInterstitial.showInterstitialAd();
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
                      children: const [
                        Icon(Icons.shopping_cart, size: 24),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child:
                              Text('COMPRAS', style: TextStyle(fontSize: 14)),
                        ),
                      ])),
              Container(
                  padding: const EdgeInsets.only(top: 3),
                  height: 46,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.local_shipping_outlined, size: 24),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text('VENTAS', style: TextStyle(fontSize: 14)),
                        ),
                      ])),
            ],
          ),
        ),
        body: meLiStatus
            ? errorMeLiCheck
                ? mercadoLibreScreen(
                    context,
                    'Información no disponible',
                    'Error de consulta a MercadoLibre',
                    'REINTENTAR',
                    () => Provider.of<UserPreferences>(context, listen: false)
                        .toggleMeLiErrorStatus(false),
                    premiumUser)
                : const TabBarView(
                    children: [
                      MercadoLibreCheck("buyer"),
                      MercadoLibreCheck("seller"),
                    ],
                  )
            : mercadoLibreScreen(
                context,
                'Información no disponible',
                'No ha ingresado a MercadoLibre',
                'INGRESAR',
                () {
                  if (!premiumUser && trackingsList.isNotEmpty)
                    adInterstitial.showInterstitialAd();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MercadoLibreSite("login", context),
                    ),
                  );
                },
                premiumUser,
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
  _MercadoLibreSiteState createState() => _MercadoLibreSiteState();
}

class _MercadoLibreSiteState extends State<MercadoLibreSite> {
  late final WebViewController _controller;

  void urlChangeHandler(BuildContext context, String url) {
    if (widget.action == "login" && url.contains("code=")) {
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
    final bool premiumUser =
        Provider.of<UserPreferences>(context).premiumStatus;
    final bool meLiStatus = Provider.of<UserPreferences>(context).meLiStatus;
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
