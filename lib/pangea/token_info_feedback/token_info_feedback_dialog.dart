import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/feedback_dialog.dart';
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

class TokenInfoFeedbackDialog extends StatelessWidget {
  final TokenInfoFeedbackRequestData requestData;
  final String langCode;
  final PangeaMessageEvent event;

  const TokenInfoFeedbackDialog({
    super.key,
    required this.requestData,
    required this.langCode,
    required this.event,
  });

  Future<String> _submitFeedback(String feedback) async {
    final request = TokenInfoFeedbackRequest(
      userFeedback: feedback,
      data: requestData,
    );

    final TokenInfoFeedbackResponse response =
        await TokenInfoFeedbackRepo.submitFeedback(request);

    final originalToken = requestData.tokens[requestData.selectedToken];
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

    final originalSent = event.originalSent;

    // if no other changes, just return the message
    final hasTokenUpdate = response.updatedToken != null;
    final hasLangUpdate = originalSent != null &&
        response.updatedLanguage != null &&
        response.updatedLanguage != originalSent.langCode;

    if (!hasTokenUpdate && !hasLangUpdate) {
      return response.userFriendlyMessage;
    }

    // update the tokens to be sent in the message edit
    final tokens = List<PangeaToken>.from(requestData.tokens);
    if (hasTokenUpdate) {
      tokens[requestData.selectedToken] = response.updatedToken!;
    }

    if (hasLangUpdate) {
      originalSent.content.langCode = response.updatedLanguage!;
    }

    await event.room.pangeaSendTextEvent(
      requestData.fullText,
      editEventId: event.eventId,
      originalSent: originalSent?.content,
      originalWritten: event.originalWritten?.content,
      tokensSent: PangeaMessageTokens(
        tokens: tokens,
      ),
      tokensWritten: event.originalWritten?.tokens != null
          ? PangeaMessageTokens(
              tokens: event.originalWritten!.tokens!,
              detections: event.originalWritten?.detections,
            )
          : null,
      choreo: originalSent?.choreo,
    );

    return response.userFriendlyMessage;
  }

  Future<void> _submit(String feedback, BuildContext context) async {
    final resp = await showFutureLoadingDialog(
      context: context,
      future: () => _submitFeedback(feedback),
    );

    if (!resp.isError) {
      Navigator.of(context).pop(resp.result!);
    }
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
        l1: PLanguageStore.byLangCode(requestData.wordCardL1) ??
            MatrixState.pangeaController.languageController.userL1!,
        l2: PLanguageStore.byLangCode(langCode) ??
            MatrixState.pangeaController.languageController.userL2!,
      ),
      content: response.content,
    );
    await PhoneticTranscriptionRepo.set(req, response);
  }

  @override
  Widget build(BuildContext context) {
    final selectedToken = requestData.tokens[requestData.selectedToken];
    return FeedbackDialog(
      title: L10n.of(context).tokenInfoFeedbackDialogTitle,
      onSubmit: (feedback) => _submit(feedback, context),
      extraContent: WordZoomWidget(
        token: selectedToken.text,
        construct: selectedToken.vocabConstructID,
        langCode: langCode,
      ),
    );
  }
}
