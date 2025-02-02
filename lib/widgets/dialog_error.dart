import 'package:flutter/material.dart';
import 'dialog_toast.dart';

class DialogError {
  static void show(BuildContext context, int errorNumber, String service) {
    ShowDialog.error(
      context,
      service.isEmpty
          ? messages[errorNumber]!
          : messages[errorNumber]!.replaceAll("service", service),
      service,
    );
  }

  static const Map<int, String> messages = {
    1: "Ocurrió un error en el servidor. La funcionalidad de la aplicación podría estar limitada. Verifique su conexión a internet y/o reintente más tarde.",
    2: "Ocurrió un error al intentar obetener información de éste seguimiento. Verifique los datos ingresados o reintente más tarde.",
    3: "Datos faltantes y/o incorrectos.",
    4: "service no tiene información sobre el seguimiento solicitado. Si cree que es un error, reintente más tarde o reclame a la empresa.",
    5: "service ya no tendría información sobre el seguimiento solicitado, por lo tanto, ya no podrá chequearse ni actualizarse. Podría ser un error del sitio, reintente más tarde.",
    6: "service no estaría respondiendo. Reintenta más tarde.",
    7: "Nuestro servidor no estaría respondiendo. Reintenta más tarde. Disculpa las molestias.",
    8: "No se pudo verificar el seguimiento. Reintente más tarde.",
    9: "No se pudo obtener información desde MercadoLibre. Reintente más tarde.",
    10: "No se pudo acceder a MercadoLibre. Reintente más tarde.",
    11: "No se pudo acceder a Google. Reintente más tarde.",
    12: "No se pudo acceder a Google Drive. Reintente más tarde.",
    13: "Éste servicio sólo funciona con códigos generados por MercadoLibre. Los códigos generados por Correo Argentino, no pueden agregarse ya que su sitio tiene verificación con reCaptcha. Disculpe las molestias.",
    14: "No se pudo obtener identificación para éste dispositivo. Si efectuó un pago, pero reinstaló la aplicación, no se puede actualizar su estado. Envíe el número de transacción de su comprobante, desde la sección 'INGRESAR PAGO', para actualizar su estado.",
    15: "No se pudo obtener identificación para éste dispositivo. Si efectuó un pago, pero luego reinstala la aplicación, deberá ingresar el número de transacción de su comprobante,desde la sección 'INGRESAR PAGO', para actualizar su estado.",
    16: "No se encontraron pagos vinculados a éste dispositivo. Si efectuó un pago, pero reinstaló la aplicación, ingrese el número de transacción que figura en su comprobante.",
    17: "Pago no encontrado. Verifique el número de transacción ingresado o reintente más tarde.",
    18: "No se ha asociado ningún pago a éste dipositivo.",
    19: "Pago no válido.",
    20: "Pago encontrado no válido.",
    21: "Ocurrió un error al realizar la operación. Reintente más tarde.",
  };
}
