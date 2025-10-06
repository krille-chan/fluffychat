import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/lemmas/user_set_lemma_info.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_repo.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_request.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_response.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_repo.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_request.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_response.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_widget.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TokenInfoFeedbackDialog extends StatefulWidget {
  final TokenInfoFeedbackRequestData requestData;
  final String langCode;
  final PangeaMessageEvent event;
  final VoidCallback onUpdate;

  const TokenInfoFeedbackDialog({
    super.key,
    required this.requestData,
    required this.langCode,
    required this.event,
    required this.onUpdate,
  });

  @override
  State<TokenInfoFeedbackDialog> createState() =>
      _TokenInfoFeedbackDialogState();
}

class _TokenInfoFeedbackDialogState extends State<TokenInfoFeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<String> _submitFeedback() async {
    final request = TokenInfoFeedbackRequest(
      userFeedback: _feedbackController.text,
      data: widget.requestData,
    );

    final TokenInfoFeedbackResponse response =
        await TokenInfoFeedbackRepo.submitFeedback(request);

    final originalToken =
        widget.requestData.tokens[widget.requestData.selectedToken];
    final token = response.updatedToken ?? originalToken;

    // first, update lemma info if changed
    if (response.updatedLemmaInfo != null) {
      await _updateLemmaInfo(
        token,
        response.updatedLemmaInfo!,
      );
    }

    // second, update the phonetic info if changed
    if (response.updatedPhonetics != null) {
      await _updatePhoneticTranscription(
        response.updatedPhonetics!,
      );
    }

    final originalSent = widget.event.originalSent;

    // if no other changes, just return the message
    final hasTokenUpdate = response.updatedToken != null;
    final hasLangUpdate = originalSent != null &&
        response.updatedLanguage != null &&
        response.updatedLanguage != originalSent.langCode;

    if (!hasTokenUpdate && !hasLangUpdate) {
      widget.onUpdate();
      return response.userFriendlyMessage;
    }

    // update the tokens to be sent in the message edit
    final tokens = List<PangeaToken>.from(widget.requestData.tokens);
    if (hasTokenUpdate) {
      tokens[widget.requestData.selectedToken] = response.updatedToken!;
    }

    if (hasLangUpdate) {
      originalSent.content.langCode = response.updatedLanguage!;
    }

    await widget.event.room.pangeaSendTextEvent(
      widget.requestData.fullText,
      editEventId: widget.event.eventId,
      originalSent: originalSent?.content,
      originalWritten: widget.event.originalWritten?.content,
      tokensSent: PangeaMessageTokens(
        tokens: tokens,
      ),
      tokensWritten: widget.event.originalWritten?.tokens != null
          ? PangeaMessageTokens(
              tokens: widget.event.originalWritten!.tokens!,
              detections: widget.event.originalWritten?.detections,
            )
          : null,
      choreo: originalSent?.choreo,
    );

    widget.onUpdate();
    return response.userFriendlyMessage;
  }

  Future<void> _updateLemmaInfo(
    PangeaToken token,
    LemmaInfoResponse response,
  ) async {
    final construct = token.vocabConstructID;

    final currentLemmaInfo = construct.userLemmaInfo;
    final updatedLemmaInfo = UserSetLemmaInfo(
      meaning: response.meaning,
      emojis: response.emoji,
    );

    if (currentLemmaInfo != updatedLemmaInfo) {
      await construct.setUserLemmaInfo(updatedLemmaInfo);
    }
  }

  Future<void> _updatePhoneticTranscription(
    PhoneticTranscriptionResponse response,
  ) async {
    final req = PhoneticTranscriptionRequest(
      arc: LanguageArc(
        l1: PLanguageStore.byLangCode(widget.requestData.wordCardL1) ??
            MatrixState.pangeaController.languageController.userL1!,
        l2: PLanguageStore.byLangCode(widget.langCode) ??
            MatrixState.pangeaController.languageController.userL2!,
      ),
      content: response.content,
    );
    await PhoneticTranscriptionRepo.set(req, response);
  }

  @override
  Widget build(BuildContext context) {
    final selectedToken =
        widget.requestData.tokens[widget.requestData.selectedToken];
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SizedBox(
          width: 325.0,
          child: Column(
            spacing: 20.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        L10n.of(context).tokenInfoFeedbackDialogTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: Icon(Icons.flag_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  spacing: 20.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Placeholder for word card
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: WordZoomWidget(
                          token: selectedToken.text,
                          construct: selectedToken.vocabConstructID,
                          langCode: widget.langCode,
                        ),
                      ),
                    ),
                    // Description text
                    Text(
                      L10n.of(context).tokenInfoFeedbackDialogDesc,
                      textAlign: TextAlign.center,
                    ),
                    // Feedback text field
                    TextField(
                      controller: _feedbackController,
                      decoration: InputDecoration(
                        hintText: L10n.of(context).feedbackHint,
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                    ),
                    // Submit button
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _feedbackController,
                      builder: (context, value, _) {
                        final isNotEmpty = value.text.isNotEmpty;
                        return ElevatedButton(
                          onPressed: isNotEmpty
                              ? () async {
                                  final resp = await showFutureLoadingDialog(
                                    context: context,
                                    future: () => _submitFeedback(),
                                  );

                                  if (!resp.isError) {
                                    Navigator.of(context).pop(resp.result!);
                                  }
                                }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(L10n.of(context).feedbackButton),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
