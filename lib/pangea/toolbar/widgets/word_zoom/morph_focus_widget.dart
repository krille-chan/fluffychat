// stateful widget that displays morphological label and a shimmer effect while the text is loading
// takes a token and morphological feature as input

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_meaning_widget.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/lemmas/construct_xp_widget.dart';
import 'package:fluffychat/pangea/morphs/edit_morph_widget.dart';
import 'package:fluffychat/pangea/morphs/morph_feature_display.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_tag_display.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/morph_selection.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class MorphFocusWidget extends StatefulWidget {
  final MorphFeaturesEnum morphFeature;
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;

  const MorphFocusWidget({
    required this.morphFeature,
    required this.pangeaMessageEvent,
    required this.overlayController,
    super.key,
  });

  @override
  MorphFocusWidgetState createState() => MorphFocusWidgetState();
}

class MorphFocusWidgetState extends State<MorphFocusWidget> {
  PangeaToken get token => widget.overlayController.selectedToken!;

  bool _editMode = false;

  /// the morphological tag that the user has selected in edit mode
  String _selectedMorphTag = "";

  final ScrollController _scrollController = ScrollController();

  void _resetMorphTag() {
    setState(
      () => _selectedMorphTag = token.getMorphTag(widget.morphFeature) ?? "X",
    );
  }

  @override
  void initState() {
    super.initState();
    _resetMorphTag();
  }

  @override
  void didUpdateWidget(MorphFocusWidget oldWidget) {
    if (widget.morphFeature != oldWidget.morphFeature) {
      _resetMorphTag();
      setState(() => _editMode = false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    setState(() {
      _editMode = true;
    });
  }

  ConstructIdentifier get _id {
    return ConstructIdentifier(
      lemma: _selectedMorphTag,
      type: ConstructTypeEnum.morph,
      category: widget.morphFeature.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_editMode) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8.0,
        children: [
          MorphFeatureDisplay(
            morphFeature: widget.morphFeature,
          ),
          if (token.getMorphTag(widget.morphFeature) != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: L10n.of(context).doubleClickToEdit,
                  child: GestureDetector(
                    onLongPress: _enterEditMode,
                    onDoubleTap: _enterEditMode,
                    child: MorphTagDisplay(
                      morphFeature: widget.morphFeature,
                      morphTag: token.getMorphTag(widget.morphFeature) ??
                          L10n.of(context).nan,
                      textColor: Theme.of(context).brightness ==
                              Brightness.light
                          ? _id.constructUses.lemmaCategory.darkColor(context)
                          : _id.constructUses.lemmaCategory.color(context),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ConstructXpWidget(
                  id: _id,
                  onTap: () => showDialog<AnalyticsPopupWrapper>(
                    context: context,
                    builder: (context) => AnalyticsPopupWrapper(
                      constructZoom: _id,
                      view: ConstructTypeEnum.morph,
                    ),
                  ),
                ),
              ],
            ),
            MorphMeaningWidget(
              feature: widget.morphFeature,
              tag: token.getMorphTag(widget.morphFeature)!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ] else
            Text(L10n.of(context).nan),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: EditMorphWidget(
        token: token,
        pangeaMessageEvent: widget.pangeaMessageEvent,
        morphFeature: widget.morphFeature,
        onClose: () {
          setState(() => _editMode = false);
          widget.overlayController.onMorphActivitySelect(
            MorphSelection(
              token,
              widget.morphFeature,
            ),
          );
        },
      ),
    );
  }
}
