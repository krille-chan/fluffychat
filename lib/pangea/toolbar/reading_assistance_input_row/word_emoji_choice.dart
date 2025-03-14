import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_shimmer.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordEmojiChoice extends StatefulWidget {
  const WordEmojiChoice({
    super.key,
    required this.constructID,
    required this.onEmojiChosen,
    required this.form,
    this.roomId,
    this.eventId,
  });

  final ConstructIdentifier constructID;
  final String form;
  final String? roomId;
  final String? eventId;
  final void Function() onEmojiChosen;

  @override
  WordEmojiChoiceState createState() => WordEmojiChoiceState();
}

class WordEmojiChoiceState extends State<WordEmojiChoice> {
  String? localSelected;

  @override
  void initState() {
    super.initState();
    localSelected = widget.constructID.userSetEmoji;
  }

  Future<void> onChoice(BuildContext context, emoji) async {
    setState(() => localSelected = emoji);

    MatrixState.pangeaController.putAnalytics.setState(
      AnalyticsStream(
        eventId: widget.eventId,
        roomId: widget.roomId,
        constructs: [
          OneConstructUse(
            useType: ConstructUseTypeEnum.em,
            lemma: widget.constructID.lemma,
            constructType: ConstructTypeEnum.vocab,
            metadata: ConstructUseMetaData(
              roomId: widget.roomId,
              timeStamp: DateTime.now(),
              eventId: widget.eventId,
            ),
            category: widget.constructID.category,
            form: widget.form,
          ),
        ],
        origin: AnalyticsUpdateOrigin.wordZoom,
      ),
    );

    await widget.constructID.setEmoji(emoji);

    await Future.delayed(
      const Duration(milliseconds: choiceArrayAnimationDuration),
    );

    widget.onEmojiChosen();

    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          FutureBuilder(
            future: widget.constructID.getEmojiChoices(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(L10n.of(context).oopsSomethingWentWrong);
              }

              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null) {
                return const ItShimmer(originalSpan: "😀", fontSize: 26);
              }

              return ChoicesArray(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                choices: snapshot.data!
                    .map(
                      (emoji) => Choice(
                        color: localSelected == emoji
                            ? Theme.of(context).colorScheme.primary
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
                  (element) => element == widget.constructID.userSetEmoji,
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
    );
  }
}
