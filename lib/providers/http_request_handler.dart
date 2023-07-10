import 'package:http/http.dart' as http;
import "package:flutter_dotenv/flutter_dotenv.dart";

class HttpRequestHandler {
  static Future<dynamic> newRequest(String route, Object body) async {
    var response;
    try {
      response = await http.Client()
          .post(Uri.parse("${dotenv.env['API_URL_1']}$route"), body: body)
          .timeout(const Duration(seconds: 8));
      // response = await http.Client()
      //     .post(Uri.parse("${dotenv.env['API_URL']}$route"), body: body)
      //     .timeout(const Duration(seconds: 8));
    } catch (e) {
      print("HTTP_ERROR_$e");
      try {
        response = await http.Client()
            .post(Uri.parse("${dotenv.env['API_URL_2']}$route"), body: body)
            .timeout(const Duration(seconds: 8));
      } catch (e) {
        return errorResponse(e);
      }
    }
    return response;
  }

  static Map<String, String> errorResponse(Object detail) {
    print("HTTP_ERROR_$detail");
    return {'error': detail.toString()};
  }
}
