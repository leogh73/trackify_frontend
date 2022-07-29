import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  static const routeName = "/privacy_policy";
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late String destinyUrl;
  late String listenUrl;
  late WebView webView;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    destinyUrl =
        "https://github.com/leogh73/trackify_frontend/blob/master/PRIVACY_POLICY.md";
    webView = WebView(
      initialUrl: destinyUrl,
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy:
          AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
      onPageFinished: (url) => {if (url != destinyUrl) controller.goBack()},
      navigationDelegate: (NavigationRequest request) {
        if (request.url != destinyUrl) controller.goBack();
        return NavigationDecision.prevent;
      },
      onWebViewCreated: (controller) {
        this.controller = controller;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Política de privacidad")),
      body: webView,
      // bottomNavigationBar: BannerAdWidget(),
    );
  }
}
