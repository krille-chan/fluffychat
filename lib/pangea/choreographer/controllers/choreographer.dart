import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pages/chat/chat.dart';
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
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/events/repo/token_api_models.dart';
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
  late ErrorService errorService;

  bool isFetching = false;
  int _timesClicked = 0;

  final int msBeforeIGCStart = 10000;

  Timer? debounceTimer;
  ChoreoRecord? choreoRecord;
  // last checked by IGC or translation
  String? _lastChecked;
  ChoreoMode choreoMode = ChoreoMode.igc;

  final StreamController stateStream = StreamController.broadcast();
  StreamSubscription? _languageStream;
  StreamSubscription? _settingsUpdateStream;
  late AssistanceState _currentAssistanceState;

  String? translatedText;

  Choreographer(this.pangeaController, this.chatController) {
    _initialize();
  }
  _initialize() {
    _textController = PangeaTextController(choreographer: this);
    InputPasteListener(_textController, onPaste);
    itController = ITController(this);
    igc = IgcController(this);
    errorService = ErrorService(this);
    _textController.addListener(_onChangeListener);
    _languageStream =
        pangeaController.userController.languageStream.stream.listen((update) {
      clear();
      setState();
    });

    _settingsUpdateStream =
        pangeaController.userController.settingsUpdateStream.stream.listen((_) {
      setState();
    });
    _currentAssistanceState = assistanceState;
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
          : chatController.send(
              message: chatController.sendController.text,
            );
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

    if (chatController.sendController.text.trim().isEmpty) {
      return;
    }

    final message = chatController.sendController.text;
    final fakeEventId = chatController.sendFakeMessage();
    final PangeaRepresentation? originalWritten =
        choreoRecord?.includedIT == true && translatedText != null
            ? PangeaRepresentation(
                langCode: l1LangCode ?? LanguageKeys.unknownLanguage,
                text: translatedText!,
                originalWritten: true,
                originalSent: false,
              )
            : null;

    PangeaMessageTokens? tokensSent;
    PangeaRepresentation? originalSent;
    try {
      TokensResponseModel? res;
      if (l1LangCode != null && l2LangCode != null) {
        res = await pangeaController.messageData
            .getTokens(
              repEventId: null,
              room: chatController.room,
              req: TokensRequestModel(
                fullText: message,
                senderL1: l1LangCode!,
                senderL2: l2LangCode!,
              ),
            )
            .timeout(const Duration(seconds: 10));
      }

      originalSent = PangeaRepresentation(
        langCode: res?.detections.firstOrNull?.langCode ??
            LanguageKeys.unknownLanguage,
        text: message,
        originalSent: true,
        originalWritten: originalWritten == null,
      );

      tokensSent = res != null
          ? PangeaMessageTokens(
              tokens: res.tokens,
              detections: res.detections,
            )
          : null;
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "currentText": message,
          "l1LangCode": l1LangCode,
          "l2LangCode": l2LangCode,
          "choreoRecord": choreoRecord?.toJson(),
        },
        level: e is TimeoutException ? SentryLevel.warning : SentryLevel.error,
      );
    } finally {
      chatController.send(
        message: message,
        originalSent: originalSent,
        originalWritten: originalWritten,
        tokensSent: tokensSent,
        choreo: choreoRecord,
        tempEventId: fakeEventId,
      );
      clear();
    }
  }

  _resetDebounceTimer() {
    if (debounceTimer != null) {
      debounceTimer?.cancel();
      debounceTimer = null;
    }
  }

  void _initChoreoRecord() {
    choreoRecord ??= ChoreoRecord(
      originalText: textController.text,
      choreoSteps: [],
      openMatches: [],
    );
  }

  void onITStart(PangeaMatch itMatch) {
    if (!itMatch.isITStart) {
      throw Exception("this isn't an itStart match!");
    }
    choreoMode = ChoreoMode.it;
    itController.initializeIT(
      ITStartData(_textController.text, null),
    );
    itMatch.status = PangeaMatchStatus.accepted;
    translatedText = _textController.text;

    //PTODO - if totally in L1, save tokens, that's good stuff

    igc.clear();

    _textController.setSystemText("", EditType.itStart);

    _initChoreoRecord();
    choreoRecord!.addRecord(_textController.text, match: itMatch);
  }

  /// Handles any changes to the text input
  _onChangeListener() {
    // Rebuild the IGC button if the state has changed.
    // This accounts for user typing after initial IGC has completed
    if (_currentAssistanceState != assistanceState) {
      setState();
    }

    if (_noChange) {
      return;
    }

    _lastChecked = _textController.text;

    if (_textController.editType == EditType.igc ||
        _textController.editType == EditType.itDismissed) {
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

    // we store translated text in the choreographer to save at the original written
    // text, but if the user edits the text after the translation, reset it, since the
    // sent text may not be an exact translation of the original text
    if (_textController.editType == EditType.keyboard) {
      translatedText = null;
    }

    if (editTypeIsKeyboard) {
      debounceTimer ??= Timer(
        Duration(milliseconds: msBeforeIGCStart),
        () => getLanguageHelp(),
      );
    } else {
      getLanguageHelp();
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
      _initChoreoRecord();

      // if getting language assistance after finishing IT,
      // reset the itController
      if (choreoMode == ChoreoMode.it && itController.isTranslationDone) {
        itController.clear();
      }

      await (isRunningIT
          ? itController.getTranslationData(_useCustomInput)
          : igc.getIGCTextData());
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
          "useCustomInput": _useCustomInput,
        },
      );
    } finally {
      stopLoading();
    }
  }

  void onITChoiceSelect(ITStep step) {
    _textController.setSystemText(
      _textController.text + step.continuances[step.chosen!].text,
      step.continuances[step.chosen!].gold
          ? EditType.itGold
          : EditType.itStandard,
    );
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);

    _initChoreoRecord();
    choreoRecord!.addRecord(_textController.text, step: step);

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

      final match = igc.igcTextData!.matches[matchIndex].copyWith
        ..status = PangeaMatchStatus.accepted;

      igc.igcTextData!.acceptReplacement(
        matchIndex,
        choiceIndex,
      );

      _textController.setSystemText(
        igc.igcTextData!.originalInput,
        EditType.igc,
      );

      //if it's the right choice, replace in text
      if (!isNormalizationError) {
        _initChoreoRecord();
        choreoRecord!.addRecord(
          _textController.text,
          match: match,
        );
      }

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

  void onUndoReplacement(PangeaMatch match) {
    try {
      igc.igcTextData?.undoReplacement(match);

      choreoRecord?.choreoSteps.removeWhere(
        (step) => step.acceptedOrIgnoredMatch == match,
      );

      _textController.setSystemText(
        igc.igcTextData!.originalInput,
        EditType.igc,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "igctextData": igc.igcTextData?.toJson(),
          "match": match.toJson(),
        },
      );
    } finally {
      MatrixState.pAnyState.closeOverlay();
      setState();
    }
  }

  void acceptNormalizationMatches() {
    final List<int> indices = [];
    for (int i = 0; i < igc.igcTextData!.matches.length; i++) {
      final isNormalizationError =
          igc.spanDataController.isNormalizationError(i);
      if (isNormalizationError) indices.add(i);
    }

    if (indices.isEmpty) return;

    _initChoreoRecord();
    final matches = igc.igcTextData!.matches
        .where(
          (match) => indices.contains(igc.igcTextData!.matches.indexOf(match)),
        )
        .toList();

    for (final match in matches) {
      final index = igc.igcTextData!.matches.indexOf(match);
      igc.igcTextData!.acceptReplacement(
        index,
        match.match.choices!.indexWhere(
          (c) => c.isBestCorrection,
        ),
      );

      final newMatch = match.copyWith;
      newMatch.status = PangeaMatchStatus.automatic;
      newMatch.match.length = match.match.choices!
          .firstWhere((c) => c.isBestCorrection)
          .value
          .characters
          .length;

      _textController.setSystemText(
        igc.igcTextData!.originalInput,
        EditType.igc,
      );

      choreoRecord!.addRecord(
        currentText,
        match: newMatch,
      );
    }
  }

  void onIgnoreMatch({required int matchIndex}) {
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

      if (matchIndex == -1) {
        debugger(when: kDebugMode);
        throw Exception("Cannot find the ignored match in igcTextData");
      }

      igc.onIgnoreMatch(igc.igcTextData!.matches[matchIndex]);
      igc.igcTextData!.matches[matchIndex].status = PangeaMatchStatus.ignored;

      final isNormalizationError =
          igc.spanDataController.isNormalizationError(matchIndex);

      if (!isNormalizationError) {
        _initChoreoRecord();
        choreoRecord!.addRecord(
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
            "matchIndex": matchIndex,
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
    choreoRecord = null;
    translatedText = null;
    itController.clear();
    igc.dispose();
    _resetDebounceTimer();
  }

  Future<void> onPaste(value) async {
    _initChoreoRecord();
    choreoRecord!.pastedStrings.add(value);
  }

  dispose() {
    _textController.dispose();
    _languageStream?.cancel();
    _settingsUpdateStream?.cancel();
    stateStream.close();
    TtsController.stop();
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
    _currentAssistanceState = assistanceState;
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
