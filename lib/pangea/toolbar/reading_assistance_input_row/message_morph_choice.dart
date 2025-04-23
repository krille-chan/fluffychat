import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_details_popup/morph_meaning_widget.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_animation.dart';
import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_morph_choice_item.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

// this widget will handle the content of the input bar when mode == MessageMode.wordMorph

// if initializing, with a selectedToken then we should show an activity if one is available
// in this case, we'll set selectedMorph to the first morph available for the selected token

// if initializing with a selectedMorph then we should show the first activity available for that morph
// if no activity available for that morph, then we should just show the details of the feature and tag

// the details of a morph will allow the user to edit the morphological tag of that feature.

const int numberOfMorphDistractors = 3;

class MessageMorphInputBarContent extends StatefulWidget {
  final MessageOverlayController overlayController;
  final PracticeActivityModel activity;
  final PangeaMessageEvent pangeaMessageEvent;

  const MessageMorphInputBarContent({
    super.key,
    required this.overlayController,
    required this.pangeaMessageEvent,
    required this.activity,
  });

  @override
  MessageMorphInputBarContentState createState() =>
      MessageMorphInputBarContentState();
}

class MessageMorphInputBarContentState
    extends State<MessageMorphInputBarContent> {
  String? selectedTag;

  MessageOverlayController get overlay => widget.overlayController;
  PangeaToken get token => widget.activity.targetTokens.first;
  MorphFeaturesEnum get morph => widget.activity.morphFeature!;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MessageMorphInputBarContent oldWidget) {
    if (morph != oldWidget.overlayController.selectedMorph?.morph ||
        token != oldWidget.overlayController.selectedToken) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  TextStyle? textStyle(BuildContext context) => overlay.maxWidth > 600
      ? Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          )
      : Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          );

  @override
  Widget build(BuildContext context) {
    final iconSize = overlay.maxWidth > 600
        ? 28.0
        : overlay.maxWidth > 600
            ? 24.0
            : 16.0;
    final spacing = overlay.maxWidth > 600
        ? 16.0
        : overlay.maxWidth > 600
            ? 8.0
            : 4.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      spacing: spacing,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacing,
          children: [
            MorphIcon(
              morphFeature: morph,
              morphTag: null,
              size: Size(iconSize, iconSize),
              showTooltip: false,
            ),
            Flexible(
              child: Text(
                L10n.of(context).whatIsTheMorphTag(
                  morph.getDisplayCopy(context),
                  token.text.content,
                ),
                style: textStyle(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: spacing,
          children: widget.activity.multipleChoiceContent!.choices.mapIndexed(
            (index, choice) {
              final wasCorrect =
                  widget.activity.practiceTarget.wasCorrectChoice(choice);

              return ChoiceAnimationWidget(
                isSelected: selectedTag == choice,
                isCorrect: wasCorrect,
                child: MessageMorphChoiceItem(
                  cId: ConstructIdentifier(
                    lemma: choice,
                    type: ConstructTypeEnum.morph,
                    category: morph.name,
                  ),
                  onTap: () {
                    setState(() => selectedTag = choice);

                    widget.activity.onMultipleChoiceSelect(
                      token,
                      PracticeChoice(
                        choiceContent: choice,
                        form: ConstructForm(
                          cId: widget.activity.targetTokens.first
                              .morphIdByFeature(
                            widget.activity.morphFeature!,
                          )!,
                          form: token.text.content,
                        ),
                      ),
                      widget.pangeaMessageEvent,
                      () => overlay.setState(() {}),
                    );
                  },
                  isSelected: selectedTag == choice,
                  isGold: wasCorrect,
                ),
              );
            },
          ).toList(),
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: overlay.maxWidth > 600 ? 20 : 34,
          ),
          alignment: Alignment.center,
          child: selectedTag != null
              ? MorphMeaningWidget(
                  feature: morph,
                  tag: selectedTag!,
                  style: overlay.maxWidth > 600
                      ? Theme.of(context).textTheme.bodyLarge
                      : Theme.of(context).textTheme.bodySmall,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
