import 'dart:developer';

import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/span_card_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
// import 'package:language_tool/language_tool.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/model_keys.dart';
import '../utils/overlay.dart';
import '../widgets/igc/span_card.dart';
import '../widgets/igc/word_data_card.dart';
import 'language_detection_model.dart';

class IGCTextData {
  List<LanguageDetection> detections;
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
      detections: (json[_detectionsKey] as Iterable)
          .map<LanguageDetection>(
            (e) => LanguageDetection.fromJson(e as Map<String, dynamic>),
          )
          .toList()
          .cast<LanguageDetection>(),
      originalInput: json["original_input"],
      fullTextCorrection: json["full_text_correction"],
      userL1: json[ModelKey.userL1],
      userL2: json[ModelKey.userL2],
      enableIT: json["enable_it"],
      enableIGC: json["enable_igc"],
    );
  }

  static const String _tokensKey = "tokens";
  static const String _matchesKey = "matches";
  static const String _detectionsKey = "detections";

  Map<String, dynamic> toJson() => {
        _detectionsKey: detections.map((e) => e.toJson()).toList(),
        "original_input": originalInput,
        "full_text_correction": fullTextCorrection,
        _tokensKey: tokens.map((e) => e.toJson()).toList(),
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
      final matchOffset = match.match.offset;
      final matchLength = match.match.length;
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

  int tokenIndexByOffset(
    cursorOffset,
  ) =>
      tokens.indexWhere(
        (token) =>
            token.text.offset <= cursorOffset &&
            cursorOffset <= token.text.offset + token.text.length,
      );

  List<int> getMatchIndicesForToken(PangeaToken token) =>
      matchIndicesByOffset(token.text.offset);

  int getTopMatchIndexForOffset(int offset) {
    final List<int> matchesForToken = matchIndicesByOffset(offset);
    if (matchesForToken.isEmpty) return -1;
    for (final matchIndex in matchesForToken) {
      final match = matches[matchIndex];
      if (enableIT) {
        if (match.isITStart || match.isl1SpanMatch) {
          return matchIndex;
        }
      }
      if (enableIGC) {
        if (match.isGrammarMatch) {
          return matchIndex;
        }
      }
    }
    return -1;
  }

  PangeaMatch? getTopMatchForToken(PangeaToken token) {
    final int topMatchIndex = getTopMatchIndexForOffset(token.text.offset);
    if (topMatchIndex == -1) return null;
    return matches[topMatchIndex];
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

  int getAfterTokenSpacingByIndex(
    int tokenIndex,
  ) {
    final int endOfToken =
        tokens[tokenIndex].text.offset + tokens[tokenIndex].text.length;

    if (tokenIndex + 1 < tokens.length) {
      final spaceBetween = tokens[tokenIndex + 1].text.offset - endOfToken;

      if (spaceBetween < 0) {
        Sentry.addBreadcrumb(
          Breadcrumb.fromJson(
            {
              "fullText": originalInput,
              "tokens": tokens.map((e) => e.toJson()).toString()
            },
          ),
        );
        ErrorHandler.logError(
          m: "wierd token lengths for ${tokens[tokenIndex].text.content} and ${tokens[tokenIndex + 1].text.content}",
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

  static const _hasDefinitionStyle = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: Color.fromARGB(148, 83, 97, 255),
    decorationThickness: 4,
  );
  static TextStyle hasDefinitionStyle(TextStyle? existingStyle) =>
      existingStyle?.merge(_hasDefinitionStyle) ?? _hasDefinitionStyle;

  //PTODO - handle multitoken spans
  List<TextSpan> constructTokenSpan({
    required BuildContext context,
    TextStyle? defaultStyle,
    required SpanCardModel? spanCardModel,
    required bool showTokens,
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

    // or could make big strings for non-match text and therefore make less textspans.
    // would that be more performant?
    tokens.asMap().forEach(
      (index, token) {
        final PangeaMatch? topTokenMatch = getTopMatchForToken(
          tokens[index],
        );
        // if (index == 3) {
        //   debugPrint(
        //       "constructing span with topTokenMatch: ${topTokenMatch?.match.rule.id}");
        // }

        final Widget cardToShow = spanCardModel != null && topTokenMatch != null
            ? SpanCard(
                scm: spanCardModel,
              )
            : WordDataCard(
                fullText: originalInput,
                fullTextLang: detections.first.langCode,
                word: token.text.content,
                wordLang: detections.first.langCode,
                hasInfo: token.hasInfo,
                room: room,
              );

        final TextStyle tokenStyle = topTokenMatch != null
            ? topTokenMatch.textStyle(defaultStyle)
            : hasDefinitionStyle(defaultStyle);

        items.add(TextSpan(
          text: token.text.content,
          style: tokenStyle,
          recognizer: handleClick
              ? (TapGestureRecognizer()
                ..onTapDown = (details) => OverlayUtil.showPositionedCard(
                      context: context,
                      cardToShow: cardToShow,
                      cardSize: topTokenMatch?.isITStart ?? false
                          ? const Size(350, 220)
                          : const Size(350, 400),
                      transformTargetId: transformTargetId,
                    ))
              : null,
        ));

        final int charBetween = getAfterTokenSpacingByIndex(
          index,
        );

        if (charBetween > 0) {
          items.add(
            TextSpan(
              text: " " * charBetween,
              style: topTokenMatch != null &&
                      token.text.offset + token.text.length + charBetween <=
                          topTokenMatch.match.offset +
                              topTokenMatch.match.length
                  ? tokenStyle
                  : defaultStyle,
            ),
          );
        }
      },
    );

    return items;
  }
}
