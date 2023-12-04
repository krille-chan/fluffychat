import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'class_model.dart';

class ExchangeModel {
  PangeaRoomRules permissions;

  ExchangeModel({
    required this.permissions,
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json) {
    return ExchangeModel(
      permissions: PangeaRoomRules.fromJson(json[ModelKey.permissions]),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data[ModelKey.permissions] = permissions.toJson();
      return data;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
      return data;
    }
  }

  updateEditableClassField(String key, dynamic value) {
    switch (key) {
      default:
        throw Exception('Invalid key for setting permissions - $key');
    }
  }
}
