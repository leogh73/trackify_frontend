import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ShowDialog {
  final BuildContext context;
  ShowDialog(this.context);

  bool fullHD() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool fullHD =
        screenWidth * MediaQuery.of(context).devicePixelRatio > 1079;
    return fullHD;
  }

  Future<void> _launchPrivacyPolicy() async {
    String url = "https://trackify-frontend.vercel.app/PRIVACY_POLICY.md";
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchPlayStore() async {
    String url =
        "https://play.google.com/store/apps/details?id=com.leogh73.trackify";
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void errorDialog(String message, bool disabledUser) {
    showDialog<String>(
      context: context,
      barrierDismissible: !disabledUser,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(Icons.error_outline, size: 45),
              ),
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fullHD() ? 16 : 15,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    padding: const EdgeInsets.only(bottom: 9, top: 0),
                    child: ElevatedButton(
                      child: Text(
                        'Aceptar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD() ? 16 : 15,
                        ),
                      ),
                      onPressed: () => {
                        _launchPlayStore,
                        Navigator.pop(context),
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void loadDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 5, left: 5),
          content: Container(
            height: 100,
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Validando acceso...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 200, child: LinearProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }

  void aboutThisApp(bool fullHD) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          contentPadding:
              const EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 5),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child:
                    Image.asset("assets/icon/icon.png", height: 35, width: 35),
              ),
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: Text(
                  "TrackeAR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fullHD ? 18 : 17,
                  ),
                ),
              ),
              //
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: Text(
                  "Versión 1.0.3",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fullHD ? 16 : 15,
                  ),
                ),
              ),
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Política de privacidad',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchPrivacyPolicy,
                      )
                    ])),
              ),
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Califíquenos',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _launchPlayStore,
                      )
                    ])),
              ),
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Licencias',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => {
                                Navigator.pop(context),
                                showLicensePage(
                                  applicationName: 'TrackeAR',
                                  context: context,
                                  applicationIcon: Image.asset(
                                      "assets/icon/icon.png",
                                      height: 35,
                                      width: 35),
                                  applicationVersion: '1.0.3',
                                ),
                              },
                      )
                    ])),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 110,
                    padding: const EdgeInsets.only(bottom: 9, top: 0),
                    child: ElevatedButton(
                      child: Text(
                        'Cerrar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fullHD ? 16 : 15,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void connectionServerError(start) {
    errorDialog(
      "Ocurrió un error de conexión al servidor. La funcionalidad de la aplicación podría estar limitada. Verifique su conexión a internet y/o reintente más tarde.",
      false,
    );
  }

  void startTrackingError() {
    errorDialog(
      "Ocurrió un error al obtener datos de éste seguimiento. Verifique el código ingresado o reintente más tarde.",
      false,
    );
  }

  void formError() {
    errorDialog(
      "Datos faltantes y/o incorrectos.",
      false,
    );
  }

  void trackingError(service) {
    errorDialog(
      "$service no tiene información sobre el seguimiento solicitado.",
      false,
    );
  }

  void checkUpdateError() {
    errorDialog(
      "No se pudo verificar el seguimiento. Reintente más tarde.",
      false,
    );
  }

  void meLiCheckError() {
    errorDialog(
      "No se pudo obtener información desde MercadoLibre. Reintente más tarde.",
      false,
    );
  }

  void meLiLoginError() {
    errorDialog(
      "No se pudo acceder a MercadoLibre. Reintente más tarde.",
      false,
    );
  }

  void googleLoginError() {
    errorDialog(
      "No se pudo acceder a Google. Reintente más tarde.",
      false,
    );
  }

  void googleDriveError() {
    errorDialog(
      "No se pudo acceder a Google Drive. Reintente más tarde.",
      false,
    );
  }

  void serviceCAWarning() {
    errorDialog(
      "Éste servicio sólo funciona con códigos generados por MercadoLibre. Los códigos generados por Correo Argentino, no pueden agregarse ya que su sitio tiene verificación con reCaptcha. Disculpe las molestias.",
      false,
    );
  }

  void loading() {
    loadDialog();
  }

  void about() {
    aboutThisApp(fullHD());
  }

  void startError(String type) {
    String message = '';
    if (type == "User not created") {
      message =
          "Ocurrió un error de conexión, debido al cual, la aplicación se instaló incorrectamente y no la podrá utilizar. Verifique su conexión a internet y reintente instalarla más tarde.";
    }
    if (type == "User not found") {
      message =
          "Ésta instalación de la aplicación fue deshabilitada por inactividad. Para poder utilizarla nuevamente, eliminelá y vuelva a instalarla.";
    }
    if (type == "Lastest version not found") {
      message =
          "Para poder utlizar ésta aplicación, descargue la última versión desde la Play Store.";
    }
    errorDialog(message, true);
  }
}

class GlobalToast {
  final BuildContext context;
  final String message;
  GlobalToast(this.context, this.message);

  displayToast() {
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
