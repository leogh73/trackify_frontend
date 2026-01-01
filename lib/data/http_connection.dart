import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart' as lite;
import 'dart:async';
import 'package:http/http.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:trackify/widgets/dialog_toast.dart';

import 'dart:convert';

import '../widgets/dialog_error.dart';

class HttpConnection {
  static Future<Response> requestHandler(String route, Object body) async {
    Response response;
    final Map<String, String> headers = {"version": "${dotenv.env['APP']}"};
    try {
      response = await Client()
          .post(Uri.parse("${dotenv.env['API_URL_1']}$route"),
              body: body, headers: headers)
          .timeout(const Duration(seconds: 12));
    } catch (e) {
      try {
        response = await Client()
            .post(Uri.parse("${dotenv.env['API_URL_2']}$route"),
                body: body, headers: headers)
            .timeout(const Duration(seconds: 12));
      } catch (e) {
        response = Response(
          e is TimeoutException
              ? '{"serverError":"Timeout"}'
              : '{"serverError":"${e.toString()}"}',
          500,
        );
      }
    }
    return response;
  }

  static Map<String, dynamic> responseHandler(
      Response response, BuildContext context) {
    Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    if (response.statusCode == 403) {
      ShowDialog.mustUpdateDialog(context);
      return {};
    }
    if (responseData['serverError'] != null) {
      responseData['serverError'] == "Timeout"
          ? DialogError.show(context, 7, "")
          : DialogError.show(context, 1, "");
    }
    return responseData;
  }

  static Future<void> customTabsLaunchUrl(
      String url, BuildContext context) async {
    try {
      await lite.launchUrl(
        Uri.parse(url),
        options: lite.LaunchOptions(
          barColor: Theme.of(context).primaryColor,
          barFixingEnabled: false,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
