import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_match.dart';

class EmojiActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    if (req.targetTokens.length == 1) {
      return _favorite(req, context);
    } else {
      return _matchActivity(req, context);
    }
  }

  Future<MessageActivityResponse> _favorite(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    final PangeaToken token = req.targetTokens.first;

    final List<String> emojis = await token.getEmojiChoices();

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.emoji,
        targetTokens: [token],
        langCode: req.userL2,
        multipleChoiceContent: MultipleChoiceActivity(
          question: L10n.of(context).pickAnEmojiFor(token.lemma.text),
          choices: emojis,
          answers: emojis,
          spanDisplayDetails: null,
        ),
      ),
    );
  }

  Future<MessageActivityResponse> _matchActivity(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    final List<Future<LemmaInfoResponse>> lemmaInfoFutures = req.targetTokens
        .map((token) => token.vocabConstructID.getLemmaInfo())
        .toList();

    final List<LemmaInfoResponse> lemmaInfos =
        await Future.wait(lemmaInfoFutures);

    final Map<ConstructIdentifier, List<String>> matchInfo = Map.fromIterables(
      req.targetTokens.map((token) => token.vocabConstructID),
      lemmaInfos.map((e) => e.emoji),
    );

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.emoji,
        targetTokens: req.targetTokens,
        langCode: req.userL2,
        matchContent: PracticeMatch(
          matchInfo: matchInfo,
        ),
      ),
    );
  }
}
