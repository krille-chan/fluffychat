import 'dart:math';

import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:flutter/foundation.dart';

/// Picks which tokens to do activities on and what types of activities to do
/// Caches result so that we don't have to recompute it
/// Most importantly, we can't do this in the state of a message widget because the state is disposed of and recreated
/// If we decided that the first token should have a hidden word listening, we need to remember that
/// Otherwise, the user might leave the chat, return, and see a different word hidden

class TargetTokensAndActivityType {
  final List<PangeaToken> tokens;
  final ActivityTypeEnum activityType;

  TargetTokensAndActivityType({
    required this.tokens,
    required this.activityType,
  });

  bool matchesActivity(PracticeActivityModel activity) {
    // check if the existing activity has the same type as the target
    if (activity.activityType != activityType) {
      return false;
    }

    // This is kind of complicated
    // if it's causing problems,
    // maybe we just verify that the target span of the activity is the same as the target span of the target?
    final List<ConstructIdentifier> relevantConstructs = tokens
        .map((t) => t.constructs)
        .expand((e) => e)
        .map((c) => c.id)
        .where(activityType.constructFilter)
        .toList();

    return listEquals(activity.tgtConstructs, relevantConstructs);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TargetTokensAndActivityType &&
        listEquals(other.tokens, tokens) &&
        other.activityType == activityType;
  }

  @override
  int get hashCode => tokens.hashCode ^ activityType.hashCode;
}

class MessageAnalyticsEntry {
  final DateTime createdAt = DateTime.now();

  late final List<PangeaToken> _tokens;

  late final bool _includeHiddenWordActivities;

  late final List<TargetTokensAndActivityType> _activityQueue;

  MessageAnalyticsEntry({
    required List<PangeaToken> tokens,
    required bool includeHiddenWordActivities,
  }) {
    _tokens = tokens;
    _includeHiddenWordActivities = includeHiddenWordActivities;
    _activityQueue = setActivityQueue();
  }

  TargetTokensAndActivityType? get nextActivity =>
      _activityQueue.isNotEmpty ? _activityQueue.first : null;

  /// If there are more than 4 tokens that can be heard, we don't want to do word focus listening
  /// Otherwise, we don't have enough distractors
  bool get canDoWordFocusListening =>
      _tokens.where((t) => t.canBeHeard).length > 4;

  /// On initialization, we pick which tokens to do activities on and what types of activities to do
  List<TargetTokensAndActivityType> setActivityQueue() {
    final List<TargetTokensAndActivityType> queue = [];

    // for each token in the message
    // pick a random activity type from the eligible types
    for (final token in _tokens) {
      // get all the eligible activity types for the token
      // based on the context of the message
      final eligibleTypesBasedOnContext = token.eligibleActivityTypes
          .where((type) => type != ActivityTypeEnum.hiddenWordListening)
          .where(
            (type) =>
                canDoWordFocusListening ||
                type != ActivityTypeEnum.wordFocusListening,
          )
          .toList();

      // if there are no eligible types, continue to the next token
      if (eligibleTypesBasedOnContext.isEmpty) continue;

      // chose a random activity type from the eligible types for that token
      queue.add(
        TargetTokensAndActivityType(
          tokens: [token],
          activityType: eligibleTypesBasedOnContext[
              Random().nextInt(eligibleTypesBasedOnContext.length)],
        ),
      );
    }

    // sort the queue by the total xp of the tokens, lowest first
    queue.sort(
      (a, b) => a.tokens.map((t) => t.xp).reduce((a, b) => a + b).compareTo(
            b.tokens.map((t) => t.xp).reduce((a, b) => a + b),
          ),
    );

    // if applicable, add a hidden word activity to the front of the queue
    final hiddenWordActivity = getHiddenWordActivity(queue.length);
    if (hiddenWordActivity != null) {
      queue.insert(0, hiddenWordActivity);
    }

    // limit to 3 activities
    return queue.take(3).toList();
  }

  /// Adds a word focus listening activity to the front of the queue
  /// And limits to 3 activities
  void addForWordMeaning(PangeaToken selectedToken) {
    _activityQueue.insert(
      0,
      TargetTokensAndActivityType(
        tokens: [selectedToken],
        activityType: ActivityTypeEnum.wordMeaning,
      ),
    );
    // remove down to three activities
    if (_activityQueue.length > 3) {
      _activityQueue.removeRange(3, _activityQueue.length);
    }
  }

  int get numActivities => _activityQueue.length;

  void clearActivityQueue() {
    _activityQueue.clear();
  }

  /// Returns a hidden word activity if there is a sequence of tokens that have hiddenWordListening in their eligibleActivityTypes
  TargetTokensAndActivityType? getHiddenWordActivity(int numOtherActivities) {
    // don't do hidden word listening on own messages
    if (!_includeHiddenWordActivities) {
      return null;
    }

    // we will only do hidden word listening 50% of the time
    // if there are no other activities to do, we will always do hidden word listening
    if (numOtherActivities >= 3 && Random().nextDouble() < 0.5) {
      return null;
    }

    // We will find the longest sequence of tokens that have hiddenWordListening in their eligibleActivityTypes
    final List<List<PangeaToken>> sequences = [];
    List<PangeaToken> currentSequence = [];
    for (final token in _tokens) {
      if (token.eligibleActivityTypes
          .contains(ActivityTypeEnum.hiddenWordListening)) {
        currentSequence.add(token);
      } else {
        if (currentSequence.isNotEmpty) {
          sequences.add(currentSequence);
          currentSequence = [];
        }
      }
    }

    if (sequences.isEmpty) {
      return null;
    }

    final longestSequence = sequences.reduce(
      (a, b) => a.length > b.length ? a : b,
    );

    return TargetTokensAndActivityType(
      tokens: longestSequence,
      activityType: ActivityTypeEnum.hiddenWordListening,
    );
  }

  void onActivityComplete(PracticeActivityModel completed) {
    _activityQueue.removeWhere(
      (a) => a.matchesActivity(completed),
    );
  }

  void revealAllTokens() {
    _activityQueue.removeWhere((a) => a.activityType.hiddenType);
  }

  bool isTokenInHiddenWordActivity(PangeaToken token) => _activityQueue.any(
        (activity) =>
            activity.tokens.contains(token) && activity.activityType.hiddenType,
      );
}

/// computes TokenWithXP for given a pangeaMessageEvent and caches the result, according to the full text of the message
/// listens for analytics updates and updates the cache accordingly
class MessageAnalyticsController {
  final GetAnalyticsController getAnalytics;
  final Map<String, MessageAnalyticsEntry> _cache = {};

  MessageAnalyticsController(this.getAnalytics);

  void dispose() {
    _cache.clear();
  }

  // if over 50, remove oldest 5 entries by createdAt
  void clean() {
    if (_cache.length > 50) {
      final sortedEntries = _cache.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      for (var i = 0; i < 5; i++) {
        _cache.remove(sortedEntries[i].key);
      }
    }
  }

  String _key(List<PangeaToken> tokens) => PangeaToken.reconstructText(tokens);

  MessageAnalyticsEntry? get(
    List<PangeaToken> tokens,
    PangeaMessageEvent pangeaMessageEvent,
  ) {
    final String key = _key(tokens);

    if (_cache.containsKey(key)) {
      return _cache[key];
    }

    final bool includeHiddenWordActivities = !pangeaMessageEvent.ownMessage &&
        pangeaMessageEvent.messageDisplayRepresentation?.tokens != null &&
        pangeaMessageEvent.messageDisplayLangIsL2;

    _cache[key] = MessageAnalyticsEntry(
      tokens: tokens,
      includeHiddenWordActivities: includeHiddenWordActivities,
    );

    clean();

    return _cache[key];
  }
}
