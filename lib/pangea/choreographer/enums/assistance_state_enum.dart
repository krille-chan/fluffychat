// assistance state is, user has not typed a message, user has typed a message and IGC has not run,
// IGC is running, IGC has run and there are remaining steps (either IT or IGC), or all steps are done
// Or user does not have a subscription

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

enum AssistanceState {
  noSub,
  noMessage,
  notFetched,
  fetching,
  fetched,
  complete,
}

extension AssistanceStateExtension on AssistanceState {
  Color stateColor(context) {
    switch (this) {
      case AssistanceState.noSub:
      case AssistanceState.noMessage:
      case AssistanceState.notFetched:
      case AssistanceState.fetching:
        return Theme.of(context).colorScheme.primary;
      case AssistanceState.fetched:
        return AppConfig.error;
      case AssistanceState.complete:
        return AppConfig.success;
    }
  }
}
