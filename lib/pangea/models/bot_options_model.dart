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
  String mode;
  String? custom;
  String? discussionTopic;
  String? discussionKeywords;
  bool? discussionTriggerScheduleEnabled;
  int? discussionTriggerScheduleHourInterval;
  bool? discussionTriggerReactionEnabled;
  String? discussionTriggerReactionKey;

  BotOptionsModel({
    this.languageLevel,
    this.topic = "General Conversation",
    this.keywords = const [],
    this.safetyModeration = true,
    this.mode = "discussion",
    this.custom = "",
    this.discussionTopic,
    this.discussionKeywords,
    this.discussionTriggerScheduleEnabled,
    this.discussionTriggerScheduleHourInterval,
    this.discussionTriggerReactionEnabled = true,
    this.discussionTriggerReactionKey,
  });

  factory BotOptionsModel.fromJson(json) {
    return BotOptionsModel(
      languageLevel: json[ModelKey.languageLevel],
      safetyModeration: json[ModelKey.safetyModeration] ?? true,
      mode: json[ModelKey.mode] ?? "discussion",
      custom: json[ModelKey.custom],
      discussionTopic: json[ModelKey.discussionTopic],
      discussionKeywords: json[ModelKey.discussionKeywords],
      discussionTriggerScheduleEnabled:
          json[ModelKey.discussionTriggerScheduleEnabled],
      discussionTriggerScheduleHourInterval:
          json[ModelKey.discussionTriggerScheduleHourInterval],
      discussionTriggerReactionEnabled:
          json[ModelKey.discussionTriggerReactionEnabled],
      discussionTriggerReactionKey: json[ModelKey.discussionTriggerReactionKey],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      // data[ModelKey.isConversationBotChat] = isConversationBotChat;
      data[ModelKey.languageLevel] = languageLevel;
      data[ModelKey.safetyModeration] = safetyModeration;
      data[ModelKey.mode] = mode;
      data[ModelKey.custom] = custom;
      data[ModelKey.discussionTopic] = discussionTopic;
      data[ModelKey.discussionKeywords] = discussionKeywords;
      data[ModelKey.discussionTriggerScheduleEnabled] =
          discussionTriggerScheduleEnabled;
      data[ModelKey.discussionTriggerScheduleHourInterval] =
          discussionTriggerScheduleHourInterval;
      data[ModelKey.discussionTriggerReactionEnabled] =
          discussionTriggerReactionEnabled;
      data[ModelKey.discussionTriggerReactionKey] =
          discussionTriggerReactionKey;
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
      case ModelKey.safetyModeration:
        safetyModeration = value;
        break;
      case ModelKey.mode:
        mode = value;
        break;
      case ModelKey.custom:
        custom = value;
        break;
      case ModelKey.discussionTopic:
        discussionTopic = value;
        break;
      case ModelKey.discussionKeywords:
        discussionKeywords = value;
        break;
      case ModelKey.discussionTriggerScheduleEnabled:
        discussionTriggerScheduleEnabled = value;
        break;
      case ModelKey.discussionTriggerScheduleHourInterval:
        discussionTriggerScheduleHourInterval = value;
        break;
      case ModelKey.discussionTriggerReactionEnabled:
        discussionTriggerReactionEnabled = value;
        break;
      case ModelKey.discussionTriggerReactionKey:
        discussionTriggerReactionKey = value;
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
