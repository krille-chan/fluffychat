import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/choice_array.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_morph_choice_item.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/morph_focus_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';

// this widget will handle the content of the input bar when mode == MessageMode.wordMorph

// if initializing, with a selectedToken then we should show an activity if one is available
// in this case, we'll set selectedMorph to the first morph available for the selected token

// if initializing with a selectedMorph then we should show the first activity available for that morph
// if no activity available for that morph, then we should just show the details of the feature and tag

// the details of a morph will allow the user to edit the morphological tag of that feature.

const int numberOfMorphDistractors = 3;

class MessageMorphInputBarContent extends StatefulWidget {
  final MessageOverlayController overlayController;
  final PangeaMessageEvent pangeaMessageEvent;

  const MessageMorphInputBarContent({
    super.key,
    required this.overlayController,
    required this.pangeaMessageEvent,
  });

  @override
  MessageMorphInputBarContentState createState() =>
      MessageMorphInputBarContentState();
}

class MessageMorphInputBarContentState
    extends State<MessageMorphInputBarContent> {
  // bool initialized = false;

  String? selectedTag;

  // @override
  // void initState() {
  //   super.initState();
  // }

  MessageOverlayController get overlay => widget.overlayController;
  PangeaToken? get token => overlay.selectedMorph?.token;
  MorphFeaturesEnum? get morph => overlay.selectedMorph?.morph;

  // void init() async {
  //   initialized = false;
  //   setState(() {});

  //   if (token != null && morph != null) {
  //     morphChoices = MorphsRepo.cached.getDisplayTags(morph);
  //   }
  //   initialized = true;
  //   setState(() {});
  // }

  @override
  void didUpdateWidget(covariant MessageMorphInputBarContent oldWidget) {
    if (morph != oldWidget.overlayController.selectedMorph?.morph ||
        token != oldWidget.overlayController.selectedToken) {
      selectedTag = null;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  List<String>? get choices {
    if (morph == null ||
        token == null ||
        overlay.messageAnalyticsEntry
                ?.hasActivity(ActivityTypeEnum.morphId, token!, morph) ==
            false) {
      return null;
    }

    final tag = token!.getMorphTag(morph!.name)!;

    return MorphsRepo.cached
            .getDisplayTags(morph!.name)
            .where((other) => other.toLowerCase() != tag.toLowerCase())
            .toList()
            .take(numberOfMorphDistractors)
            .toList() +
        [tag];
  }

  bool isCorrect(String tag) => token?.getMorphTag(morph!.name) == tag;

  Future<void> onActivityChoice(
    String choice,
  ) async {
    if (token == null || morph == null) {
      ErrorHandler.logError(
        m: "Token or morph is null in onTokenSelectionWithSelectedMorphs",
        data: overlay.selectedToken?.toJson() ?? {},
      );
      debugger(when: kDebugMode);
      return;
    }

    selectedTag = choice;

    MatrixState.pangeaController.putAnalytics.setState(
      AnalyticsStream(
        eventId: overlay.pangeaMessageEvent!.eventId,
        roomId: overlay.pangeaMessageEvent!.room.id,
        constructs: [
          OneConstructUse(
            useType: isCorrect(choice)
                ? ConstructUseTypeEnum.corM
                : ConstructUseTypeEnum.incM,
            lemma: choice,
            constructType: ConstructTypeEnum.morph,
            metadata: ConstructUseMetaData(
              roomId: overlay.pangeaMessageEvent!.room.id,
              timeStamp: DateTime.now(),
              eventId: overlay.pangeaMessageEvent!.eventId,
            ),
            category: morph!.name,
            form: token!.text.content,
          ),
        ],
        targetID: token!.text.uniqueKey,
      ),
    );

    setState(() => {});

    await Future.delayed(
      const Duration(milliseconds: choiceArrayAnimationDuration),
    );

    // this removes just one of the options
    // important because sometimes meanings are the same for different words
    if (isCorrect(choice)) {
      overlay.messageAnalyticsEntry
          ?.onActivityComplete(ActivityTypeEnum.morphId, token);
    }

    // kind of an odd way to do this, but should work
    overlay.setState(() {});
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (choices != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        spacing: 16.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              MorphIcon(
                morphFeature: morph!,
                morphTag: null,
                size: const Size(30, 30),
                showTooltip: false,
              ),
              Flexible(
                child: Text(
                  L10n.of(context).whatIsTheMorphTag(
                    morph!.getDisplayCopy(context),
                    token!.text.content,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 8.0, // Adjust spacing between items
            runSpacing: 8.0, // Adjust spacing between rows
            children: choices!
                .mapIndexed(
                  (index, choice) => MessageMorphChoiceItem(
                    cId: ConstructIdentifier(
                      lemma: choice,
                      type: ConstructTypeEnum.morph,
                      category: morph!.name,
                    ),
                    onTap: () => onActivityChoice(choice),
                    isSelected: selectedTag == choice,
                    isGold: selectedTag != null ? isCorrect(choice) : null,
                  ),
                )
                .toList(),
          ),
        ],
      );
    }

    if (token != null && morph != null) {
      return MorphFocusWidget(
        token: token!,
        morphFeature: morph!.name,
        pangeaMessageEvent: widget.pangeaMessageEvent,
        overlayController: overlay,
        onEditDone: () => overlay.setState(() {}),
      );
    }

    return Center(
      child: Text(
        L10n.of(context).selectForGrammar,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
