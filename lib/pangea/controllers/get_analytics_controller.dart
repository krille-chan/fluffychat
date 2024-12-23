import 'dart:async';
import 'dart:math';

import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/put_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A minimized version of AnalyticsController that get the logged in user's analytics
class GetAnalyticsController {
  late PangeaController _pangeaController;
  late MessageAnalyticsController perMessage;
  final List<AnalyticsCacheEntry> _cache = [];
  StreamSubscription<AnalyticsUpdate>? _analyticsUpdateSubscription;
  StreamController<AnalyticsStreamUpdate> analyticsStream =
      StreamController.broadcast();

  ConstructListModel constructListModel = ConstructListModel(uses: []);
  Completer<void> initCompleter = Completer<void>();

  GetAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;

    perMessage = MessageAnalyticsController(
      this,
    );
  }

  String? get _l2Code => _pangeaController.languageController.userL2?.langCode;
  Client get _client => _pangeaController.matrixState.client;

  // the minimum XP required for a given level
  int get _minXPForLevel {
    return _calculateMinXpForLevel(constructListModel.level);
  }

  // the minimum XP required for the next level
  int get _minXPForNextLevel {
    return _calculateMinXpForLevel(constructListModel.level + 1);
  }

  int get minXPForNextLevel => _minXPForNextLevel;

  /// Calculates the minimum XP required for a specific level.
  int _calculateMinXpForLevel(int level) {
    if (level == 1) return 0; // Ensure level 1 starts at 0 XP
    return ((100 / 8) * (2 * pow(level - 1, 2))).floor();
  }

  // the progress within the current level as a percentage (0.0 to 1.0)
  double get levelProgress {
    final progress = (constructListModel.totalXP - _minXPForLevel) /
        (_minXPForNextLevel - _minXPForLevel);
    return progress >= 0 ? progress : 0;
  }

  Future<void> initialize() async {
    if (initCompleter.isCompleted) return;

    try {
      _analyticsUpdateSubscription ??= _pangeaController
          .putAnalytics.analyticsUpdateStream.stream
          .listen(_onAnalyticsUpdate);

      await _pangeaController.putAnalytics.lastUpdatedCompleter.future;
      await _getConstructs();
      constructListModel.updateConstructs([
        ...(_getConstructsLocal() ?? []),
        ..._locallyCachedConstructs,
      ]);
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
    } finally {
      _updateAnalyticsStream();
      if (!initCompleter.isCompleted) initCompleter.complete();
    }
  }

  /// Clear all cached analytics data.
  void dispose() {
    constructListModel.dispose();
    _analyticsUpdateSubscription?.cancel();
    _analyticsUpdateSubscription = null;
    initCompleter = Completer<void>();
    _cache.clear();
    // perMessage.dispose();
  }

  Future<void> _onAnalyticsUpdate(AnalyticsUpdate analyticsUpdate) async {
    if (analyticsUpdate.isLogout) return;
    constructListModel.updateConstructs(analyticsUpdate.newConstructs);
    if (analyticsUpdate.type == AnalyticsUpdateType.server) {
      await _getConstructs(forceUpdate: true);
    }
    _updateAnalyticsStream(origin: analyticsUpdate.origin);
  }

  void _updateAnalyticsStream({AnalyticsUpdateOrigin? origin}) {
    analyticsStream.add(AnalyticsStreamUpdate(origin: origin));
  }

  /// A local cache of eventIds and construct uses for messages sent since the last update.
  /// It's a map of eventIDs to a list of OneConstructUses. Not just a list of OneConstructUses
  /// because, with practice activity constructs, we might need to add to the list for a given
  /// eventID.
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
          try {
            formattedCache[entry.key] =
                entry.value.map((e) => OneConstructUse.fromJson(e)).toList();
          } catch (err, s) {
            ErrorHandler.logError(
              e: err,
              s: s,
              data: {
                "key": entry.key,
              },
            );
            continue;
          }
        }
        return formattedCache;
      } catch (err) {
        // if something goes wrong while trying to format the local data, clear it
        _pangeaController.putAnalytics
            .clearMessagesSinceUpdate(clearDrafts: true);
        return {};
      }
    } catch (exception, stackTrace) {
      ErrorHandler.logError(
        e: PangeaWarningError(
          "Failed to get messages since update: $exception",
        ),
        s: stackTrace,
        m: 'Failed to retrieve messages since update',
        data: {
          "messagesSinceUpdate": PLocalKey.messagesSinceUpdate,
        },
      );
      return {};
    }
  }

  /// A flat list of all locally cached construct uses
  List<OneConstructUse> get _locallyCachedConstructs =>
      messagesSinceUpdate.values.expand((e) => e).toList();

  /// A flat list of all locally cached construct uses that are not drafts
  List<OneConstructUse> get locallyCachedSentConstructs =>
      messagesSinceUpdate.entries
          .where((entry) => !entry.key.startsWith('draft'))
          .expand((e) => e.value)
          .toList();

  /// Get a list of all constructs used by the logged in user in their current L2
  Future<List<OneConstructUse>> _getConstructs({
    bool forceUpdate = false,
    ConstructTypeEnum? constructType,
  }) async {
    // if the user isn't logged in, return an empty list
    if (_client.userID == null) return [];
    await _client.roomsLoading;

    // don't try to get constructs until last updated time has been loaded
    await _pangeaController.putAnalytics.lastUpdatedCompleter.future;

    // if forcing a refreshing, clear the cache
    if (forceUpdate) _cache.clear();

    final List<OneConstructUse>? local = _getConstructsLocal(
      constructType: constructType,
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
        await _allMyConstructs();

    final List<OneConstructUse> uses = [];
    for (final event in constructEvents) {
      uses.addAll(event.content.uses);
    }

    // if there isn't already a valid, local cache, cache the filtered uses
    if (local == null) {
      _cacheConstructs(
        constructType: constructType,
        uses: uses,
      );
    }

    return uses;
  }

  /// Get the last time the user updated their analytics for their current l2
  Future<DateTime?> myAnalyticsLastUpdated() async {
    // this function gets called soon after login, so first
    // make sure that the user's l2 is loaded, if the user has set their l2
    if (_client.userID != null && _l2Code == null) {
      await _pangeaController.matrixState.client.waitForAccountData();
      if (_l2Code == null) return null;
    }
    final Room? analyticsRoom = _client.analyticsRoomLocal(_l2Code!);
    if (analyticsRoom == null) return null;
    final DateTime? lastUpdated = await analyticsRoom.analyticsLastUpdated(
      _client.userID!,
    );
    return lastUpdated;
  }

  /// Get all the construct analytics events for the logged in user
  Future<List<ConstructAnalyticsEvent>> _allMyConstructs() async {
    if (_l2Code == null) return [];
    final Room? analyticsRoom = _client.analyticsRoomLocal(_l2Code!);
    if (analyticsRoom == null) return [];
    return await analyticsRoom.getAnalyticsEvents(userId: _client.userID!) ??
        [];
  }

  /// Get the cached construct uses for the current user, if it exists
  List<OneConstructUse>? _getConstructsLocal({
    ConstructTypeEnum? constructType,
  }) {
    final index = _cache.indexWhere(
      (e) => e.type == constructType && e.langCode == _l2Code,
    );

    if (index > -1) {
      final DateTime? lastUpdated = _pangeaController.putAnalytics.lastUpdated;
      if (_cache[index].needsUpdate(lastUpdated)) {
        _cache.removeAt(index);
        return null;
      }
      return _cache[index].uses;
    }

    return null;
  }

  /// Cache the construct uses for the current user
  void _cacheConstructs({
    required List<OneConstructUse> uses,
    ConstructTypeEnum? constructType,
  }) {
    if (_l2Code == null) return;
    final entry = AnalyticsCacheEntry(
      type: constructType,
      uses: List.from(uses),
      langCode: _l2Code!,
    );
    _cache.add(entry);
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

class AnalyticsStreamUpdate {
  final AnalyticsUpdateOrigin? origin;

  AnalyticsStreamUpdate({
    this.origin,
  });
}
