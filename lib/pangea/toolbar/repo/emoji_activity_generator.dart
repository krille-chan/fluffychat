import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/message_activity_request.dart';
import 'package:fluffychat/pangea/toolbar/models/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';

class EmojiActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    debugger(when: kDebugMode && req.targetTokens.length != 1);

    final PangeaToken token = req.targetTokens.first;

    final List<String> emojis = await token.getEmojiChoices();
    final tokenEmoji = token.getEmoji();
    if (tokenEmoji != null && !emojis.contains(tokenEmoji)) {
      final Random random = Random();
      final int randomIndex = random.nextInt(emojis.length);
      emojis[randomIndex] = tokenEmoji;
    }

    // TODO - modify MultipleChoiceActivity flow to allow no correct answer
    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.emoji,
        targetTokens: [token],
        tgtConstructs: [token.vocabConstructID],
        langCode: req.userL2,
        content: ActivityContent(
          // TODO: add to L10n
          question: L10n.of(context).pickAnEmojiFor(token.lemma.text),
          choices: emojis,
          answers: emojis,
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
