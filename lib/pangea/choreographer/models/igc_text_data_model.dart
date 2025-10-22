import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/utils/match_style_util.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/autocorrect_span.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';

class IGCTextData {
  String originalInput;
  String? fullTextCorrection;
  List<PangeaMatch> matches;
  String userL1;
  String userL2;
  bool enableIT;
  bool enableIGC;

  IGCTextData({
    required this.originalInput,
    required this.fullTextCorrection,
    required this.matches,
    required this.userL1,
    required this.userL2,
    required this.enableIT,
    required this.enableIGC,
  });

  factory IGCTextData.fromJson(Map<String, dynamic> json) {
    return IGCTextData(
      matches: json["matches"] != null
          ? (json["matches"] as Iterable)
              .map<PangeaMatch>(
                (e) {
                  return PangeaMatch.fromJson(e as Map<String, dynamic>);
                },
              )
              .toList()
              .cast<PangeaMatch>()
          : [],
      originalInput: json["original_input"],
      fullTextCorrection: json["full_text_correction"],
      userL1: json[ModelKey.userL1],
      userL2: json[ModelKey.userL2],
      enableIT: json["enable_it"],
      enableIGC: json["enable_igc"],
    );
  }

  Map<String, dynamic> toJson() => {
        "original_input": originalInput,
        "full_text_correction": fullTextCorrection,
        "matches": matches.map((e) => e.toJson()).toList(),
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        "enable_it": enableIT,
        "enable_igc": enableIGC,
      };

  List<int> _matchIndicesByOffset(int offset) {
    final List<int> matchesForOffset = [];
    for (final (index, match) in matches.indexed) {
      if (match.isOffsetInMatchSpan(offset)) {
        matchesForOffset.add(index);
      }
    }
    return matchesForOffset;
  }

  int getTopMatchIndexForOffset(int offset) =>
      _matchIndicesByOffset(offset).firstWhereOrNull((matchIndex) {
        final match = matches[matchIndex];
        return (enableIT && (match.isITStart || match.needsTranslation)) ||
            (enableIGC && match.isGrammarMatch);
      }) ??
      -1;

  int? get _openMatchIndex {
    final RegExp pattern = RegExp(r'span_card_overlay_\d+');
    final String? matchingKeys =
        MatrixState.pAnyState.getMatchingOverlayKeys(pattern).firstOrNull;
    if (matchingKeys == null) return null;

    final int? index = int.tryParse(matchingKeys.split("_").last);
    if (index == null ||
        matches.length <= index ||
        matches[index].status != PangeaMatchStatus.open) {
      return null;
    }

    return index;
  }

  InlineSpan _matchSpan(
    PangeaMatch match,
    TextStyle style,
    void Function(PangeaMatch)? onUndo,
  ) {
    if (match.status == PangeaMatchStatus.automatic) {
      final span = originalInput.characters
          .getRange(
            match.match.offset,
            match.match.offset + match.match.length,
          )
          .toString();

      final originalText = match.match.fullText.characters
          .getRange(
            match.match.offset,
            match.match.offset + match.match.length,
          )
          .toString();

      return AutocorrectSpan(
        transformTargetId:
            "autocorrection_${match.match.offset}_${match.match.length}",
        currentText: span,
        originalText: originalText,
        onUndo: () => onUndo?.call(match),
        style: style,
      );
    } else {
      return TextSpan(
        text: originalInput.characters
            .getRange(
              match.match.offset,
              match.match.offset + match.match.length,
            )
            .toString(),
        style: style,
      );
    }
  }

  /// Returns a list of [TextSpan]s used to display the text in the input field
  /// with the appropriate styling for each error match.
  List<InlineSpan> constructTokenSpan({
    required List<ChoreoRecordStep> choreoSteps,
    void Function(PangeaMatch)? onUndo,
    TextStyle? defaultStyle,
  }) {
    final automaticMatches = choreoSteps
        .map((s) => s.acceptedOrIgnoredMatch)
        .whereType<PangeaMatch>()
        .where((m) => m.status == PangeaMatchStatus.automatic)
        .toList();

    final textSpanMatches = [...matches, ...automaticMatches]
      ..sort((a, b) => a.match.offset.compareTo(b.match.offset));

    final spans = <InlineSpan>[];
    int cursor = 0;

    for (final match in textSpanMatches) {
      if (cursor < match.match.offset) {
        final text = originalInput.characters
            .getRange(cursor, match.match.offset)
            .toString();
        spans.add(TextSpan(text: text, style: defaultStyle));
      }

      final matchIndex = matches.indexWhere(
        (m) => m.match.offset == match.match.offset,
      );

      final style = MatchStyleUtil.textStyle(
        match,
        defaultStyle,
        _openMatchIndex != null && _openMatchIndex == matchIndex,
      );

      spans.add(_matchSpan(match, style, onUndo));
      cursor = match.match.offset + match.match.length;
    }

    if (cursor < originalInput.characters.length) {
      spans.add(
        TextSpan(
          text: originalInput.characters
              .getRange(cursor, originalInput.characters.length)
              .toString(),
          style: defaultStyle,
        ),
      );
    }

    return spans;
  }

  void acceptReplacement(
    int matchIndex,
    int choiceIndex,
  ) {
    final PangeaMatch pangeaMatch = matches.removeAt(matchIndex);
    if (pangeaMatch.match.choices == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "pangeaMatch.match.choices is null in acceptReplacement",
        data: {
          "match": pangeaMatch.match.toJson(),
        },
      );
      return;
    }

    _runReplacement(
      pangeaMatch.match.offset,
      pangeaMatch.match.length,
      pangeaMatch.match.choices![choiceIndex].value,
    );
  }

  void undoReplacement(PangeaMatch match) {
    final choice = match.match.choices
        ?.firstWhereOrNull(
          (c) => c.isBestCorrection,
        )
        ?.value;

    if (choice == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "pangeaMatch.match.choices has no best correction in undoReplacement",
        data: {
          "match": match.match.toJson(),
        },
      );
      return;
    }

    final String replacement = match.match.fullText.characters
        .getRange(
          match.match.offset,
          match.match.offset + match.match.length,
        )
        .toString();

    _runReplacement(
      match.match.offset,
      choice.characters.length,
      replacement,
    );
  }

  /// Internal runner for applying a replacement to the current text.
  void _runReplacement(
    int offset,
    int length,
    String replacement,
  ) {
    final newStart = originalInput.characters.take(offset);
    final newEnd = originalInput.characters.skip(offset + length);
    final fullText = newStart + replacement.characters + newEnd;
    originalInput = fullText.toString();

    for (final match in matches) {
      match.match.fullText = originalInput;
      if (match.match.offset > offset) {
        match.match.offset += replacement.characters.length - length;
      }
    }
  }
}
