import 'dart:async';

import 'package:fluffychat/pangea/constants/match_rule_ids.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/class_default_values.dart';
import '../extensions/client_extension/client_extension.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';
import 'base_controller.dart';
import 'pangea_controller.dart';

// controls the fetching of analytics data
class AnalyticsController extends BaseController {
  late PangeaController _pangeaController;
  final List<ConstructCacheEntry> _cachedConstructs = [];

  AnalyticsController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  String get langCode =>
      _pangeaController.languageController.userL2?.langCode ??
      _pangeaController.pLanguageStore.targetOptions.first.langCode;

  // String get _analyticsTimeSpanKey => "ANALYTICS_TIME_SPAN_KEY";

  // TimeSpan get currentAnalyticsTimeSpan {
  //   try {
  //     final String? str = _pangeaController.pStoreService.read(
  //       _analyticsTimeSpanKey,
  //     );
  //     return str != null
  //         ? TimeSpan.values.firstWhere((e) {
  //             final spanString = e.toString();
  //             return spanString == str;
  //           })
  //         : ClassDefaultValues.defaultTimeSpan;
  //   } catch (err) {
  //     debugger(when: kDebugMode);
  //     return ClassDefaultValues.defaultTimeSpan;
  //   }
  // }

  // Future<void> setCurrentAnalyticsTimeSpan(TimeSpan timeSpan) async {
  //   await _pangeaController.pStoreService.save(
  //     _analyticsTimeSpanKey,
  //     timeSpan.toString(),
  //   );
  //   setState();
  // }

  // String get _analyticsSpaceLangKey => "ANALYTICS_SPACE_LANG_KEY";

  // LanguageModel get currentAnalyticsLang {
  //   try {
  //     final String? str = _pangeaController.pStoreService.read(
  //       _analyticsSpaceLangKey,
  //     );
  //     return str != null
  //         ? PangeaLanguage.byLangCode(str)
  // : _pangeaController.languageController.userL2 ??
  //     _pangeaController.pLanguageStore.targetOptions.first;
  //   } catch (err) {
  //     debugger(when: kDebugMode);
  //     return _pangeaController.pLanguageStore.targetOptions.first;
  //   }
  // }

  // Future<void> setCurrentAnalyticsLang(LanguageModel lang) async {
  //   await _pangeaController.pStoreService.save(
  //     _analyticsSpaceLangKey,
  //     lang.langCode,
  //   );
  //   setState();
  // }

  /// Get the last time the user updated their analytics.
  /// Tries to get the last time the user updated analytics for their current L2.
  /// If there isn't yet an analytics room reacted for their L2, checks if the
  /// user has any other analytics rooms and returns the most recent update time.
  Future<DateTime?> myAnalyticsLastUpdated() async {
    final List<Room> analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;

    final Map<String, DateTime> langCodeLastUpdates = {};
    for (final Room analyticsRoom in analyticsRooms) {
      final String? roomLang = analyticsRoom.madeForLang;
      if (roomLang == null) continue;
      final DateTime? lastUpdated = await analyticsRoom.analyticsLastUpdated(
        _pangeaController.matrixState.client.userID!,
      );
      if (lastUpdated != null) {
        langCodeLastUpdates[roomLang] = lastUpdated;
      }
    }

    if (langCodeLastUpdates.isEmpty) return null;
    final String? l2Code =
        _pangeaController.languageController.userL2?.langCode;
    if (l2Code != null && langCodeLastUpdates.containsKey(l2Code)) {
      return langCodeLastUpdates[l2Code];
    }
    return langCodeLastUpdates.values.reduce(
      (check, mostRecent) => check.isAfter(mostRecent) ? check : mostRecent,
    );
  }

  /// check if any students have recently updated their analytics
  /// if any have, then the cache needs to be updated
  Future<DateTime?> spaceAnalyticsLastUpdated(
    Room space,
  ) async {
    await space.requestParticipants();

    final List<Future<DateTime?>> lastUpdatedFutures = [];
    for (final student in space.students) {
      final Room? analyticsRoom = _pangeaController.matrixState.client
          .analyticsRoomLocal(langCode, student.id);
      if (analyticsRoom == null) continue;
      lastUpdatedFutures.add(
        analyticsRoom.analyticsLastUpdated(student.id),
      );
    }

    final List<DateTime?> lastUpdatedWithNulls =
        await Future.wait(lastUpdatedFutures);
    final List<DateTime> lastUpdates =
        lastUpdatedWithNulls.where((e) => e != null).cast<DateTime>().toList();
    if (lastUpdates.isNotEmpty) {
      return lastUpdates.reduce(
        (check, mostRecent) => check.isAfter(mostRecent) ? check : mostRecent,
      );
    }
    return null;
  }

  Future<List<ConstructAnalyticsEvent>> allMyConstructs(
    TimeSpan timeSpan,
  ) async {
    final Room? analyticsRoom =
        _pangeaController.matrixState.client.analyticsRoomLocal(langCode);
    if (analyticsRoom == null) return [];

    final List<ConstructAnalyticsEvent>? roomEvents =
        (await analyticsRoom.getAnalyticsEvents(
      since: timeSpan.cutOffDate,
      userId: _pangeaController.matrixState.client.userID!,
    ))
            ?.cast<ConstructAnalyticsEvent>();
    final List<ConstructAnalyticsEvent> allConstructs = roomEvents ?? [];

    return allConstructs
        .where((construct) => construct.content.uses.isNotEmpty)
        .toList();
  }

  Future<List<ConstructAnalyticsEvent>> allSpaceMemberConstructs(
    Room space,
    TimeSpan timeSpan,
  ) async {
    await space.requestParticipants();
    final List<ConstructAnalyticsEvent> constructEvents = [];
    for (final student in space.students) {
      final Room? analyticsRoom = _pangeaController.matrixState.client
          .analyticsRoomLocal(langCode, student.id);
      if (analyticsRoom != null) {
        final List<ConstructAnalyticsEvent>? roomEvents =
            (await analyticsRoom.getAnalyticsEvents(
          since: timeSpan.cutOffDate,
          userId: student.id,
        ))
                ?.cast<ConstructAnalyticsEvent>();
        constructEvents.addAll(roomEvents ?? []);
      }
    }

    final List<String> spaceChildrenIds = space.allSpaceChildRoomIds;
    final List<ConstructAnalyticsEvent> allConstructs = [];
    for (final constructEvent in constructEvents) {
      constructEvent.content.uses.removeWhere(
        (use) => !spaceChildrenIds.contains(use.chatId),
      );

      if (constructEvent.content.uses.isNotEmpty) {
        allConstructs.add(constructEvent);
      }
    }

    return allConstructs;
  }

  List<ConstructAnalyticsEvent> filterStudentConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    String? studentId,
  ) {
    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);
    filtered.removeWhere((element) => element.event.senderId != studentId);
    return filtered;
  }

  List<ConstructAnalyticsEvent> filterRoomConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    String? roomID,
  ) {
    final List<ConstructAnalyticsEvent> filtered = [...unfilteredConstructs];
    for (final construct in filtered) {
      construct.content.uses.removeWhere((u) => u.chatId != roomID);
    }
    return filtered;
  }

  Future<List<ConstructAnalyticsEvent>> filterPrivateChatConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    Room space,
  ) async {
    final List<String> privateChatIds = space.allSpaceChildRoomIds;
    final resp = await space.client.getSpaceHierarchy(space.id);
    final List<String> chatIds = resp.rooms.map((room) => room.roomId).toList();
    for (final id in chatIds) {
      privateChatIds.removeWhere((e) => e == id);
    }
    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);
    for (final construct in filtered) {
      construct.content.uses.removeWhere(
        (use) => !privateChatIds.contains(use.chatId),
      );
    }
    return filtered;
  }

  Future<List<ConstructAnalyticsEvent>> filterSpaceConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    Room space,
  ) async {
    final resp = await space.client.getSpaceHierarchy(space.id);
    final List<String> chatIds = resp.rooms.map((room) => room.roomId).toList();
    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);

    for (final construct in filtered) {
      construct.content.uses.removeWhere(
        (use) => !chatIds.contains(use.chatId),
      );
    }

    return filtered;
  }

  List<ConstructAnalyticsEvent>? getConstructsLocal({
    required TimeSpan timeSpan,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    DateTime? lastUpdated,
    ConstructTypeEnum? constructType,
  }) {
    final index = _cachedConstructs.indexWhere(
      (e) =>
          e.timeSpan == timeSpan &&
          e.type == constructType &&
          e.defaultSelected.id == defaultSelected.id &&
          e.defaultSelected.type == defaultSelected.type &&
          e.selected?.id == selected?.id &&
          e.selected?.type == selected?.type &&
          e.langCode == langCode,
    );

    if (index > -1) {
      if (_cachedConstructs[index].needsUpdate(lastUpdated)) {
        _cachedConstructs.removeAt(index);
        return null;
      }
      return _cachedConstructs[index].events;
    }

    return null;
  }

  void cacheConstructs({
    required List<ConstructAnalyticsEvent> events,
    required AnalyticsSelected defaultSelected,
    required TimeSpan timeSpan,
    AnalyticsSelected? selected,
    ConstructTypeEnum? constructType,
  }) {
    final entry = ConstructCacheEntry(
      timeSpan: timeSpan,
      type: constructType,
      events: List.from(events),
      defaultSelected: defaultSelected,
      selected: selected,
      langCode: langCode,
    );
    _cachedConstructs.add(entry);
  }

  Future<List<ConstructAnalyticsEvent>> getMyConstructs({
    required AnalyticsSelected defaultSelected,
    required TimeSpan timeSpan,
    ConstructTypeEnum? constructType,
    AnalyticsSelected? selected,
  }) async {
    final List<ConstructAnalyticsEvent> unfilteredConstructs =
        await allMyConstructs(timeSpan);

    final Room? space = selected?.type == AnalyticsEntryType.space
        ? _pangeaController.matrixState.client.getRoomById(selected!.id)
        : null;

    return filterConstructs(
      unfilteredConstructs: unfilteredConstructs,
      space: space,
      defaultSelected: defaultSelected,
      selected: selected,
      timeSpan: timeSpan,
    );
  }

  Future<List<ConstructAnalyticsEvent>> getSpaceConstructs({
    required Room space,
    required AnalyticsSelected defaultSelected,
    required TimeSpan timeSpan,
    AnalyticsSelected? selected,
    ConstructTypeEnum? constructType,
  }) async {
    final List<ConstructAnalyticsEvent> unfilteredConstructs =
        await allSpaceMemberConstructs(
      space,
      timeSpan,
    );

    return filterConstructs(
      unfilteredConstructs: unfilteredConstructs,
      space: space,
      defaultSelected: defaultSelected,
      selected: selected,
      timeSpan: timeSpan,
    );
  }

  Future<List<ConstructAnalyticsEvent>> filterConstructs({
    required List<ConstructAnalyticsEvent> unfilteredConstructs,
    required AnalyticsSelected defaultSelected,
    required TimeSpan timeSpan,
    Room? space,
    AnalyticsSelected? selected,
  }) async {
    if ([AnalyticsEntryType.privateChats, AnalyticsEntryType.space]
        .contains(selected?.type)) {
      assert(space != null);
    }

    for (int i = 0; i < unfilteredConstructs.length; i++) {
      final construct = unfilteredConstructs[i];
      construct.content.uses.removeWhere(
        (use) => use.timeStamp.isBefore(timeSpan.cutOffDate),
      );
    }

    unfilteredConstructs.removeWhere((e) => e.content.uses.isEmpty);

    switch (selected?.type) {
      case null:
        return unfilteredConstructs;
      case AnalyticsEntryType.student:
        if (defaultSelected.type != AnalyticsEntryType.space) {
          throw Exception(
            "student filtering not available for default filter ${defaultSelected.type}",
          );
        }
        return filterStudentConstructs(unfilteredConstructs, selected!.id);
      case AnalyticsEntryType.room:
        return filterRoomConstructs(unfilteredConstructs, selected?.id);
      case AnalyticsEntryType.privateChats:
        return defaultSelected.type == AnalyticsEntryType.student
            ? throw "private chat filtering not available for my analytics"
            : await filterPrivateChatConstructs(unfilteredConstructs, space!);
      case AnalyticsEntryType.space:
        return await filterSpaceConstructs(unfilteredConstructs, space!);
      default:
        throw Exception("invalid filter type - ${selected?.type}");
    }
  }

  Future<List<ConstructAnalyticsEvent>?> getConstructs({
    required AnalyticsSelected defaultSelected,
    required TimeSpan timeSpan,
    AnalyticsSelected? selected,
    bool removeIT = true,
    bool forceUpdate = false,
    ConstructTypeEnum? constructType,
  }) async {
    debugPrint("getting constructs");
    await _pangeaController.matrixState.client.roomsLoading;

    Room? space;
    if (defaultSelected.type == AnalyticsEntryType.space) {
      space = _pangeaController.matrixState.client.getRoomById(
        defaultSelected.id,
      );
      if (space == null) {
        ErrorHandler.logError(
          m: "space not found in setConstructs",
          data: {
            "defaultSelected": defaultSelected,
            "selected": selected,
          },
        );
        return [];
      }
    }

    DateTime? lastUpdated;
    if (defaultSelected.type != AnalyticsEntryType.space) {
      // if default selected view is my analytics, check for the last
      // time the logged in user updated their analytics events
      // this gets passed to getAnalyticsLocal to determine if the cached
      // entry is out-of-date
      lastUpdated = await myAnalyticsLastUpdated();
    } else {
      // else, get the last time a student in the space updated their analytics
      lastUpdated = await spaceAnalyticsLastUpdated(
        space!,
      );
    }

    final List<ConstructAnalyticsEvent>? local = getConstructsLocal(
      timeSpan: timeSpan,
      constructType: constructType,
      defaultSelected: defaultSelected,
      selected: selected,
      lastUpdated: lastUpdated,
    );
    if (local != null && !forceUpdate) {
      debugPrint("returning local constructs");
      return local;
    }
    debugPrint("fetching new constructs");

    final filteredConstructs = space == null
        ? await getMyConstructs(
            constructType: constructType,
            defaultSelected: defaultSelected,
            selected: selected,
            timeSpan: timeSpan,
          )
        : await getSpaceConstructs(
            constructType: constructType,
            space: space,
            defaultSelected: defaultSelected,
            selected: selected,
            timeSpan: timeSpan,
          );

    if (removeIT) {
      for (final construct in filteredConstructs) {
        construct.content.uses.removeWhere(
          (element) =>
              element.lemma == "Try interactive translation" ||
              element.lemma == "itStart" ||
              element.lemma == MatchRuleIds.interactiveTranslation,
        );
      }
    }

    if (local == null) {
      cacheConstructs(
        constructType: constructType,
        events: filteredConstructs,
        defaultSelected: defaultSelected,
        selected: selected,
        timeSpan: timeSpan,
      );
    }

    return filteredConstructs;
  }
}

abstract class CacheEntry {
  final String langCode;
  final TimeSpan timeSpan;
  final AnalyticsSelected defaultSelected;
  AnalyticsSelected? selected;
  late final DateTime _createdAt;

  CacheEntry({
    required this.timeSpan,
    required this.defaultSelected,
    required this.langCode,
    this.selected,
  }) {
    _createdAt = DateTime.now();
  }

  bool get isExpired =>
      DateTime.now().difference(_createdAt).inMinutes >
      ClassDefaultValues.minutesDelayToMakeNewChartAnalytics;

  bool needsUpdate(DateTime? lastEventUpdated) {
    // cache entry is invalid if it's older than the last event update
    // if lastEventUpdated is null, that would indicate that no events
    // of this type have been sent to the room. In this case, there
    // shouldn't be any cached data.
    if (lastEventUpdated == null) {
      Sentry.addBreadcrumb(
        Breadcrumb(message: "lastEventUpdated is null in needsUpdate"),
      );
      return false;
    }
    return _createdAt.isBefore(lastEventUpdated);
  }
}

class ConstructCacheEntry extends CacheEntry {
  final ConstructTypeEnum? type;
  final List<ConstructAnalyticsEvent> events;

  ConstructCacheEntry({
    required this.events,
    required super.timeSpan,
    required super.langCode,
    required super.defaultSelected,
    this.type,
    super.selected,
  });
}
