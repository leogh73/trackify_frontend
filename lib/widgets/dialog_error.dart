import 'package:flutter/material.dart';

import 'dialog_toast.dart';

class DialogError {
  static void serverError(BuildContext context) {
    ShowDialog.error(
      context,
      "Ocurrió un error en el servidor. La funcionalidad de la aplicación podría estar limitada. Verifique su conexión a internet y/o reintente más tarde.",
      "",
    );
  }

  static void startTrackingError(BuildContext context) {
    ShowDialog.error(
      context,
      "Ocurrió un error al intentar obtener información de éste seguimiento. Verifique los datos ingresados o reintente más tarde.",
      "",
    );
  }

  static void formError(BuildContext context) {
    ShowDialog.error(
      context,
      "Datos faltantes y/o incorrectos.",
      "",
    );
  }

  static void trackingNoData(BuildContext context, service) {
    ShowDialog.error(
      context,
      "$service no tiene información sobre el seguimiento solicitado. Si cree que es un error, reintente más tarde o reclame a la empresa.",
      service,
    );
  }

  static void trackingNoDataRemoved(BuildContext context, service) {
    ShowDialog.error(
      context,
      "$service ya no tiene información sobre el seguimiento solicitado, por lo tanto, ya no podrá chequearse ni actualizarse.",
      service,
    );
  }

  static void serviceTimeout(BuildContext context, String service) {
    ShowDialog.error(
      context,
      "$service no estaría respondiendo. Reintenta más tarde.",
      service,
    );
  }

  static void serverTimeout(BuildContext context) {
    ShowDialog.error(
      context,
      "Nuestro servidor no estaría respondiendo. Reintenta más tarde. Disculpa las molestias.",
      "",
    );
  }

  static void checkUpdateError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo verificar el seguimiento. Reintente más tarde.",
      "",
    );
  }

  static void meLiCheckError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo obtener información desde MercadoLibre. Reintente más tarde.",
      "",
    );
  }

  static void meLiLoginError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo acceder a MercadoLibre. Reintente más tarde.",
      "",
    );
  }

  static void googleLoginError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo acceder a Google. Reintente más tarde.",
      "",
    );
  }

  static void googleDriveError(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo acceder a Google Drive. Reintente más tarde.",
      "",
    );
  }

  static void serviceCAWarning(BuildContext context) {
    ShowDialog.error(
      context,
      "Éste servicio sólo funciona con códigos generados por MercadoLibre. Los códigos generados por Correo Argentino, no pueden agregarse ya que su sitio tiene verificación con reCaptcha. Disculpe las molestias.",
      "",
    );
  }

  static void getUuidCheck(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo obtener identificación para éste dispositivo. Si efectuó un pago, pero reinstaló la aplicación, no se puede actualizar su estado. Use el formulario para contactarnos y proveernos información sobre su pago. Disculpe las molestias.",
      "",
    );
  }

  static void getUuidWarning(BuildContext context) {
    ShowDialog.error(
      context,
      "No se pudo obtener identificación para éste dispositivo. Si efectuó un pago, pero luego reinstala la aplicación, no podrá actualizar su estado. En ese caso, deberá contactarnos y proveernos información sobre su pago.",
      "",
    );
  }

  static void paymentNotFound(BuildContext context) {
    ShowDialog.error(
      context,
      "No se encontraron pagos vinculados a éste dispositivo. Si efectuó un pago, pero reinstaló la aplicación, póngase en contacto con nosotros y proveanos información sobre su pago. Disculpe las molestias.",
      "",
    );
  }

  static void paymentError(BuildContext context) {
    ShowDialog.error(
      context,
      "Ocurrió un error al realizar la operación. Reintente más tarde.",
      "",
    );
  }
}
