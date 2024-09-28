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
class MyAnalyticsController extends BaseController<AnalyticsStream> {
  late PangeaController _pangeaController;
  CachedStreamController<AnalyticsUpdateType> analyticsUpdateStream =
      CachedStreamController<AnalyticsUpdateType>();
  StreamSubscription<AnalyticsStream>? _messageSendSubscription;
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
  final int _minutesBeforeUpdate = 2;

  /// the time since the last update that will trigger an automatic update
  final Duration _timeSinceUpdate = const Duration(days: 1);

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  void initialize() {
    // Listen to a stream that provides the eventIDs
    // of new messages sent by the logged in user
    _messageSendSubscription ??=
        stateStream.listen((data) => _onNewAnalyticsData(data));

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
      await sendLocalAnalyticsToAnalyticsRoom();
    }
  }

  /// Given the data from a newly sent message, format and cache
  /// the message's construct data locally and reset the update timer
  void _onNewAnalyticsData(AnalyticsStream data) {
    // convert that data into construct uses and add it to the cache
    final metadata = ConstructUseMetaData(
      roomId: data.roomId,
      eventId: data.eventId,
      timeStamp: DateTime.now(),
    );

    final List<OneConstructUse> constructs = _getDraftUses(data.roomId);

    if (data.eventType == EventTypes.Message) {
      constructs.addAll([
        ...(data.choreo!.grammarConstructUses(metadata: metadata)),
        ...(data.originalSent!.vocabUses(
          choreo: data.choreo,
          tokens: data.tokensSent!.tokens,
          metadata: metadata,
        )),
      ]);
    } else if (data.eventType == PangeaEventTypes.activityRecord &&
        data.practiceActivity != null) {
      final activityConstructs = data.recordModel!.uses(
        data.practiceActivity!,
        metadata: metadata,
      );
      constructs.addAll(activityConstructs);
    } else {
      throw PangeaWarningError("Invalid event type for analytics stream");
    }

    final String eventID = data.eventId;
    final String roomID = data.roomId;

    _pangeaController.analytics
        .filterConstructs(unfilteredConstructs: constructs)
        .then((filtered) {
      if (filtered.isEmpty) return;

      // @ggurdin - are we sure this isn't happening twice? it's also above
      filtered.addAll(_getDraftUses(data.roomId));

      final level = _pangeaController.analytics.level;

      _addLocalMessage(eventID, filtered).then(
        (_) {
          _clearDraftUses(roomID);
          _decideWhetherToUpdateAnalyticsRoom(level);
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
        .where((token) => token.lemma.saveVocab)
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

    // @ggurdin - if the point of draft uses is that we don't want to send them twice,
    // then, if this is triggered here, couldn't that make a problem?
    final level = _pangeaController.analytics.level;
    _addLocalMessage('draft$roomID', uses).then(
      (_) => _decideWhetherToUpdateAnalyticsRoom(level),
    );
  }

  List<OneConstructUse> _getDraftUses(String roomID) {
    final currentCache = _pangeaController.analytics.messagesSinceUpdate;
    return currentCache['draft$roomID'] ?? [];
  }

  void _clearDraftUses(String roomID) {
    final currentCache = _pangeaController.analytics.messagesSinceUpdate;
    currentCache.remove('draft$roomID');
    _setMessagesSinceUpdate(currentCache);
  }

  /// Add a list of construct uses for a new message to the local
  /// cache of recently sent messages
  Future<void> _addLocalMessage(
    String eventID,
    List<OneConstructUse> constructs,
  ) async {
    try {
      final currentCache = _pangeaController.analytics.messagesSinceUpdate;
      constructs.addAll(currentCache[eventID] ?? []);
      currentCache[eventID] = constructs;

      await _setMessagesSinceUpdate(currentCache);
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
  void _decideWhetherToUpdateAnalyticsRoom(int prevLevel) {
    // cancel the last timer that was set on message event and
    // reset it to fire after _minutesBeforeUpdate minutes
    _updateTimer?.cancel();
    _updateTimer = Timer(Duration(minutes: _minutesBeforeUpdate), () {
      debugPrint("timer fired, updating analytics");
      sendLocalAnalyticsToAnalyticsRoom();
    });

    if (_pangeaController.analytics.messagesSinceUpdate.length >
        _maxMessagesCached) {
      debugPrint("reached max messages, updating");
      sendLocalAnalyticsToAnalyticsRoom();
      return;
    }

    final int newLevel = _pangeaController.analytics.level;
    newLevel > prevLevel
        ? sendLocalAnalyticsToAnalyticsRoom()
        : analyticsUpdateStream.add(AnalyticsUpdateType.local);
  }

  /// Clears the local cache of recently sent constructs. Called before updating analytics
  void clearMessagesSinceUpdate() {
    _pangeaController.pStoreService.delete(PLocalKey.messagesSinceUpdate);
  }

  /// Save the local cache of recently sent constructs to the local storage
  Future<void> _setMessagesSinceUpdate(
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
  Future<void> sendLocalAnalyticsToAnalyticsRoom() async {
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

class AnalyticsStream {
  final String eventId;
  final String eventType;
  final String roomId;

  /// if the event is a message, the original message sent
  final PangeaRepresentation? originalSent;

  /// if the event is a message, the tokens sent
  final PangeaMessageTokens? tokensSent;

  /// if the event is a message, the choreo record
  final ChoreoRecord? choreo;

  /// if the event is a practice activity, the practice activity event
  final PracticeActivityEvent? practiceActivity;

  /// if the event is a practice activity, the record model
  final PracticeActivityRecordModel? recordModel;

  AnalyticsStream({
    required this.eventId,
    required this.eventType,
    required this.roomId,
    this.originalSent,
    this.tokensSent,
    this.choreo,
    this.practiceActivity,
    this.recordModel,
  }) {
    assert(
      (originalSent != null && tokensSent != null && choreo != null) ||
          (practiceActivity != null && recordModel != null),
      "Either a message or a practice activity must be provided",
    );

    assert(
      eventType == EventTypes.Message ||
          eventType == PangeaEventTypes.activityRecord,
    );
  }
}
