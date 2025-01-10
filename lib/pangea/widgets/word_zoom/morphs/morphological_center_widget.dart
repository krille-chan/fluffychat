// stateful widget that displays morphological label and a shimmer effect while the text is loading
// takes a token and morphological feature as input

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/constants/morph_categories_and_labels.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/grammar/get_grammar_copy.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class MorphologicalCenterWidget extends StatefulWidget {
  final PangeaToken token;
  final String morphFeature;
  final PangeaMessageEvent pangeaMessageEvent;

  const MorphologicalCenterWidget({
    required this.token,
    required this.morphFeature,
    required this.pangeaMessageEvent,
    super.key,
  });

  @override
  MorphologicalCenterWidgetState createState() =>
      MorphologicalCenterWidgetState();
}

class MorphologicalCenterWidgetState extends State<MorphologicalCenterWidget> {
  bool editMode = false;

  /// the morphological tag that the user has selected in edit mode
  String selectedMorphTag = "";

  void resetMorphTag() => setState(
        () => selectedMorphTag = widget.token.morph[widget.morphFeature]!,
      );

  @override
  void didUpdateWidget(MorphologicalCenterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token ||
        widget.morphFeature != oldWidget.morphFeature) {
      resetMorphTag();
      setState(() => editMode = false);
    }
  }

  @override
  void initState() {
    super.initState();
    resetMorphTag();
  }

  void enterEditMode() {
    setState(() {
      editMode = true;
    });
  }

  PangeaMessageEvent get pm => widget.pangeaMessageEvent;

  Future<void> confirmChanges() async {
    try {
      // NOTE: it is not clear how this would work if the user was not editing the originalSent tokens
      // this case would only happen in immersion mode which is disabled until further notice
      // this flow assumes that the user is editing the originalSent tokens
      // if not, we'll get an error and we'll cross that bridge

      // make a copy of the original tokens
      final existingTokens = pm.originalSent!.tokens!
          .map((token) => PangeaToken.fromJson(token.toJson()))
          .toList();

      // change the morphological tag in the selected token
      final tokenIndex = existingTokens
          .indexWhere((token) => token.text.offset == widget.token.text.offset);
      if (tokenIndex == -1) {
        throw Exception("Token not found in message");
      }
      existingTokens[tokenIndex].morph[widget.morphFeature] = selectedMorphTag;

      // send a new message as an edit to original message to the server
      // including the new tokens
      await pm.room.pangeaSendTextEvent(
        pm.messageDisplayText,
        editEventId: pm.eventId,
        originalSent: pm.originalSent?.content,
        originalWritten: pm.originalWritten?.content,
        tokensSent: PangeaMessageTokens(tokens: existingTokens),
        tokensWritten: pm.originalWritten?.tokens != null
            ? PangeaMessageTokens(tokens: pm.originalWritten!.tokens!)
            : null,
        choreo: pm.originalSent?.choreo,
      );
    } catch (e) {
      SnackBar(
        content: Text(L10n.of(context).oopsSomethingWentWrong),
      );
      ErrorHandler.logError(
        e: e,
        data: {
          "selectedMorphTag": selectedMorphTag,
          "morphFeature": widget.morphFeature,
          "token": widget.token.toJson(),
          "pangeaMessageEvent": widget.pangeaMessageEvent.event.content,
        },
      );
    }
  }

  List<String> get allMorphTagsForEdit {
    final List<String> tags = getLabelsForMorphCategory(widget.morphFeature)
        .where((tag) => !["punct", "space", "sym", "x", "other"]
            .contains(tag.toLowerCase()))
        .toList();

    // as long as the feature is not POS, add a nan tag
    // this will allow the user to remove the feature from the tags
    if (widget.morphFeature.toLowerCase() != "pos") {
      tags.add(L10n.of(context).constructUseNanDesc);
    }

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    if (!editMode) {
      return GestureDetector(
        onLongPress: enterEditMode,
        onDoubleTap: enterEditMode,
        child: Text(
          getGrammarCopy(
                category: widget.morphFeature,
                lemma: widget.token.morph[widget.morphFeature],
                context: context,
              ) ??
              widget.token.morph[widget.morphFeature]!,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        Text(
          L10n.of(context).editMorphologicalLabel,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 170),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: allMorphTagsForEdit.map((tag) {
                  return Container(
                    margin: const EdgeInsets.all(2),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: selectedMorphTag == tag
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 7),
                        ),
                        backgroundColor: selectedMorphTag == tag
                            ? WidgetStateProperty.all<Color>(
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(50),
                              )
                            : null,
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() => selectedMorphTag = tag);
                      },
                      child: Text(
                        getGrammarCopy(
                              category: widget.morphFeature,
                              lemma: tag,
                              context: context,
                            ) ??
                            tag,
                        style: BotStyle.text(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            //cancel button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  editMode = false;
                });
              },
              child: Text(L10n.of(context).cancel),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed:
                  selectedMorphTag == widget.token.morph[widget.morphFeature]
                      ? null
                      : () => showFutureLoadingDialog(
                            context: context,
                            future: confirmChanges,
                          ),
              child: Text(L10n.of(context).saveChanges),
            ),
          ],
        ),
      ],
    );
  }
}
