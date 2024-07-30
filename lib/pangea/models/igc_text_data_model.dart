import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/controllers/language_detection_controller.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/span_card_model.dart';
import 'package:fluffychat/pangea/repo/igc_repo.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/model_keys.dart';

// import 'package:language_tool/language_tool.dart';

class IGCTextData {
  LanguageDetectionResponse detections;
  String originalInput;
  String? fullTextCorrection;
  List<PangeaToken> tokens;
  List<PangeaMatch> matches;
  String userL1;
  String userL2;
  bool enableIT;
  bool enableIGC;
  bool loading = false;
  List<PreviousMessage> prevMessages;

  IGCTextData({
    required this.detections,
    required this.originalInput,
    required this.fullTextCorrection,
    required this.tokens,
    required this.matches,
    required this.userL1,
    required this.userL2,
    required this.enableIT,
    required this.enableIGC,
    required this.prevMessages,
  });

  factory IGCTextData.fromJson(Map<String, dynamic> json) {
    // changing this to allow for use of the LanguageDetectionResponse methods
    // TODO - change API after we're sure all clients are updated. not urgent.
    final LanguageDetectionResponse detections =
        json[_detectionsKey] is Iterable
            ? LanguageDetectionResponse.fromJson({
                "detections": json[_detectionsKey],
                "full_text": json["original_input"],
              })
            : LanguageDetectionResponse.fromJson(
                json[_detectionsKey] as Map<String, dynamic>,
              );

    return IGCTextData(
      tokens: (json[_tokensKey] as Iterable)
          .map<PangeaToken>(
            (e) => PangeaToken.fromJson(e as Map<String, dynamic>),
          )
          .toList()
          .cast<PangeaToken>(),
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
      detections: detections,
      originalInput: json["original_input"],
      fullTextCorrection: json["full_text_correction"],
      userL1: json[ModelKey.userL1],
      userL2: json[ModelKey.userL2],
      enableIT: json["enable_it"],
      enableIGC: json["enable_igc"],
      prevMessages: json["prev_messages"],
    );
  }

  static const String _tokensKey = "tokens";
  static const String _matchesKey = "matches";
  static const String _detectionsKey = "detections";

  Map<String, dynamic> toJson() => {
        _detectionsKey: detections.toJson(),
        "original_input": originalInput,
        "full_text_correction": fullTextCorrection,
        _tokensKey: tokens.map((e) => e.toJson()).toList(),
        _matchesKey: matches.map((e) => e.toJson()).toList(),
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        "enable_it": enableIT,
        "enable_igc": enableIGC,
        "prev_messages": prevMessages,
      };

  /// if we haven't run IGC or IT or there are no matches, we use the highest validated detection
  /// from [LanguageDetectionResponse.highestValidatedDetection]
  /// if we have run igc/it and there are no matches, we can relax the threshold
  /// and use the highest confidence detection
  String get detectedLanguage {
    if (!(enableIGC && enableIT) || matches.isNotEmpty) {
      return detections.highestValidatedDetection().langCode;
    } else {
      return detections.highestConfidenceDetection.langCode;
    }
  }

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
      );
      return;
    }

    final String replacement = pangeaMatch.match.choices![choiceIndex].value;

    originalInput = originalInput.replaceRange(
      pangeaMatch.match.offset,
      pangeaMatch.match.offset + pangeaMatch.match.length,
      replacement,
    );

    //update offsets in existing matches to reflect the change
    //Question - remove matches that overlap with the accepted one?
    // see case of "quiero ver un fix"
    matches.removeAt(matchIndex);

    for (final match in matches) {
      match.match.fullText = originalInput;
      if (match.match.offset > pangeaMatch.match.offset) {
        match.match.offset += replacement.length - pangeaMatch.match.length;
      }
    }
    //quiero ver un fix
    //match offset zero and length of full text or 16
    //fix is repplaced by arreglo and now the length needs to be 20
    //if the accepted span is within another span, then the length of that span needs
    //needs to be increased by the difference between the new and old length
    //if the two spans are overlapping, what happens?
    //------
    //   ----- -> ---
    //if there is any overlap, maybe igc needs to run again?
  }

  void removeMatchByOffset(int offset) {
    final int index = getTopMatchIndexForOffset(offset);
    if (index != -1) {
      matches.removeAt(index);
    }
  }

  int tokenIndexByOffset(cursorOffset) => tokens.indexWhere(
        (token) =>
            token.text.offset <= cursorOffset && cursorOffset <= token.end,
      );

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

  PangeaMatch? getTopMatchForToken(PangeaToken token) {
    final int topMatchIndex = getTopMatchIndexForOffset(token.text.offset);
    if (topMatchIndex == -1) return null;
    return matches[topMatchIndex];
  }

  int getAfterTokenSpacingByIndex(int tokenIndex) {
    final int endOfToken = tokens[tokenIndex].end;

    if (tokenIndex + 1 < tokens.length) {
      final spaceBetween = tokens[tokenIndex + 1].text.offset - endOfToken;

      if (spaceBetween < 0) {
        Sentry.addBreadcrumb(
          Breadcrumb.fromJson(
            {
              "fullText": originalInput,
              "tokens": tokens.map((e) => e.toJson()).toString(),
            },
          ),
        );
        ErrorHandler.logError(
          m: "weird token lengths for ${tokens[tokenIndex].text.content} and ${tokens[tokenIndex + 1].text.content}",
        );
        return 0;
      }
      return spaceBetween;
    } else {
      return originalInput.length - endOfToken;
    }
  }

  static TextStyle underlineStyle(Color color) => TextStyle(
        decoration: TextDecoration.underline,
        decorationColor: color,
        decorationThickness: 5,
      );

  List<MatchToken> getMatchTokens() {
    final List<MatchToken> matchTokens = [];
    int? endTokenIndex;
    PangeaMatch? topMatch;
    for (final (i, token) in tokens.indexed) {
      if (endTokenIndex != null) {
        if (i <= endTokenIndex) {
          matchTokens.add(
            MatchToken(
              token: token,
              match: topMatch,
            ),
          );
          continue;
        }
        endTokenIndex = null;
      }
      topMatch = getTopMatchForToken(token);
      if (topMatch != null) {
        endTokenIndex = tokens.indexWhere((e) => e.end >= topMatch!.end, i);
      }
      matchTokens.add(
        MatchToken(
          token: token,
          match: topMatch,
        ),
      );
    }
    return matchTokens;
  }

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

  //PTODO - handle multitoken spans
  /// Returns a list of [TextSpan]s used to display the text in the input field
  /// with the appropriate styling for each error match.
  List<TextSpan> constructTokenSpan({
    required BuildContext context,
    TextStyle? defaultStyle,
    required SpanCardModel? spanCardModel,
    required bool handleClick,
    required String transformTargetId,
    required Room room,
  }) {
    final List<TextSpan> items = [];

    if (loading) {
      return [
        TextSpan(
          text: originalInput,
          style: defaultStyle,
        ),
      ];
    }

    final List<List<int>> matchRanges = matches
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
    while (currentIndex < originalInput.characters.length) {
      // check if the pointer is at a match, and if so, get the index of the match
      final int matchIndex = matchRanges.indexWhere(
        (range) => currentIndex >= range[0] && currentIndex < range[1],
      );
      final bool inMatch = matchIndex != -1;

      if (inMatch) {
        // if the pointer is in a match, then add that match to items
        // and then move the pointer to the end of the match range
        final PangeaMatch match = matches[matchIndex];
        items.add(
          getSpanItem(
            start: match.match.offset,
            end: match.match.offset + match.match.length,
            style: match.textStyle(defaultStyle),
          ),
        );

        currentIndex = match.match.offset + match.match.length;
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
    }

    return items;
  }
}

class MatchToken {
  final PangeaToken token;
  final PangeaMatch? match;

  MatchToken({required this.token, this.match});
}
