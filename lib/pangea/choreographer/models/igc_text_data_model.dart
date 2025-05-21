import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/models/span_data.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/autocorrect_popup.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

// import 'package:language_tool/language_tool.dart';

class IGCTextData {
  String originalInput;
  String? fullTextCorrection;
  List<PangeaMatch> matches;
  String userL1;
  String userL2;
  bool enableIT;
  bool enableIGC;
  bool loading = false;

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
      matches: json[_matchesKey] != null
          ? (json[_matchesKey] as Iterable)
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

  factory IGCTextData.fromRepresentationEvent(
    RepresentationEvent event,
    String userL1,
    String userL2,
  ) {
    final PangeaRepresentation content = event.content;
    final List<PangeaMatch> matches = event.choreo?.choreoSteps
            .map((step) => step.acceptedOrIgnoredMatch)
            .whereType<PangeaMatch>()
            .toList() ??
        [];

    String originalInput = content.text;
    if (matches.isNotEmpty) {
      originalInput = matches.first.match.fullText;
    }

    return IGCTextData(
      originalInput: originalInput,
      fullTextCorrection: content.text,
      matches: matches,
      userL1: userL1,
      userL2: userL2,
      enableIT: true,
      enableIGC: true,
    );
  }

  static const String _matchesKey = "matches";

  Map<String, dynamic> toJson() => {
        "original_input": originalInput,
        "full_text_correction": fullTextCorrection,
        _matchesKey: matches.map((e) => e.toJson()).toList(),
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        "enable_it": enableIT,
        "enable_igc": enableIGC,
      };

  // reconstruct fullText based on accepted match
  //update offsets in existing matches to reflect the change
  //if existing matches overlap with the accepted one, remove them??
  void acceptReplacement(
    int matchIndex,
    int choiceIndex,
  ) async {
    //should be already added to choreoRecord
    //TODO - that should be done in the same function to avoid error potential

    final PangeaMatch pangeaMatch = matches[matchIndex];

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

    final SpanChoice replacement = pangeaMatch.match.choices![choiceIndex];

    final newStart = originalInput.characters.take(pangeaMatch.match.offset);
    final newEnd = originalInput.characters
        .skip(pangeaMatch.match.offset + pangeaMatch.match.length);
    final fullText = newStart + replacement.value.characters + newEnd;
    originalInput = fullText.toString();

    // update offsets in existing matches to reflect the change
    // Question - remove matches that overlap with the accepted one?
    // see case of "quiero ver un fix"
    matches.removeAt(matchIndex);

    for (final match in matches) {
      match.match.fullText = originalInput;
      if (match.match.offset > pangeaMatch.match.offset) {
        match.match.offset +=
            replacement.value.length - pangeaMatch.match.length;
      }
    }
  }

  void undoReplacement(PangeaMatch match) async {
    if (match.match.choices == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "pangeaMatch.match.choices is null in undoReplacement",
        data: {
          "match": match.match.toJson(),
        },
      );
      return;
    }

    if (!match.match.choices!.any((c) => c.isBestCorrection)) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "pangeaMatch.match.choices has no best correction in undoReplacement",
        data: {
          "match": match.match.toJson(),
        },
      );
      return;
    }

    final bestCorrection =
        match.match.choices!.firstWhere((c) => c.isBestCorrection).value;

    final String replacement = match.match.fullText.characters
        .getRange(
          match.match.offset,
          match.match.offset + match.match.length,
        )
        .toString();

    final newStart = originalInput.characters.take(match.match.offset);
    final newEnd = originalInput.characters.skip(
      match.match.offset + bestCorrection.characters.length,
    );
    final fullText = newStart + replacement.characters + newEnd;
    originalInput = fullText.toString();

    for (final remainingMatch in matches) {
      remainingMatch.match.fullText = originalInput;
      if (remainingMatch.match.offset > match.match.offset) {
        remainingMatch.match.offset +=
            match.match.length - bestCorrection.characters.length;
      }
    }
  }

  List<int> matchIndicesByOffset(int offset) {
    final List<int> matchesForOffset = [];
    for (final (index, match) in matches.indexed) {
      if (match.isOffsetInMatchSpan(offset)) {
        matchesForOffset.add(index);
      }
    }
    return matchesForOffset;
  }

  int getTopMatchIndexForOffset(int offset) {
    final List<int> matchesForToken = matchIndicesByOffset(offset);
    final int matchIndex = matchesForToken.indexWhere((matchIndex) {
      final match = matches[matchIndex];
      return (enableIT && (match.isITStart || match.isl1SpanMatch)) ||
          (enableIGC && match.isGrammarMatch);
    });
    if (matchIndex == -1) return -1;
    return matchesForToken[matchIndex];
  }

  static TextStyle underlineStyle(Color color) => TextStyle(
        decoration: TextDecoration.underline,
        decorationColor: color,
        decorationThickness: 5,
      );

  TextSpan getSpanItem({
    required int start,
    required int end,
    TextStyle? style,
  }) {
    return TextSpan(
      text: originalInput.characters.getRange(start, end).toString(),
      style: style,
    );
  }

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

  //PTODO - handle multitoken spans
  /// Returns a list of [TextSpan]s used to display the text in the input field
  /// with the appropriate styling for each error match.
  List<InlineSpan> constructTokenSpan({
    required List<ChoreoRecordStep> choreoSteps,
    void Function(PangeaMatch)? onUndo,
    TextStyle? defaultStyle,
  }) {
    final automaticMatches = choreoSteps
        .where(
          (step) =>
              step.acceptedOrIgnoredMatch?.status ==
              PangeaMatchStatus.automatic,
        )
        .map((step) => step.acceptedOrIgnoredMatch)
        .whereType<PangeaMatch>()
        .toList();

    final List<PangeaMatch> textSpanMatches = List.from(matches);
    textSpanMatches.addAll(automaticMatches);

    final List<InlineSpan> items = [];

    if (loading) {
      return [
        TextSpan(
          text: originalInput,
          style: defaultStyle,
        ),
      ];
    }

    textSpanMatches.sort((a, b) => a.match.offset.compareTo(b.match.offset));
    final List<List<int>> matchRanges = textSpanMatches
        .map(
          (match) => [
            match.match.offset,
            match.match.length + match.match.offset,
          ],
        )
        .toList();

    // create a pointer to the current index in the original input
    // and iterate until the pointer has reached the end of the input
    int currentIndex = 0;
    int loops = 0;
    final List<PangeaMatch> addedMatches = [];
    while (currentIndex < originalInput.characters.length) {
      if (loops > 100) {
        ErrorHandler.logError(
          e: "In constructTokenSpan, infinite loop detected",
          data: {
            "currentIndex": currentIndex,
            "matches": textSpanMatches.map((m) => m.toJson()).toList(),
          },
        );
        throw "In constructTokenSpan, infinite loop detected";
      }

      // check if the pointer is at a match, and if so, get the index of the match
      final int matchIndex = matchRanges.indexWhere(
        (range) => currentIndex >= range[0] && currentIndex < range[1],
      );
      final bool inMatch = matchIndex != -1 &&
          !addedMatches.contains(
            textSpanMatches[matchIndex],
          );

      if (matchIndex != -1 &&
          addedMatches.contains(
            textSpanMatches[matchIndex],
          )) {
        ErrorHandler.logError(
          e: "In constructTokenSpan, currentIndex is in match that has already been added",
          data: {
            "currentIndex": currentIndex,
            "matchIndex": matchIndex,
            "matches": textSpanMatches.map((m) => m.toJson()).toList(),
          },
        );
        throw "In constructTokenSpan, currentIndex is in match that has already been added";
      }

      final prevIndex = currentIndex;

      if (inMatch) {
        // if the pointer is in a match, then add that match to items
        // and then move the pointer to the end of the match range
        final PangeaMatch match = textSpanMatches[matchIndex];
        final style = match.textStyle(
          matchIndex,
          _openMatchIndex,
          defaultStyle,
        );
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

          items.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: CompositedTransformTarget(
                link: MatrixState.pAnyState
                    .layerLinkAndKey("autocorrection_$matchIndex")
                    .link,
                child: Builder(
                  builder: (context) {
                    return RichText(
                      key: MatrixState.pAnyState
                          .layerLinkAndKey("autocorrection_$matchIndex")
                          .key,
                      text: TextSpan(
                        text: span,
                        style: style,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            OverlayUtil.showOverlay(
                              context: context,
                              child: AutocorrectPopup(
                                originalText: originalText,
                                onUndo: () => onUndo?.call(match),
                              ),
                              transformTargetId: "autocorrection_$matchIndex",
                            );
                          },
                      ),
                    );
                  },
                ),
              ),
            ),
          );

          addedMatches.add(match);
          currentIndex = match.match.offset + match.match.length;
        } else {
          items.add(
            getSpanItem(
              start: match.match.offset,
              end: match.match.offset + match.match.length,
              style: style,
            ),
          );
          currentIndex = match.match.offset + match.match.length;
        }
      } else {
        // otherwise, if the pointer is not at a match, then add all the text
        // until the next match (or, if there is not next match, the end of the
        // text) to items and move the pointer to the start of the next match
        final int nextIndex = matchRanges
                .firstWhereOrNull(
                  (range) => range[0] > currentIndex,
                )
                ?.first ??
            originalInput.characters.length;

        items.add(
          getSpanItem(
            start: currentIndex,
            end: nextIndex,
            style: defaultStyle,
          ),
        );
        currentIndex = nextIndex;
      }

      if (prevIndex >= currentIndex) {
        ErrorHandler.logError(
          e: "In constructTokenSpan, currentIndex is less than prevIndex",
          data: {
            "currentIndex": currentIndex,
            "prevIndex": prevIndex,
            "matches": textSpanMatches.map((m) => m.toJson()).toList(),
          },
        );
        throw "In constructTokenSpan, currentIndex is less than prevIndex";
      }

      loops++;
    }

    return items;
  }
}
