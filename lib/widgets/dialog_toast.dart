import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:trackify/widgets/showStatusMessage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../providers/status.dart';

class ShowDialog {
  static bool fullHD(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return fullHD;
  }

  static void show(
    bool error,
    bool statusMessage,
    bool premiumSubscription,
    BuildContext context,
    List<Widget> contentWidgets,
    List<Map<String, dynamic>> buttonsWidgets,
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
                    child: Text(
                      button['text'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fullHD(context) ? 16 : 15,
                      ),
                    ),
                    onPressed: button['function'],
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
          content: Container(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...contentWidgets,
                if (statusMessage) ShowAgainStatusMessage(),
                if (error)
                  Container(
                    height: 55,
                    width: 110,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton(
                      child: Text(
                        "Cerrar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD(context) ? 16 : 15,
                        ),
                      ),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: premiumSubscription ? [] : buttonsList,
                ),
                if (premiumSubscription) ...buttonsList,
              ],
            ),
          ),
        );
      },
    );
  }

  static void actionConfirmation(
    BuildContext context,
    String action,
    String buttonText,
    VoidCallback buttonFunction,
  ) {
    show(
      false,
      false,
      false,
      context,
      [
        Container(
          padding: EdgeInsets.only(top: 6, bottom: 8),
          child: Text(
            action != "archivar"
                ? "¿Confirma $action?"
                : "¿Confirma archivar? Ésta acción no puede deshacerse.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
      [
        {
          "width": 110,
          "text": "Cancelar",
          "function": () => Navigator.pop(context),
        },
        {"width": 110, "text": buttonText, "function": buttonFunction},
      ],
    );
  }

  static void styleDialog(
    BuildContext context,
    bool isPortrait,
    Widget widget,
  ) {
    show(
      false,
      false,
      false,
      context,
      [widget],
      [
        {
          "width": 110,
          "text": "Aceptar",
          "function": () => Navigator.pop(context),
        }
      ],
    );
  }

  static void error(BuildContext context, String message) {
    show(
      true,
      false,
      false,
      context,
      [
        Container(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(Icons.error_outline, size: 55)),
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
    );
  }

  static void statusMessage(BuildContext context, String message) {
    show(
      true,
      true,
      false,
      context,
      [
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(Icons.error_outline, size: 55),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ],
      [],
    );
  }

  static void sending(BuildContext context) {
    show(
      false,
      false,
      false,
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
          'Enviando...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: fullHD(context) ? 16 : 15,
          ),
        ),
      ],
      [],
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

  static void aboutThisApp(BuildContext context) {
    final bool fHD = fullHD(context);

    List<Widget> textsData = [
      Text(
        "TrackeAR",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fHD ? 19 : 18,
        ),
      ),
      Text(
        "Versión 1.1.5",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fHD ? 16 : 15,
        ),
      ),
    ];
    List<Widget> contentWidgets = textsData
        .map((widget) => Container(
              width: 245,
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: widget,
            ))
        .toList();

    List<Map<String, dynamic>> linksData = [
      {
        "text": "Política de privacidad",
        "onTap": launchPrivacyPolicy,
      },
      {
        "text": "Califíquenos",
        "onTap": launchPlayStore,
      },
      {
        "text": "Licencias",
        "onTap": () => {
              Navigator.pop(context),
              showLicensePage(
                applicationName: 'TrackeAR',
                context: context,
                applicationIcon:
                    Image.asset("assets/icon/icon.png", height: 35, width: 35),
                applicationVersion: '1.1.5',
              ),
            },
      },
    ];

    List<Widget> linksWidgets = linksData
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
      false,
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
          "text": "Cerrar",
          "function": () => {
                Navigator.pop(context),
              },
        }
      ],
    );
  }

  static void premiumSubscription(BuildContext context) {
    final fHD = fullHD(context);
    final List<Widget> widgetsData = [
      Text(
        "Suscripción Premium",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fHD ? 18 : 17,
        ),
      ),
      Text(
        "Por sólo 2 dólares al mes, puedes utilizar TrackeAR sin ningún tipo de publicidad. Si ya tienes suscripción, sigue los pasos para actualizar la aplicación.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fHD ? 16 : 15,
        ),
      ),
    ];

    List<Widget> contentWidgets = widgetsData
        .map(
          (text) => Container(
            width: 225,
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: text,
          ),
        )
        .toList();
    contentWidgets.insert(
      0,
      Container(
        padding: const EdgeInsets.only(top: 6),
        child: Icon(Icons.workspace_premium, size: 50),
      ),
    );

    List<Map<String, dynamic>> buttonsData = [
      {
        "width": 190,
        "text": "Comprar suscripción",
        "function": () => Navigator.pop(context)
      },
      {
        "width": 190,
        "text": "Ya tengo suscripción",
        "function": () => {Navigator.pop(context)}
      }
    ];

    show(
      false,
      false,
      true,
      context,
      contentWidgets,
      buttonsData,
    );
  }

  static void deleteDriveBackup(BuildContext context, String backupId) {
    show(
      false,
      false,
      false,
      context,
      [
        Container(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(Icons.error_outline, size: 55)),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text(
            '¿Desea eliminar éste respaldo? Ésta acción no puede deshacerse.',
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
    );
  }

  static void restoreDriveBackup(
    BuildContext context,
    String selectedBackup,
    List<Widget> content,
    VoidCallback restoreFunction,
  ) {
    show(
      false,
      false,
      false,
      context,
      [...content],
      [
        {
          "width": 110,
          "text": "Cancelar",
          "function": () => Navigator.pop(context),
        },
        {
          "width": 110,
          "text": "Eliminar",
          "function": restoreFunction,
        },
      ],
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
      // Animation duration   animDuration * 2 <= duration
      animDuration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.fastOutSlowIn,
    );
  }
}
