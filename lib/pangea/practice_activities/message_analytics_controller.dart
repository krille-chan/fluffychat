import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/target_tokens_and_activity_type.dart';
import 'package:flutter/foundation.dart';

class MessageAnalyticsEntry {
  final DateTime createdAt = DateTime.now();

  late final List<PangeaToken> _tokens;

  final Map<ActivityTypeEnum, List<TargetTokensAndActivityType>>
      _activityQueue = {};

  final int _maxQueueLength = 5;

  MessageAnalyticsEntry({
    required List<PangeaToken> tokens,
    required bool includeHiddenWordActivities,
    required PangeaMessageEvent pangeaMessageEvent,
  }) {
    _tokens = tokens;
    initialize();
  }

  void _pushQueue(TargetTokensAndActivityType entry) {
    if (_activityQueue.containsKey(entry.activityType)) {
      _activityQueue[entry.activityType]!.insert(0, entry);
    } else {
      _activityQueue[entry.activityType] = [entry];
    }

    // just in case we make a mistake and the queue gets too long
    if (_activityQueue[entry.activityType]!.length > _maxQueueLength) {
      debugger(when: kDebugMode);
      _activityQueue[entry.activityType]!.removeRange(
        _maxQueueLength,
        _activityQueue.length,
      );
    }
  }

  void _filterActivityQueue(ActivityTypeEnum activityType) {
    _activityQueue[activityType]?.clear();
  }

  void _clearAllQueue() {
    _activityQueue.clear();
  }

  TargetTokensAndActivityType? nextActivity(ActivityTypeEnum a) =>
      _activityQueue[a]?.firstOrNull;

  bool get hasHiddenWordActivity =>
      activities(ActivityTypeEnum.hiddenWordListening).isNotEmpty;

  bool get hasMessageMeaningActivity =>
      activities(ActivityTypeEnum.messageMeaning).isNotEmpty;

  int get numActivities => _activityQueue.length;

  List<TargetTokensAndActivityType> activities(ActivityTypeEnum a) =>
      _activityQueue[a] ?? [];

  // /// If there are more than 4 tokens that can be heard, we don't want to do word focus listening
  // /// Otherwise, we don't have enough distractors
  // bool get canDoWordFocusListening =>
  //     _tokens.where((t) => t.canBeHeard).length > 4;

  /// On initialization, we pick which tokens to do activities on and what types of activities to do
  void initialize() {
    final eligibleTokens = _tokens.where((t) => t.lemma.saveVocab);

    // EMOJI
    // sort the tokens by the preference of them for an emoji activity
    // order from least to most recent
    // words that have never been used are counted as 1000 days
    // we preference content words over function words by multiplying the days since last use by 2
    // NOTE: for now, we put it at the end if it has no uses and basically just give them the answer
    // later on, we may introduce an emoji activity that is easier than the current matching one
    // i.e. we show them 3 good emojis and 1 bad one and ask them to pick the bad one
    _activityQueue[ActivityTypeEnum.emoji] = eligibleTokens
        .map(
          (t) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.emoji,
          ),
        )
        .sorted(
          (a, b) => a.tokens.first
              .activityPriorityScore(ActivityTypeEnum.emoji, null)
              .compareTo(
                b.tokens.first
                    .activityPriorityScore(ActivityTypeEnum.emoji, null),
              ),
        )
        .take(_maxQueueLength)
        .shuffled()
        .toList();

    // WORD MEANING
    // make word meaning activities
    // same as emojis for now
    _activityQueue[ActivityTypeEnum.wordMeaning] = eligibleTokens
        .map(
          (t) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.wordMeaning,
          ),
        )
        .sorted(
          (a, b) => a.tokens.first
              .activityPriorityScore(ActivityTypeEnum.wordMeaning, null)
              .compareTo(
                b.tokens.first
                    .activityPriorityScore(ActivityTypeEnum.wordMeaning, null),
              ),
        )
        .take(_maxQueueLength)
        .shuffled()
        .toList();

    // WORD FOCUS LISTENING
    // make word focus listening activities
    // same as emojis for now
    _activityQueue[ActivityTypeEnum.wordFocusListening] = eligibleTokens
        .map(
          (t) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.wordFocusListening,
          ),
        )
        .sorted(
          (a, b) => a.tokens.first
              .activityPriorityScore(ActivityTypeEnum.wordFocusListening, null)
              .compareTo(
                b.tokens.first.activityPriorityScore(
                  ActivityTypeEnum.wordFocusListening,
                  null,
                ),
              ),
        )
        .take(_maxQueueLength)
        .shuffled()
        .toList();

    // GRAMMAR
    // build a list of TargetTokensAndActivityType for all tokens and all features in the message
    // limits to _maxQueueLength activities and only one per token
    final List<TargetTokensAndActivityType> candidates = eligibleTokens.expand(
      (t) {
        return t.morphsBasicallyEligibleForPracticeByPriority.map(
          (m) => TargetTokensAndActivityType(
            tokens: [t],
            activityType: ActivityTypeEnum.morphId,
            morphFeature: MorphFeaturesEnumExtension.fromString(m.category),
          ),
        );
      },
    ).sorted(
      (a, b) => a.tokens.first
          .activityPriorityScore(
            ActivityTypeEnum.morphId,
            a.morphFeature!.name,
          )
          .compareTo(
            b.tokens.first.activityPriorityScore(
              ActivityTypeEnum.morphId,
              b.morphFeature!.name,
            ),
          ),
    );
    //pick from the top 5, only including one per token
    _activityQueue[ActivityTypeEnum.morphId] = [];
    for (final candidate in candidates) {
      if (_activityQueue[ActivityTypeEnum.morphId]!.length >= _maxQueueLength) {
        break;
      }
      if (_activityQueue[ActivityTypeEnum.morphId]?.any(
            (entry) => entry.tokens.contains(candidate.tokens.first),
          ) ==
          false) {
        _activityQueue[ActivityTypeEnum.morphId]?.add(candidate);
      }
    }
  }

  bool hasActivity(
    ActivityTypeEnum a,
    PangeaToken t, [
    MorphFeaturesEnum? morph,
  ]) =>
      _activityQueue[a]?.any(
        (entry) =>
            entry.tokens.contains(t) &&
            (morph == null || entry.morphFeature == morph),
      ) ==
      true;

  /// Add a message meaning activity to the front of the queue
  /// And limits to _maxQueueLength activities
  void addMessageMeaningActivity() {
    final entry = TargetTokensAndActivityType(
      tokens: _tokens,
      activityType: ActivityTypeEnum.messageMeaning,
    );
    _pushQueue(entry);
  }

  void onActivityComplete(ActivityTypeEnum a, PangeaToken? token) {
    _activityQueue[a]
        ?.removeWhere((entry) => token == null || entry.tokens.contains(token));
  }

  void exitPracticeFlow() => _activityQueue.clear();

  void revealAllTokens() =>
      _activityQueue[ActivityTypeEnum.hiddenWordListening]?.clear();

  bool isTokenInHiddenWordActivity(PangeaToken token) =>
      _activityQueue[ActivityTypeEnum.hiddenWordListening]?.isNotEmpty ?? false;
}

/// computes TokenWithXP for given a pangeaMessageEvent and caches the result, according to the full text of the message
/// listens for analytics updates and updates the cache accordingly
class MessageAnalyticsController {
  static final Map<String, MessageAnalyticsEntry> _cache = {};

  void dispose() {
    _cache.clear();
  }

  // if over 300, remove oldest 5 entries by createdAt
  static void clean() {
    if (_cache.length > 300) {
      final sortedEntries = _cache.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      for (var i = 0; i < 5; i++) {
        _cache.remove(sortedEntries[i].key);
      }
    }
  }

  static String _key(List<PangeaToken> tokens) =>
      PangeaToken.reconstructText(tokens);

  static MessageAnalyticsEntry? get(
    List<PangeaToken> tokens,
    PangeaMessageEvent pangeaMessageEvent,
  ) {
    final String key = _key(tokens);
    final entry = _cache[key];

    // if cache is older than 1 day, then remove and recompute
    if (entry != null &&
        DateTime.now().difference(entry.createdAt).inDays > 1) {
      _cache.remove(key);
    }

    if (entry != null) {
      return entry;
    }

    final bool includeHiddenWordActivities = !pangeaMessageEvent.ownMessage &&
        pangeaMessageEvent.messageDisplayRepresentation?.tokens != null &&
        pangeaMessageEvent.messageDisplayLangIsL2 &&
        !pangeaMessageEvent.event.isRichMessage;

    _cache[key] = MessageAnalyticsEntry(
      tokens: tokens,
      includeHiddenWordActivities: includeHiddenWordActivities,
      pangeaMessageEvent: pangeaMessageEvent,
    );

    clean();

    return _cache[key];
  }
}
