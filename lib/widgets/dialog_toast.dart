import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:trackify/data/preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../screens/claim.dart';
import '../screens/premium.dart';
import '../widgets/show_message_again.dart';
import '../data/status.dart';

class ShowDialog {
  static bool fullHD(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return fullHD;
  }

  static void show(
    bool error,
    bool showAgain,
    String messageType,
    String serviceError,
    BuildContext context,
    List<Widget> contentWidgets,
    List<Map<String, dynamic>> buttonsWidgets,
    Map<int, dynamic> texts,
  ) {
    List<Widget> buttonsList = buttonsWidgets
        .map((button) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 55,
                  width: button["width"].toDouble(),
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: ElevatedButton(
                    onPressed: button['function'],
                    child: Text(
                      button['text'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fullHD(context) ? 16 : 15,
                      ),
                    ),
                  ),
                )
              ],
            ))
        .toList();

    showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...contentWidgets,
                if (showAgain) const ShowPaymentMessageAgain(),
                if (serviceError.isNotEmpty)
                  Container(
                    height: 55,
                    width: 110,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton(
                      child: Text(
                        texts[193]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD(dialogContext) ? 16 : 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.push(
                          dialogContext,
                          MaterialPageRoute(
                            builder: (_) => ServiceClaim(serviceError),
                          ),
                        );
                      },
                    ),
                  ),
                if (error || showAgain)
                  Container(
                    height: 55,
                    width: 110,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton(
                      child: Text(
                        texts[233]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD(dialogContext) ? 16 : 15,
                        ),
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: buttonsList,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void actionConfirmation(BuildContext context, String action,
      String buttonText, VoidCallback buttonFunction, Map<int, dynamic> texts) {
    show(
      false,
      false,
      "",
      '',
      context,
      [
        Container(
          padding: const EdgeInsets.only(top: 6, bottom: 8),
          child: Text(
            action != texts[190] ? "¿${texts[234]} $action?" : texts[235]!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
      [
        {
          "width": 110,
          "text": texts[18]!,
          "function": () => Navigator.pop(context),
        },
        {"width": 110, "text": buttonText, "function": buttonFunction},
      ],
      texts,
    );
  }

  static void styleDialog(BuildContext context, bool isPortrait, Widget widget,
      Map<int, dynamic> texts) {
    show(
      false,
      false,
      "",
      '',
      context,
      [widget],
      [
        {
          "width": 110,
          "text": texts[233],
          "function": () => Navigator.pop(context),
        }
      ],
      texts,
    );
  }

  static void error(BuildContext context, String message, String service,
      Map<int, dynamic> texts) {
    show(
      true,
      false,
      "",
      service,
      context,
      [
        Container(
            padding: const EdgeInsets.only(top: 5),
            child: const Icon(Icons.error_outline, size: 55)),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fullHD(context) ? 16 : 15,
            ),
          ),
        )
      ],
      [],
      texts,
    );
  }

  static void showMessage(BuildContext context, String message, String type,
      Map<int, dynamic> texts) {
    show(
      true,
      true,
      type,
      '',
      context,
      [
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: const Icon(Icons.error_outline, size: 55),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ],
      [],
      texts,
    );
  }

  static void waiting(
      BuildContext context, String message, Map<int, dynamic> texts) {
    show(
      false,
      false,
      "",
      '',
      context,
      [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 25),
          child: const SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ),
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: fullHD(context) ? 16 : 15,
          ),
        ),
      ],
      [],
      texts,
    );
  }

  static Future<void> launchPrivacyPolicy() async {
    String url = "https://trackify-frontend.vercel.app/PRIVACY_POLICY.md";
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchPlayStore() async {
    String url =
        "https://play.google.com/store/apps/details?id=com.leogh73.trackify";
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  static void goPremiumDialog(BuildContext context) {
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    show(
      true,
      false,
      "",
      '',
      context,
      [
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(Icons.workspace_premium,
              size: 55, color: Theme.of(context).primaryColor),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            texts[150],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: 110,
          child: ElevatedButton(
            child: Text(
              texts[251]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fullHD(context) ? 16 : 15,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Premium(),
                ),
              );
            },
          ),
        ),
      ],
      [],
      texts,
    );
  }

  static void mustUpdateDialog(BuildContext context) {
    final Map<int, dynamic> texts =
        Provider.of<UserPreferences>(context, listen: false).selectedLanguage;
    show(
      true,
      false,
      "",
      '',
      context,
      [
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: const Icon(Icons.error, size: 55),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            texts[256],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: 110,
          child: ElevatedButton(
            child: Text(
              texts[257]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fullHD(context) ? 16 : 15,
              ),
            ),
            onPressed: () => launchPlayStore(),
          ),
        ),
      ],
      [],
      texts,
    );
  }

  static void aboutThisApp(
      BuildContext context, bool premiumUser, Map<int, dynamic> texts) {
    final bool fHD = fullHD(context);
    final List<Widget> textsData = [
      Text(
        "TrackeAR",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fHD ? 19 : 18,
        ),
      ),
      Text(
        "Versión 1.3.5 ${premiumUser ? 'Premium ' : ''}",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fHD ? 16 : 15,
        ),
      ),
    ];
    final List<Widget> contentWidgets = textsData
        .map((widget) => Container(
              width: 245,
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: widget,
            ))
        .toList();

    final List<Map<String, dynamic>> linksData = [
      {
        "text": texts[236],
        "onTap": launchPrivacyPolicy,
      },
      {
        "text": texts[237],
        "onTap": launchPlayStore,
      },
      {
        "text": texts[238],
        "onTap": () => {
              Navigator.pop(context),
              showLicensePage(
                applicationName: 'TrackeAR',
                context: context,
                applicationIcon:
                    Image.asset("assets/icon/icon.png", height: 35, width: 35),
                applicationVersion: '1.2.0',
              ),
            },
      },
    ];

    final List<Widget> linksWidgets = linksData
        .map(
          (link) => Container(
            width: 245,
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: link["text"],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = link["onTap"],
                  )
                ])),
          ),
        )
        .toList();

    show(
      false,
      false,
      "",
      '',
      context,
      [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Image.asset("assets/icon/icon.png", height: 35, width: 35),
        ),
        ...contentWidgets,
        ...linksWidgets,
      ],
      [
        {
          "width": 110,
          "text": texts[233],
          "function": () => {
                Navigator.pop(context),
              },
        }
      ],
      texts,
    );
  }

  static void deleteDriveBackup(
      BuildContext context, String backupId, Map<int, dynamic> texts) {
    show(
      false,
      false,
      "",
      '',
      context,
      [
        Container(
            padding: const EdgeInsets.only(top: 5),
            child: const Icon(Icons.error_outline, size: 55)),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            texts[239]!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fullHD(context) ? 16 : 15,
            ),
          ),
        )
      ],
      [
        {
          "width": 110,
          "text": "Cancelar",
          "function": () => Navigator.pop(context),
        },
        {
          "width": 110,
          "text": "Eliminar",
          "function": () => {
                Navigator.of(context).pop(),
                Provider.of<Status>(context, listen: false)
                    .deleteBackup(context, backupId),
              },
        },
      ],
      texts,
    );
  }

  static void restoreDriveBackup(
      BuildContext context,
      String selectedBackup,
      List<Widget> content,
      VoidCallback restoreFunction,
      Map<int, dynamic> texts) {
    show(
      false,
      false,
      "",
      '',
      context,
      [...content],
      [
        {
          "width": 110,
          "text": texts[26],
          "function": () => Navigator.pop(context),
        },
        {
          "width": 110,
          "text": texts[191],
          "function": restoreFunction,
        },
      ],
      texts,
    );
  }
}

class GlobalToast {
  static displayToast(BuildContext context, String message) {
    showToast(
      message,
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(20),
      textAlign: TextAlign.center,
      textStyle: const TextStyle(color: Colors.white, fontSize: 17),
      animation: StyledToastAnimation.scale,
      startOffset: const Offset(0.0, 5.0),
      reverseEndOffset: const Offset(0.0, 5.0),
      position: StyledToastPosition.center,
      duration: const Duration(seconds: 4),
      animDuration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.fastOutSlowIn,
    );
  }
}
