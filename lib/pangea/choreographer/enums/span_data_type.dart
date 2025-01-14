import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/matrix.dart';

enum SpanDataTypeEnum {
  definition,
  practice,
  correction,
  itStart,
}

extension SpanDataTypeEnumExt on SpanDataTypeEnum {
  String get name {
    switch (this) {
      case SpanDataTypeEnum.definition:
        return "definition";
      case SpanDataTypeEnum.practice:
        return "practice";
      case SpanDataTypeEnum.correction:
        return "correction";
      case SpanDataTypeEnum.itStart:
        return "itStart";
    }
  }

  String defaultPrompt(BuildContext context) {
    switch (this) {
      case SpanDataTypeEnum.definition:
        return L10n.of(context).definitionDefaultPrompt;
      case SpanDataTypeEnum.practice:
        return L10n.of(context).practiceDefaultPrompt;
      case SpanDataTypeEnum.correction:
        return L10n.of(context).correctionDefaultPrompt;
      case SpanDataTypeEnum.itStart:
        return L10n.of(context).needsItMessage(
          MatrixState.pangeaController.languageController.userL2?.displayName ??
              L10n.of(context).targetLanguage,
        );
    }
  }
}
