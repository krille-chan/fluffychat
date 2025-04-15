import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/models/igc_text_data_model.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/paywall_card.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/span_card.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import '../../../common/utils/overlay.dart';
import '../../controllers/choreographer.dart';
import '../../enums/edit_type.dart';
import '../../models/span_card_model.dart';

class PangeaTextController extends TextEditingController {
  Choreographer choreographer;

  EditType editType = EditType.keyboard;
  PangeaTextController({
    String? text,
    required this.choreographer,
  }) {
    text ??= '';
    this.text = text;
  }

  static const int maxLength = 1000;
  bool get exceededMaxLength => text.length >= maxLength;

  bool forceKeepOpen = false;

  setSystemText(String text, EditType type) {
    editType = type;
    this.text = text;
  }

  void onInputTap(BuildContext context, {required FocusNode fNode}) {
    fNode.requestFocus();
    forceKeepOpen = true;
    if (!context.mounted) {
      debugger(when: kDebugMode);
      return;
    }

    // show the paywall if appropriate
    if (choreographer
                .pangeaController.subscriptionController.subscriptionStatus ==
            SubscriptionStatus.shouldShowPaywall &&
        !choreographer.isFetching &&
        text.isNotEmpty) {
      OverlayUtil.showPositionedCard(
        context: context,
        cardToShow: PaywallCard(
          chatController: choreographer.chatController,
        ),
        maxHeight: 325,
        maxWidth: 325,
        transformTargetId: choreographer.inputTransformTargetKey,
      );
    }

    // if there is no igc text data, then don't do anything
    if (choreographer.igc.igcTextData == null) return;

    // debugPrint(
    //     "onInputTap matches are ${choreographer.igc.igcTextData?.matches.map((e) => e.match.rule.id).toList().toString()}");

    // if user is just trying to get their cursor into the text input field to add soemthing,
    // then don't interrupt them
    if (selection.baseOffset >= text.length) {
      return;
    }

    int tokenIndex;
    try {
      tokenIndex = choreographer.igc.igcTextData!.tokenIndexByOffset(
        selection.baseOffset,
      );
    } catch (_) {
      return;
    }

    final int matchIndex =
        choreographer.igc.igcTextData!.getTopMatchIndexForOffset(
      selection.baseOffset,
    );

    // if autoplay on and it start then just start it
    if (matchIndex != -1 &&
        // choreographer.itAutoPlayEnabled &&
        choreographer.igc.igcTextData!.matches[matchIndex].isITStart) {
      return choreographer.onITStart(
        choreographer.igc.igcTextData!.matches[matchIndex],
      );
    }

    final Widget? cardToShow = matchIndex != -1
        ? SpanCard(
            scm: SpanCardModel(
              // igcTextData: choreographer.igc.igcTextData!,
              matchIndex: matchIndex,
              onReplacementSelect: choreographer.onReplacementSelect,
              // may not need this
              onSentenceRewrite: ((sentenceRewrite) async {
                debugPrint("onSentenceRewrite $tokenIndex $sentenceRewrite");
              }),
              onIgnore: () => choreographer.onIgnoreMatch(
                cursorOffset: selection.baseOffset,
              ),
              onITStart: () {
                choreographer.onITStart(
                  choreographer.igc.igcTextData!.matches[matchIndex],
                );
              },
              choreographer: choreographer,
            ),
            roomId: choreographer.roomId,
          )
        : null;

    if (cardToShow != null) {
      OverlayUtil.showPositionedCard(
        context: context,
        maxHeight: matchIndex != -1 &&
                choreographer.igc.igcTextData!.matches[matchIndex].isITStart
            ? 260
            : 400,
        maxWidth: 350,
        cardToShow: cardToShow,
        transformTargetId: choreographer.inputTransformTargetKey,
      );
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // If the composing range is out of range for the current text, ignore it to
    // preserve the tree integrity, otherwise in release mode a RangeError will
    // be thrown and this EditableText will be built with a broken subtree.
    // debugPrint("composing? $withComposing");
    // if (!value.isComposingRangeValid || !withComposing) {
    //   debugPrint("just returning straight text");
    //   // debugger(when: kDebugMode);
    //   return TextSpan(style: style, text: text);
    // }
    // if (value.isComposingRangeValid) {
    //   debugPrint("composing before ${value.composing.textBefore(value.text)}");
    //   debugPrint("composing inside ${value.composing.textInside(value.text)}");
    //   debugPrint("composing after ${value.composing.textAfter(value.text)}");
    // }

    final SubscriptionStatus canSendStatus = choreographer
        .pangeaController.subscriptionController.subscriptionStatus;
    if (canSendStatus == SubscriptionStatus.shouldShowPaywall &&
        !choreographer.isFetching &&
        text.isNotEmpty) {
      return TextSpan(
        text: text,
        style: style?.merge(
          IGCTextData.underlineStyle(
            const Color.fromARGB(187, 132, 96, 224),
          ),
        ),
      );
    } else if (choreographer.igc.igcTextData == null || text.isEmpty) {
      return TextSpan(text: text, style: style);
    } else {
      final parts = text.split(choreographer.igc.igcTextData!.originalInput);

      if (parts.length == 1 || parts.length > 2) {
        return TextSpan(text: text, style: style);
      }

      final choreoSteps = choreographer.choreoRecord.choreoSteps;

      return TextSpan(
        style: style,
        children: [
          ...choreographer.igc.igcTextData!.constructTokenSpan(
            choreoStep: choreoSteps.isNotEmpty ? choreoSteps.last : null,
            defaultStyle: style,
          ),
          TextSpan(text: parts[1], style: style),
        ],
      );
    }
  }
}
