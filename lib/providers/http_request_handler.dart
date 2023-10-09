import 'dart:async';
import 'package:http/http.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

class HttpRequestHandler {
  static Future<Response> newRequest(String route, Object body) async {
    Response response;
    try {
      // response = await Client()
      //     .post(Uri.parse("${dotenv.env['API_URL_1']}$route"), body: body)
      //     .timeout(const Duration(seconds: 10));
      response = await Client()
          .post(Uri.parse("${dotenv.env['API_URL']}$route"), body: body)
          .timeout(const Duration(seconds: 9));
      print("HTTP_RESPONSE_${dotenv.env['API_URL']}$route");
      print("HTTP_RESPONSE_$body");
    } catch (e) {
      print("HTTP_RESPONSE_$e");
      try {
        response = await Client()
            .post(Uri.parse("${dotenv.env['API_URL']}$route"), body: body)
            .timeout(const Duration(seconds: 9));
      } catch (e) {
        print("HTTP_RESPONSE_$e");
        response = e is TimeoutException
            ? Response('Server timeout', 500)
            : Response('error: ${e.toString()}', 500);
      }
    }
    print("HTTP_RESPONSE_${response.body}");
    return response;
  }
}
