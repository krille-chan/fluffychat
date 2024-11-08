import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';

class MessageAnalyticsEntry {
  final List<TokenWithXP> tokens;

  MessageAnalyticsEntry(this.tokens) {
    _pickTargetTypes();
  }

  // we're going to do the activity on just one token for now
  void _pickTargetTypes() {
    for (final token in tokens) {
      if (token.shouldDoHiddenWorkListening) {
        token.targetType = ActivityTypeEnum.hiddenWordListening;
        break;
      }
    }
  }

  bool get shouldHideToken => tokens
      .any((token) => token.targetType == ActivityTypeEnum.hiddenWordListening);
}

/// computes TokenWithXP for given a pangeaMessageEvent and caches the result, according to the full text of the message
/// listens for analytics updates and updates the cache accordingly
class MessageAnalyticsController {
  final Map<String, MessageAnalyticsEntry> _cache = {};

  late Timer _cacheClearTimer;

  MessageAnalyticsController(GetAnalyticsController analyticsController) {
    _cacheClearTimer = Timer.periodic(const Duration(minutes: 10), (Timer t) {
      if (_cache.length > 50) {
        // just randomly remove enough entries to get to 50
        //TODO - smarter way to remove entries
        _cache.removeWhere((key, value) => _cache.length > 50);
      }
    });
  }

  void dispose() {
    _cache.clear();
    _cacheClearTimer.cancel();
  }

  bool _hasLocal(PangeaMessageEvent pmEvent) =>
      _cache.containsKey(pmEvent.messageDisplayText);

  MessageAnalyticsEntry? _local(PangeaMessageEvent pmEvent) =>
      _cache[pmEvent.messageDisplayText];

  MessageAnalyticsEntry? get(
    PangeaMessageEvent pmEvent,
    bool refresh,
  ) {
    if (_hasLocal(pmEvent) && !refresh) {
      return _local(pmEvent)!;
    }

    return _make(
      pmEvent,
    );
  }

  MessageAnalyticsEntry? _make(
    PangeaMessageEvent pmEvent,
  ) {
    final vocab = MatrixState.pangeaController.getAnalytics.vocabModel;
    final grammar = MatrixState.pangeaController.getAnalytics.grammarModel;

    final tokens = pmEvent.messageDisplayRepresentation?.tokens
        ?.map((token) => token.emptyTokenWithXP)
        .toList();

    if (tokens == null || tokens.isEmpty) {
      debugger(when: kDebugMode);
      return null;
    }

    for (final token in tokens) {
      // we don't need to do this for tokens that don't have saveVocab set to true
      if (!token.token.lemma.saveVocab) {
        continue;
      }

      for (final construct in token.constructs) {
        final constructUseModel = vocab.getConstructUses(
              ConstructIdentifier(
                lemma: construct.id.lemma,
                type: construct.id.type,
                category: construct.id.category,
              ),
            ) ??
            grammar.getConstructUses(
              ConstructIdentifier(
                lemma: construct.id.lemma,
                type: construct.id.type,
                category: construct.id.category,
              ),
            );

        if (constructUseModel != null) {
          construct.xp += constructUseModel.points;
          construct.lastUsed = constructUseModel.lastUsed;
        }
      }
    }

    _cache[pmEvent.messageDisplayText] = MessageAnalyticsEntry(tokens);

    return _cache[pmEvent.messageDisplayText]!;
  }
}
