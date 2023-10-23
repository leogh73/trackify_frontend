import 'package:flutter/material.dart';

import 'dialog_toast.dart';

class DialogError {
  static void serverError(BuildContext context) {
    ShowDialog.error(
      context,
      "Ocurrió un error en el servidor. La funcionalidad de la aplicación podría estar limitada. Verifique su conexión a internet y/o reintente más tarde.",
    );
  }

  static void startTrackingError(BuildContext context) {
    ShowDialog.error(
      context,
      "Ocurrió un error al obtener datos de éste seguimiento. Verifique los datos ingresados o reintente más tarde.",
    );
  }

  static void formError(BuildContext context) {
    ShowDialog.error(
      context,
      "Datos faltantes y/o incorrectos.",
    );
  }

  static void trackingNoData(BuildContext context, service) {
    ShowDialog.error(
      context,
      "$service no tiene información sobre el seguimiento solicitado.",
    );
  }

  static void trackingNoDataRemoved(BuildContext context, service) {
    ShowDialog.error(
      context,
      "$service ya no tiene información sobre el seguimiento solicitado, por lo tanto, ya no podrá chequearse ni actualizarse.",
    );
  }

  static void serviceTimeout(BuildContext context, String service) {
    ShowDialog.error(
      context,
      "$service no estaría respondiendo. Reintenta más tarde.",
    );
  }

  static void serverTimeout(BuildContext context) {
    ShowDialog.error(
      context,
      "Nuestro servidor no estaría respondiendo. Reintenta más tarde. Disculpa las molestias.",
    );
  }

  static void checkUpdateError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo verificar el seguimiento. Reintente más tarde.",
    );
  }

  static void meLiCheckError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo obtener información desde MercadoLibre. Reintente más tarde.",
    );
  }

  static void meLiLoginError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo acceder a MercadoLibre. Reintente más tarde.",
    );
  }

  static void googleLoginError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo acceder a Google. Reintente más tarde.",
    );
  }

  static void googleDriveError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo acceder a Google Drive. Reintente más tarde.",
    );
  }

  static void serviceCAWarning(BuildContext context) {
    ShowDialog.error(
      context,
      "Éste servicio sólo funciona con códigos generados por MercadoLibre. Los códigos generados por Correo Argentino, no pueden agregarse ya que su sitio tiene verificación con reCaptcha. Disculpe las molestias.",
    );
  }

  static void startError(BuildContext context, String type) {
    String message = '';
    if (type == "User not initialized") {
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
    ShowDialog.error(context, message);
  }
}
