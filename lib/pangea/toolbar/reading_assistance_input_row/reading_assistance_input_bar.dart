import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/target_tokens_and_activity_type.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_match_activity.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_morph_choice.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_mode_locked_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_translation_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';

class ReadingAssistanceInputBar extends StatelessWidget {
  final ChatController controller;
  final MessageOverlayController overlayController;

  const ReadingAssistanceInputBar(
    this.controller,
    this.overlayController, {
    super.key,
  });

  PangeaToken? get token => overlayController.selectedToken;

  PracticeActivityCard getPracticeActivityCard(
    ActivityTypeEnum a, [
    String? morphFeature,
  ]) {
    if (a == ActivityTypeEnum.morphId && morphFeature == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "morphFeature null with activityType of morphId in getPracticeActivityCard",
        s: StackTrace.current,
        data: token?.toJson() ?? {},
      );
      morphFeature = "pos";
    }
    return PracticeActivityCard(
      pangeaMessageEvent: overlayController.pangeaMessageEvent!,
      targetTokensAndActivityType: TargetTokensAndActivityType(
        tokens: [token!],
        activityType: a,
      ),
      overlayController: overlayController,
      morphFeature: morphFeature,
      location: AnalyticsUpdateOrigin.inputBar,
    );
  }

  Widget barContent(BuildContext context) {
    switch (overlayController.toolbarMode) {
      // message meaning will not use the input bar (for now at least)
      // maybe we move some choices there later
      case MessageMode.messageSpeechToText:
      case MessageMode.practiceActivity:
      case MessageMode.wordZoom:
      case MessageMode.noneSelected:
        //TODO: show all emojis for the lemmas and allow sending normal reactions
        return const SizedBox.shrink();
      // return MessageEmojiChoice(
      //   controller: controller,
      //   overlayController: overlayController,
      // );

      case MessageMode.messageTranslation:
        if (overlayController.isTranslationUnlocked) {
          return MessageTranslationCard(
            messageEvent: overlayController.pangeaMessageEvent!,
          );
        } else {
          return MessageModeLockedCard(controller: overlayController);
        }

      case MessageMode.wordEmoji:
      case MessageMode.messageMeaning:
      case MessageMode.wordMeaning:
      case MessageMode.listening:
        return MessageMatchActivity(
          overlayController: overlayController,
        );

      case MessageMode.wordMorph:
        return MessageMorphInputBarContent(
          overlayController: overlayController,
          pangeaMessageEvent: overlayController.pangeaMessageEvent!,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.showEmojiPicker) return const SizedBox.shrink();

    final display = controller.editEvent == null &&
        controller.replyEvent == null &&
        controller.room.canSendDefaultMessages &&
        controller.selectedEvents.isNotEmpty;

    if (!display) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height / 2) -
              AppConfig.toolbarButtonsHeight,
        ),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: AnimatedSize(
          duration: const Duration(
            milliseconds: AppConfig.overlayAnimationDuration,
          ),
          child: SingleChildScrollView(
            child: barContent(context),
          ),
        ),
      ),
    );
  }
}
