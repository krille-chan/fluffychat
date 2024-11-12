import 'dart:async';
import 'dart:math';

import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';

/// Picks which tokens to do activities on and what types of activities to do
/// Caches result so that we don't have to recompute it
/// Most importantly, we can't do this in the state of a message widget because the state is disposed of and recreated
/// If we decided that the first token should have a hidden word listening, we need to remember that
/// Otherwise, the user might leave the chat, return, and see a different word hidden
class MessageAnalyticsEntry {
  final DateTime createdAt = DateTime.now();

  late List<TokenWithXP> tokensWithXp;

  final PangeaMessageEvent pmEvent;

  TokenWithXP? nextActivityToken;

  ActivityTypeEnum? nextActivityType;

  MessageAnalyticsEntry(this.pmEvent) {
    if (pmEvent.messageDisplayRepresentation?.tokens == null) {
      throw Exception('No tokens in message in MessageAnalyticsEntry');
    }
    tokensWithXp = pmEvent.messageDisplayRepresentation!.tokens!
        .map(
          (token) => TokenWithXP(
            token: token,
          ),
        )
        .toList();

    computeTargetTypesForMessage(true);
  }

  List<TokenWithXP> get tokensThatCanBeHeard =>
      tokensWithXp.where((t) => t.token.canBeHeard).toList();

  void computeTargetTypesForMessage(bool includeHiddenWordActivities) {
    for (final token in tokensWithXp) {
      token.targetTypes = [];

      if (!token.token.lemma.saveVocab) {
        continue;
      }

      if (token.daysSinceLastUse < 1) {
        continue;
      }

      if (!token.didActivity(ActivityTypeEnum.wordMeaning)) {
        // debugger(when: kDebugMode && token.token.text.content == "Claro");
        token.targetTypes.add(ActivityTypeEnum.wordMeaning);
      }

      if (!token.didActivity(ActivityTypeEnum.wordFocusListening) &&
          tokensThatCanBeHeard.length > 3) {
        token.targetTypes.add(ActivityTypeEnum.wordFocusListening);
      }

      // we only want to include hidden word activities the first time we pick activities to do
      // in second runs, it's because the constructs have been updated by doing practice
      // however, at this point, the user has already seen those words
      if (token.targetTypes.isEmpty &&
          includeHiddenWordActivities &&
          !token.didActivity(ActivityTypeEnum.hiddenWordListening) &&
          !pmEvent.ownMessage) {
        token.targetTypes.add(ActivityTypeEnum.hiddenWordListening);
      }
    }

    // from the tokens with hiddenWordListening in targetTypes, pick one at random
    final List<int> withListening = tokensWithXp
        .asMap()
        .entries
        .where(
          (entry) => entry.value.targetTypes
              .contains(ActivityTypeEnum.hiddenWordListening),
        )
        .map((entry) => entry.key)
        .toList();
    // randomly pick one entry in the list
    if (withListening.isNotEmpty) {
      final int randomIndex =
          withListening[Random().nextInt(withListening.length)];
      nextActivityToken = tokensWithXp[randomIndex];
      nextActivityType = ActivityTypeEnum.hiddenWordListening;
      return;
    }

    // if we didn't find any hiddenWordListening, pick the first token that has a target type
    // do an activity with that token and type
    nextActivityToken =
        tokensWithXp.where((t) => t.targetTypes.isNotEmpty).firstOrNull;
    nextActivityType = nextActivityToken?.targetTypes.firstOrNull;
  }

  bool get shouldHideToken => tokensWithXp.any(
        (token) =>
            token.targetTypes.contains(ActivityTypeEnum.hiddenWordListening),
      );

  /// Should only do this with short lists of constructUses
  Future<void> updateTokensWithConstructs(
    List<OneConstructUse> constructUses,
  ) async {
    for (final token in tokensWithXp) {
      // we don't need to do this for tokens that don't have saveVocab set to true
      if (!token.token.lemma.saveVocab) {
        continue;
      }

      // debugger(when: kDebugMode && token.token.text.content == "Claro");

      for (final construct in token.constructs) {
        for (final use in constructUses) {
          if (use.category == construct.id.category &&
              use.lemma == construct.id.lemma &&
              use.constructType == construct.id.type) {
            construct.xp += use.pointValue;
            construct.lastUsed = use.timeStamp;
            construct.uses.add(use);
          }
        }
      }
    }

    nextActivityToken = null;
    nextActivityType = null;

    computeTargetTypesForMessage(false);

    //TODO - do we need to make sure we don't do more hidden word activities at this point?
  }
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

  MessageAnalyticsEntry? get(
    PangeaMessageEvent pmEvent,
    bool refresh,
  ) {
    if (pmEvent.messageDisplayRepresentation?.tokens == null) {
      return null;
    }

    if (_cache.containsKey(pmEvent.messageDisplayText) && !refresh) {
      return _cache[pmEvent.messageDisplayText];
    }

    _cache[pmEvent.messageDisplayText] = MessageAnalyticsEntry(pmEvent);

    clean();

    return _cache[pmEvent.messageDisplayText];
  }
}
