import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/models/span_card_model.dart';
import 'package:fluffychat/pangea/choreographer/models/span_data.dart';
import 'package:fluffychat/pangea/choreographer/repo/language_detection_repo.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';

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
    );
  }

  factory IGCTextData.fromRepresentationEvent(
    RepresentationEvent event,
    String userL1,
    String userL2,
  ) {
    final PangeaRepresentation content = event.content;
    final List<PangeaToken> tokens = event.tokens ?? [];
    final List<PangeaMatch> matches = event.choreo?.choreoSteps
            .map((step) => step.acceptedOrIgnoredMatch)
            .whereType<PangeaMatch>()
            .toList() ??
        [];

    String originalInput = content.text;
    if (matches.isNotEmpty) {
      originalInput = matches.first.match.fullText;
    }

    final defaultDetections = LanguageDetectionResponse(
      detections: [
        LanguageDetection(langCode: content.langCode, confidence: 1),
      ],
      fullText: content.text,
    );

    final LanguageDetectionResponse detections = event.detections != null
        ? LanguageDetectionResponse.fromJson({
            "detections": event.detections,
            "full_text": content.text,
          })
        : defaultDetections;

    return IGCTextData(
      detections: detections,
      originalInput: originalInput,
      fullTextCorrection: content.text,
      tokens: tokens,
      matches: matches,
      userL1: userL1,
      userL2: userL2,
      enableIT: true,
      enableIGC: true,
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
      };

  /// if we haven't run IGC or IT or there are no matches, we use the highest validated detection
  /// from [LanguageDetectionResponse.highestValidatedDetection]
  /// if we have run igc/it and there are no matches, we can relax the threshold
  /// and use the highest confidence detection
  String get detectedLanguage {
    return detections.detections.firstOrNull?.langCode ??
        LanguageKeys.unknownLanguage;
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

    int startIndex;
    int endIndex;

    // replace the tokens that are part of the match
    // with the tokens in the replacement
    //    start is inclusive
    try {
      startIndex = tokenIndexByOffset(pangeaMatch.match.offset);
      //    end is exclusive, hence the +1
      // use pangeaMatch.matchContent.trim().length instead of pangeaMatch.match.length since pangeaMatch.match.length may include leading/trailing spaces
      endIndex = tokenIndexByOffset(
            pangeaMatch.match.offset + pangeaMatch.matchContent.trim().length,
          ) +
          1;
    } catch (err, s) {
      matches.removeAt(matchIndex);

      for (final match in matches) {
        match.match.fullText = originalInput;
        if (match.match.offset > pangeaMatch.match.offset) {
          match.match.offset +=
              replacement.value.length - pangeaMatch.match.length;
        }
      }
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "cursorOffset": pangeaMatch.match.offset,
          "match": pangeaMatch.match.toJson(),
          "tokens": tokens.map((e) => e.toJson()).toString(),
        },
      );
      return;
    }

    // for all tokens after the replacement, update their offsets
    for (int i = endIndex; i < tokens.length; i++) {
      tokens[i].text.offset +=
          replacement.value.length - pangeaMatch.match.length;
    }

    // clone the list for debugging purposes
    final List<PangeaToken> newTokens = List.from(tokens);

    // replace the tokens in the list
    newTokens.replaceRange(startIndex, endIndex, replacement.tokens);

    final String newFullText = PangeaToken.reconstructText(newTokens);
    if (newFullText.trim() != originalInput.trim() && kDebugMode) {
      PangeaToken.reconstructText(newTokens, debugWalkThrough: true);
      ErrorHandler.logError(
        m: "reconstructed text not working",
        s: StackTrace.current,
        data: {
          "originalInput": originalInput,
          "newFullText": newFullText,
          "match": pangeaMatch.match.toJson(),
        },
      );
    }

    tokens = newTokens;

    //update offsets in existing matches to reflect the change
    //Question - remove matches that overlap with the accepted one?
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

  void removeMatchByOffset(int offset) {
    final int index = getTopMatchIndexForOffset(offset);
    if (index != -1) {
      matches.removeAt(index);
    }
  }

  int tokenIndexByOffset(int cursorOffset) {
    final tokenIndex = tokens.indexWhere(
      (token) => token.start <= cursorOffset && cursorOffset <= token.end,
    );
    if (tokenIndex < 0) {
      throw "No token found for cursor offset";
    }
    return tokenIndex;
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
        ErrorHandler.logError(
          m: "weird token lengths for ${tokens[tokenIndex].text.content} and ${tokens[tokenIndex + 1].text.content}",
          data: {
            "fullText": originalInput,
            "tokens": tokens.map((e) => e.toJson()).toString(),
          },
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

  List<PangeaToken> matchTokens(int matchIndex) {
    if (matchIndex >= matches.length) {
      return [];
    }

    final PangeaMatch match = matches[matchIndex];
    final List<PangeaToken> tokensForMatch = [];
    for (final token in tokens) {
      if (match.isOffsetInMatchSpan(token.text.offset)) {
        tokensForMatch.add(token);
      }
    }
    return tokensForMatch;
  }
}
