import 'dart:async';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_data/analytics_database.dart';
import 'package:fluffychat/pangea/analytics_data/analytics_database_builder.dart';
import 'package:fluffychat/pangea/analytics_data/analytics_sync_controller.dart';
import 'package:fluffychat/pangea/analytics_data/analytics_update_dispatcher.dart';
import 'package:fluffychat/pangea/analytics_data/analytics_update_events.dart';
import 'package:fluffychat/pangea/analytics_data/analytics_update_service.dart';
import 'package:fluffychat/pangea/analytics_data/construct_merge_table.dart';
import 'package:fluffychat/pangea/analytics_data/derived_analytics_data_model.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_event.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_settings/analytics_settings_extension.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/languages/language_model.dart';
import 'package:fluffychat/pangea/user/analytics_profile_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class _AnalyticsClient {
  final Client client;
  final AnalyticsDatabase database;

  _AnalyticsClient({required this.client, required this.database});
}

class AnalyticsStreamUpdate {
  final int points;
  final Set<ConstructIdentifier>? blockedConstructs;
  final String? targetID;

  AnalyticsStreamUpdate({
    this.points = 0,
    this.blockedConstructs,
    this.targetID,
  });
}

class AnalyticsDataService {
  _AnalyticsClient? _analyticsClient;

  late final AnalyticsUpdateDispatcher updateDispatcher;
  late final AnalyticsUpdateService updateService;
  AnalyticsSyncController? _syncController;
  final ConstructMergeTable _mergeTable = ConstructMergeTable();

  Completer<void> initCompleter = Completer<void>();

  AnalyticsDataService(Client client) {
    updateDispatcher = AnalyticsUpdateDispatcher(this);
    updateService = AnalyticsUpdateService(this);
    _initDatabase(client);
  }

  static const int _morphUnlockXP = AnalyticsConstants.xpForGreens;

  int _cacheVersion = 0;
  int _derivedCacheVersion = -1;
  DerivedAnalyticsDataModel? _cachedDerivedStats;

  _AnalyticsClient get _analyticsClientGetter {
    assert(_analyticsClient != null);
    return _analyticsClient!;
  }

  bool get isInitializing => !initCompleter.isCompleted;

  Future<Room?> getAnalyticsRoom(LanguageModel l2) =>
      _analyticsClientGetter.client.getMyAnalyticsRoom(l2);

  void dispose() {
    _syncController?.dispose();
    updateDispatcher.dispose();
    updateService.dispose();
    _closeDatabase();
  }

  void _invalidateCaches() {
    _cacheVersion++;
    _cachedDerivedStats = null;
  }

  Future<void> _initDatabase(Client client) async {
    _invalidateCaches();

    final database = await analyticsDatabaseBuilder(
      "${client.clientName}_analytics",
    );
    _analyticsClient = _AnalyticsClient(client: client, database: database);

    if (client.isLogged()) {
      await _initAnalytics();
    } else {
      await client.onLoginStateChanged.stream.firstWhere(
        (state) => state == LoginState.loggedIn,
      );
      await _initAnalytics();
    }
  }

  Future<void> _initAnalytics() async {
    try {
      Logs().i("Initializing analytics database.");
      final client = _analyticsClientGetter.client;
      if (client.prevBatch == null) {
        await client.onSync.stream.first;
      }

      _invalidateCaches();
      final l2 = MatrixState.pangeaController.userController.userL2;
      final analyticsUserId = await _analyticsClientGetter.database.getUserID();
      final analyticsLanguage = await _analyticsClientGetter.database
          .getCurrentLanguage();

      if (analyticsUserId != client.userID || analyticsLanguage == null) {
        // If current language not set, analytics database needs be updated to include language flag, so clear it.
        // If user ID doesn't match, this means that a different user has logged in since the last time the database was initialized,
        // so clear it to avoid showing another user's analytics.
        _clear();
        await _analyticsClientGetter.database.clear();
        await _analyticsClientGetter.database.updateUserID(client.userID!);
        if (l2 != null) {
          await _analyticsClientGetter.database.updateCurrentLanguage(
            l2.langCodeShort,
          );
        }
      } else if (l2 != null && analyticsLanguage != l2.langCodeShort) {
        // If the current language doesn't match the language in the database, this means that
        // the user has switched their L2 since the last time the database was initialized.
        // Clear local cache / merge table data.
        _clear();
        await _analyticsClientGetter.database.updateCurrentLanguage(
          l2.langCodeShort,
        );
      }

      _syncController?.dispose();
      _syncController = AnalyticsSyncController(
        client: client,
        dataService: this,
      );

      if (l2 != null) {
        await _syncController!.bulkUpdate(l2.langCodeShort);
      }

      final resp = await client.getUserProfile(client.userID!);
      final analyticsProfile = AnalyticsProfileModel.fromJson(
        resp.additionalProperties,
      );

      if (l2 != null) {
        await updateXPOffset(
          analyticsProfile.xpOffsetByLanguage(l2) ?? 0,
          l2.langCodeShort,
        );
      }

      _syncController!.start();

      if (l2 != null) {
        await _initMergeTable(l2.langCodeShort);
      }
    } catch (e, s) {
      Logs().e("Error initializing analytics: $e, $s");
    } finally {
      Logs().i("Analytics database initialized.");
      initCompleter.complete();
      updateDispatcher.sendEmptyAnalyticsUpdate();
      updateDispatcher.sendActivityAnalyticsUpdate(null);
    }
  }

  Future<void> _initMergeTable(String language) async {
    final vocab = await _analyticsClientGetter.database.getAggregatedConstructs(
      ConstructTypeEnum.vocab,
      language,
    );
    final morph = await _analyticsClientGetter.database.getAggregatedConstructs(
      ConstructTypeEnum.morph,
      language,
    );

    final blocked = blockedConstructs;
    _mergeTable.addConstructs(vocab, blocked);
    _mergeTable.addConstructs(morph, blocked);
  }

  Future<void> reinitialize() async {
    Logs().i("Reinitializing analytics database.");
    initCompleter = Completer<void>();
    _clear();
    await _initDatabase(_analyticsClientGetter.client);
  }

  void _clear() {
    _invalidateCaches();
    _mergeTable.clear();
  }

  Future<void> _closeDatabase() async {
    await _analyticsClient?.database.delete();
    _analyticsClient = null;
    _clear();
  }

  Future<void> _ensureInitialized() =>
      initCompleter.isCompleted ? Future.value() : initCompleter.future;

  int numConstructs(ConstructTypeEnum type) =>
      _mergeTable.uniqueConstructsByType(type);

  bool hasUsedConstruct(ConstructIdentifier id) =>
      _mergeTable.constructUsed(id);

  int uniqueConstructsByType(ConstructTypeEnum type) =>
      _mergeTable.uniqueConstructsByType(type);

  Set<ConstructIdentifier> get blockedConstructs {
    final analyticsRoom = _analyticsClientGetter.client.analyticsRoomLocal();
    return analyticsRoom?.blockedConstructs ?? {};
  }

  Future<void> waitForSync(String analyticsRoomID) async {
    await _syncController?.waitForSync(analyticsRoomID);
  }

  DerivedAnalyticsDataModel? get cachedDerivedData => _cachedDerivedStats;

  Future<DerivedAnalyticsDataModel> derivedData(String language) async {
    await _ensureInitialized();

    if (_cachedDerivedStats == null || _derivedCacheVersion != _cacheVersion) {
      _cachedDerivedStats = await _analyticsClientGetter.database
          .getDerivedStats(language);
      _derivedCacheVersion = _cacheVersion;
    }

    return _cachedDerivedStats!;
  }

  Future<DateTime?> getLastUpdatedAnalytics(String language) async {
    return _analyticsClientGetter.database.getLastEventTimestamp(language);
  }

  Future<List<OneConstructUse>> getUses(
    String language, {
    int? count,
    String? roomId,
    DateTime? since,
    List<ConstructUseTypeEnum>? types,
    bool filterCapped = true,
  }) async {
    await _ensureInitialized();
    final uses = await _analyticsClientGetter.database.getUses(
      language,
      count: count,
      roomId: roomId,
      since: since,
      types: types,
    );

    final blocked = blockedConstructs;
    final List<OneConstructUse> filtered = [];

    final Map<ConstructIdentifier, DateTime?> cappedLastUseCache = {};
    for (final use in uses) {
      if (blocked.contains(use.identifier)) continue;
      if (use.identifier.isInvalid) continue;

      if (!cappedLastUseCache.containsKey(use.identifier)) {
        final constructs = await getConstructUse(use.identifier, language);
        cappedLastUseCache[use.identifier] = constructs.cappedLastUse;
      }
      final cappedLastUse = cappedLastUseCache[use.identifier];
      if (filterCapped &&
          (cappedLastUse != null && use.timeStamp.isAfter(cappedLastUse))) {
        continue;
      }
      filtered.add(use);
    }

    return filtered;
  }

  Future<List<OneConstructUse>> getLocalUses(String language) async {
    await _ensureInitialized();
    return _analyticsClientGetter.database.getLocalUses(language);
  }

  Future<int> getLocalConstructCount(String language) async {
    await _ensureInitialized();
    return _analyticsClientGetter.database.getLocalConstructCount(language);
  }

  Future<ConstructUses> getConstructUse(
    ConstructIdentifier id,
    String language,
  ) async {
    await _ensureInitialized();
    final blocked = blockedConstructs;
    final ids = _mergeTable.groupedIds(_mergeTable.resolve(id), blocked);
    if (ids.isEmpty) {
      return ConstructUses(
        uses: [],
        constructType: id.type,
        lemma: id.lemma,
        category: id.category,
      );
    }

    return _analyticsClientGetter.database.getConstructUse(ids, language);
  }

  Future<Map<ConstructIdentifier, ConstructUses>> getConstructUses(
    List<ConstructIdentifier> ids,
    String language,
  ) async {
    await _ensureInitialized();
    final Map<ConstructIdentifier, List<ConstructIdentifier>> request = {};
    final blocked = blockedConstructs;
    for (final id in ids) {
      if (blocked.contains(id)) continue;
      request[id] = _mergeTable.groupedIds(_mergeTable.resolve(id), blocked);
    }

    return _analyticsClientGetter.database.getConstructUses(request, language);
  }

  Future<Map<ConstructIdentifier, ConstructUses>> getAggregatedConstructs(
    ConstructTypeEnum type,
    String language,
  ) async {
    final combined = await _analyticsClientGetter.database
        .getAggregatedConstructs(type, language);

    final stopwatch = Stopwatch()..start();

    final cleaned = <ConstructIdentifier, ConstructUses>{};
    final blocked = blockedConstructs;
    for (final entry in combined) {
      final canonical = _mergeTable.resolve(entry.id);

      // Insert or merge
      final existing = cleaned[canonical];
      if (existing != null) {
        existing.merge(entry);
      } else if (!blocked.contains(canonical) && !canonical.isInvalid) {
        cleaned[canonical] = entry;
      }
    }

    stopwatch.stop();
    Logs().i(
      "Merging analytics took: ${stopwatch.elapsedMilliseconds} ms, total constructs: ${cleaned.length}",
    );

    return cleaned;
  }

  Future<int> getNewConstructCount(
    List<OneConstructUse> newConstructs,
    ConstructTypeEnum type,
    String language,
  ) async {
    await _ensureInitialized();
    final blocked = blockedConstructs;
    final uses = newConstructs
        .where(
          (c) =>
              c.constructType == type &&
              !blocked.contains(c.identifier) &&
              c.identifier.category != 'other',
        )
        .toList();

    final Map<ConstructIdentifier, int> constructPoints = {};
    for (final use in uses) {
      constructPoints[use.identifier] ??= 0;
      constructPoints[use.identifier] =
          constructPoints[use.identifier]! + use.xp;
    }

    final constructs = await getConstructUses(
      constructPoints.keys.toList(),
      language,
    );

    int newConstructCount = 0;
    for (final entry in constructPoints.entries) {
      final construct = constructs[entry.key]!;
      if (construct.points == entry.value) {
        newConstructCount++;
      }
    }

    return newConstructCount;
  }

  Future<void> updateXPOffset(int offset, String language) async {
    _invalidateCaches();
    await _analyticsClientGetter.database.updateXPOffset(offset, language);
  }

  Future<List<AnalyticsUpdateEvent>> updateLocalAnalytics(
    AnalyticsUpdate update,
    String language,
  ) async {
    final events = <AnalyticsUpdateEvent>[];
    final addedConstructs = update.addedConstructs
        .where((c) => c.category != 'other')
        .toList();
    final updateIds = addedConstructs.map((c) => c.identifier).toList();

    final prevData = await derivedData(language);
    final prevConstructs = await getConstructUses(updateIds, language);

    _invalidateCaches();
    await _ensureInitialized();

    final blocked = blockedConstructs;
    final newUnusedConstructs = updateIds
        .where((id) => !hasUsedConstruct(id))
        .toSet();

    _mergeTable.addConstructsByUses(addedConstructs, blocked);
    await _analyticsClientGetter.database.updateLocalAnalytics(
      addedConstructs,
      language,
    );

    final newConstructs = await getConstructUses(updateIds, language);

    int points = 0;
    if (updateIds.isNotEmpty) {
      for (final id in updateIds) {
        final prevPoints = prevConstructs[id]?.points ?? 0;
        final newPoints = newConstructs[id]?.points ?? 0;
        points += (newPoints - prevPoints);
      }
      events.add(XPGainedEvent(points, update.targetID));
    }

    final newData = prevData.addXP(points);
    await _analyticsClientGetter.database.updateDerivedStats(newData, language);

    // Update public profile each time that new analytics are added.
    // If the level hasn't changed, this will not send an update to the server.
    // Do this on all updates (not just on level updates) to account for cases
    // of target language updates being missed (https://github.com/pangeachat/client/issues/2006)
    MatrixState.pangeaController.userController.updateAnalyticsProfile(
      level: newData.level,
    );

    if (newData.level > prevData.level) {
      events.add(LevelUpEvent(prevData.level, newData.level));
    } else if (newData.level < prevData.level) {
      final lowerLevelXP = DerivedAnalyticsDataModel.calculateXpWithLevel(
        prevData.level,
      );

      final offset = lowerLevelXP - newData.totalXP;
      await MatrixState.pangeaController.userController.addXPOffset(offset);
      await updateXPOffset(
        MatrixState
            .pangeaController
            .userController
            .publicProfile!
            .analytics
            .xpOffset!,
        language,
      );
    }

    final newUnlockedMorphs = updateIds.where((id) {
      if (id.type != ConstructTypeEnum.morph) return false;
      final prevPoints = prevConstructs[id]?.points ?? 0;
      final newPoints = newConstructs[id]?.points ?? 0;
      return prevPoints < _morphUnlockXP && newPoints >= _morphUnlockXP;
    }).toSet();

    if (newUnlockedMorphs.isNotEmpty) {
      events.add(MorphUnlockedEvent(newUnlockedMorphs));
    }

    for (final entry in newConstructs.entries) {
      final prevConstruct = prevConstructs[entry.key];
      if (prevConstruct == null) continue;

      final prevLevel = prevConstruct.lemmaCategory;
      final newLevel = entry.value.lemmaCategory;
      if (newLevel.xpNeeded > prevLevel.xpNeeded) {
        events.add(ConstructLevelUpEvent(entry.key, newLevel, update.targetID));
      }
    }

    if (newUnusedConstructs.isNotEmpty) {
      events.add(NewConstructsEvent(newUnusedConstructs));
    }

    return events;
  }

  Future<void> updateServerAnalytics(
    List<ConstructAnalyticsEvent> events,
    String language,
  ) async {
    _invalidateCaches();
    final blocked = blockedConstructs;
    for (final event in events) {
      _mergeTable.addConstructsByUses(event.content.uses, blocked);
    }
    await _analyticsClientGetter.database.updateServerAnalytics(
      events,
      language,
    );
    final vocab = await getAggregatedConstructs(
      ConstructTypeEnum.vocab,
      language,
    );
    final morphs = await getAggregatedConstructs(
      ConstructTypeEnum.morph,
      language,
    );
    final constructs = [...vocab.values, ...morphs.values];
    final totalXP = constructs.fold(0, (total, c) => total + c.points);

    await _analyticsClientGetter.database.updateTotalXP(totalXP, language);
  }

  Future<void> updateBlockedConstructs(
    ConstructIdentifier constructId,
    String language,
  ) async {
    await _ensureInitialized();
    _mergeTable.removeConstruct(constructId);

    final construct = await _analyticsClientGetter.database.getConstructUse([
      constructId,
    ], language);

    final derived = await derivedData(language);
    final newXP = derived.totalXP - construct.points;
    final newLevel = DerivedAnalyticsDataModel.calculateLevelWithXp(newXP);

    await MatrixState.pangeaController.userController.updateAnalyticsProfile(
      level: newLevel,
    );

    await _analyticsClientGetter.database.updateTotalXP(newXP, language);
    _invalidateCaches();
  }

  Future<void> clearLocalAnalytics(String language) async {
    _invalidateCaches();
    await _ensureInitialized();
    await _analyticsClientGetter.database.clearLocalConstructData(language);
  }
}
