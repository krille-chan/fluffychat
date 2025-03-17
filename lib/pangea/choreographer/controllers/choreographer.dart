import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/choreographer/controllers/alternative_translator.dart';
import 'package:fluffychat/pangea/choreographer/controllers/igc_controller.dart';
import 'package:fluffychat/pangea/choreographer/enums/assistance_state_enum.dart';
import 'package:fluffychat/pangea/choreographer/enums/edit_type.dart';
import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/models/it_step.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/utils/input_paste_listener.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/pangea_text_controller.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/paywall_card.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import '../../../widgets/matrix.dart';
import 'error_service.dart';
import 'it_controller.dart';

enum ChoreoMode { igc, it }

class Choreographer {
  PangeaController pangeaController;
  ChatController chatController;
  late PangeaTextController _textController;
  late ITController itController;
  late IgcController igc;
  late AlternativeTranslator altTranslator;
  late ErrorService errorService;
  late TtsController tts;

  bool isFetching = false;
  int _timesClicked = 0;

  final int msBeforeIGCStart = 10000;

  Timer? debounceTimer;
  ChoreoRecord choreoRecord = ChoreoRecord.newRecord;
  // last checked by IGC or translation
  String? _lastChecked;
  ChoreoMode choreoMode = ChoreoMode.igc;

  final StreamController stateStream = StreamController.broadcast();
  StreamSubscription? _trialStream;
  StreamSubscription? _languageStream;

  Choreographer(this.pangeaController, this.chatController) {
    _initialize();
  }
  _initialize() {
    tts = TtsController(chatController: chatController);
    _textController = PangeaTextController(choreographer: this);
    InputPasteListener(
      _textController,
      // TODO, do something on paste
      () => debugPrint("on paste"),
    );
    itController = ITController(this);
    igc = IgcController(this);
    errorService = ErrorService(this);
    altTranslator = AlternativeTranslator(this);
    _textController.addListener(_onChangeListener);
    _trialStream = pangeaController
        .subscriptionController.trialActivationStream.stream
        .listen((_) => _onChangeListener);
    _languageStream =
        pangeaController.userController.stateStream.listen((update) {
      if (update is Map<String, dynamic> &&
          update['prev_target_lang'] is LanguageModel) {
        clear();
      }

      // refresh on any profile update, to account
      // for changes like enabling autocorrect
      setState();
    });
    clear();
  }

  void send(BuildContext context) {
    debugPrint("can send message: $canSendMessage");

    // if isFetching, already called to getLanguageHelp and hasn't completed yet
    // could happen if user clicked send button multiple times in a row
    if (isFetching) return;

    if (igc.igcTextData != null && igc.igcTextData!.matches.isNotEmpty) {
      igc.showFirstMatch(context);
      return;
    } else if (isRunningIT) {
      // If the user is in the middle of IT, don't send the message.
      // If they've already clicked the send button once, this will
      // not be true, so they can still send it if they want.
      return;
    }

    final isSubscribed = pangeaController.subscriptionController.isSubscribed;
    if (isSubscribed != null && !isSubscribed) {
      // don't want to run IGC if user isn't subscribed, so either
      // show the paywall if applicable or just send the message
      final status = pangeaController.subscriptionController.subscriptionStatus;
      status == SubscriptionStatus.shouldShowPaywall
          ? OverlayUtil.showPositionedCard(
              context: context,
              cardToShow: PaywallCard(
                chatController: chatController,
              ),
              maxHeight: 325,
              maxWidth: 325,
              transformTargetId: inputTransformTargetKey,
            )
          : chatController.send();
      return;
    }

    if (!igc.hasRelevantIGCTextData && !itController.dismissed) {
      getLanguageHelp().then((value) => _sendWithIGC(context));
    } else {
      _sendWithIGC(context);
    }
  }

  Future<void> _sendWithIGC(BuildContext context) async {
    if (!canSendMessage) {
      // It's possible that the reason user can't send message is because they're in the middle of IT. If this is the case,
      // do nothing (there's no matches to show). The user can click the send button again to override this.
      if (!isRunningIT) {
        igc.showFirstMatch(context);
      }
      return;
    }

    final PangeaRepresentation? originalWritten =
        choreoRecord.includedIT && itController.sourceText != null
            ? PangeaRepresentation(
                langCode: l1LangCode ?? LanguageKeys.unknownLanguage,
                text: itController.sourceText!,
                originalWritten: true,
                originalSent: false,
              )
            : null;

    // we've got a rather elaborate method of updating tokens after matches are accepted
    // so we need to check if the reconstructed text matches the current text
    // if not, let's get the tokens again and log an error
    if (igc.igcTextData?.tokens != null &&
        PangeaToken.reconstructText(igc.igcTextData!.tokens).trim() !=
            currentText.trim()) {
      if (kDebugMode) {
        PangeaToken.reconstructText(
          igc.igcTextData!.tokens,
          debugWalkThrough: true,
        );
      }
      ErrorHandler.logError(
        m: "reconstructed text not working",
        s: StackTrace.current,
        data: {
          "igcTextData": igc.igcTextData?.toJson(),
          "choreoRecord": choreoRecord.toJson(),
        },
      );

      await igc.getIGCTextData(onlyTokensAndLanguageDetection: true);
    }

    // TODO - why does both it and igc need to be enabled for choreo to be applicable?
    // final ChoreoRecord? applicableChoreo =
    //     isITandIGCEnabled && igc.igcTextData != null ? choreoRecord : null;

    // if tokens OR language detection are not available, we should get them
    // notes
    // 1) we probably need to move this to after we clear the input field
    // or the user could experience some lag here.
    // 2)  that this call is being made after we've determined if we have an applicable choreo in order to
    // say whether correction was run on the message. we may eventually want
    // to edit the useType after
    if ((l2Lang != null && l1Lang != null) &&
        (igc.igcTextData?.tokens == null ||
            igc.igcTextData?.detectedLanguage == null)) {
      await igc.getIGCTextData(onlyTokensAndLanguageDetection: true);
    }

    final PangeaRepresentation originalSent = PangeaRepresentation(
      langCode:
          igc.igcTextData?.detectedLanguage ?? LanguageKeys.unknownLanguage,
      text: currentText,
      originalSent: true,
      originalWritten: originalWritten == null,
    );

    final PangeaMessageTokens? tokensSent = igc.igcTextData?.tokens != null
        ? PangeaMessageTokens(
            tokens: igc.igcTextData!.tokens,
            detections: igc.igcTextData!.detections.detections,
          )
        : null;

    chatController.send(
      // originalWritten: originalWritten,
      originalSent: originalSent,
      tokensSent: tokensSent,
      //TODO - save originalwritten tokens
      // choreo: applicableChoreo,
      choreo: choreoRecord,
    );

    clear();
  }

  _resetDebounceTimer() {
    if (debounceTimer != null) {
      debounceTimer?.cancel();
      debounceTimer = null;
    }
  }

  void onITStart(PangeaMatch itMatch) {
    if (!itMatch.isITStart) {
      throw Exception("this isn't an itStart match!");
    }
    choreoMode = ChoreoMode.it;
    itController.initializeIT(
      ITStartData(_textController.text, igc.igcTextData?.detectedLanguage),
    );
    itMatch.status = PangeaMatchStatus.accepted;

    choreoRecord.addRecord(_textController.text, match: itMatch);

    //PTODO - if totally in L1, save tokens, that's good stuff

    igc.clear();

    _textController.setSystemText("", EditType.itStart);
  }

  /// Handles any changes to the text input
  _onChangeListener() {
    if (_noChange) {
      return;
    }

    if (_textController.editType == EditType.igc ||
        _textController.editType == EditType.itDismissed) {
      _lastChecked = _textController.text;
      _textController.editType = EditType.keyboard;
      return;
    }

    // not sure if this is necessary now
    MatrixState.pAnyState.closeOverlay();

    if (errorService.isError) {
      return;
    }

    igc.clear();

    _resetDebounceTimer();

    if (editTypeIsKeyboard) {
      debounceTimer ??= Timer(
        Duration(milliseconds: msBeforeIGCStart),
        () => getLanguageHelp(),
      );
    } else {
      getLanguageHelp(
        onlyTokensAndLanguageDetection: ChoreoMode.it == choreoMode,
      );
    }

    //Note: we don't set the keyboard type on each keyboard stroke so this is how we default to
    //a change being from the keyboard unless explicitly set to one of the other
    //types when that action happens (e.g. an it/igc choice is selected)
    textController.editType = EditType.keyboard;
  }

  /// Fetches the language help for the current text, including grammar correction, language detection,
  /// tokens, and translations. Includes logic to exit the flow if the user is not subscribed, if the tools are not enabled, or
  /// or if autoIGC is not enabled and the user has not manually requested it.
  /// [onlyTokensAndLanguageDetection] will
  Future<void> getLanguageHelp({
    bool onlyTokensAndLanguageDetection = false,
    bool manual = false,
  }) async {
    try {
      if (errorService.isError) return;
      final SubscriptionStatus canSendStatus =
          pangeaController.subscriptionController.subscriptionStatus;

      if (canSendStatus != SubscriptionStatus.subscribed ||
          l2Lang == null ||
          l1Lang == null ||
          (!igcEnabled && !itEnabled) ||
          (!isAutoIGCEnabled && !manual && choreoMode != ChoreoMode.it)) {
        return;
      }

      startLoading();

      // if getting language assistance after finishing IT,
      // reset the itController
      if (choreoMode == ChoreoMode.it &&
          itController.isTranslationDone &&
          !onlyTokensAndLanguageDetection) {
        itController.clear();
      }

      await (isRunningIT
          ? itController.getTranslationData(_useCustomInput)
          : igc.getIGCTextData(
              onlyTokensAndLanguageDetection: onlyTokensAndLanguageDetection,
            ));
    } catch (err, stack) {
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "l2Lang": l2Lang?.toJson(),
          "l1Lang": l1Lang?.toJson(),
          "choreoMode": choreoMode,
          "igcEnabled": igcEnabled,
          "itEnabled": itEnabled,
          "isAutoIGCEnabled": isAutoIGCEnabled,
          "isTranslationDone": itController.isTranslationDone,
          "onlyTokensAndLanguageDetection": onlyTokensAndLanguageDetection,
          "useCustomInput": _useCustomInput,
        },
      );
    } finally {
      stopLoading();
    }
  }

  void onITChoiceSelect(ITStep step) {
    choreoRecord.addRecord(_textController.text, step: step);
    _textController.setSystemText(
      _textController.text + step.continuances[step.chosen!].text,
      step.continuances[step.chosen!].gold
          ? EditType.itGold
          : EditType.itStandard,
    );
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
    giveInputFocus();
  }

  void onPredictorSelect(String text) {
    //TODO - add some kind of record of this
    // choreoRecord.addRecord(_textController.text, step: step);

    // TODO - probably give it a different type of edit type
    _textController.setSystemText(
      "${_textController.text} $text",
      EditType.other,
    );
    giveInputFocus();
  }

  Future<void> onReplacementSelect({
    required int matchIndex,
    required int choiceIndex,
  }) async {
    try {
      if (igc.igcTextData == null) {
        ErrorHandler.logError(
          e: "onReplacementSelect with null igcTextData",
          s: StackTrace.current,
          data: {
            "matchIndex": matchIndex,
            "choiceIndex": choiceIndex,
          },
        );
        MatrixState.pAnyState.closeOverlay();
        return;
      }
      if (igc.igcTextData!.matches[matchIndex].match.choices == null) {
        ErrorHandler.logError(
          e: "onReplacementSelect with null choices",
          s: StackTrace.current,
          data: {
            "igctextData": igc.igcTextData?.toJson(),
            "matchIndex": matchIndex,
            "choiceIndex": choiceIndex,
          },
        );
        MatrixState.pAnyState.closeOverlay();
        return;
      }

      //if it's the wrong choice, return
      // if (!igc.igcTextData!.matches[matchIndex].match.choices![choiceIndex]
      //     .selected) {
      //   igc.igcTextData!.matches[matchIndex].match.choices![choiceIndex]
      //       .selected = true;
      //   setState();
      //   return;
      // }

      igc.igcTextData!.matches[matchIndex].match.choices![choiceIndex]
          .selected = true;

      final isNormalizationError =
          igc.spanDataController.isNormalizationError(matchIndex);

      //if it's the right choice, replace in text
      if (!isNormalizationError) {
        choreoRecord.addRecord(
          _textController.text,
          match: igc.igcTextData!.matches[matchIndex].copyWith
            ..status = PangeaMatchStatus.accepted,
        );
      }

      igc.igcTextData!.acceptReplacement(
        matchIndex,
        choiceIndex,
      );

      _textController.setSystemText(
        igc.igcTextData!.originalInput,
        EditType.igc,
      );

      MatrixState.pAnyState.closeOverlay();
      setState();
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "igctextData": igc.igcTextData?.toJson(),
          "matchIndex": matchIndex,
          "choiceIndex": choiceIndex,
        },
      );
      igc.igcTextData?.matches.clear();
    } finally {
      setState();
    }
  }

  void onIgnoreMatch({required int cursorOffset}) {
    try {
      if (igc.igcTextData == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "should not be in onIgnoreMatch with null igcTextData",
          s: StackTrace.current,
          data: {},
        );
        return;
      }

      final int matchIndex = igc.igcTextData!.getTopMatchIndexForOffset(
        cursorOffset,
      );

      if (matchIndex == -1) {
        debugger(when: kDebugMode);
        throw Exception("Cannot find the ignored match in igcTextData");
      }

      igc.onIgnoreMatch(igc.igcTextData!.matches[matchIndex]);
      igc.igcTextData!.matches[matchIndex].status = PangeaMatchStatus.ignored;

      final isNormalizationError =
          igc.spanDataController.isNormalizationError(matchIndex);

      if (!isNormalizationError) {
        choreoRecord.addRecord(
          _textController.text,
          match: igc.igcTextData!.matches[matchIndex],
        );
      }

      igc.igcTextData!.matches.removeAt(matchIndex);
    } catch (err, stack) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(
          data: {
            "igcTextData": igc.igcTextData?.toJson(),
            "offset": cursorOffset,
          },
        ),
      );
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "igctextData": igc.igcTextData?.toJson(),
        },
      );
      igc.igcTextData?.matches.clear();
    } finally {
      setState();
    }
  }

  void onSelectAlternativeTranslation(String translation) {
    // PTODO - add some kind of record of this
    // choreoRecord.addRecord(_textController.text, match);

    _textController.setSystemText(
      translation,
      EditType.alternativeTranslation,
    );
    altTranslator.clear();
    altTranslator.translationFeedbackKey = FeedbackKey.allDone;
    altTranslator.showTranslationFeedback = true;
    giveInputFocus();
    setState();
  }

  void giveInputFocus() {
    Future.delayed(Duration.zero, () {
      chatController.inputFocus.requestFocus();
    });
  }

  String get currentText => _textController.text;

  PangeaTextController get textController => _textController;

  String get accessToken => pangeaController.userController.accessToken;

  clear() {
    choreoMode = ChoreoMode.igc;
    _lastChecked = null;
    _timesClicked = 0;
    isFetching = false;
    choreoRecord = ChoreoRecord.newRecord;
    itController.clear();
    igc.dispose();
    //@ggurdin - why is this commented out?
    // errorService.clear();
    _resetDebounceTimer();
  }

  void onMatchError({int? cursorOffset}) {
    if (cursorOffset == null) {
      igc.igcTextData?.matches.clear();
    } else {
      final int? matchIndex = igc.igcTextData?.getTopMatchIndexForOffset(
        cursorOffset,
      );
      matchIndex == -1 || matchIndex == null
          ? igc.igcTextData?.matches.clear()
          : igc.igcTextData?.matches.removeAt(matchIndex);
    }

    setState();
    giveInputFocus();
  }

  dispose() {
    _textController.dispose();
    _trialStream?.cancel();
    _languageStream?.cancel();
    stateStream.close();
    tts.dispose();
  }

  LanguageModel? get l2Lang {
    return pangeaController.languageController.activeL2Model();
  }

  String? get l2LangCode => l2Lang?.langCode;

  LanguageModel? get l1Lang =>
      pangeaController.languageController.activeL1Model();

  String? get l1LangCode => l1Lang?.langCode;

  String? get userId => pangeaController.userController.userId;

  bool get _noChange =>
      _lastChecked != null && _lastChecked == _textController.text;

  bool get isRunningIT =>
      choreoMode == ChoreoMode.it && !itController.isTranslationDone;

  void startLoading() {
    _lastChecked = _textController.text;
    isFetching = true;
    setState();
  }

  void stopLoading() {
    isFetching = false;
    setState();
  }

  void incrementTimesClicked() {
    if (assistanceState == AssistanceState.fetched) {
      _timesClicked++;

      // if user is doing IT, call closeIT here to
      // ensure source text is replaced when needed
      if (itController.isOpen && _timesClicked > 1) {
        itController.closeIT();
      }
    }
  }

  get roomId => chatController.roomId;

  bool get _useCustomInput => [
        EditType.keyboard,
        EditType.igc,
        EditType.alternativeTranslation,
      ].contains(_textController.editType);

  bool get editTypeIsKeyboard => EditType.keyboard == _textController.editType;

  setState() {
    if (!stateStream.isClosed) {
      stateStream.add(0);
    }
  }

  LayerLinkAndKey get itBarLinkAndKey =>
      MatrixState.pAnyState.layerLinkAndKey(itBarTransformTargetKey);

  String get itBarTransformTargetKey => 'it_bar$roomId';

  LayerLinkAndKey get inputLayerLinkAndKey =>
      MatrixState.pAnyState.layerLinkAndKey(inputTransformTargetKey);

  String get inputTransformTargetKey => 'input$roomId';

  LayerLinkAndKey get itBotLayerLinkAndKey =>
      MatrixState.pAnyState.layerLinkAndKey(itBotTransformTargetKey);

  String get itBotTransformTargetKey => 'itBot$roomId';

  bool get igcEnabled => pangeaController.permissionsController.isToolEnabled(
        ToolSetting.interactiveGrammar,
        chatController.room,
      );

  bool get itEnabled => pangeaController.permissionsController.isToolEnabled(
        ToolSetting.interactiveTranslator,
        chatController.room,
      );

  // bool get itAutoPlayEnabled {
  //   return pangeaController.userController.profile.userSettings.itAutoPlay;
  // }

  bool get definitionsEnabled =>
      pangeaController.permissionsController.isToolEnabled(
        ToolSetting.definitions,
        chatController.room,
      );

  bool get immersionMode =>
      pangeaController.permissionsController.isToolEnabled(
        ToolSetting.immersionMode,
        chatController.room,
      );

  // bool get translationEnabled =>
  //     pangeaController.permissionsController.isToolEnabled(
  //       ToolSetting.translations,
  //       chatController.room,
  //     );

  bool get isITandIGCEnabled =>
      pangeaController.permissionsController.isWritingAssistanceEnabled(
        chatController.room,
      );

  bool get isAutoIGCEnabled =>
      pangeaController.permissionsController.isToolEnabled(
        ToolSetting.autoIGC,
        chatController.room,
      );

  AssistanceState get assistanceState {
    final isSubscribed = pangeaController.subscriptionController.isSubscribed;
    if (isSubscribed != null && !isSubscribed) {
      return AssistanceState.noSub;
    }

    if (currentText.isEmpty && itController.sourceText == null) {
      return AssistanceState.noMessage;
    }

    if ((igc.igcTextData?.matches.isNotEmpty ?? false) || isRunningIT) {
      return AssistanceState.fetched;
    }

    if (isFetching) {
      return AssistanceState.fetching;
    }

    if (igc.igcTextData == null) {
      return AssistanceState.notFetched;
    }

    return AssistanceState.complete;
  }

  bool get canSendMessage {
    // if there's an error, let them send. we don't want to block them from sending in this case
    if (errorService.isError ||
        l2Lang == null ||
        l1Lang == null ||
        _timesClicked > 1) {
      return true;
    }

    // if they're in IT mode, don't let them send
    if (itEnabled && isRunningIT) return false;

    // if they've turned off IGC then let them send the message when they want
    if (!isAutoIGCEnabled) return true;

    // if we're in the middle of fetching results, don't let them send
    if (isFetching) return false;

    // they're supposed to run IGC but haven't yet, don't let them send
    if (igc.igcTextData == null) {
      return itController.dismissed;
    }

    // if they have relevant matches, don't let them send
    final hasITMatches =
        igc.igcTextData!.matches.any((match) => match.isITStart);
    final hasIGCMatches =
        igc.igcTextData!.matches.any((match) => !match.isITStart);
    if ((itEnabled && hasITMatches) || (igcEnabled && hasIGCMatches)) {
      return false;
    }

    // otherwise, let them send
    return true;
  }
}
