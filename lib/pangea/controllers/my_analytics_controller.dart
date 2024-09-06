import 'dart:async';

import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/choreo_record.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/models/representation_content_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/cached_stream_controller.dart';

enum AnalyticsUpdateType { server, local }

/// handles the processing of analytics for
/// 1) messages sent by the user and
/// 2) constructs used by the user, both in sending messages and doing practice activities
class MyAnalyticsController extends BaseController {
  late PangeaController _pangeaController;
  CachedStreamController<AnalyticsUpdateType> analyticsUpdateStream =
      CachedStreamController<AnalyticsUpdateType>();
  StreamSubscription? _messageSendSubscription;
  Timer? _updateTimer;

  Client get _client => _pangeaController.matrixState.client;

  String? get userL2 => _pangeaController.languageController.activeL2Code();

  /// the last time that matrix analytics events were updated for the user's current l2
  DateTime? lastUpdated;

  /// Last updated completer. Used to wait for the last
  /// updated time to be set before setting analytics data.
  Completer<DateTime?> lastUpdatedCompleter = Completer<DateTime?>();

  /// the max number of messages that will be cached before
  /// an automatic update is triggered
  final int _maxMessagesCached = 10;

  /// the number of minutes before an automatic update is triggered
  final int _minutesBeforeUpdate = 5;

  /// the time since the last update that will trigger an automatic update
  final Duration _timeSinceUpdate = const Duration(days: 1);

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  void initialize() {
    // Listen to a stream that provides the eventIDs
    // of new messages sent by the logged in user
    _messageSendSubscription ??= stateStream
        .where((data) => data is Map)
        .listen((data) => onMessageSent(data as Map<String, dynamic>));

    _refreshAnalyticsIfOutdated();
  }

  /// Reset analytics last updated time to null.
  @override
  void dispose() {
    _updateTimer?.cancel();
    lastUpdated = null;
    lastUpdatedCompleter = Completer<DateTime?>();
    _messageSendSubscription?.cancel();
    _messageSendSubscription = null;
    _refreshAnalyticsIfOutdated();
    clearMessagesSinceUpdate();
  }

  /// If analytics haven't been updated in the last day, update them
  Future<void> _refreshAnalyticsIfOutdated() async {
    // don't set anything is the user is not logged in
    if (_pangeaController.matrixState.client.userID == null) return;
    try {
      // if lastUpdated hasn't been set yet, set it
      lastUpdated ??=
          await _pangeaController.analytics.myAnalyticsLastUpdated();
    } catch (err, s) {
      ErrorHandler.logError(
        s: s,
        e: err,
        m: "Failed to get last updated time for analytics",
      );
    } finally {
      // if this is the initial load, complete the lastUpdatedCompleter
      if (!lastUpdatedCompleter.isCompleted) {
        lastUpdatedCompleter.complete(lastUpdated);
      }
    }

    final DateTime yesterday = DateTime.now().subtract(_timeSinceUpdate);
    if (lastUpdated?.isBefore(yesterday) ?? true) {
      debugPrint("analytics out-of-date, updating");
      await updateAnalytics();
    }
  }

  /// Given the data from a newly sent message, format and cache
  /// the message's construct data locally and reset the update timer
  void onMessageSent(Map<String, dynamic> data) {
    // cancel the last timer that was set on message event and
    // reset it to fire after _minutesBeforeUpdate minutes
    _updateTimer?.cancel();
    _updateTimer = Timer(Duration(minutes: _minutesBeforeUpdate), () {
      debugPrint("timer fired, updating analytics");
      updateAnalytics();
    });

    // extract the relevant data about this message
    final String? eventID = data['eventID'];
    final String? roomID = data['roomID'];
    final String? eventType = data['eventType'];
    final PangeaRepresentation? originalSent = data['originalSent'];
    final PangeaMessageTokens? tokensSent = data['tokensSent'];
    final ChoreoRecord? choreo = data['choreo'];
    final PracticeActivityEvent? practiceActivity = data['practiceActivity'];
    final PracticeActivityRecordModel? recordModel = data['recordModel'];

    if (roomID == null || eventID == null) return;

    // convert that data into construct uses and add it to the cache
    final metadata = ConstructUseMetaData(
      roomId: roomID,
      eventId: eventID,
      timeStamp: DateTime.now(),
    );

    final List<OneConstructUse> constructs = getDraftUses(roomID);

    if (eventType == EventTypes.Message) {
      final grammarConstructs =
          choreo?.grammarConstructUses(metadata: metadata);
      final vocabUses = tokensSent != null
          ? originalSent?.vocabUses(
              choreo: choreo,
              tokens: tokensSent.tokens,
              metadata: metadata,
            )
          : null;
      constructs.addAll([
        ...(grammarConstructs ?? []),
        ...(vocabUses ?? []),
      ]);
    }

    if (eventType == PangeaEventTypes.activityRecord &&
        practiceActivity != null) {
      final activityConstructs = recordModel?.uses(
        practiceActivity,
        metadata: metadata,
      );
      constructs.addAll(activityConstructs ?? []);
    }

    _pangeaController.analytics
        .filterConstructs(unfilteredConstructs: constructs)
        .then((filtered) {
      if (filtered.isEmpty) return;
      filtered.addAll(getDraftUses(roomID));
      final level = _pangeaController.analytics.level;
      addLocalMessage(eventID, filtered).then(
        (_) {
          clearDraftUses(roomID);
          afterAddLocalMessages(level);
        },
      );
    });
  }

  void addDraftUses(
    List<PangeaToken> tokens,
    String roomID,
    ConstructUseTypeEnum useType,
  ) {
    final metadata = ConstructUseMetaData(
      roomId: roomID,
      timeStamp: DateTime.now(),
    );

    final uses = tokens
        .map(
          (token) => OneConstructUse(
            useType: useType,
            lemma: token.lemma.text,
            form: token.lemma.form,
            constructType: ConstructTypeEnum.vocab,
            metadata: metadata,
          ),
        )
        .toList();

    for (final token in tokens) {
      for (final entry in token.morph.entries) {
        uses.add(
          OneConstructUse(
            useType: useType,
            lemma: entry.value,
            categories: [entry.key],
            constructType: ConstructTypeEnum.morph,
            metadata: metadata,
          ),
        );
      }
    }

    final level = _pangeaController.analytics.level;
    addLocalMessage('draft$roomID', uses).then(
      (_) => afterAddLocalMessages(level),
    );
  }

  List<OneConstructUse> getDraftUses(String roomID) {
    final currentCache = _pangeaController.analytics.messagesSinceUpdate;
    return currentCache['draft$roomID'] ?? [];
  }

  void clearDraftUses(String roomID) {
    final currentCache = _pangeaController.analytics.messagesSinceUpdate;
    currentCache.remove('draft$roomID');
    setMessagesSinceUpdate(currentCache);
  }

  /// Add a list of construct uses for a new message to the local
  /// cache of recently sent messages
  Future<void> addLocalMessage(
    String eventID,
    List<OneConstructUse> constructs,
  ) async {
    try {
      final currentCache = _pangeaController.analytics.messagesSinceUpdate;
      constructs.addAll(currentCache[eventID] ?? []);
      currentCache[eventID] = constructs;

      await setMessagesSinceUpdate(currentCache);
    } catch (e, s) {
      ErrorHandler.logError(
        e: PangeaWarningError("Failed to add message since update: $e"),
        s: s,
        m: 'Failed to add message since update for eventId: $eventID',
      );
    }
  }

  /// Handles cleanup after adding a new message to the local cache.
  /// If the addition brought the total number of messages in the cache
  /// to the max, or if the addition triggered a level-up, update the analytics.
  /// Otherwise, add a local update to the alert stream.
  void afterAddLocalMessages(int prevLevel) {
    if (_pangeaController.analytics.messagesSinceUpdate.length >
        _maxMessagesCached) {
      debugPrint("reached max messages, updating");
      updateAnalytics();
      return;
    }

    final int newLevel = _pangeaController.analytics.level;
    newLevel > prevLevel
        ? updateAnalytics()
        : analyticsUpdateStream.add(AnalyticsUpdateType.local);
  }

  /// Clears the local cache of recently sent constructs. Called before updating analytics
  void clearMessagesSinceUpdate() {
    _pangeaController.pStoreService.delete(PLocalKey.messagesSinceUpdate);
  }

  /// Save the local cache of recently sent constructs to the local storage
  Future<void> setMessagesSinceUpdate(
    Map<String, List<OneConstructUse>> cache,
  ) async {
    final formattedCache = {};
    for (final entry in cache.entries) {
      final constructJsons = entry.value.map((e) => e.toJson()).toList();
      formattedCache[entry.key] = constructJsons;
    }
    await _pangeaController.pStoreService.save(
      PLocalKey.messagesSinceUpdate,
      formattedCache,
    );
  }

  /// Prevent concurrent updates to analytics
  Completer<void>? _updateCompleter;

  /// Updates learning analytics.
  ///
  /// This method is responsible for updating the analytics. It first checks if an update is already in progress
  /// by checking the completion status of the [_updateCompleter]. If an update is already in progress, it waits
  /// for the completion of the previous update and returns. Otherwise, it creates a new [_updateCompleter] and
  /// proceeds with the update process. If the update is successful, it clears any messages that were received
  /// since the last update and notifies the [analyticsUpdateStream].
  Future<void> updateAnalytics() async {
    if (_pangeaController.matrixState.client.userID == null) return;
    if (!(_updateCompleter?.isCompleted ?? true)) {
      await _updateCompleter!.future;
      return;
    }
    _updateCompleter = Completer<void>();
    try {
      await _updateAnalytics();
      clearMessagesSinceUpdate();

      lastUpdated = DateTime.now();
      analyticsUpdateStream.add(AnalyticsUpdateType.server);
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        m: "Failed to update analytics",
        s: s,
      );
    } finally {
      _updateCompleter?.complete();
      _updateCompleter = null;
    }
  }

  /// Updates the analytics by sending cached analytics data to the analytics room.
  /// The analytics room is determined based on the user's current target language.
  Future<void> _updateAnalytics() async {
    // if there's no cached construct data, there's nothing to send
    final cachedConstructs = _pangeaController.analytics.messagesSinceUpdate;
    final bool onlyDraft = cachedConstructs.length == 1 &&
        cachedConstructs.keys.single.startsWith('draft');
    if (cachedConstructs.isEmpty || onlyDraft) return;

    // if missing important info, don't send analytics. Could happen if user just signed up.
    if (userL2 == null || _client.userID == null) return;

    // analytics room for the user and current target language
    final Room? analyticsRoom = await _client.getMyAnalyticsRoom(userL2!);

    // and send cached analytics data to the room
    await analyticsRoom?.sendConstructsEvent(
      _pangeaController.analytics.locallyCachedSentConstructs,
    );
  }
}
