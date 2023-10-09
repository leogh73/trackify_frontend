import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/dialog_error.dart';
import 'package:http/http.dart';
import 'package:trackify/widgets/tracking_item.dart';

import '../providers/http_request_handler.dart';
import '../providers/classes.dart';
import '../providers/trackings_active.dart';
import '../providers/preferences.dart';

import 'ad_interstitial.dart';
import 'dialog_toast.dart';

class TrackingData {
  static Future fetch(BuildContext context, ItemTracking tracking) async {
    AdInterstitial interstitialAd = AdInterstitial();
    interstitialAd.createInterstitialAd();
    String userId = Provider.of<UserPreferences>(context, listen: false).userId;
    Object body = {
      'title': tracking.title,
      'service': tracking.service,
      'code': tracking.code.trim(),
    };
    Response response =
        await HttpRequestHandler.newRequest('/api/user/$userId/add', body);
    // Response response = await HttpRequestHandler.newRequest('/api/dev/2', body);
    if (response.body == "Server timeout") {
      return DialogError.serverTimeout(context);
    }
    Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData['error'] == null) {
      Provider.of<ActiveTrackings>(context, listen: false)
          .loadStartData(context, tracking, responseData);
      GlobalToast.displayToast(context, "Seguimiento agregado");
      tracking.checkError = false;
      return;
    }
    if (responseData['error'] == "No data") {
      Provider.of<ActiveTrackings>(context, listen: false)
          .removeTracking([tracking], context, true);
      DialogError.trackingNoData(context, tracking.service);
      return;
    }
    responseData['error']['body'] == "Service timeout"
        ? DialogError.serviceTimeout(context, tracking.service)
        : DialogError.startTrackingError(context);
    tracking.checkError = true;
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
