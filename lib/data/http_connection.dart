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
          .timeout(const Duration(seconds: 13));
    } catch (e) {
      try {
        response = await Client()
            .post(Uri.parse("${dotenv.env['API_URL_2']}$route"), body: body)
            .timeout(const Duration(seconds: 13));
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
    if (response.statusCode == 200) return responseData;
    if (responseData['serverError'] != null) {
      responseData['serverError'] == "Timeout"
          ? DialogError.show(context, 7, "")
          : DialogError.show(context, 1, "");
    }
    return responseData;
  }
}
