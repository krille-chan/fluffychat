// stateful widget that displays morphological label and a shimmer effect while the text is loading
// takes a token and morphological feature as input

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
import 'package:fluffychat/pangea/morphs/morph_categories_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class MorphologicalCenterWidget extends StatefulWidget {
  final PangeaToken token;
  final String morphFeature;
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageOverlayController overlayController;

  final VoidCallback onEditDone;

  const MorphologicalCenterWidget({
    required this.token,
    required this.morphFeature,
    required this.pangeaMessageEvent,
    required this.overlayController,
    required this.onEditDone,
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void enterEditMode() {
    setState(() {
      editMode = true;
    });
  }

  PangeaMessageEvent get pm => widget.pangeaMessageEvent;

  /// confirm the changes made by the user
  /// this will send a new message to the server
  /// with the new morphological tag
  Future<void> saveChanges(
    PangeaToken Function(PangeaToken token) changeCallback,
  ) async {
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
      existingTokens[tokenIndex] = changeCallback(existingTokens[tokenIndex]);

      // send a new message as an edit to original message to the server
      // including the new tokens
      // marking the message as a morphological edit will allow use to filter
      // from some processing and potentially find the data for LLM fine-tuning
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
        messageTag: ModelKey.messageTagMorphEdit,
      );

      setState(() => editMode = false);
      widget.onEditDone();
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

  String get morphCopy =>
      getMorphologicalCategoryCopy(widget.morphFeature, context) ??
      widget.morphFeature;

  String get tagCopy =>
      getGrammarCopy(
        category: widget.morphFeature,
        lemma: selectedMorphTag,
        context: context,
      ) ??
      selectedMorphTag;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (!editMode) {
      return Flexible(
        child: Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: L10n.of(context).doubleClickToEdit,
          child: GestureDetector(
            onLongPress: enterEditMode,
            onDoubleTap: enterEditMode,
            child: Text(
              "$morphCopy: $tagCopy",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Text(
            "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).chooseCorrectLabel}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder(
                    future: MorphsRepo.get(),
                    builder: (context, snapshot) {
                      final allMorphTagsForEdit =
                          snapshot.data?.getDisplayTags(widget.morphFeature) ??
                              defaultMorphMapping
                                  .getDisplayTags(widget.morphFeature);

                      return snapshot.connectionState == ConnectionState.done
                          ? Wrap(
                              alignment: WrapAlignment.center,
                              children: allMorphTagsForEdit.map((tag) {
                                return Container(
                                  margin: const EdgeInsets.all(2),
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      color: selectedMorphTag == tag
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              // this would allow the user to totally remove the morphological feature from the token
              // disabled and let's see if someone asks for it
              // if (widget.morphFeature.toLowerCase() != "pos")
              //   TextButton(
              //     onPressed: () => saveChanges(
              //       (token) {
              //         token.morph.remove(widget.morphFeature);
              //         return token;
              //       },
              //     ),
              //     child: Text(L10n.of(context).removeFeature(morphCopy)),
              //   ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                onPressed: () {
                  setState(() {
                    editMode = false;
                  });
                },
                child: Text(L10n.of(context).cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                onPressed: selectedMorphTag ==
                        widget.token.morph[widget.morphFeature]
                    ? null
                    : () => showFutureLoadingDialog(
                          context: context,
                          future: () => saveChanges(
                            (token) {
                              token.morph[widget.morphFeature] =
                                  selectedMorphTag;
                              if (widget.morphFeature.toLowerCase() == 'pos') {
                                token.pos = selectedMorphTag;
                              }
                              return token;
                            },
                          ),
                        ),
                child: Text(L10n.of(context).saveChanges),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
