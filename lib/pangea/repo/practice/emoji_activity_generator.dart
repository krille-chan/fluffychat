import 'dart:developer';
import 'dart:math';

import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:flutter/foundation.dart';

class EmojiActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
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
          question: "",
          choices: emojis,
          answers: emojis,
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
