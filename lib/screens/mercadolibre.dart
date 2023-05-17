import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../providers/preferences.dart';
import '../widgets/meli_check.dart';
import '../widgets/ad_banner.dart';

class MercadoLibre extends StatelessWidget {
  const MercadoLibre({Key? key}) : super(key: key);

  Text screenText(String texto) {
    return Text(
      texto,
      style: const TextStyle(fontSize: 16),
    );
  }

  Center mercadoLibreScreen(BuildContext context, String text1, String text2,
      String button, VoidCallback function) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                screenText(text1),
                screenText(text2),
                ElevatedButton(
                  child: screenText(button),
                  onPressed: function,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool meLiStatus = Provider.of<Preferences>(context).meLiStatus;
    final bool errorMeLiCheck =
        Provider.of<Preferences>(context).errorMeLiCheck;
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => meLiStatus
                      ? const MercadoLibreSite("logout")
                      : const MercadoLibreSite("login"),
                ),
              ),
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
                    () => Provider.of<Preferences>(context, listen: false)
                        .toggleMeLiErrorStatus(false),
                  )
                : const TabBarView(
                    children: [
                      MeLiCheck("buyer"),
                      MeLiCheck("seller"),
                    ],
                  )
            : mercadoLibreScreen(
                context,
                'Información no disponible',
                'No ha ingresado a MercadoLibre',
                'INGRESAR',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MercadoLibreSite("login"),
                  ),
                ),
              ),
        bottomNavigationBar: const BannerAdWidget(),
      ),
    );
  }
}

class MercadoLibreSite extends StatefulWidget {
  final String action;
  const MercadoLibreSite(this.action, {Key? key}) : super(key: key);

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
      Provider.of<Preferences>(context, listen: false)
          .initializeMeLi(context, code!);
      Navigator.of(context).pop();
    } else if (widget.action == "logout" &&
        (url.startsWith("https://www.mercadolibre.com.ar/"))) {
      Provider.of<Preferences>(context, listen: false).toggleMeLiStatus(false);
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

    String destinyUrl = widget.action == "login"
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
            urlChangeHandler(context, change.url!);
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
      ..loadRequest(Uri.parse(destinyUrl));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    final bool meLiStatus = Provider.of<Preferences>(context).meLiStatus;
    return Scaffold(
      appBar: AppBar(
        title: meLiStatus
            ? const Text("Salir de MercadoLibre")
            : const Text("Acceder a MercadoLibre"),
        titleSpacing: 1.0,
      ),
      body: WebViewWidget(controller: _controller),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}
