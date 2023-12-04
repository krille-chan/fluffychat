
import 'package:flutter/foundation.dart';

import '../utils/p_toast.dart';

class ApiException {
  static exception({required int statusCode, required String body}) {
    switch (statusCode) {
      case 400:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(msg: "Unknown error accrued", success: false);
        return;
      case 401:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(
            msg: "Exception: Unauthorized access", success: false,);

        return;
      case 403:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(
            msg: "Exception: Don't have permissions!", success: false,);
        return;
      case 500:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(
            msg: "Exception: Internal Server Error", success: false,);
        return;
      case 502:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(
            msg: "Exception: Bad Gateway", success: false,);

        return;
      case 503:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(
            msg: "Exception: Service Unavailable", success: false,);

        return;
      case 504:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(
            msg: "Exception: Gateway timeout error!", success: false,);

        return;
      default:
        if (kDebugMode) {
          debugPrint(body);
          debugPrint(statusCode.toString());
        }
        PToastController.toastMsg(
            msg: "Unknown exception accrued!", success: false,);
        return;
    }
  }
}
