import 'dart:math';

import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:flutter/foundation.dart';

/// Picks which tokens to do activities on and what types of activities to do
/// Caches result so that we don't have to recompute it
/// Most importantly, we can't do this in the state of a message widget because the state is disposed of and recreated
/// If we decided that the first token should have a hidden word listening, we need to remember that
/// Otherwise, the user might leave the chat, return, and see a different word hidden
class MessageAnalyticsEntry {
  final DateTime createdAt = DateTime.now();

  late List<TokenWithXP> tokensWithXp;

  final PangeaMessageEvent pmEvent;

  //
  bool isFirstTimeComputing = true;

  TokenWithXP? nextActivityToken;
  ActivityTypeEnum? nextActivityType;

  MessageAnalyticsEntry(this.pmEvent) {
    debugPrint('making MessageAnalyticsEntry: ${pmEvent.messageDisplayText}');
    if (pmEvent.messageDisplayRepresentation?.tokens == null) {
      throw Exception('No tokens in message in MessageAnalyticsEntry');
    }
    tokensWithXp = pmEvent.messageDisplayRepresentation!.tokens!
        .map((token) => TokenWithXP(token: token))
        .toList();

    computeTargetTypesForMessage();
  }

  List<TokenWithXP> get tokensThatCanBeHeard =>
      tokensWithXp.where((t) => t.token.canBeHeard).toList();

  // compute target tokens within async wrapper that adds a 250ms delay
  // to avoid blocking the UI thread
  Future<void> computeTargetTypesForMessageAsync() async {
    await Future.delayed(const Duration(milliseconds: 250));
    computeTargetTypesForMessage();
  }

  void computeTargetTypesForMessage() {
    // reset
    nextActivityToken = null;
    nextActivityType = null;

    // compute target types for each token
    for (final token in tokensWithXp) {
      token.targetTypes = [];

      if (!token.token.lemma.saveVocab) {
        continue;
      }

      if (token.daysSinceLastUse < 1) {
        continue;
      }

      if (token.eligibleForActivity(ActivityTypeEnum.wordMeaning) &&
          !token.didActivity(ActivityTypeEnum.wordMeaning)) {
        token.targetTypes.add(ActivityTypeEnum.wordMeaning);
      }

      if (token.eligibleForActivity(ActivityTypeEnum.wordFocusListening) &&
          !token.didActivity(ActivityTypeEnum.wordFocusListening) &&
          tokensThatCanBeHeard.length > 3) {
        token.targetTypes.add(ActivityTypeEnum.wordFocusListening);
      }

      if (token.eligibleForActivity(ActivityTypeEnum.hiddenWordListening) &&
          isFirstTimeComputing &&
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

      // remove from all other tokens
      for (int i = 0; i < tokensWithXp.length; i++) {
        if (i != randomIndex) {
          tokensWithXp[i]
              .targetTypes
              .remove(ActivityTypeEnum.hiddenWordListening);
        }
      }
    }

    // if we didn't find any hiddenWordListening,
    // pick the first token that has a target type
    nextActivityToken ??=
        tokensWithXp.where((t) => t.targetTypes.isNotEmpty).firstOrNull;
    nextActivityType ??= nextActivityToken?.targetTypes.firstOrNull;

    isFirstTimeComputing = false;
  }

  bool get shouldHideToken => tokensWithXp.any(
        (token) =>
            token.targetTypes.contains(ActivityTypeEnum.hiddenWordListening),
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
