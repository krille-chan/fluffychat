// assistance state is, user has not typed a message, user has typed a message and IGC has not run,
// IGC is running, IGC has run and there are remaining steps (either IT or IGC), or all steps are done
// Or user does not have a subscription

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

enum AssistanceStateEnum {
  noSub,
  noMessage,
  notFetched,
  fetching,
  fetched,
  complete,
  error;

  Color stateColor(BuildContext context) {
    switch (this) {
      case AssistanceStateEnum.noSub:
      case AssistanceStateEnum.noMessage:
      case AssistanceStateEnum.fetched:
      case AssistanceStateEnum.error:
        return Colors.grey[400]!;
      case AssistanceStateEnum.notFetched:
      case AssistanceStateEnum.fetching:
        return Theme.of(context).colorScheme.primary;
      case AssistanceStateEnum.complete:
        return AppConfig.success;
    }
  }

  Color sendButtonColor(BuildContext context) {
    switch (this) {
      case AssistanceStateEnum.noMessage:
      case AssistanceStateEnum.fetched:
        return Theme.of(context).disabledColor;
      case AssistanceStateEnum.noSub:
      case AssistanceStateEnum.error:
      case AssistanceStateEnum.notFetched:
      case AssistanceStateEnum.fetching:
        return Theme.of(context).colorScheme.primary;
      case AssistanceStateEnum.complete:
        return AppConfig.success;
    }
  }

  bool get allowsFeedback => switch (this) {
    AssistanceStateEnum.notFetched => true,
    _ => false,
  };

  bool get showIcon => switch (this) {
    AssistanceStateEnum.noSub => true,
    AssistanceStateEnum.noMessage => true,
    AssistanceStateEnum.notFetched => true,
    AssistanceStateEnum.error => true,
    AssistanceStateEnum.complete => true,
    _ => false,
  };
}
