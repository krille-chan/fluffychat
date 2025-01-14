import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/repo/language_repo.dart';
import 'shared_prefs.dart';

class PangeaLanguage {
  PangeaLanguage() {
    initialize();
  }

  static List<LanguageModel> _langList = [];

  List<LanguageModel> get langList => _langList;

  List<LanguageModel> get targetOptions =>
      _langList.where((element) => element.l2).toList();

  List<LanguageModel> get baseOptions =>
      _langList.where((element) => element.l1).toList();

  static Future<void> initialize() async {
    try {
      _langList = await _getCachedFlags();
      if (await _shouldFetch ||
          _langList.isEmpty ||
          _langList.every((lang) => !lang.l2)) {
        _langList = await LanguageRepo.fetchLanguages();

        await _saveFlags(_langList);
        await saveLastFetchDate();
      }
      _langList.removeWhere(
        (element) =>
            LanguageModel.codeFromNameOrCode(element.langCode) ==
            LanguageKeys.unknownLanguage,
      );
      _langList.sort((a, b) => a.displayName.compareTo(b.displayName));
      _langList.insert(0, LanguageModel.multiLingual());
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "langList": _langList.map((e) => e.toJson()),
        },
      );
    }
  }

  static saveLastFetchDate() async {
    final String now = DateTime.now().toIso8601String();
    await MyShared.saveString(PrefKey.lastFetched, now);
  }

  static Future<bool> get _shouldFetch async {
    final String? dateString = await MyShared.readString(PrefKey.lastFetched);
    if (dateString == null) {
      return true;
    }
    // return true;
    final DateTime lastFetchedDate = DateTime.parse(dateString);
    final DateTime targetDate = DateTime(2024, 1, 15);
    if (lastFetchedDate.isBefore(targetDate)) {
      return true;
    }

    final int lastFetched = DateTime.parse(dateString).millisecondsSinceEpoch;
    final int now = DateTime.now().millisecondsSinceEpoch;
    const int fetchIntervalInMilliseconds = 86534601;
    return (now - lastFetched) >= fetchIntervalInMilliseconds ? true : false;
  }

  static Future<void> _saveFlags(List<LanguageModel> langFlags) async {
    final Map flagMap = {
      PrefKey.flags: langFlags.map((e) => e.toJson()).toList(),
    };
    await MyShared.saveJson(PrefKey.flags, flagMap);
  }

  static Future<List<LanguageModel>> _getCachedFlags() async {
    final Map<dynamic, dynamic>? flagsMap =
        await MyShared.readJson(PrefKey.flags);
    if (flagsMap == null) {
      return [];
    }

    final List<LanguageModel> flags = [];
    final List mapList = flagsMap[PrefKey.flags] as List;
    for (final element in mapList) {
      flags.add(LanguageModel.fromJson(element));
    }

    return flags;
  }

  static LanguageModel? byLangCode(String langCode) {
    for (final element in _langList) {
      if (element.langCode == langCode) return element;
    }
    return null;
  }
}
