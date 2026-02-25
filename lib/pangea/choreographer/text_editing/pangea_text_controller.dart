import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/igc/autocorrect_span.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/replacement_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../choreographer.dart';
import 'edit_type_enum.dart';

class PangeaTextController extends TextEditingController {
  final Choreographer choreographer;
  EditTypeEnum editType = EditTypeEnum.keyboard;
  String _currentText = '';

  PangeaTextController({required this.choreographer}) {
    addListener(_onTextChanged);
  }

  bool get exceededMaxLength => text.length >= ChoreoConstants.maxLength;

  TextStyle _underlineStyle(Color color, bool isSelected) => TextStyle(
    decoration: isSelected ? null : TextDecoration.underline,
    decorationColor: isSelected ? null : color,
    decorationThickness: isSelected ? null : 5,
    backgroundColor: isSelected ? color : null,
  );

  Color _underlineColor(PangeaMatch match) {
    final status = match.status;
    final opacity = status.underlineOpacity;
    final alpha = (255 * opacity).ceil();
    // Automatic corrections use primary color
    if (status == PangeaMatchStatusEnum.automatic) {
      return AppConfig.primaryColor.withAlpha(alpha);
    }

    // Use type-based coloring
    return match.match.type.color.withAlpha(alpha);
  }

  void setSystemText(String newText, EditTypeEnum type) {
    editType = type;
    text = newText;
  }

  void _onTextChanged() {
    final diff = text.characters.length - _currentText.characters.length;
    if (diff > 1 && editType == EditTypeEnum.keyboard) {
      final pastedText = text.characters
          .skip(_currentText.characters.length)
          .take(diff)
          .join();
      choreographer.onPaste(pastedText);
    }
    _currentText = text;
  }

  void _onUndo(PangeaMatchState match) {
    try {
      choreographer.igcController.updateMatchStatus(
        match,
        PangeaMatchStatusEnum.undo,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        level: SentryLevel.warning,
        data: {"match": match.toJson()},
      );
      MatrixState.pAnyState.closeOverlay();
      choreographer.clearMatches(e);
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final subscription =
        MatrixState.pangeaController.subscriptionController.subscriptionStatus;

    if (subscription == SubscriptionStatus.shouldShowPaywall) {
      return _buildPaywallSpan(style);
    }

    if (choreographer.igcController.currentText == null) {
      return TextSpan(text: text, style: style);
    }

    final parts = text.split(choreographer.igcController.currentText!);
    if (parts.length != 2) {
      return TextSpan(text: text, style: style);
    }

    return TextSpan(
      style: style,
      children: [
        ..._buildTokenSpan(style),
        TextSpan(text: parts[1], style: style),
      ],
    );
  }

  TextSpan _buildPaywallSpan(TextStyle? style) => TextSpan(
    text: text,
    style: style?.merge(
      _underlineStyle(const Color.fromARGB(187, 132, 96, 224), false),
    ),
  );

  InlineSpan _buildMatchSpan(
    PangeaMatchState match,
    bool isSelected,
    TextStyle? existingStyle,
  ) {
    final span = choreographer.igcController.currentText!.characters
        .getRange(
          match.updatedMatch.match.offset,
          match.updatedMatch.match.offset + match.updatedMatch.match.length,
        )
        .toString();

    // If selected, do full highlight with match color.
    // If open, do underline with high opacity match color.
    // Otherwise (viewed / accepted), do underline with lower opacity match color.
    final matchColor = _underlineColor(match.updatedMatch);
    final underlineStyle = _underlineStyle(matchColor, isSelected);
    final textStyle = existingStyle != null
        ? existingStyle.merge(underlineStyle)
        : underlineStyle;

    final originalText = match.originalMatch.match.fullText.characters
        .getRange(
          match.originalMatch.match.offset,
          match.originalMatch.match.offset + match.originalMatch.match.length,
        )
        .toString();

    if (match.updatedMatch.status == PangeaMatchStatusEnum.automatic) {
      return AutocorrectSpan(
        transformTargetId:
            "autocorrection_${match.updatedMatch.match.offset}_${match.updatedMatch.match.length}",
        currentText: span,
        originalText: originalText,
        onUndo: () => _onUndo(match),
        style: textStyle,
      );
    } else {
      return TextSpan(text: span, style: textStyle);
    }
  }

  /// Returns a list of [TextSpan]s used to display the text in the input field
  /// with the appropriate styling for each error match.
  List<InlineSpan> _buildTokenSpan(TextStyle? defaultStyle) {
    final textSpanMatches = choreographer.igcController.matches.sorted(
      (a, b) =>
          a.updatedMatch.match.offset.compareTo(b.updatedMatch.match.offset),
    );

    final currentText = choreographer.igcController.currentText!;
    final spans = <InlineSpan>[];
    int cursor = 0;

    for (final match in textSpanMatches) {
      if (cursor < match.updatedMatch.match.offset) {
        final text = currentText.characters
            .getRange(cursor, match.updatedMatch.match.offset)
            .toString();
        spans.add(TextSpan(text: text, style: defaultStyle));
      }

      final openMatch =
          choreographer.igcController.activeMatch.value?.updatedMatch.match;
      final isSelected =
          openMatch?.offset == match.updatedMatch.match.offset &&
          openMatch?.length == match.updatedMatch.match.length;

      spans.add(_buildMatchSpan(match, isSelected, defaultStyle));
      cursor =
          match.updatedMatch.match.offset + match.updatedMatch.match.length;
    }

    if (cursor < currentText.characters.length) {
      spans.add(
        TextSpan(
          text: currentText.characters
              .getRange(cursor, currentText.characters.length)
              .toString(),
          style: defaultStyle,
        ),
      );
    }

    return spans;
  }
}
