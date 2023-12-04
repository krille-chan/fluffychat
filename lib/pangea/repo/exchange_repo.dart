import 'package:flutter/material.dart';

class PExchangeRepo {
  static fetchExchangeClassInfo(String exchangePangeaId) async {}

  static saveExchangeRecord(
    String requestFromClass,
    String requestToClass,
    String requestTeacher,
    String requestToClassAuthor,
    String exchangePangeaId,
  ) async {}

  static exchangeRejectRequest(String roomId, String teacherName) async {}

  static validateExchange({
    required String requestFromClass,
    required String requestToClass,
    required BuildContext context,
  }) async {}

  static createExchangeRequest({
    required String roomId,
    required String teacherID,
    required String toClass,
    required BuildContext context,
  }) async {}

  static isExchange(
    BuildContext context,
    String accessToken,
    String exchangeId,
  ) async {}
}
