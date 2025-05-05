import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_details_popup/analytics_details_popup.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/lemmas/construct_xp_widget.dart';
import 'package:fluffychat/pangea/morphs/edit_morph_widget.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/morphs/morph_meaning/morph_info_repo.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/morph_selection.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_zoom_activity_button.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MorphologicalListItem extends StatelessWidget {
  final MorphFeaturesEnum morphFeature;
  final PangeaToken token;
  final MessageOverlayController overlayController;
  // final VoidCallback editMorph;

  const MorphologicalListItem({
    required this.morphFeature,
    required this.token,
    required this.overlayController,
    // required this.editMorph,
    super.key,
  });

  bool get shouldDoActivity =>
      overlayController.hideWordCardContent &&
      overlayController.practiceSelection?.hasActiveActivityByToken(
            ActivityTypeEnum.morphId,
            token,
            morphFeature,
          ) ==
          true;

  bool get isSelected =>
      overlayController.toolbarMode == MessageMode.wordMorph &&
      overlayController.selectedMorph?.morph == morphFeature;

  String get morphTag => token.getMorphTag(morphFeature) ?? "X";

  ConstructIdentifier get cId =>
      token.morphIdByFeature(morphFeature) ??
      ConstructIdentifier(
        type: ConstructTypeEnum.morph,
        category: morphFeature.name,
        lemma: morphTag,
      );

  void _openDefintionPopup(BuildContext context) async {
    const width = 300.0;
    const height = 200.0;

    try {
      if (overlayController.pangeaMessageEvent == null) {
        return;
      }

      OverlayUtil.showPositionedCard(
        context: context,
        cardToShow: MorphMeaningPopup(
          token: token,
          pangeaMessageEvent: overlayController.pangeaMessageEvent!,
          cId: cId,
          width: width,
          height: height,
          refresh: () {
            overlayController.onMorphActivitySelect(
              MorphSelection(token, morphFeature),
            );
          },
        ),
        transformTargetId: cId.string,
        backDropToDismiss: true,
        borderColor: Theme.of(context).colorScheme.primary,
        closePrevOverlay: false,
        addBorder: false,
        maxHeight: height,
        maxWidth: width,
      );
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        data: cId.toJson(),
        e: e,
        s: s,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: MatrixState.pAnyState.layerLinkAndKey(cId.string).link,
      child: SizedBox(
        key: MatrixState.pAnyState.layerLinkAndKey(cId.string).key,
        width: 40,
        height: 40,
        child: WordZoomActivityButton(
          icon: shouldDoActivity
              ? const Icon(Symbols.toys_and_games)
              : MorphIcon(
                  morphFeature: morphFeature,
                  morphTag: token.getMorphTag(morphFeature),
                  size: const Size(24, 24),
                ),
          isSelected: isSelected,
          onPressed: () {
            overlayController
                .onMorphActivitySelect(MorphSelection(token, morphFeature));
            _openDefintionPopup(context);
          },
          tooltip: shouldDoActivity
              ? morphFeature.getDisplayCopy(context)
              : getGrammarCopy(
                  category: morphFeature.name,
                  lemma: morphTag,
                  context: context,
                ),
          opacity: isSelected ? 1 : 0.7,
        ),
      ),
    );
  }
}

class MorphMeaningPopup extends StatefulWidget {
  final PangeaToken token;
  final PangeaMessageEvent pangeaMessageEvent;
  final ConstructIdentifier cId;
  final double width;
  final double height;
  final VoidCallback refresh;

  const MorphMeaningPopup({
    super.key,
    required this.token,
    required this.pangeaMessageEvent,
    required this.cId,
    required this.width,
    required this.height,
    required this.refresh,
  });

  @override
  State<MorphMeaningPopup> createState() => MorphMeaningPopupState();
}

class MorphMeaningPopupState extends State<MorphMeaningPopup> {
  MorphFeaturesEnum get _morphFeature =>
      MorphFeaturesEnumExtension.fromString(widget.cId.category);

  String get _morphTag => widget.cId.lemma;
  String? _defintion;

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _fetchDefinition();
  }

  @override
  void didUpdateWidget(covariant MorphMeaningPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cId != widget.cId) {
      _fetchDefinition();
    }
  }

  Future<void> _fetchDefinition() async {
    try {
      final response = await MorphInfoRepo.get(
        feature: _morphFeature,
        tag: _morphTag,
      );

      if (mounted) {
        setState(
          () => _defintion = response ?? L10n.of(context).meaningNotFound,
        );
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        data: widget.cId.toJson(),
        e: e,
        s: s,
      );
    }
  }

  void _setEditMode(bool editing) {
    setState(() => _isEditMode = editing);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: _isEditMode
                ? EditMorphWidget(
                    token: widget.token,
                    pangeaMessageEvent: widget.pangeaMessageEvent,
                    morphFeature: _morphFeature,
                    onClose: () {
                      _setEditMode(false);
                      _fetchDefinition();
                      widget.refresh();
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 16.0,
                          children: [
                            SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: MorphIcon(
                                morphFeature: _morphFeature,
                                morphTag: _morphTag,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                textAlign: TextAlign.center,
                                getGrammarCopy(
                                      category: _morphFeature.name,
                                      lemma: _morphTag,
                                      context: context,
                                    ) ??
                                    _morphTag,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (MatrixState.pangeaController.getAnalytics
                                    .constructListModel
                                    .getConstructUses(widget.cId) !=
                                null)
                              ConstructXpWidget(
                                id: widget.cId,
                                onTap: () => showDialog<AnalyticsPopupWrapper>(
                                  context: context,
                                  builder: (context) => AnalyticsPopupWrapper(
                                    constructZoom: widget.cId,
                                    view: ConstructTypeEnum.morph,
                                    backButtonOverride: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _defintion != null
                              ? Text(
                                  _defintion!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              : const LinearProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
          ),
          if (!_isEditMode)
            Positioned(
              top: 12.0,
              right: 12.0,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: Icon(
                    Icons.edit_outlined,
                    size: 20.0,
                    color: Theme.of(context).disabledColor,
                  ),
                  onTap: () {
                    _setEditMode(true);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
