import 'package:flutter/material.dart';
import 'dialog_toast.dart';

class DialogError {
  static const Map<int, String> messages = {
    1: "Ocurrió un error en el servidor. La funcionalidad de la aplicación podría estar limitada. Verifique su conexión a internet y/o reintente más tarde.",
    2: "Ocurrió un error en el servidor. La funcionalidad de la aplicación podría estar limitada. Verifique su conexión a internet y/o reintente más tarde.",
    3: "Datos faltantes y/o incorrectos.",
    4: "service no tiene información sobre el seguimiento solicitado. Si cree que es un error, reintente más tarde o reclame a la empresa.",
    5: "service ya no tiene información sobre el seguimiento solicitado, por lo tanto, ya no podrá chequearse ni actualizarse.",
    6: "service no estaría respondiendo. Reintenta más tarde.",
    7: "Nuestro servidor no estaría respondiendo. Reintenta más tarde. Disculpa las molestias.",
    8: "No se pudo verificar el seguimiento. Reintente más tarde.",
    9: "No se pudo obtener información desde MercadoLibre. Reintente más tarde.",
    10: "No se pudo acceder a MercadoLibre. Reintente más tarde.",
    11: "No se pudo acceder a Google. Reintente más tarde.",
    12: "No se pudo acceder a Google Drive. Reintente más tarde.",
    13: "Éste servicio sólo funciona con códigos generados por MercadoLibre. Los códigos generados por Correo Argentino, no pueden agregarse ya que su sitio tiene verificación con reCaptcha. Disculpe las molestias.",
    14: "No se pudo obtener identificación para éste dispositivo. Si efectuó un pago, pero reinstaló la aplicación, no se puede actualizar su estado. Use el formulario para contactarnos y proveernos información sobre su pago. Disculpe las molestias.",
    15: "No se pudo obtener identificación para éste dispositivo. Si efectuó un pago, pero luego reinstala la aplicación, deberá ingresar el número de transacción de su comprobante para actualizar su estado.",
    16: "No se encontraron pagos vinculados a éste dispositivo. Si efectuó un pago, pero reinstaló la aplicación, ingrese el número de transacción que figura en su comprobante.",
    17: "Pago no encontrado. Verifique el número de transacción ingresado o reintente más tarde.",
    18: "No se ha asociado ningún pago a éste dipositivo.",
    19: "Pago no válido.",
    20: "Pago encontrado no válido.",
    21: "Ocurrió un error al realizar la operación. Reintente más tarde.",
    22: "No se pudo verificar el pago asociado a éste dispositivo, su estado Premium fue desactivado. Si el problema persiste, pongasé en contacto con nosotros."
  };

  static void serverError(BuildContext context) {
    ShowDialog.error(context, messages[1]!, "");
  }

  static void startTrackingError(BuildContext context) {
    ShowDialog.error(context, messages[2]!, "");
  }

  static void formError(BuildContext context) {
    ShowDialog.error(context, messages[3]!, "");
  }

  static void trackingNoData(BuildContext context, String service) {
    ShowDialog.error(
        context, messages[4]!.replaceAll("service", service), service);
  }

  static void trackingNoDataRemoved(BuildContext context, String service) {
    ShowDialog.error(
        context, messages[5]!.replaceAll("service", service), service);
  }

  static void serviceTimeout(BuildContext context, String service) {
    ShowDialog.error(
        context, messages[6]!.replaceAll("service", service), service);
  }

  static void serverTimeout(BuildContext context) {
    ShowDialog.error(context, messages[7]!, "");
  }

  static void checkUpdateError(BuildContext context) {
    ShowDialog.error(context, messages[8]!, "");
  }

  static void meLiCheckError(BuildContext context) {
    ShowDialog.error(context, messages[9]!, "");
  }

  static void meLiLoginError(BuildContext context) {
    ShowDialog.error(context, messages[10]!, "");
  }

  static void googleLoginError(BuildContext context) {
    ShowDialog.error(context, messages[11]!, "");
  }

  static void googleDriveError(BuildContext context) {
    ShowDialog.error(context, messages[12]!, "");
  }

  static void serviceCAWarning(BuildContext context) {
    ShowDialog.error(context, messages[13]!, "");
  }

  static void getUuidCheck(BuildContext context) {
    ShowDialog.error(context, messages[14]!, "");
  }

  static void getUuidWarning(BuildContext context) {
    ShowDialog.error(context, messages[15]!, "");
  }

  static void devicePaymentNotFound(BuildContext context) {
    ShowDialog.error(context, messages[16]!, "");
  }

  static void paymentNotFound(BuildContext context) {
    ShowDialog.error(context, messages[17]!, "");
  }

  static void paymentDetailNotFound(BuildContext context) {
    ShowDialog.error(context, messages[18]!, "");
  }

  static void paymentNotValid(BuildContext context) {
    ShowDialog.error(context, messages[19]!, "");
  }

  static void paymentValidNotFound(BuildContext context) {
    ShowDialog.error(context, messages[20]!, "");
  }

  static void paymentError(BuildContext context) {
    ShowDialog.error(context, messages[21]!, "");
  }

  static void paymentCheckError(BuildContext context) {
    ShowDialog.error(context, messages[22]!, "");
  }
}
