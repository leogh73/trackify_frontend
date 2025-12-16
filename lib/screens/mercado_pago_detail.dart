import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

import '../data/http_connection.dart';
import '../data/preferences.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';
import '../widgets/dialog_error.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({super.key});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  bool onProcess = false;

  Widget paymentDetail(
    bool isPortrait,
    double screenWidth,
    Map<String, dynamic> paymentData,
    Map<int, dynamic> texts,
  ) {
    const Map<String, IconData> statusIcon = {
      "approved": Icons.check,
      "pending": Icons.pending,
      "rejected": Icons.cancel_outlined,
      "authorized": Icons.check,
      "cancelled": Icons.cancel,
      "could not be checked": Icons.warning_amber,
    };
    Map<String, String> statusText = {
      "approved": texts[74]!,
      "pending": texts[75]!,
      "rejected": texts[76]!,
      "authorized":
          paymentData["paymentType"] == "simple" ? texts[77]! : texts[78]!,
      "paused": texts[79]!,
      "cancelled": texts[80]!,
      "in_process": texts[81]!,
      "in_mediation": texts[82]!,
      "refunded": texts[83]!,
      "charged_back": texts[84]!,
      "could not be checked": texts[85]!
    };
    final List<List<dynamic>> dataList = [
      [
        Icons.numbers,
        statusIcon[paymentData["status"]] ?? Icons.cancel_outlined,
        Icons.attach_money,
        Icons.calendar_month,
        paymentData["paymentType"] == "simple"
            ? Icons.timelapse
            : Icons.date_range,
        Icons.description_outlined,
      ],
      [
        texts[86]!,
        texts[87]!,
        texts[88]!,
        texts[89]!,
        paymentData["paymentType"] == "simple" ? texts[90]! : texts[91]!,
        texts[92]!
      ],
      [
        paymentData["operationId"].toString(),
        statusText[paymentData["status"]],
        paymentData["paymentType"] == "simple" ? "Simple" : texts[93],
        paymentData["dateCreated"],
        paymentData["paymentType"] == "simple"
            ? paymentData["daysRemaining"].toString()
            : paymentData["billingDay"].toString(),
        paymentData["isValid"].toString() == "true" ? "Si" : "No"
      ],
    ];

    return Container(
      width: isPortrait ? screenWidth * 0.9 : screenWidth * 0.6,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: dataList[0]
                    .map((d) => SizedBox(
                        height: 45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(d, size: 24)],
                        )))
                    .toList(),
              ),
              Column(
                children: dataList[1]
                    .map((d) => SizedBox(
                        height: 45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              d,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            )
                          ],
                        )))
                    .toList(),
              ),
              SizedBox(
                width: isPortrait ? screenWidth * 0.4 : screenWidth * 0.25,
                child: Column(
                  children: dataList[2]
                      .map((d) => SizedBox(
                          height: 45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                d,
                                style: const TextStyle(
                                    fontSize: 17,
                                    overflow: TextOverflow.ellipsis),
                              )
                            ],
                          )))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onProcessToggle() {
    setState(() {
      onProcess = !onProcess;
    });
  }

  Future<void> cancelSubscription() async {
    onProcessToggle();
    final BuildContext ctx = context;
    final String userId =
        Provider.of<UserPreferences>(ctx, listen: false).userId;
    Object body = {'userId': userId};
    final Response response = await HttpConnection.requestHandler(
        "/api/mercadopago/cancelSubscription/", body);
    if (!ctx.mounted) {
      return;
    }
    final Map<String, dynamic> responseData =
        HttpConnection.responseHandler(response, ctx);
    if (response.statusCode == 200) {
      Provider.of<UserPreferences>(ctx, listen: false)
          .setPaymentData(responseData['paymentData']);
    } else {
      if (responseData['serverError'] == null) {
        DialogError.show(ctx, 21, "");
      }
    }
    onProcessToggle();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    final Map<String, dynamic> paymentData = context.select(
        (UserPreferences userPreferences) => userPreferences.paymentData);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Widget divider = Container(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Divider(color: Theme.of(context).primaryColor, thickness: .3));
    final Widget separator = SizedBox(height: isPortrait ? 10 : 15);
    final List<Widget> subscriptionOptions = paymentData['isValid'] == true &&
            paymentData['paymentType'] == "subscription"
        ? [
            separator,
            divider,
            separator,
            Padding(
              padding: isPortrait
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: isPortrait ? 232 : 200,
                child: ElevatedButton(
                  onPressed: cancelSubscription,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cancel_outlined),
                      const SizedBox(width: 20),
                      Text(
                        texts[94]!,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
        : [];
    return Scaffold(
      appBar: AppBar(
        title: Text(texts[95]!),
        titleSpacing: 1.0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: onProcess
            ? SizedBox(
                height: isPortrait ? screenHeight * 0.45 : screenHeight * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        texts[179]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: fullHD ? 16 : 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  if (!premiumUser)
                    const Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: AdNative("small"),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      paymentDetail(
                          isPortrait, screenWidth, paymentData, texts),
                    ],
                  ),
                  ...subscriptionOptions,
                ],
              ),
      ),
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
