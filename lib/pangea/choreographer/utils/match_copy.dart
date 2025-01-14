import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/choreographer/enums/span_data_type.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../constants/match_rule_ids.dart';
import '../models/pangea_match_model.dart';

class MatchCopy {
  PangeaMatch match;
  late String title;
  String? description;

  MatchCopy(BuildContext context, this.match) {
    if (match.match.rule?.id != null) {
      _byMatchRuleId(context);
      return;
    }
    if (match.match.shortMessage != null) {
      title = match.match.shortMessage!;
    }
    if (match.match.message != null) {
      description = match.match.message!;
    }
    if (match.match.shortMessage == null) {
      _bySpanDataType(context);
    }
  }

  _setDefaults() {
    try {
      title = match.match.shortMessage ?? "unknown";
      description = match.match.message ?? "unknown";
    } catch (err) {
      title = "Error";
      description = "Could not find the check info";
    }
  }

  void _bySpanDataType(BuildContext context) {
    try {
      final L10n l10n = L10n.of(context);
      switch (match.match.type.typeName) {
        case SpanDataTypeEnum.correction:
          title = l10n.someErrorTitle;
          description = l10n.someErrorBody;
          break;
        case SpanDataTypeEnum.definition:
          title = match.matchContent;
          description = null;
          break;
        case SpanDataTypeEnum.itStart:
          title = l10n.needsItShortMessage;
          // description = l10n.needsItMessage;
          break;
        case SpanDataTypeEnum.practice:
          title = match.match.shortMessage ?? "Activity";
          description = match.match.message;
          break;
      }
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "match": match.toJson(),
        },
      );
      _setDefaults();
    }
  }

  void _byMatchRuleId(BuildContext context) {
    try {
      if (match.match.rule?.id == null) {
        throw Exception("match.match.rule.id is null");
      }
      final L10n l10n = L10n.of(context);

      final List<String> splits = match.match.rule!.id.split(":");
      if (splits.length >= 2) {
        splits.removeAt(0);
      }
      final String afterColon = splits.join();

      debugPrint("grammar rule ${match.match.rule!.id}");

      switch (afterColon) {
        case MatchRuleIds.interactiveTranslation:
          title = l10n.needsItShortMessage;
          description = l10n.needsItMessage(
            MatrixState
                    .pangeaController.languageController.userL2?.displayName ??
                "target language",
          );
          break;
        case MatchRuleIds.tokenNeedsTranslation:
          title = l10n.tokenTranslationTitle;
          description = l10n.spanTranslationDesc;
          break;
        case MatchRuleIds.tokenSpanNeedsTranslation:
          title = l10n.spanTranslationTitle;
          description = l10n.spanTranslationDesc;
          break;
        case MatchRuleIds.l1SpanAndGrammar:
          title = l10n.l1SpanAndGrammarTitle;
          description = l10n.l1SpanAndGrammarDesc;
          break;
        // case "PART":
        //   title = l10n.partTitle;
        //   description = l10n.partDesc;
        //   break;
        // case "PUNCT":
        //   title = l10n.punctTitle;
        //   description = l10n.punctDesc;
        //   break;
        // case "ORTH":
        //   title = l10n.orthTitle;
        //   description = l10n.orthDesc;
        //   break;
        // case "SPELL":
        //   title = l10n.spellTitle;
        //   description = l10n.spellDesc;
        //   break;
        // case "WO":
        //   title = l10n.woTitle;
        //   description = l10n.woDesc;
        //   break;
        // case "MORPH":
        //   title = l10n.morphTitle;
        //   description = l10n.morphDesc;
        //   break;
        // case "ADV":
        //   title = l10n.advTitle;
        //   description = l10n.advDesc;
        //   break;
        // case "CONTR":
        //   title = l10n.contrTitle;
        //   description = l10n.contrDesc;
        //   break;
        // case "CONJ":
        //   title = l10n.conjTitle;
        //   description = l10n.conjDesc;
        //   break;
        // case "DET":
        //   title = l10n.detTitle;
        //   description = l10n.detDesc;
        //   break;
        // case "DETART":
        //   title = l10n.detArtTitle;
        //   description = l10n.detArtDesc;
        //   break;
        // case "PREP":
        //   title = l10n.prepTitle;
        //   description = l10n.prepDesc;
        //   break;
        // case "PRON":
        //   title = l10n.pronTitle;
        //   description = l10n.pronDesc;
        //   break;
        // case "VERB":
        //   title = l10n.verbTitle;
        //   description = l10n.verbDesc;
        //   break;
        // case "VERBFORM":
        //   title = l10n.verbFormTitle;
        //   description = l10n.verbFormDesc;
        //   break;
        // case "VERBTENSE":
        //   title = l10n.verbTenseTitle;
        //   description = l10n.verbTenseDesc;
        //   break;
        // case "VERBSVA":
        //   title = l10n.verbSvaTitle;
        //   description = l10n.verbSvaDesc;
        //   break;
        // case "VERBINFL":
        //   title = l10n.verbInflTitle;
        //   description = l10n.verbInflDesc;
        //   break;
        // case "ADJ":
        //   title = l10n.adjTitle;
        //   description = l10n.adjDesc;
        //   break;
        // case "ADJFORM":
        //   title = l10n.adjFormTitle;
        //   description = l10n.adjFormDesc;
        //   break;
        // case "NOUN":
        //   title = l10n.nounTitle;
        //   description = l10n.nounDesc;
        //   break;
        // case "NOUNPOSS":
        //   title = l10n.nounPossTitle;
        //   description = l10n.nounPossDesc;
        //   break;
        // case "NOUNINFL":
        //   title = l10n.nounInflTitle;
        //   description = l10n.nounInflDesc;
        //   break;
        // case "NOUNNUM":
        //   title = l10n.nounNumTitle;
        //   description = l10n.nounNumDesc;
        //   break;
        case "OTHER":
        default:
          _setDefaults();
          break;
      }
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "match": match.toJson(),
        },
      );
      _setDefaults();
    }
  }
}
