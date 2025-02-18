import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';

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

    final List<ConstructIdentifier>? otherRelevantConstructs = activity
        .targetTokens
        ?.map((t) => t.constructs)
        .expand((e) => e)
        .map((c) => c.id)
        .where(activityType.constructFilter)
        .toList();

    return listEquals(otherRelevantConstructs, relevantConstructs);
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

  late final PangeaMessageEvent _pangeaMessageEvent;

  final List<TargetTokensAndActivityType> _activityQueue = [];

  final int _maxQueueLength = 3;

  MessageAnalyticsEntry({
    required List<PangeaToken> tokens,
    required bool includeHiddenWordActivities,
    required PangeaMessageEvent pangeaMessageEvent,
  }) {
    _tokens = tokens;
    _includeHiddenWordActivities = includeHiddenWordActivities;
    _pangeaMessageEvent = pangeaMessageEvent;
    setActivityQueue();
  }

  void _pushQueue(TargetTokensAndActivityType entry) {
    if (nextActivity?.activityType == ActivityTypeEnum.hiddenWordListening) {
      if (entry.activityType == ActivityTypeEnum.hiddenWordListening) {
        _activityQueue[0] = entry;
      } else {
        _activityQueue.insert(1, entry);
      }
    } else {
      _activityQueue.insert(0, entry);
    }

    if (_activityQueue.length > _maxQueueLength) {
      _activityQueue.removeRange(
        _maxQueueLength,
        _activityQueue.length,
      );
    }
  }

  void _popQueue() {
    if (_activityQueue.isNotEmpty) _activityQueue.removeAt(0);
  }

  void _filterQueue(ActivityTypeEnum activityType) {
    _activityQueue.removeWhere((a) => a.activityType == activityType);
  }

  void _clearQueue() {
    _activityQueue.clear();
  }

  TargetTokensAndActivityType? get nextActivity =>
      _activityQueue.isNotEmpty ? _activityQueue.first : null;

  bool get hasHiddenWordActivity =>
      nextActivity?.activityType.hiddenType ?? false;

  bool get hasMessageMeaningActivity => _activityQueue
      .any((a) => a.activityType == ActivityTypeEnum.messageMeaning);

  int get numActivities => _activityQueue.length;

  // /// If there are more than 4 tokens that can be heard, we don't want to do word focus listening
  // /// Otherwise, we don't have enough distractors
  // bool get canDoWordFocusListening =>
  //     _tokens.where((t) => t.canBeHeard).length > 4;

  /// On initialization, we pick which tokens to do activities on and what types of activities to do
  void setActivityQueue() {
    final List<TargetTokensAndActivityType> queue = [];

    // if applicable, add a hidden word activity to the front of the queue
    final hiddenWordActivity = getHiddenWordActivity(queue.length);
    if (hiddenWordActivity != null) {
      _pushQueue(hiddenWordActivity);
    }
  }

  /// Add a message meaning activity to the front of the queue
  /// And limits to _maxQueueLength activities
  void addMessageMeaningActivity() {
    final entry = TargetTokensAndActivityType(
      tokens: _tokens,
      activityType: ActivityTypeEnum.messageMeaning,
    );
    _pushQueue(entry);
  }

  /// Returns a hidden word activity if there is a sequence of tokens that have hiddenWordListening in their eligibleActivityTypes
  TargetTokensAndActivityType? getHiddenWordActivity(int numOtherActivities) {
    // don't do hidden word listening on own messages
    if (!_includeHiddenWordActivities) {
      return null;
    }

    // we will only do hidden word listening 30% of the time
    // if there are no other activities to do, we will always do hidden word listening
    if (Random().nextDouble() < 0.7) {
      // @ggurdin - just want you to review this change. i'm not sure what numOtherActivities >= _maxQueueLength was doing
      // if (numOtherActivities >= _maxQueueLength && Random().nextDouble() < 0.5) {
      return null;
    }

    // We will find the longest sequence of tokens that have hiddenWordListening in their eligibleActivityTypes
    final List<List<PangeaToken>> sequences = [];
    List<PangeaToken> currentSequence = [];
    for (final token in _tokens) {
      if (_pangeaMessageEvent.shouldDoActivity(
        token: token,
        a: ActivityTypeEnum.hiddenWordListening,
        feature: null,
        tag: null,
      )) {
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

    // Truncate the sequence to a maximum of 2 words
    final truncatedSequence = longestSequence.take(2).toList();

    return TargetTokensAndActivityType(
      tokens: truncatedSequence,
      activityType: ActivityTypeEnum.hiddenWordListening,
    );
  }

  void onActivityComplete() => _popQueue();

  void exitPracticeFlow() => _clearQueue();

  void revealAllTokens() => _filterQueue(ActivityTypeEnum.hiddenWordListening);

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
