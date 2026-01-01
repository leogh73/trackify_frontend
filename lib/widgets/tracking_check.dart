import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import '../data/classes.dart';
import '../data/http_connection.dart';
import '../data/trackings_active.dart';
import '../data/preferences.dart';

import './dialog_error.dart';
import './tracking_item.dart';
import './dialog_toast.dart';

class TrackingCheck extends StatefulWidget {
  final ItemTracking tracking;
  const TrackingCheck(this.tracking, {Key? key}) : super(key: key);

  @override
  TrackingCheckState createState() => TrackingCheckState();
}

class TrackingCheckState extends State<TrackingCheck> {
  late Future fetchTrackingData;

  @override
  void initState() {
    super.initState();
    fetchTrackingData = fetchData();
  }

  Future fetchData() async {
    final BuildContext ctx = context;
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(ctx, listen: false).selectedLanguage;
    final String userId =
        Provider.of<UserPreferences>(ctx, listen: false).userId;
    final Object body = {
      'title': widget.tracking.title,
      'service': widget.tracking.service,
      'code': widget.tracking.code.trim(),
      'language': texts[0],
    };
    final Response response =
        await HttpConnection.requestHandler('/api/user/$userId/add', body);

    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);

    if (response.statusCode == 200) {
      Provider.of<ActiveTrackings>(ctx, listen: false)
          .loadStartData(ctx, widget.tracking, responseData);
      widget.tracking.checkError = false;
      GlobalToast.displayToast(ctx, texts[240]!);
    } else {
      if (responseData["serverError"] != null) {
        return;
      }
      if (responseData['error'] is String) {
        Provider.of<ActiveTrackings>(ctx, listen: false)
            .removeTracking([widget.tracking], ctx, true);
        responseData['error'] == "No data"
            ? DialogError.show(ctx, 4, widget.tracking.service)
            : DialogError.show(ctx, 1, "");
        return;
      }
      responseData['error']['body'] == "Service timeout"
          ? DialogError.show(ctx, 6, widget.tracking.service)
          : DialogError.show(ctx, 2, "");
      widget.tracking.checkError = true;
    }
    return widget.tracking;
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return FutureBuilder(
      future: fetchTrackingData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data == null
              ? const SizedBox()
              : TrackingItem(snapshot.data as ItemTracking);
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
                    texts[69]!,
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
