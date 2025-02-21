import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import '../../events/constants/pangea_event_types.dart';
import '../../learning_settings/constants/language_constants.dart';
import '../../learning_settings/models/language_model.dart';

class LanguageSettingsModel {
  String? city;
  String? country;
  String? schoolName;
  String dominantLanguage;
  String targetLanguage;

  LanguageSettingsModel({
    this.dominantLanguage = SpaceConstants.defaultDominantLanguage,
    this.targetLanguage = SpaceConstants.defaultTargetLanguage,
    this.city,
    this.country,
    this.schoolName,
  });

  factory LanguageSettingsModel.fromJson(Map<String, dynamic> json) {
    return LanguageSettingsModel(
      city: json['city'],
      country: json['country'],
      dominantLanguage: LanguageModel.codeFromNameOrCode(
        json['dominant_language'] ?? LanguageKeys.unknownLanguage,
      ),
      targetLanguage: LanguageModel.codeFromNameOrCode(
        json['target_language'] ?? LanguageKeys.unknownLanguage,
      ),
      schoolName: json['school_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data['city'] = city;
      data['country'] = country;
      //check for and do "english" => en and "spanish" => es
      data['dominant_language'] = dominantLanguage;
      //check for and do "english" => en and "spanish" => es
      data['target_language'] = targetLanguage;
      data['school_name'] = schoolName;
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

  StateEvent get toStateEvent => StateEvent(
        content: toJson(),
        type: PangeaEventTypes.languageSettings,
      );
}

class PangeaRoomRules {
  // int? pangeaClassID; // this is id our database
  bool isPublic;
  bool isOpenEnrollment;
  bool oneToOneChatClass;
  bool isCreateRooms;
  bool isShareVideo;
  bool isSharePhoto;
  bool isShareFiles;
  bool isShareLocation;
  bool isCreateStories;
  bool isVoiceNotes;
  bool isInviteOnlyStudents;
  // 0 = forbidden, 1 = allow individual to choose, 2 = require
  int interactiveTranslator;
  int interactiveGrammar;
  int immersionMode;
  int definitions;
  int translations;
  int autoIGC;

  PangeaRoomRules({
    this.isPublic = false,
    this.isOpenEnrollment = false,
    this.oneToOneChatClass = true,
    this.isCreateRooms = true,
    this.isShareVideo = true,
    this.isSharePhoto = true,
    this.isShareFiles = true,
    this.isShareLocation = false,
    this.isCreateStories = false,
    this.isVoiceNotes = true,
    this.isInviteOnlyStudents = true,
    this.interactiveTranslator = SpaceConstants.languageToolPermissions,
    this.interactiveGrammar = SpaceConstants.languageToolPermissions,
    this.immersionMode = SpaceConstants.languageToolPermissions,
    this.definitions = SpaceConstants.languageToolPermissions,
    this.translations = SpaceConstants.languageToolPermissions,
    this.autoIGC = SpaceConstants.languageToolPermissions,
  });

  setLanguageToolSetting(ToolSetting setting, int value) {
    switch (setting) {
      case ToolSetting.interactiveTranslator:
        interactiveTranslator = value;
        break;
      case ToolSetting.interactiveGrammar:
        interactiveGrammar = value;
        break;
      case ToolSetting.immersionMode:
        immersionMode = value;
        break;
      case ToolSetting.definitions:
        definitions = value;
        break;
      // case ToolSetting.translations:
      //   translations = value;
      //   break;
      case ToolSetting.autoIGC:
        autoIGC = value;
        break;
      default:
        throw Exception('Invalid key for setting permissions - $setting');
    }
  }

  StateEvent get toStateEvent => StateEvent(
        content: toJson(),
        type: PangeaEventTypes.rules,
      );

  factory PangeaRoomRules.fromJson(Map<String, dynamic> json) =>
      PangeaRoomRules(
        // pangeaClassID: json['pangea_class'];
        isPublic: json['is_public'],
        isOpenEnrollment: json['is_open_enrollment'],
        oneToOneChatClass: json['one_to_one_chat_class'],
        isCreateRooms: json['is_create_rooms'],
        isShareVideo: json['is_share_video'],
        isSharePhoto: json['is_share_photo'],
        isShareFiles: json['is_share_files'],
        isShareLocation: json['is_share_location'],
        isCreateStories: json['is_create_stories'],
        isVoiceNotes: json['is_voice_notes'],
        isInviteOnlyStudents: json['is_invite_only_students'] ?? true,
        interactiveTranslator: json['interactive_translator'] ??
            SpaceConstants.languageToolPermissions,
        interactiveGrammar: json['interactive_grammar'] ??
            SpaceConstants.languageToolPermissions,
        immersionMode:
            json['immersion_mode'] ?? SpaceConstants.languageToolPermissions,
        definitions:
            json['definitions'] ?? SpaceConstants.languageToolPermissions,
        translations:
            json['translations'] ?? SpaceConstants.languageToolPermissions,
        autoIGC: json['auto_igc'] ?? SpaceConstants.languageToolPermissions,
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['pangea_class'] = pangeaClassID;
    data['is_public'] = isPublic;
    data['is_open_enrollment'] = isOpenEnrollment;
    data['one_to_one_chat_class'] = oneToOneChatClass;
    data['is_create_rooms'] = isCreateRooms;
    data['is_share_video'] = isShareVideo;
    data['is_share_photo'] = isSharePhoto;
    data['is_share_files'] = isShareFiles;
    data['is_share_location'] = isShareLocation;
    data['is_create_stories'] = isCreateStories;
    data['is_voice_notes'] = isVoiceNotes;
    data['is_invite_only_students'] = isInviteOnlyStudents;
    data['interactive_translator'] = interactiveTranslator;
    data['interactive_grammar'] = interactiveGrammar;
    data['immersion_mode'] = immersionMode;
    data['definitions'] = definitions;
    data['translations'] = translations;
    data['auto_igc'] = autoIGC;
    return data;
  }

  int getToolSettings(ToolSetting setting) {
    switch (setting) {
      case ToolSetting.interactiveTranslator:
        return interactiveTranslator;
      case ToolSetting.interactiveGrammar:
        return interactiveGrammar;
      case ToolSetting.immersionMode:
        return immersionMode;
      case ToolSetting.definitions:
        return definitions;
      // case ToolSetting.translations:
      //   return translations;
      case ToolSetting.autoIGC:
        return autoIGC;
      default:
        throw Exception('Invalid key for setting permissions - $setting');
    }
  }

  String languageToolPermissionsText(
    BuildContext context,
    ToolSetting setting,
  ) {
    switch (getToolSettings(setting)) {
      case 0:
        return L10n.of(context).interactiveTranslatorNotAllowed;
      case 1:
        return L10n.of(context).interactiveTranslatorAllowed;
      case 2:
        return L10n.of(context).interactiveTranslatorRequired;
      default:
        return L10n.of(context).notYetSet;
    }
  }
}

enum ToolSetting {
  interactiveTranslator,
  interactiveGrammar,
  immersionMode,
  definitions,
  // translations,
  autoIGC,
  enableTTS,
  enableAutocorrect,
}

extension SettingCopy on ToolSetting {
  String toolName(BuildContext context) {
    switch (this) {
      case ToolSetting.interactiveTranslator:
        return L10n.of(context).interactiveTranslatorSliderHeader;
      case ToolSetting.interactiveGrammar:
        return L10n.of(context).interactiveGrammarSliderHeader;
      case ToolSetting.immersionMode:
        return L10n.of(context).toggleImmersionMode;
      case ToolSetting.definitions:
        return L10n.of(context).definitionsToolName;
      // case ToolSetting.translations:
      //   return L10n.of(context).messageTranslationsToolName;
      case ToolSetting.autoIGC:
        return L10n.of(context).autoIGCToolName;
      case ToolSetting.enableTTS:
        return L10n.of(context).enableTTSToolName;
      case ToolSetting.enableAutocorrect:
        return L10n.of(context).enableAutocorrectToolName;
    }
  }

  //use l10n to get tool name
  String toolDescription(BuildContext context) {
    switch (this) {
      case ToolSetting.interactiveTranslator:
        return L10n.of(context).itToggleDescription;
      case ToolSetting.interactiveGrammar:
        return L10n.of(context).igcToggleDescription;
      case ToolSetting.immersionMode:
        return L10n.of(context).toggleImmersionModeDesc;
      case ToolSetting.definitions:
        return L10n.of(context).definitionsToolDescription;
      // case ToolSetting.translations:
      //   return L10n.of(context).translationsToolDescrption;
      case ToolSetting.autoIGC:
        return L10n.of(context).autoIGCToolDescription;
      case ToolSetting.enableTTS:
        return L10n.of(context).enableTTSToolDescription;
      case ToolSetting.enableAutocorrect:
        return L10n.of(context).enableAutocorrectDescription;
    }
  }

  bool get isAvailableSetting {
    switch (this) {
      case ToolSetting.interactiveTranslator:
      case ToolSetting.interactiveGrammar:
      case ToolSetting.definitions:
      case ToolSetting.immersionMode:
        return false;
      case ToolSetting.autoIGC:
      case ToolSetting.enableTTS:
      case ToolSetting.enableAutocorrect:
        return true;
    }
  }
}
