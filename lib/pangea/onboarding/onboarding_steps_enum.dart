import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';

enum OnboardingStepsEnum {
  chatWithBot,
  joinSpace,
  inviteFriends;

  String description(L10n l10n) {
    switch (this) {
      case OnboardingStepsEnum.chatWithBot:
        return l10n.getStartedBotChatDesc;
      case OnboardingStepsEnum.joinSpace:
        return l10n.getStartedCommunitiesDesc;
      case OnboardingStepsEnum.inviteFriends:
        return l10n.getStartedFriendsDesc;
    }
  }

  String completeMessage(L10n l10n) {
    switch (this) {
      case OnboardingStepsEnum.chatWithBot:
        return l10n.getStartedBotChatComplete;
      case OnboardingStepsEnum.joinSpace:
        return l10n.getStartedCommunitiesComplete;
      case OnboardingStepsEnum.inviteFriends:
        return l10n.getStartedFriendsComplete;
    }
  }

  Widget icon(double size) {
    switch (this) {
      case OnboardingStepsEnum.chatWithBot:
        return BotFace(expression: BotExpression.gold, width: size);
      case OnboardingStepsEnum.joinSpace:
        return Icon(Icons.groups_outlined, size: size);
      case OnboardingStepsEnum.inviteFriends:
        return Icon(Icons.share, size: size);
    }
  }

  String buttonText(L10n l10n) {
    switch (this) {
      case OnboardingStepsEnum.chatWithBot:
        return l10n.getStartedBotChatButton;
      case OnboardingStepsEnum.joinSpace:
        return l10n.findYourPeople;
      case OnboardingStepsEnum.inviteFriends:
        return l10n.getStartedFriendsButton;
    }
  }
}
