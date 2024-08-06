import 'dart:async';

import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/match_rule_ids.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A minimized version of AnalyticsController that get the logged in user's analytics
class GetAnalyticsController {
  late PangeaController _pangeaController;
  final List<AnalyticsCacheEntry> _cache = [];

  GetAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  String? get l2Code => _pangeaController.languageController.userL2?.langCode;

  Client get client => _pangeaController.matrixState.client;

  /// A local cache of eventIds and construct uses for messages sent since the last update
  Map<String, List<OneConstructUse>> get messagesSinceUpdate {
    try {
      final dynamic locallySaved = _pangeaController.pStoreService.read(
        PLocalKey.messagesSinceUpdate,
      );
      if (locallySaved == null) return {};
      try {
        // try to get the local cache of messages and format them as OneConstructUses
        final Map<String, List<dynamic>> cache =
            Map<String, List<dynamic>>.from(locallySaved);
        final Map<String, List<OneConstructUse>> formattedCache = {};
        for (final entry in cache.entries) {
          formattedCache[entry.key] =
              entry.value.map((e) => OneConstructUse.fromJson(e)).toList();
        }
        return formattedCache;
      } catch (err) {
        // if something goes wrong while trying to format the local data, clear it
        _pangeaController.myAnalytics.clearMessagesSinceUpdate();
        return {};
      }
    } catch (exception, stackTrace) {
      ErrorHandler.logError(
        e: PangeaWarningError(
          "Failed to get messages since update: $exception",
        ),
        s: stackTrace,
        m: 'Failed to retrieve messages since update',
      );
      return {};
    }
  }

  /// Get a list of all constructs used by the logged in user in their current L2
  Future<List<OneConstructUse>> getConstructs({
    bool forceUpdate = false,
    ConstructTypeEnum? constructType,
  }) async {
    debugPrint("getting constructs");
    await client.roomsLoading;

    // don't try to get constructs until last updated time has been loaded
    await _pangeaController.myAnalytics.lastUpdatedCompleter.future;

    // if forcing a refreshing, clear the cache
    if (forceUpdate) clearCache();

    // get the last time the user updated their analytics for their current l2
    // then try to get local cache of construct uses. lastUpdate time is used to
    // determine if cached data is still valid.
    final DateTime? lastUpdated = _pangeaController.myAnalytics.lastUpdated ??
        await myAnalyticsLastUpdated();

    final List<OneConstructUse>? local = getConstructsLocal(
      constructType: constructType,
      lastUpdated: lastUpdated,
    );

    if (local != null) {
      debugPrint("returning local constructs");
      return local;
    }
    debugPrint("fetching new constructs");

    // if there is no cached data (or if force updating),
    // get all the construct events for the user from analytics room
    // and convert their content into a list of construct uses
    final List<ConstructAnalyticsEvent> constructEvents =
        await allMyConstructs();

    final List<OneConstructUse> unfilteredUses = [];
    for (final event in constructEvents) {
      unfilteredUses.addAll(event.content.uses);
    }

    // filter out any constructs that are not relevant to the user
    final List<OneConstructUse> filteredUses = await filterConstructs(
      unfilteredConstructs: unfilteredUses,
    );

    // if there isn't already a valid, local cache, cache the filtered uses
    if (local == null) {
      cacheConstructs(
        constructType: constructType,
        uses: filteredUses,
      );
    }

    return filteredUses;
  }

  /// Get the last time the user updated their analytics for their current l2
  Future<DateTime?> myAnalyticsLastUpdated() async {
    // this function gets called soon after login, so first
    // make sure that the user's l2 is loaded, if the user has set their l2
    if (client.userID != null && l2Code == null) {
      await _pangeaController.matrixState.client.waitForAccountData();
      if (l2Code == null) return null;
    }
    final Room? analyticsRoom = client.analyticsRoomLocal(l2Code!);
    if (analyticsRoom == null) return null;
    final DateTime? lastUpdated = await analyticsRoom.analyticsLastUpdated(
      client.userID!,
    );
    return lastUpdated;
  }

  /// Get all the construct analytics events for the logged in user
  Future<List<ConstructAnalyticsEvent>> allMyConstructs() async {
    if (l2Code == null) return [];
    final Room? analyticsRoom = client.analyticsRoomLocal(l2Code!);
    if (analyticsRoom == null) return [];
    return await analyticsRoom.getAnalyticsEvents(userId: client.userID!) ?? [];
  }

  /// Filter out constructs that are not relevant to the user, specifically those from
  /// rooms in which the user is a teacher and those that are interative translation span constructs
  Future<List<OneConstructUse>> filterConstructs({
    required List<OneConstructUse> unfilteredConstructs,
  }) async {
    return unfilteredConstructs
        .where(
          (use) =>
              use.lemma != "Try interactive translation" &&
                  use.lemma != "itStart" ||
              use.lemma != MatchRuleIds.interactiveTranslation,
        )
        .toList();
  }

  /// Get the cached construct uses for the current user, if it exists
  List<OneConstructUse>? getConstructsLocal({
    DateTime? lastUpdated,
    ConstructTypeEnum? constructType,
  }) {
    final index = _cache.indexWhere(
      (e) => e.type == constructType && e.langCode == l2Code,
    );

    if (index > -1) {
      if (_cache[index].needsUpdate(lastUpdated)) {
        _cache.removeAt(index);
        return null;
      }
      return _cache[index].uses;
    }

    return null;
  }

  /// Cache the construct uses for the current user
  void cacheConstructs({
    required List<OneConstructUse> uses,
    ConstructTypeEnum? constructType,
  }) {
    if (l2Code == null) return;
    final entry = AnalyticsCacheEntry(
      type: constructType,
      uses: List.from(uses),
      langCode: l2Code!,
    );
    _cache.add(entry);
  }

  /// Clear all cached analytics data.
  void clearCache() {
    _cache.clear();
  }
}

class AnalyticsCacheEntry {
  final String langCode;
  final ConstructTypeEnum? type;
  final List<OneConstructUse> uses;
  late final DateTime _createdAt;

  AnalyticsCacheEntry({
    required this.langCode,
    required this.type,
    required this.uses,
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
