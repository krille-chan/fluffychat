import 'dart:developer';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/pangea_event_types.dart';

class BotOptionsModel {
  int? languageLevel;
  String topic;
  List<String> keywords;
  bool safetyModeration;
  String preset;
  String? custom;

  BotOptionsModel({
    this.languageLevel,
    this.topic = "General Conversation",
    this.keywords = const [],
    this.safetyModeration = true,
    this.preset = "discussion",
    this.custom = "",
  });

  factory BotOptionsModel.fromJson(json) {
    return BotOptionsModel(
      languageLevel: json[ModelKey.languageLevel],
      topic: json[ModelKey.conversationTopic] ?? "General Conversation",
      keywords: (json[ModelKey.keywords] ?? []).cast<String>(),
      safetyModeration: json[ModelKey.safetyModeration] ?? true,
      preset: json[ModelKey.preset] ?? "discussion",
      custom: json[ModelKey.custom],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      // data[ModelKey.isConversationBotChat] = isConversationBotChat;
      data[ModelKey.languageLevel] = languageLevel;
      data[ModelKey.conversationTopic] = topic;
      data[ModelKey.keywords] = keywords;
      data[ModelKey.safetyModeration] = safetyModeration;
      return data;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
      return data;
    }
  }

  //TODO: define enum with all possible values
  updateBotOption(String key, dynamic value) {
    switch (key) {
      case ModelKey.languageLevel:
        languageLevel = value;
        break;
      case ModelKey.conversationTopic:
        topic = value;
        break;
      case ModelKey.keywords:
        keywords = value;
        break;
      case ModelKey.safetyModeration:
        safetyModeration = value;
        break;
      default:
        throw Exception('Invalid key for bot options - $key');
    }
  }

  StateEvent get toStateEvent => StateEvent(
        content: toJson(),
        type: PangeaEventTypes.botOptions,
      );
}
