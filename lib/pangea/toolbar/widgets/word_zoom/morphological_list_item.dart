import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/morph_selection.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';

class MorphologicalListItem extends StatelessWidget {
  final MorphFeaturesEnum morphFeature;
  final PangeaToken token;
  final MessageOverlayController overlayController;

  const MorphologicalListItem({
    required this.morphFeature,
    required this.token,
    required this.overlayController,
    super.key,
  });

  bool get shouldDoActivity =>
      overlayController.messageAnalyticsEntry?.hasActivity(
        ActivityTypeEnum.morphId,
        token,
        morphFeature,
      ) ==
      true;

  bool get isSelected =>
      overlayController.toolbarMode == MessageMode.wordMorph &&
      overlayController.selectedMorph?.morph == morphFeature;

  String get morphTag => token.getMorphTag(morphFeature.name) ?? "X";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: WordZoomActivityButton(
        icon: shouldDoActivity
            ? const Icon(Symbols.toys_and_games)
            : MorphIcon(
                morphFeature: morphFeature,
                morphTag: token.getMorphTag(morphFeature.name),
                size: const Size(24, 24),
              ),
        isSelected: isSelected,
        // onPressed: shouldDoActivity
        //     ? () => overlayController.updateToolbarMode(MessageMode.wordMorph)
        //     : () => (feature) => showDialog<AnalyticsPopupWrapper>(
        //           context: context,
        //           builder: (context) => AnalyticsPopupWrapper(
        //             constructZoom: token.morphIdByFeature(feature),
        //             view: ConstructTypeEnum.vocab,
        //           ),
        //         ),
        onPressed: () => overlayController
            .onMorphActivitySelect(MorphSelection(token, morphFeature)),
        tooltip: shouldDoActivity
            ? morphFeature.getDisplayCopy(context)
            : getGrammarCopy(
                category: morphFeature.name,
                lemma: morphTag,
                context: context,
              ),
        opacity: isSelected
            ? 1
            : shouldDoActivity
                ? 0.4
                : 1,
      ),
    );
  }
}
