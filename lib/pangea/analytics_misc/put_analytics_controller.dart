import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/controllers/base_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum AnalyticsUpdateType { server, local }

/// handles the processing of analytics for
/// 1) messages sent by the user and
/// 2) constructs used by the user, both in sending messages and doing practice activities
class PutAnalyticsController extends BaseController<AnalyticsStream> {
  late PangeaController _pangeaController;
  StreamController<AnalyticsUpdate> analyticsUpdateStream =
      StreamController.broadcast();
  StreamSubscription<AnalyticsStream>? _analyticsStream;
  StreamSubscription? _languageStream;
  Timer? _updateTimer;

  Client get _client => _pangeaController.matrixState.client;

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

  PutAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  void initialize() {
    // Listen for calls to setState on the analytics stream
    // and update the analytics room if necessary
    _analyticsStream ??=
        stateStream.listen((data) => _onNewAnalyticsData(data));

    // Listen for changes to the user's language settings
    _languageStream ??=
        _pangeaController.userController.stateStream.listen((update) {
      if (update is Map<String, dynamic> &&
          update['prev_target_lang'] is LanguageModel) {
        final LanguageModel previousL2 = update['prev_target_lang'];
        _onUpdateLanguages(previousL2);
      }
    });

    _refreshAnalyticsIfOutdated();
  }

  /// Reset analytics last updated time to null.
  @override
  void dispose() {
    _updateTimer?.cancel();
    lastUpdated = null;
    lastUpdatedCompleter = Completer<DateTime?>();
    _analyticsStream?.cancel();
    _analyticsStream = null;
    _languageStream?.cancel();
    _languageStream = null;
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
          await _pangeaController.getAnalytics.myAnalyticsLastUpdated();
    } catch (err, s) {
      ErrorHandler.logError(
        s: s,
        e: err,
        m: "Failed to get last updated time for analytics",
        data: {},
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

  /// Given new construct uses, format and cache
  /// the data locally and reset the update timer
  /// Decide whether to update the analytics room
  void _onNewAnalyticsData(AnalyticsStream data) {
    final String? eventID = data.eventId;
    final String? roomID = data.roomId;

    List<OneConstructUse> constructs = [];
    if (roomID != null) {
      constructs = _getDraftUses(roomID);
    }

    constructs.addAll(data.constructs);

    if (kDebugMode) {
      for (final use in constructs) {
        debugPrint(
          "_onNewAnalyticsData filtered use: ${use.constructType.string} ${use.useType.string} ${use.lemma} ${use.useType.pointValue}",
        );
      }
    }

    final level = _pangeaController.getAnalytics.constructListModel.level;

    _addLocalMessage(eventID, constructs).then(
      (_) {
        if (roomID != null) _clearDraftUses(roomID);
        _decideWhetherToUpdateAnalyticsRoom(
          level,
          data.origin,
          data.constructs,
        );
      },
    );
  }

  Future<void> _onUpdateLanguages(LanguageModel? previousL2) async {
    await sendLocalAnalyticsToAnalyticsRoom(
      l2Override: previousL2,
    );
    _pangeaController.resetAnalytics().then((_) {
      final level = _pangeaController.getAnalytics.constructListModel.level;
      _pangeaController.userController.updatePublicProfile(level: level);
    });
  }

  void addDraftUses(
    List<PangeaToken> tokens,
    String roomID,
    ConstructUseTypeEnum useType,
    AnalyticsUpdateOrigin origin,
  ) {
    final metadata = ConstructUseMetaData(
      roomId: roomID,
      timeStamp: DateTime.now(),
    );

    // we only save those with saveVocab == true
    final tokensToSave =
        tokens.where((token) => token.lemma.saveVocab).toList();

    // get all our vocab constructs
    final uses = tokensToSave
        .map(
          (token) => OneConstructUse(
            useType: useType,
            lemma: token.lemma.text,
            form: token.text.content,
            constructType: ConstructTypeEnum.vocab,
            metadata: metadata,
            category: token.pos,
          ),
        )
        .toList();

    // get all our grammar constructs
    for (final token in tokensToSave) {
      uses.add(
        OneConstructUse(
          useType: useType,
          lemma: token.pos,
          form: token.text.content,
          category: "POS",
          constructType: ConstructTypeEnum.morph,
          metadata: metadata,
        ),
      );
      for (final entry in token.morph.entries) {
        uses.add(
          OneConstructUse(
            useType: useType,
            lemma: entry.value,
            form: token.text.content,
            category: entry.key,
            constructType: ConstructTypeEnum.morph,
            metadata: metadata,
          ),
        );
      }
    }

    if (kDebugMode) {
      for (final use in uses) {
        debugPrint(
          "Draft use: ${use.constructType.string} ${use.useType.string} ${use.lemma} ${use.useType.pointValue}",
        );
      }
    }

    final level = _pangeaController.getAnalytics.constructListModel.level;

    // the list 'uses' gets altered in the _addLocalMessage method,
    // so copy it here to that the list of new uses is accurate
    final List<OneConstructUse> newUses = List.from(uses);
    _addLocalMessage('draft$roomID', uses).then(
      (_) => _decideWhetherToUpdateAnalyticsRoom(level, origin, newUses),
    );
  }

  List<OneConstructUse> _getDraftUses(String roomID) {
    final currentCache = _pangeaController.getAnalytics.messagesSinceUpdate;
    return currentCache['draft$roomID'] ?? [];
  }

  void _clearDraftUses(String roomID) {
    final currentCache = _pangeaController.getAnalytics.messagesSinceUpdate;
    currentCache.remove('draft$roomID');
    _setMessagesSinceUpdate(currentCache);
  }

  /// Add a list of construct uses for a new message to the local
  /// cache of recently sent messages
  Future<void> _addLocalMessage(
    String? cacheKey,
    List<OneConstructUse> constructs,
  ) async {
    try {
      final currentCache = _pangeaController.getAnalytics.messagesSinceUpdate;
      constructs.addAll(currentCache[cacheKey] ?? []);

      // if this is not a draft message, add the eventId to the metadata
      // if it's missing (it will be missing for draft constructs)
      if (cacheKey != null && !cacheKey.startsWith('draft')) {
        constructs = constructs.map((construct) {
          if (construct.metadata.eventId != null) return construct;
          construct.metadata.eventId = cacheKey;
          return construct;
        }).toList();
      }

      cacheKey ??= Object.hashAll(constructs).toString();
      currentCache[cacheKey] = constructs;

      await _setMessagesSinceUpdate(currentCache);
    } catch (e, s) {
      ErrorHandler.logError(
        e: PangeaWarningError("Failed to add message since update: $e"),
        s: s,
        m: 'Failed to add message since update for eventId: $cacheKey',
        data: {
          "cacheKey": cacheKey,
        },
      );
    }
  }

  /// Handles cleanup after adding a new message to the local cache.
  /// If the addition brought the total number of messages in the cache
  /// to the max, or if the addition triggered a level-up, update the analytics.
  /// Otherwise, add a local update to the alert stream.
  void _decideWhetherToUpdateAnalyticsRoom(
    int prevLevel,
    AnalyticsUpdateOrigin? origin,
    List<OneConstructUse> newConstructs,
  ) {
    // cancel the last timer that was set on message event and
    // reset it to fire after _minutesBeforeUpdate minutes
    _updateTimer?.cancel();
    _updateTimer = Timer(Duration(minutes: _minutesBeforeUpdate), () {
      debugPrint("timer fired, updating analytics");
      sendLocalAnalyticsToAnalyticsRoom();
    });

    if (_pangeaController.getAnalytics.messagesSinceUpdate.length >
        _maxMessagesCached) {
      debugPrint("reached max messages, updating");
      sendLocalAnalyticsToAnalyticsRoom();
      return;
    }

    final int newLevel =
        _pangeaController.getAnalytics.constructListModel.level;
    newLevel > prevLevel
        ? sendLocalAnalyticsToAnalyticsRoom()
        : analyticsUpdateStream.add(
            AnalyticsUpdate(
              AnalyticsUpdateType.local,
              newConstructs,
              origin: origin,
            ),
          );
  }

  /// Clears the local cache of recently sent constructs. Called before updating analytics
  void clearMessagesSinceUpdate({clearDrafts = false}) {
    if (clearDrafts) {
      MatrixState.pangeaController.getAnalytics.analyticsBox
          .remove(PLocalKey.messagesSinceUpdate);
      return;
    }

    final localCache = _pangeaController.getAnalytics.messagesSinceUpdate;
    final draftKeys = localCache.keys.where((key) => key.startsWith('draft'));
    if (draftKeys.isEmpty) {
      MatrixState.pangeaController.getAnalytics.analyticsBox
          .remove(PLocalKey.messagesSinceUpdate);
      return;
    }

    final Map<String, List<OneConstructUse>> newCache = {};
    for (final key in draftKeys) {
      newCache[key] = localCache[key]!;
    }
    _setMessagesSinceUpdate(newCache);
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
    await MatrixState.pangeaController.getAnalytics.analyticsBox.write(
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
  Future<void> sendLocalAnalyticsToAnalyticsRoom({
    onLogout = false,
    LanguageModel? l2Override,
  }) async {
    if (_pangeaController.matrixState.client.userID == null) return;
    if (_pangeaController.getAnalytics.messagesSinceUpdate.isEmpty) return;

    if (!(_updateCompleter?.isCompleted ?? true)) {
      await _updateCompleter!.future;
      return;
    }
    _updateCompleter = Completer<void>();
    try {
      await _updateAnalytics(l2Override: l2Override);
      clearMessagesSinceUpdate();

      lastUpdated = DateTime.now();
      analyticsUpdateStream.add(
        AnalyticsUpdate(
          AnalyticsUpdateType.server,
          [],
          isLogout: onLogout,
        ),
      );
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        m: "Failed to update analytics",
        s: s,
        data: {
          "l2Override": l2Override,
        },
      );
    } finally {
      _updateCompleter?.complete();
      _updateCompleter = null;
    }
  }

  /// Updates the analytics by sending cached analytics data to the analytics room.
  /// The analytics room is determined based on the user's current target language.
  Future<void> _updateAnalytics({LanguageModel? l2Override}) async {
    // if there's no cached construct data, there's nothing to send
    final cachedConstructs = _pangeaController.getAnalytics.messagesSinceUpdate;
    final bool onlyDraft = cachedConstructs.length == 1 &&
        cachedConstructs.keys.single.startsWith('draft');
    if (cachedConstructs.isEmpty || onlyDraft) return;

    // if missing important info, don't send analytics. Could happen if user just signed up.
    final l2 = l2Override ?? _pangeaController.languageController.userL2;
    if (l2 == null || _client.userID == null) return;

    // analytics room for the user and current target language
    final Room? analyticsRoom = await _client.getMyAnalyticsRoom(l2);

    // and send cached analytics data to the room
    await analyticsRoom?.sendConstructsEvent(
      _pangeaController.getAnalytics.locallyCachedSentConstructs,
    );
  }
}

class AnalyticsStream {
  final String? eventId;
  final String? roomId;
  final AnalyticsUpdateOrigin? origin;

  final List<OneConstructUse> constructs;

  AnalyticsStream({
    required this.eventId,
    required this.roomId,
    required this.constructs,
    this.origin,
  });
}

enum AnalyticsUpdateOrigin {
  it,
  igc,
  sendMessage,
  practiceActivity,
  inputBar,
  wordZoom,
}

class AnalyticsUpdate {
  final AnalyticsUpdateType type;
  final AnalyticsUpdateOrigin? origin;
  final List<OneConstructUse> newConstructs;
  final bool isLogout;

  AnalyticsUpdate(
    this.type,
    this.newConstructs, {
    this.isLogout = false,
    this.origin,
  });
}
