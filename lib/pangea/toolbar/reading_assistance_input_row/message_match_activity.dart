import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/message_token_text/message_token_button.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/target_tokens_and_activity_type.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_match_activity_item.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class MessageMatchActivity extends StatelessWidget {
  final MessageOverlayController overlayController;

  const MessageMatchActivity({
    super.key,
    required this.overlayController,
  });

  ActivityTypeEnum? get activityType =>
      overlayController.toolbarMode.associatedActivityType;

  List<String> choices(TargetTokensAndActivityType a) {
    switch (activityType) {
      case ActivityTypeEnum.emoji:
        return overlayController
            .messageLemmaInfos![a.tokens.first.vocabConstructID]!.emoji
            .take(maxEmojisPerLemma)
            .toList();
      case ActivityTypeEnum.wordMeaning:
        return [
          overlayController
              .messageLemmaInfos![a.tokens.first.vocabConstructID]!.meaning,
        ];
      case ActivityTypeEnum.wordFocusListening:
        return [a.tokens.first.text.content];
      default:
        debugger(when: kDebugMode);
        return [];
    }
  }

  Widget choiceDisplayContent(TargetTokensAndActivityType a, String choice) {
    switch (activityType) {
      case ActivityTypeEnum.emoji:
        return Text(
          choice,
          style: const TextStyle(fontSize: 26),
        );
      case ActivityTypeEnum.wordMeaning:
        return Text(
          choice,
          style: const TextStyle(fontSize: 26),
        );
      case ActivityTypeEnum.wordFocusListening:
        return const Icon(
          Icons.volume_up,
          size: 26,
        );
      default:
        debugger(when: kDebugMode);
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (overlayController.messageAnalyticsEntry == null ||
        activityType == null) {
      debugger(when: kDebugMode);
      return const SizedBox();
    }

    if (overlayController.messageLemmaInfos == null) {
      return const CircularProgressIndicator.adaptive();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      spacing: 16.0,
      children: [
        if (overlayController.toolbarMode == MessageMode.listening &&
            overlayController.pangeaMessageEvent != null)
          MessageAudioCard(
            messageEvent: overlayController.pangeaMessageEvent!,
            overlayController: overlayController,
            setIsPlayingAudio: overlayController.setIsPlayingAudio,
          ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0, // Adjust spacing between items
          runSpacing: 8.0, // Adjust spacing between rows
          children: overlayController.messageAnalyticsEntry!
              .activities(activityType!)
              .expand(
            (TargetTokensAndActivityType a) {
              return choices(a).map(
                (choice) => MessageMatchActivityItem(
                  constructForm: ConstructForm(
                    choice,
                    a.tokens.first.vocabConstructID,
                  ),
                  content: choiceDisplayContent(a, choice),
                  audioContent:
                      overlayController.toolbarMode == MessageMode.listening
                          ? a.tokens.first.text.content
                          : null,
                  overlayController: overlayController,
                  fixedSize: a.activityType == ActivityTypeEnum.wordMeaning
                      ? null
                      : 60,
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
