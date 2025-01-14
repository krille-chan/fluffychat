import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/message_activity_request.dart';
import 'package:fluffychat/pangea/toolbar/models/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';

class LemmaActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    debugger(when: kDebugMode && req.targetTokens.length != 1);

    final token = req.targetTokens.first;
    final List<String> choices = await token.lemmaActivityDistractors(token);

    // TODO - modify MultipleChoiceActivity flow to allow no correct answer
    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.lemmaId,
        targetTokens: [token],
        tgtConstructs: [token.vocabConstructID],
        langCode: req.userL2,
        content: ActivityContent(
          question: L10n.of(context).chooseBaseForm,
          choices: choices,
          answers: [token.lemma.text],
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
