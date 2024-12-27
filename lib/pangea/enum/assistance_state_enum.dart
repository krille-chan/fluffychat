// assistance state is, user has not typed a message, user has typed a message and IGC has not run,
// IGC is running, IGC has run and there are remaining steps (either IT or IGC), or all steps are done
// Or user does not have a subscription
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
        return PangeaColors.igcError;
      case AssistanceState.complete:
        return AppConfig.success;
    }
  }

  String tooltip(L10n l10n) {
    switch (this) {
      case AssistanceState.noMessage:
      case AssistanceState.notFetched:
        return l10n.runGrammarCorrection;
      case AssistanceState.noSub:
      case AssistanceState.fetching:
        return "";
      case AssistanceState.fetched:
        return l10n.grammarCorrectionFailed;
      case AssistanceState.complete:
        return l10n.grammarCorrectionComplete;
    }
  }
}
