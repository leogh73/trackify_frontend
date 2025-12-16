import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:device_uuid/device_uuid.dart';

import '../data/classes.dart';
import '../data/trackings_active.dart';
import '../screens/claim.dart';

import '../database.dart';
import '../data/http_connection.dart';
import '../data/preferences.dart';
import '../data/theme.dart';

import '../widgets/ad_banner.dart';
import '../widgets/ad_native.dart';
import '../widgets/ad_interstitial.dart';
import '../widgets/dialog_error.dart';
import '../widgets/dialog_toast.dart';

class FormContact extends StatefulWidget {
  const FormContact({Key? key}) : super(key: key);

  @override
  State<FormContact> createState() => _FormContactState();
}

class _FormContactState extends State<FormContact> {
  AdInterstitial interstitialAd = AdInterstitial();
  bool premiumUser = false;
  final DeviceUuid _deviceUuidPlugin = DeviceUuid();

  @override
  void initState() {
    super.initState();
    interstitialAd.createInterstitialAd();
  }

  int index = 0;
  late Color mainColor;

  void loadColor() async {
    mainColor =
        UserTheme.getColor[[...await StoredData().loadUserData()][0].color]!;
  }

  final formKey = GlobalKey<FormState>();

  final message = TextEditingController();
  final email = TextEditingController();

  @override
  void dispose() {
    message.dispose();
    email.dispose();
    super.dispose();
  }

  void sendRequest(bool fullHD, Map<int, dynamic> texts) async {
    late String uuid;
    try {
      uuid = await _deviceUuidPlugin.getUUID() ?? '';
    } catch (e) {
      // print("Error getting UUID: $e");
    }
    if (!mounted) {
      return;
    }
    if (formKey.currentState?.validate() == false) {
      DialogError.show(context, 3, "");
      return;
    } else {
      ShowDialog.waiting(context, texts[20]!, texts);
      String requestEmail = 'Sin datos';
      if (email.text.isNotEmpty) requestEmail = email.text;
      final String userId =
          Provider.of<UserPreferences>(context, listen: false).userId;
      final Object body = {
        'userId': userId,
        'uuid': uuid,
        'message': message.text,
        'email': requestEmail,
      };
      final Response response =
          await HttpConnection.requestHandler('/api/user/contact/', body);
      setState(() {
        index = 4;
        if (response.statusCode == 200) index = 1;
        if (response.statusCode == 403) index = 2;
        if (response.statusCode == 400) index = 3;
      });
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      final List<ItemTracking> trackingsList =
          Provider.of<ActiveTrackings>(context, listen: false).trackings;
      if (!premiumUser && trackingsList.isNotEmpty) {
        interstitialAd.showInterstitialAd();
        ShowDialog.goPremiumDialog(context);
      }
    }
  }

  Widget requestForm(bool fullHD, Map<int, dynamic> texts) {
    final MaterialColor mainColor =
        Provider.of<UserTheme>(context, listen: false).startColor;
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: premiumUser ? null : const AdNative("small"),
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        texts[21]!,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fullHD ? 17 : 16,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                          hintText: texts[22],
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 1,
                            color: mainColor,
                          ))),
                      controller: message,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return texts[23];
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 5),
                        labelText: texts[24],
                      ),
                      controller: email,
                      textInputAction: TextInputAction.next,
                      autofocus: false,
                      validator: (value) {
                        if (value == null || !value.contains("@")) {
                          return texts[25];
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                                child: Text(
                                  texts[26]!,
                                  style: const TextStyle(fontSize: 17),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (!premiumUser &&
                                      trackingsList.isNotEmpty) {
                                    interstitialAd.showInterstitialAd();
                                    ShowDialog.goPremiumDialog(context);
                                  }
                                }),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                                child: Text(
                                  texts[27]!,
                                  style: const TextStyle(fontSize: 17),
                                ),
                                onPressed: () {
                                  sendRequest(fullHD, texts);
                                  if (!premiumUser &&
                                      trackingsList.isNotEmpty) {
                                    interstitialAd.showInterstitialAd();
                                    ShowDialog.goPremiumDialog(context);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (premiumUser) const SizedBox(width: 50, height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sendResult(
      String text1, String text2, bool success, Map<int, dynamic> texts) {
    final List<ItemTracking> trackingsList =
        Provider.of<ActiveTrackings>(context, listen: false).trackings;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(success ? Icons.done_all : Icons.error_outline, size: 80),
        if (success)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text1,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            text2,
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            child: Text(
              texts[28]!,
              style: const TextStyle(fontSize: 17),
            ),
            onPressed: () {
              if (!premiumUser && trackingsList.isNotEmpty) {
                interstitialAd.showInterstitialAd();
              }
              Navigator.pop(context);
              if (index == 3) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ServiceClaim("")));
              }
            },
          ),
        ),
      ],
    );
  }

  void togglePremiumStatus() {
    setState(() {
      premiumUser = !premiumUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, dynamic> texts = context.select(
        (UserPreferences userPreferences) => userPreferences.selectedLanguage);
    final bool premiumUser = context.select(
        (UserPreferences userPreferences) => userPreferences.premiumStatus);
    if (premiumUser != premiumUser) {
      togglePremiumStatus();
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    final Map<int, Widget> results = {
      0: requestForm(fullHD, texts),
      1: sendResult(texts[29]!, texts[30]!, true, texts),
      2: sendResult('', texts[31]!, false, texts),
      3: sendResult('', texts[32]!, false, texts),
      4: sendResult('', texts[33]!, false, texts)
    };
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        title: Text(texts[34]!),
        actions: [
          if (index == 0)
            IconButton(
              icon: const Icon(Icons.send),
              iconSize: 26,
              onPressed: () => sendRequest(fullHD, texts),
            ),
        ],
      ),
      body: results[index],
      bottomNavigationBar: premiumUser ? null : const AdBanner(),
    );
  }
}
