import 'package:flutter/material.dart';
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

  void errorDialog(String message, bool disabledUser, bool fullHD) {
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
                    fontSize: fullHD ? 16 : 15,
                  ),
                ),
              ),
              if (!disabledUser)
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
                  "Trackify",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fullHD ? 16 : 15,
                  ),
                ),
              ),
              Container(
                width: 245,
                padding: const EdgeInsets.only(bottom: 12, top: 8),
                child: Text(
                  "Versión 1.0.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fullHD ? 16 : 15,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 110,
                    padding: const EdgeInsets.only(bottom: 9, top: 0),
                    child: ElevatedButton(
                        child: Text(
                          'Licencias',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fullHD ? 16 : 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showLicensePage(
                            context: context,
                            applicationIcon: Image.asset("assets/icon/icon.png",
                                height: 35, width: 35),
                            applicationVersion: '1.0.0',
                          );
                        }),
                  ),
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

  void startCheckError() {
    errorDialog(
      "Ocurrió un error al obtener datos de éste seguimiento. Verifique el código ingresado o reintente más tarde.",
      false,
      fullHD(),
    );
  }

  void connectionError() {
    errorDialog(
      "Ocurrió un error con tu conexión a internet. Verifica tu conexión e intenta nuevamente.",
      false,
      fullHD(),
    );
  }

  void formError() {
    errorDialog(
      "Datos faltantes y/o incorrectos.",
      false,
      fullHD(),
    );
  }

  void trackingError(service) {
    errorDialog(
      "$service no tiene información sobre el seguimiento solicitado.",
      false,
      fullHD(),
    );
  }

  void checkUpdateError() {
    errorDialog(
      "No se pudo verificar el seguimiento. Reintente más tarde.",
      false,
      fullHD(),
    );
  }

  void meLiCheckError() {
    errorDialog(
      "No se pudo obtener información desde MercadoLibre. Reintente más tarde.",
      false,
      fullHD(),
    );
  }

  void meLiLoginError() {
    errorDialog(
      "No se pudo acceder a MercadoLibre. Reintente más tarde.",
      false,
      fullHD(),
    );
  }

  void googleLoginError() {
    errorDialog(
      "No se pudo acceder a Google. Reintente más tarde.",
      false,
      fullHD(),
    );
  }

  void googleDriveError() {
    errorDialog(
      "No se pudo acceder a Google Drive. Reintente más tarde.",
      false,
      fullHD(),
    );
  }

  void disabledUserError() {
    errorDialog(
      "Ésta instalación de la aplicación fue deshabilitada por inactividad. Para poder utilizarla nuevamente, eliminelá y vuelva a instalarla.",
      true,
      fullHD(),
    );
  }

  void loading() {
    loadDialog();
  }

  void about() {
    aboutThisApp(fullHD());
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
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToBottom,
      startOffset: const Offset(0.0, 3.0),
      reverseEndOffset: const Offset(0.0, 3.0),
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 4),
      // Animation duration   animDuration * 2 <= duration
      animDuration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.fastOutSlowIn,
    );
  }
}
