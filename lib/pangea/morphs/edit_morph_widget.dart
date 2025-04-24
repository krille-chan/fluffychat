import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/morphs/default_morph_mapping.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class EditMorphWidget extends StatefulWidget {
  final PangeaToken token;
  final PangeaMessageEvent pangeaMessageEvent;
  final MorphFeaturesEnum morphFeature;
  final VoidCallback onClose;

  const EditMorphWidget({
    required this.token,
    required this.pangeaMessageEvent,
    required this.morphFeature,
    required this.onClose,
    super.key,
  });

  @override
  State<EditMorphWidget> createState() => EditMorphWidgetState();
}

class EditMorphWidgetState extends State<EditMorphWidget> {
  List<String>? _availableMorphTags;
  String? _selectedMorphTag;

  @override
  void initState() {
    super.initState();
    _setAvailableMorphs(widget.morphFeature);
    _selectedMorphTag = _assignedMorphTag;
  }

  @override
  void didUpdateWidget(covariant EditMorphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.morphFeature != widget.morphFeature) {
      _setAvailableMorphs(widget.morphFeature);
    }
  }

  String? get _assignedMorphTag => widget.token.morph[widget.morphFeature];

  Future<void> _setAvailableMorphs(MorphFeaturesEnum feature) async {
    try {
      setState(() => _availableMorphTags = null);
      final resp = await MorphsRepo.get();
      _availableMorphTags = resp.getDisplayTags(
        feature.name,
      );
    } catch (e) {
      _availableMorphTags = defaultMorphMapping.getDisplayTags(
        feature.name,
      );
    } finally {
      if (mounted) setState(() {});
    }
  }

  void _saveChanges() {
    if (_selectedMorphTag == null) return;
    showFutureLoadingDialog(
      context: context,
      future: () => _sendEditedMessage(
        (token) {
          token.morph[widget.morphFeature] = _selectedMorphTag!;
          if (widget.morphFeature.name.toLowerCase() == 'pos') {
            token.pos = _selectedMorphTag!;
          }
          return token;
        },
      ),
    );
  }

  Future<void> _sendEditedMessage(
    PangeaToken Function(PangeaToken token) changeCallback,
  ) async {
    try {
      final pm = widget.pangeaMessageEvent;
      final existingTokens = pm.originalSent!.tokens!
          .map((token) => PangeaToken.fromJson(token.toJson()))
          .toList();

      final tokenIndex = existingTokens.indexWhere(
        (token) => token.text.offset == widget.token.text.offset,
      );
      if (tokenIndex == -1) {
        throw Exception("Token not found in message");
      }
      existingTokens[tokenIndex] = changeCallback(existingTokens[tokenIndex]);

      await pm.room.pangeaSendTextEvent(
        pm.messageDisplayText,
        editEventId: pm.eventId,
        originalSent: pm.originalSent?.content,
        originalWritten: pm.originalWritten?.content,
        tokensSent: PangeaMessageTokens(
          tokens: existingTokens,
          detections: pm.originalSent?.detections,
        ),
        tokensWritten: pm.originalWritten?.tokens != null
            ? PangeaMessageTokens(
                tokens: pm.originalWritten!.tokens!,
                detections: pm.originalWritten?.detections,
              )
            : null,
        choreo: pm.originalSent?.choreo,
        messageTag: ModelKey.messageTagMorphEdit,
      );

      widget.onClose();
    } catch (e) {
      ErrorHandler.logError(
        e: e,
        data: {
          "selectedMorphTag": _selectedMorphTag,
          "morphFeature": widget.morphFeature.name,
          "pangeaMessageEvent": widget.pangeaMessageEvent.event.content,
        },
      );
    }
  }

  bool get _canSaveChanges =>
      _selectedMorphTag != _assignedMorphTag && _selectedMorphTag != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.0,
      children: [
        Text(
          "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).chooseCorrectLabel}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        if (_availableMorphTags == null || _availableMorphTags!.isEmpty)
          const CircularProgressIndicator()
        else
          Wrap(
            alignment: WrapAlignment.center,
            children: _availableMorphTags!.map((tag) {
              return Container(
                margin: const EdgeInsets.all(2),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    color: _selectedMorphTag == tag
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    style: BorderStyle.solid,
                    width: 2.0,
                  ),
                ),
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 7,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      _selectedMorphTag == tag
                          ? Theme.of(context).colorScheme.primary.withAlpha(50)
                          : Colors.transparent,
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () => setState(() => _selectedMorphTag = tag),
                  child: Text(
                    getGrammarCopy(
                          category: widget.morphFeature.name,
                          lemma: tag,
                          context: context,
                        ) ??
                        tag,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              onPressed: widget.onClose,
              child: Text(L10n.of(context).cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              onPressed: _canSaveChanges ? _saveChanges : null,
              child: Text(L10n.of(context).saveChanges),
            ),
          ],
        ),
      ],
    );
  }
}
