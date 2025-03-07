import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/analytics_misc/message_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/word_emoji_choice.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/morphs/morphological_center_widget.dart';
import 'message_emoji_choice.dart';

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
    if (token == null ||
        !(overlayController.pangeaMessageEvent?.messageDisplayLangIsL2 ??
            false)) {
      return MessageEmojiChoice(
        tokens: overlayController
                .pangeaMessageEvent?.messageDisplayRepresentation?.tokens ??
            [],
        controller: controller,
        overlayController: overlayController,
      );
    }

    switch (overlayController.toolbarMode) {
      // message meaning will not use the input bar (for now at least)
      // maybe we move some choices there later
      case MessageMode.messageMeaning:
      case MessageMode.messageTranslation:
      case MessageMode.messageTextToSpeech:
      case MessageMode.messageSpeechToText:
      case MessageMode.practiceActivity:
      case MessageMode.wordZoom:
      case MessageMode.noneSelected:
        return MessageEmojiChoice(
          tokens: overlayController
                  .pangeaMessageEvent?.messageDisplayRepresentation?.tokens ??
              [],
          controller: controller,
          overlayController: overlayController,
        );

      case MessageMode.wordEmoji:
        return WordEmojiChoice(
          overlayController: overlayController,
          token: overlayController.selectedToken!,
        );

      case MessageMode.wordMeaning:
        return getPracticeActivityCard(ActivityTypeEnum.wordMeaning);

      case MessageMode.wordMorph:
        if (overlayController.selectedMorphFeature != null) {
          if (!token!.shouldDoActivity(
            a: ActivityTypeEnum.morphId,
            feature: overlayController.selectedMorphFeature,
            tag: token!.getMorphTag(overlayController.selectedMorphFeature!),
          )) {
            return MorphFocusWidget(
              token: token!,
              morphFeature: overlayController.selectedMorphFeature!,
              pangeaMessageEvent: overlayController.pangeaMessageEvent!,
              overlayController: overlayController,
              onEditDone: () => overlayController.initializeTokensAndMode(),
            );
          } else {
            return getPracticeActivityCard(
              ActivityTypeEnum.morphId,
              overlayController.selectedMorphFeature,
            );
          }
        } else {
          /// we're not supposed to be here actually
          debugger(when: kDebugMode);
          ErrorHandler.logError(
            m: "selectedMorphFeature is null in wordMorph mode",
            s: StackTrace.current,
            data: token?.toJson() ?? {},
          );
          final String? nextFeature = overlayController
              .selectedToken?.nextMorphFeatureEligibleForActivity;
          if (nextFeature != null) {
            return getPracticeActivityCard(
              ActivityTypeEnum.morphId,
              nextFeature,
            );
          } else {
            // morph center widget with feature = "pos"
            return MorphFocusWidget(
              token: token!,
              morphFeature: "pos",
              pangeaMessageEvent: overlayController.pangeaMessageEvent!,
              overlayController: overlayController,
              onEditDone: () => overlayController.initializeTokensAndMode(),
            );
          }
        }
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

    return Flexible(
      child: Container(
        height: AppConfig.readingAssistanceInputBarHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        alignment: Alignment.center,
        child: barContent(context),
      ),
    );
  }
}
