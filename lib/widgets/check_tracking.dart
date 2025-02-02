import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../data/classes.dart';
import '../data/http_connection.dart';
import '../data/trackings_active.dart';
import '../data/../data/preferences.dart';

import '../widgets/dialog_error.dart';
import '../widgets/tracking_item.dart';
import '../widgets/dialog_toast.dart';

class TrackingData {
  static Future fetch(BuildContext context, ItemTracking tracking) async {
    final String userId =
        Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {
      'title': tracking.title,
      'service': tracking.service,
      'code': tracking.code.trim(),
    };
    Response response =
        await HttpConnection.requestHandler('/api/user/$userId/add', body);
    Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, context);
    if (response.statusCode == 200) {
      Provider.of<ActiveTrackings>(context, listen: false)
          .loadStartData(context, tracking, responseData);
      tracking.checkError = false;
      GlobalToast.displayToast(context, "Seguimiento agregado");
    } else {
      if (responseData["serverError"] == null) {
        if (responseData['error'] == "No data") {
          Provider.of<ActiveTrackings>(context, listen: false)
              .removeTracking([tracking], context, true);
          DialogError.show(context, 4, tracking.service);
          return;
        } else {
          responseData['error']['body'] == "Service timeout"
              ? DialogError.show(context, 6, tracking.service)
              : DialogError.show(context, 2, "");
        }
      }
      tracking.checkError = true;
    }
    return tracking;
  }
}

class CheckTracking extends StatelessWidget {
  final ItemTracking tracking;
  const CheckTracking(this.tracking, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return FutureBuilder(
      future: TrackingData.fetch(context, tracking),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data == null ? SizedBox() : TrackingItem(tracking);
        } else {
          return Center(
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: const SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  Text(
                    'Verificando...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: fullHD ? 16 : 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
