import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_event.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/controllers/base_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_selection_repo.dart';

/// A minimized version of AnalyticsController that get the logged in user's analytics
class GetAnalyticsController extends BaseController {
  final GetStorage analyticsBox = GetStorage("analytics_storage");
  late PangeaController _pangeaController;
  late PracticeSelectionRepo perMessage;

  final List<AnalyticsCacheEntry> _cache = [];
  StreamSubscription<AnalyticsUpdate>? _analyticsUpdateSubscription;
  StreamController<AnalyticsStreamUpdate> analyticsStream =
      StreamController.broadcast();
  StreamSubscription? _joinSpaceSubscription;

  ConstructListModel constructListModel = ConstructListModel(uses: []);
  Completer<void> initCompleter = Completer<void>();
  bool _initializing = false;

  GetAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  LanguageModel? get _l1 => _pangeaController.languageController.userL1;
  LanguageModel? get _l2 => _pangeaController.languageController.userL2;

  Client get _client => _pangeaController.matrixState.client;

  // the minimum XP required for a given level
  int get _minXPForLevel {
    return constructListModel.calculateXpWithLevel(constructListModel.level);
  }

  // the minimum XP required for the next level
  int get _minXPForNextLevel {
    return constructListModel
        .calculateXpWithLevel(constructListModel.level + 1);
  }

  int get minXPForNextLevel => _minXPForNextLevel;

  // the progress within the current level as a percentage (0.0 to 1.0)
  double get levelProgress {
    final progress = (constructListModel.totalXP - _minXPForLevel) /
        (_minXPForNextLevel - _minXPForLevel);
    return progress >= 0 ? progress : 0;
  }

  Future<void> initialize() async {
    if (_initializing || initCompleter.isCompleted) return;
    _initializing = true;

    try {
      _client.updateAnalyticsRoomVisibility();
      _client.addAnalyticsRoomsToSpaces();

      _analyticsUpdateSubscription ??= _pangeaController
          .putAnalytics.analyticsUpdateStream.stream
          .listen(_onAnalyticsUpdate);

      // When a newly-joined space comes through in a sync
      // update, add the analytics rooms to the space
      _joinSpaceSubscription ??= _client.onSync.stream
          .where(_client.isJoinSpaceSyncUpdate)
          .listen((_) => _client.addAnalyticsRoomsToSpaces());

      await _pangeaController.putAnalytics.lastUpdatedCompleter.future;
      await _getConstructs();

      final offset =
          _pangeaController.userController.publicProfile?.xpOffset ?? 0;
      constructListModel.updateConstructs(
        [
          ...(_getConstructsLocal() ?? []),
          ..._locallyCachedConstructs,
        ],
        offset,
      );
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
    } finally {
      _updateAnalyticsStream(points: 0, newConstructs: []);
      if (!initCompleter.isCompleted) initCompleter.complete();
      _initializing = false;
    }
  }

  /// Clear all cached analytics data.
  @override
  void dispose() {
    constructListModel = ConstructListModel(uses: []);
    _analyticsUpdateSubscription?.cancel();
    _analyticsUpdateSubscription = null;
    _joinSpaceSubscription?.cancel();
    _joinSpaceSubscription = null;
    initCompleter = Completer<void>();
    _cache.clear();
    // perMessage.dispose();
  }

  Future<void> _onAnalyticsUpdate(
    AnalyticsUpdate analyticsUpdate,
  ) async {
    if (analyticsUpdate.isLogout) return;
    final oldLevel = constructListModel.level;

    final offset =
        _pangeaController.userController.publicProfile?.xpOffset ?? 0;

    final prevUnlockedMorphs = constructListModel
        .unlockedLemmas(
          ConstructTypeEnum.morph,
          threshold: 25,
        )
        .toSet();

    final prevUnlockedVocab =
        constructListModel.unlockedLemmas(ConstructTypeEnum.vocab).toSet();

    constructListModel.updateConstructs(analyticsUpdate.newConstructs, offset);

    final newUnlockedMorphs = constructListModel
        .unlockedLemmas(
          ConstructTypeEnum.morph,
          threshold: 25,
        )
        .toSet()
        .difference(prevUnlockedMorphs);

    final newUnlockedVocab = constructListModel
        .unlockedLemmas(ConstructTypeEnum.vocab)
        .toSet()
        .difference(prevUnlockedVocab);

    if (analyticsUpdate.type == AnalyticsUpdateType.server) {
      await _getConstructs(forceUpdate: true);
    }
    if (oldLevel < constructListModel.level) {
      // do not await this - it's not necessary for this to finish
      // before the function completes and it blocks the UI
      _onLevelUp(oldLevel, constructListModel.level);
    }
    if (oldLevel > constructListModel.level) {
      await _onLevelDown(constructListModel.level, oldLevel);
    }
    if (newUnlockedMorphs.isNotEmpty) {
      _onUnlockMorphLemmas(newUnlockedMorphs);
    }
    _updateAnalyticsStream(
      points: analyticsUpdate.newConstructs.fold<int>(
        0,
        (previousValue, element) => previousValue + element.xp,
      ),
      targetID: analyticsUpdate.targetID,
      newConstructs: [...newUnlockedMorphs, ...newUnlockedVocab],
    );
    // Update public profile each time that new analytics are added.
    // If the level hasn't changed, this will not send an update to the server.
    // Do this on all updates (not just on level updates) to account for cases
    // of target language updates being missed (https://github.com/pangeachat/client/issues/2006)
    _pangeaController.userController.updatePublicProfile(
      level: constructListModel.level,
    );
  }

  void _updateAnalyticsStream({
    required int points,
    required List<ConstructIdentifier> newConstructs,
    String? targetID,
  }) =>
      analyticsStream.add(
        AnalyticsStreamUpdate(
          points: points,
          newConstructs: newConstructs,
          targetID: targetID,
        ),
      );

  void _onLevelUp(final int lowerLevel, final int upperLevel) {
    setState({
      'level_up': constructListModel.level,
      'upper_level': upperLevel,
      'lower_level': lowerLevel,
    });
  }

  Future<void> _onLevelDown(final int lowerLevel, final int upperLevel) async {
    final offset = constructListModel.calculateXpWithLevel(lowerLevel) -
        constructListModel.totalXP;
    await _pangeaController.userController.addXPOffset(offset);
    constructListModel.updateConstructs(
      [],
      _pangeaController.userController.publicProfile!.xpOffset!,
    );
  }

  void _onUnlockMorphLemmas(Set<ConstructIdentifier> unlocked) {
    setState({'unlocked_constructs': unlocked});
  }

  /// A local cache of eventIds and construct uses for messages sent since the last update.
  /// It's a map of eventIDs to a list of OneConstructUses. Not just a list of OneConstructUses
  /// because, with practice activity constructs, we might need to add to the list for a given
  /// eventID.
  Map<String, List<OneConstructUse>> get messagesSinceUpdate {
    try {
      final dynamic locallySaved = analyticsBox.read(
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
    if (_client.prevBatch == null) {
      await _client.onSync.stream.first;
    }

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
    if (_client.userID != null && _l2 == null) {
      if (_pangeaController.matrixState.client.prevBatch == null) {
        await _pangeaController.matrixState.client.onSync.stream.first;
      }
      if (_l2 == null) return null;
    }
    final Room? analyticsRoom = _client.analyticsRoomLocal(_l2!);
    if (analyticsRoom == null) return null;
    final DateTime? lastUpdated = await analyticsRoom.analyticsLastUpdated(
      _client.userID!,
    );
    return lastUpdated;
  }

  /// Get all the construct analytics events for the logged in user
  Future<List<ConstructAnalyticsEvent>> _allMyConstructs() async {
    if (_l2 == null) return [];
    final Room? analyticsRoom = _client.analyticsRoomLocal(_l2!);
    if (analyticsRoom == null) return [];
    return await analyticsRoom.getAnalyticsEvents(userId: _client.userID!) ??
        [];
  }

  /// Get the cached construct uses for the current user, if it exists
  List<OneConstructUse>? _getConstructsLocal({
    ConstructTypeEnum? constructType,
  }) {
    final index = _cache.indexWhere(
      (e) => e.type == constructType && e.langCode == _l2?.langCodeShort,
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
    if (_l2 == null) return;
    final entry = AnalyticsCacheEntry(
      type: constructType,
      uses: List.from(uses),
      langCode: _l2!.langCodeShort,
    );
    _cache.add(entry);
  }

  Future<String> _saveConstructSummaryResponseToStateEvent(
    final ConstructSummary summary,
  ) async {
    final Room? analyticsRoom = _client.analyticsRoomLocal(_l2!);
    final stateEventId = await _client.setRoomStateWithKey(
      analyticsRoom!.id,
      PangeaEventTypes.constructSummary,
      '',
      summary.toJson(),
    );
    return stateEventId;
  }

  int newConstructCount(
    List<OneConstructUse> newConstructs,
    ConstructTypeEnum type,
  ) {
    final uses = newConstructs.where((c) => c.constructType == type);
    final Map<ConstructIdentifier, int> constructPoints = {};
    for (final use in uses) {
      constructPoints[use.identifier] ??= 0;
      constructPoints[use.identifier] =
          constructPoints[use.identifier]! + use.xp;
    }

    int newConstructCount = 0;
    for (final entry in constructPoints.entries) {
      final construct = constructListModel.getConstructUses(entry.key);
      if (construct == null || construct.points == entry.value) {
        newConstructCount++;
      }
    }

    return newConstructCount;
  }

//   Future<GenerateConstructSummaryResult?>
//       _generateLevelUpAnalyticsAndSaveToStateEvent(
//     final int lowerLevel,
//     final int upperLevel,
//   ) async {
//     // generate level up analytics as a construct summary
//     ConstructSummary summary;
//     try {
//       final int maxXP = constructListModel.calculateXpWithLevel(upperLevel);
//       final int minXP = constructListModel.calculateXpWithLevel(lowerLevel);
//       int diffXP = maxXP - minXP;
//       if (diffXP < 0) diffXP = 0;

  Future<ConstructSummary?> getConstructSummaryFromStateEvent() async {
    try {
      final Room? analyticsRoom = _client.analyticsRoomLocal(_l2!);
      if (analyticsRoom == null) return null;
      final state =
          analyticsRoom.getState(PangeaEventTypes.constructSummary, '');
      if (state == null) return null;
      return ConstructSummary.fromJson(state.content);
    } catch (e) {
      debugPrint("Error getting construct summary room: $e");
      ErrorHandler.logError(e: e, data: {'e': e});
      return null;
    }
  }

  Future<ConstructSummary?> generateLevelUpAnalytics(
    final int lowerLevel,
    final int upperLevel,
  ) async {
    // generate level up analytics as a construct summary
    ConstructSummary summary;
    try {
      final int maxXP = constructListModel.calculateXpWithLevel(upperLevel);
      final int minXP = constructListModel.calculateXpWithLevel(lowerLevel);
      int diffXP = maxXP - minXP;
      if (diffXP < 0) diffXP = 0;

      // compute construct use of current level
      final List<OneConstructUse> constructUseOfCurrentLevel = [];
      int score = 0;
      for (final use in constructListModel.uses) {
        constructUseOfCurrentLevel.add(use);
        score += use.xp;
        if (score >= diffXP) break;
      }

      // extract construct use message bodies for analytics
      List<String?>? constructUseMessageContentBodies = [];
      for (final use in constructUseOfCurrentLevel) {
        try {
          final useMessage = await use.getEvent(_client);
          final useMessageBody = useMessage?.content["body"];
          if (useMessageBody is String) {
            constructUseMessageContentBodies.add(useMessageBody);
          } else {
            constructUseMessageContentBodies.add(null);
          }
        } catch (e) {
          constructUseMessageContentBodies.add(null);
        }
      }
      if (constructUseMessageContentBodies.length !=
          constructUseOfCurrentLevel.length) {
        constructUseMessageContentBodies = null;
      }

      final request = ConstructSummaryRequest(
        constructs: constructUseOfCurrentLevel,
        constructUseMessageContentBodies: constructUseMessageContentBodies,
        language: _l1!.langCodeShort,
        upperLevel: upperLevel,
        lowerLevel: lowerLevel,
      );

      final response = await ConstructRepo.generateConstructSummary(request);
      summary = response.summary;
    } catch (e) {
      debugPrint("Error generating level up analytics: $e");
      ErrorHandler.logError(e: e, data: {'e': e});
      return null;
    }

    try {
      final Room? analyticsRoom = await _client.getMyAnalyticsRoom(_l2!);
      if (analyticsRoom == null) {
        throw "Analytics room not found for user";
      }

      // don't await this, just return the original response
      _saveConstructSummaryResponseToStateEvent(
        summary,
      );
    } catch (e, s) {
      debugPrint("Error saving construct summary room: $e");
      ErrorHandler.logError(e: e, s: s, data: {'e': e});
    }

    return summary;
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
  final int points;
  final List<ConstructIdentifier> newConstructs;
  final String? targetID;

  AnalyticsStreamUpdate({
    required this.points,
    required this.newConstructs,
    this.targetID,
  });
}
