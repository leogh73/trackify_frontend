import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

import 'dart:convert';

import '../widgets/dialog_error.dart';

class HttpConnection {
  static Future<Response> requestHandler(String route, Object body) async {
    Response response;
    try {
      response = await Client()
          .post(Uri.parse("${dotenv.env['API_URL_1']}$route"), body: body)
          .timeout(const Duration(seconds: 9));
      // response = await Client()
      //     .post(Uri.parse("${dotenv.env['API_URL']}$route"), body: body)
      //     .timeout(const Duration(seconds: 9));
    } catch (e) {
      print("HTTP_R_$e");
      try {
        response = await Client()
            .post(Uri.parse("${dotenv.env['API_URL_2']}$route"), body: body)
            .timeout(const Duration(seconds: 9));
      } catch (e) {
        print("HTTP_R_$e");
        response = Response(
          e is TimeoutException
              ? '{"error":"Server timeout"}'
              : '{"error":"${e.toString()}"}',
          500,
        );
      }
    }
    print("HTTP_R_${response.body}");
    return response;
  }

  static dynamic responseHandler(Response response, BuildContext context) {
    dynamic responseData = json.decode(response.body);
    if (response.statusCode == 200) return responseData;
    responseData['errorDisplayed'] = false;
    dynamic errorData = responseData['error'];
    if (errorData is String) {
      if (errorData == "Server timeout") {
        DialogError.serverTimeout(context);
      } else if (errorData != "No data") {
        DialogError.serverError(context);
      }
      responseData['errorDisplayed'] = true;
    }
    return responseData;
  }

  static Future<void> awakeAPIs() async {
    try {
      await Client()
          .get(Uri.parse("${dotenv.env['API_URL_1']}/api/cronjobs/awake"))
          .timeout(const Duration(seconds: 5));
      print("HTTP_R_APIs awaken successfully");
    } catch (e) {
      print("HTTP_R_APIs awakening failed: $e");
    }
  }
}
