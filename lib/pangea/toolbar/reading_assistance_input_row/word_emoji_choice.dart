import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_shimmer.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordEmojiChoice extends StatefulWidget {
  const WordEmojiChoice({
    super.key,
    required this.overlayController,
    required this.token,
  });

  final MessageOverlayController overlayController;
  final PangeaToken token;

  @override
  WordEmojiChoiceState createState() => WordEmojiChoiceState();
}

class WordEmojiChoiceState extends State<WordEmojiChoice> {
  String? localSelected;

  @override
  void initState() {
    super.initState();
    localSelected = widget.token.getEmoji();
  }

  Future<void> onChoice(BuildContext context, emoji) async {
    setState(() => localSelected = emoji);

    MatrixState.pangeaController.putAnalytics.setState(
      AnalyticsStream(
        eventId: widget.overlayController.pangeaMessageEvent!.eventId,
        roomId: widget.overlayController.pangeaMessageEvent!.room.id,
        constructs: [
          OneConstructUse(
            useType: ConstructUseTypeEnum.em,
            lemma: widget.token.text.content,
            constructType: ConstructTypeEnum.vocab,
            metadata: ConstructUseMetaData(
              roomId: widget.overlayController.pangeaMessageEvent!.room.id,
              timeStamp: DateTime.now(),
              eventId: widget.overlayController.pangeaMessageEvent!.eventId,
            ),
            category: widget.token.pos,
            form: widget.token.text.content,
          ),
        ],
        origin: AnalyticsUpdateOrigin.wordZoom,
      ),
    );

    await widget.token.setEmoji(emoji);

    await Future.delayed(
      const Duration(milliseconds: choiceArrayAnimationDuration),
    );

    widget.overlayController.onActivityFinish(ActivityTypeEnum.emoji);

    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            FutureBuilder(
              future: widget.token.getEmojiChoices(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(L10n.of(context).oopsSomethingWentWrong);
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return const ItShimmer(originalSpan: "😀", fontSize: 26);
                }

                return ChoicesArray(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  choices: snapshot.data!
                      .map(
                        (emoji) => Choice(
                          color: localSelected == emoji
                              ? AppConfig.primaryColor
                              : Colors.transparent,
                          text: emoji,
                          isGold: localSelected == emoji,
                        ),
                      )
                      .toList(),
                  onPressed: (emoji, index) => onChoice(context, emoji),
                  originalSpan: "😀",
                  uniqueKeyForLayerLink: (int index) => "emojiChoice$index",
                  selectedChoiceIndex: snapshot.data!.indexWhere(
                    (element) => element == widget.token.getEmoji(),
                  ),
                  tts: null,
                  fontSize: 26,
                  enableMultiSelect: true,
                  isActive: true,
                  overflowMode: OverflowMode.horizontalScroll,
                );
              },
            ),
            const InstructionsInlineTooltip(
              instructionsEnum: InstructionsEnum.chooseEmoji,
            ),
          ],
        ),
      ),
    );
  }
}
