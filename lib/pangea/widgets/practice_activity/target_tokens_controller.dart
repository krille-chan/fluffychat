import 'dart:developer';

import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Seperated out the target tokens from the practice activity card
/// in order to control the state of the target tokens
class TargetTokensController {
  List<TokenWithXP>? _targetTokens;

  TargetTokensController();

  /// From the tokens in the message, do a preliminary filtering of which to target
  /// Then get the construct uses for those tokens
  Future<List<TokenWithXP>> targetTokens(
    BuildContext context,
    PangeaMessageEvent pangeaMessageEvent,
  ) async {
    if (_targetTokens != null) {
      return _targetTokens!;
    }

    _targetTokens = await _initialize(context, pangeaMessageEvent);

    await updateTokensWithConstructs(
      MatrixState.pangeaController.analytics.analyticsStream.value ?? [],
      context,
      pangeaMessageEvent,
    );

    return _targetTokens!;
  }

  Future<List<TokenWithXP>> _initialize(
    BuildContext context,
    PangeaMessageEvent pangeaMessageEvent,
  ) async {
    if (!context.mounted) {
      ErrorHandler.logError(
        m: 'getTargetTokens called when not mounted',
        s: StackTrace.current,
      );
      return _targetTokens = [];
    }

    final tokens = await pangeaMessageEvent
        .representationByLanguage(pangeaMessageEvent.messageDisplayLangCode)
        ?.tokensGlobal(context);

    if (tokens == null || tokens.isEmpty) {
      debugger(when: kDebugMode);
      return _targetTokens = [];
    }

    return _targetTokens = tokens
        .map((token) => token.emptyTokenWithXP)
        .toList();
  }

  Future<void> updateTokensWithConstructs(
    List<OneConstructUse> constructUses,
    context,
    pangeaMessageEvent,
  ) async {
    final ConstructListModel constructList = ConstructListModel(
      uses: constructUses,
      type: null,
    );

    _targetTokens ??= await _initialize(context, pangeaMessageEvent);

    for (final token in _targetTokens!) {
      
      // we don't need to do this for tokens that don't have saveVocab set to true
      if (!token.token.lemma.saveVocab){
        continue;
      }

      for (final construct in token.constructs) {
        final constructUseModel = constructList.getConstructUses(
          construct.id.lemma,
          construct.id.type,
        );
        if (constructUseModel != null) {
          construct.xp += constructUseModel.points;
          construct.lastUsed = constructUseModel.lastUsed;
        }
      }
    }
  }
}
