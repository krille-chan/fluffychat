import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class BotOptionsModel {
  LanguageLevelTypeEnum languageLevel;
  String topic;
  List<String> keywords;
  bool safetyModeration;
  String mode;
  String? discussionTopic;
  String? discussionKeywords;
  bool? discussionTriggerReactionEnabled;
  String? discussionTriggerReactionKey;
  String? customSystemPrompt;
  bool? customTriggerReactionEnabled;
  String? customTriggerReactionKey;
  String? textAdventureGameMasterInstructions;
  String? targetLanguage;
  String? targetVoice;

  BotOptionsModel({
    ////////////////////////////////////////////////////////////////////////////
    // General Bot Options
    ////////////////////////////////////////////////////////////////////////////
    this.languageLevel = LanguageLevelTypeEnum.a1,
    this.topic = "General Conversation",
    this.keywords = const [],
    this.safetyModeration = true,
    this.mode = BotMode.discussion,
    this.targetLanguage,
    this.targetVoice,

    ////////////////////////////////////////////////////////////////////////////
    // Discussion Mode Options
    ////////////////////////////////////////////////////////////////////////////
    this.discussionTopic,
    this.discussionKeywords,
    this.discussionTriggerReactionEnabled = true,
    this.discussionTriggerReactionKey = "⏩",

    ////////////////////////////////////////////////////////////////////////////
    // Custom Mode Options
    ////////////////////////////////////////////////////////////////////////////
    this.customSystemPrompt,
    this.customTriggerReactionEnabled = true,
    this.customTriggerReactionKey = "⏩",

    ////////////////////////////////////////////////////////////////////////////
    // Text Adventure Mode Options
    ////////////////////////////////////////////////////////////////////////////
    this.textAdventureGameMasterInstructions,
  });

  factory BotOptionsModel.fromJson(json) {
    return BotOptionsModel(
      //////////////////////////////////////////////////////////////////////////
      // General Bot Options
      //////////////////////////////////////////////////////////////////////////
      languageLevel: json[ModelKey.languageLevel] is int
          ? LanguageLevelTypeEnumExtension.fromInt(json[ModelKey.languageLevel])
          : json[ModelKey.languageLevel] is String
              ? LanguageLevelTypeEnumExtension.fromString(
                  json[ModelKey.languageLevel],
                )
              : LanguageLevelTypeEnum.a1,
      safetyModeration: json[ModelKey.safetyModeration] ?? true,
      mode: json[ModelKey.mode] ?? BotMode.discussion,
      targetLanguage: json[ModelKey.targetLanguage],
      targetVoice: json[ModelKey.targetVoice],

      //////////////////////////////////////////////////////////////////////////
      // Discussion Mode Options
      //////////////////////////////////////////////////////////////////////////
      discussionTopic: json[ModelKey.discussionTopic],
      discussionKeywords: json[ModelKey.discussionKeywords],
      discussionTriggerReactionEnabled:
          json[ModelKey.discussionTriggerReactionEnabled] ?? true,
      discussionTriggerReactionKey:
          json[ModelKey.discussionTriggerReactionKey] ?? "⏩",

      //////////////////////////////////////////////////////////////////////////
      // Custom Mode Options
      //////////////////////////////////////////////////////////////////////////
      customSystemPrompt: json[ModelKey.customSystemPrompt],
      customTriggerReactionEnabled:
          json[ModelKey.customTriggerReactionEnabled] ?? true,
      customTriggerReactionKey: json[ModelKey.customTriggerReactionKey] ?? "⏩",

      //////////////////////////////////////////////////////////////////////////
      // Text Adventure Mode Options
      //////////////////////////////////////////////////////////////////////////
      textAdventureGameMasterInstructions:
          json[ModelKey.textAdventureGameMasterInstructions],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      // data[ModelKey.isConversationBotChat] = isConversationBotChat;
      data[ModelKey.languageLevel] = languageLevel.storageInt;
      data[ModelKey.safetyModeration] = safetyModeration;
      data[ModelKey.mode] = mode;
      data[ModelKey.targetLanguage] = targetLanguage;
      data[ModelKey.targetVoice] = targetVoice;
      data[ModelKey.discussionTopic] = discussionTopic;
      data[ModelKey.discussionKeywords] = discussionKeywords;
      data[ModelKey.discussionTriggerReactionEnabled] =
          discussionTriggerReactionEnabled ?? true;
      data[ModelKey.discussionTriggerReactionKey] =
          discussionTriggerReactionKey ?? "⏩";
      data[ModelKey.customSystemPrompt] = customSystemPrompt;
      data[ModelKey.customTriggerReactionEnabled] =
          customTriggerReactionEnabled ?? true;
      data[ModelKey.customTriggerReactionKey] = customTriggerReactionKey ?? "⏩";
      data[ModelKey.textAdventureGameMasterInstructions] =
          textAdventureGameMasterInstructions;
      return data;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: data,
      );
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
      case ModelKey.discussionTopic:
        discussionTopic = value;
        break;
      case ModelKey.discussionKeywords:
        discussionKeywords = value;
        break;
      case ModelKey.discussionTriggerReactionEnabled:
        discussionTriggerReactionEnabled = value;
        break;
      case ModelKey.discussionTriggerReactionKey:
        discussionTriggerReactionKey = value;
        break;
      case ModelKey.customSystemPrompt:
        customSystemPrompt = value;
        break;
      case ModelKey.customTriggerReactionEnabled:
        customTriggerReactionEnabled = value;
        break;
      case ModelKey.customTriggerReactionKey:
        customTriggerReactionKey = value;
        break;
      case ModelKey.textAdventureGameMasterInstructions:
        textAdventureGameMasterInstructions = value;
        break;
      case ModelKey.targetLanguage:
        targetLanguage = value;
        break;
      case ModelKey.targetVoice:
        targetVoice = value;
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
