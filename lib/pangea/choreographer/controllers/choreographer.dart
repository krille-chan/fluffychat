import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/choreographer/controllers/alternative_translator.dart';
import 'package:fluffychat/pangea/choreographer/controllers/igc_controller.dart';
import 'package:fluffychat/pangea/choreographer/controllers/message_options.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/enum/edit_type.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/models/it_step.dart';
import 'package:fluffychat/pangea/models/message_data_models.dart';
import 'package:fluffychat/pangea/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/overlay.dart';
import 'package:fluffychat/pangea/widgets/igc/paywall_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../widgets/matrix.dart';
import '../../enum/use_type.dart';
import '../../models/choreo_record.dart';
import '../../models/language_model.dart';
import '../../models/pangea_match_model.dart';
import '../../widgets/igc/pangea_text_controller.dart';
import 'error_service.dart';
import 'it_controller.dart';

enum ChoreoMode { igc, it }

class Choreographer {
  PangeaController pangeaController;
  ChatController chatController;
  late PangeaTextController _textController;
  late ITController itController;
  late IgcController igc;
  late MessageOptions messageOptions;
  late AlternativeTranslator altTranslator;
  late ErrorService errorService;

  bool isFetching = false;
  Timer? debounceTimer;
  String? _roomId;
  ChoreoRecord choreoRecord = ChoreoRecord.newRecord;
  // last checked by IGC or translation
  String? _lastChecked;
  ChoreoMode choreoMode = ChoreoMode.igc;
  final StreamController stateListener = StreamController();

  Choreographer(this.pangeaController, this.chatController) {
    _initialize();
  }
  _initialize() {
    _textController = PangeaTextController(choreographer: this);
    itController = ITController(this);
    igc = IgcController(this);
    messageOptions = MessageOptions(this);
    errorService = ErrorService(this);
    altTranslator = AlternativeTranslator(this);
    _textController.addListener(_onChangeListener);

    clear();
  }

  void send(BuildContext context) {
    if (isFetching) return;

    if (pangeaController.subscriptionController.canSendStatus ==
        CanSendStatus.showPaywall) {
      OverlayUtil.showPositionedCard(
        context: context,
        cardToShow: const PaywallCard(),
        cardSize: const Size(325, 375),
        transformTargetId: inputTransformTargetKey,
      );
      return;
    }

    if (!igc.hasRelevantIGCTextData) {
      getLanguageHelp().then((value) => _sendWithIGC(context));
    } else {
      _sendWithIGC(context);
    }
  }

  void _sendWithIGC(BuildContext context) {
    if (igc.canSendMessage) {
      final PangeaRepresentation? originalWritten =
          choreoRecord.includedIT && itController.sourceText != null
              ? PangeaRepresentation(
                  langCode: l1LangCode ?? LanguageKeys.unknownLanguage,
                  text: itController.sourceText!,
                  originalWritten: true,
                  originalSent: false,
                )
              : null;

      // PTODO - just put this in original message event
      final PangeaRepresentation originalSent = PangeaRepresentation(
        langCode: langCodeOfCurrentText ?? LanguageKeys.unknownLanguage,
        text: currentText,
        originalSent: true,
        originalWritten: originalWritten == null,
      );
      final ChoreoRecord? applicableChoreo =
          isITandIGCEnabled && igc.igcTextData != null ? choreoRecord : null;

      final UseType useType = useTypeCalculator(applicableChoreo);
      debugPrint("use type in choreographer $useType");

      chatController.send(
        // PTODO - turn this back on in conjunction with saving tokens
        // we need to save those tokens as well, in order for exchanges to work
        // properly. in an exchange, the other user will want
        // originalWritten: originalWritten,
        originalSent: originalSent,
        tokensSent: igc.igcTextData?.tokens != null
            ? PangeaMessageTokens(tokens: igc.igcTextData!.tokens)
            : null,
        //TODO - save originalwritten tokens
        choreo: applicableChoreo,
        useType: useType,
      );

      clear();
    } else {
      igc.showFirstMatch(context);
    }
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
      ITStartData(_textController.text, igc.detectedLangCode),
    );
    itMatch.status = PangeaMatchStatus.accepted;

    choreoRecord.addRecord(_textController.text, match: itMatch);

    //PTODO - if totally in L1, save tokens, that's good stuff

    igc.clear();

    _textController.setSystemText("", EditType.itStart);
  }

  _onChangeListener() {
    if (_noChange) {
      return;
    }

    if ([
      EditType.igc,
    ].contains(_textController.editType)) {
      igc.justGetTokensAndAddThemToIGCTextData();
      textController.editType = EditType.keyboard;
      return;
    }

    MatrixState.pAnyState.closeOverlay();

    if (errorService.isError) {
      return;
    }

    // if (igc.igcTextData != null) {
    igc.clear();
    // setState();
    // }

    _resetDebounceTimer();

    if (editTypeIsKeyboard) {
      debounceTimer ??= Timer(
        const Duration(milliseconds: 1500),
        () => getLanguageHelp(),
      );
    } else {
      getLanguageHelp(ChoreoMode.it == choreoMode);
    }

    //Note: we don't set the keyboard type on each keyboard stroke so this is how we default to
    //a change being from the keyboard unless explicitly set to one of the other
    //types when that action happens (e.g. an it/igc choice is selected)
    textController.editType = EditType.keyboard;
  }

  Future<void> getLanguageHelp([bool tokensOnly = false]) async {
    try {
      if (errorService.isError) return;
      final CanSendStatus canSendStatus =
          pangeaController.subscriptionController.canSendStatus;

      if (canSendStatus != CanSendStatus.subscribed) {
        return;
      }

      startLoading();
      if (choreoMode == ChoreoMode.it &&
          itController.isTranslationDone &&
          !tokensOnly) {
        debugger(when: kDebugMode);
      }

      await (choreoMode == ChoreoMode.it && !itController.isTranslationDone
          ? itController.getTranslationData(_useCustomInput)
          : igc.getIGCTextData(tokensOnly: tokensOnly));
    } catch (err, stack) {
      ErrorHandler.logError(e: err, s: stack);
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

  Future<void> onReplacementSelect({
    required int matchIndex,
    required int choiceIndex,
  }) async {
    try {
      if (igc.igcTextData == null) {
        ErrorHandler.logError(
          e: "onReplacementSelect with null igcTextData",
          s: StackTrace.current,
        );
        MatrixState.pAnyState.closeOverlay();
        return;
      }
      if (igc.igcTextData!.matches[matchIndex].match.choices == null) {
        ErrorHandler.logError(
          e: "onReplacementSelect with null choices",
          s: StackTrace.current,
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

      //if it's the right choice, replace in text
      choreoRecord.addRecord(
        _textController.text,
        match: igc.igcTextData!.matches[matchIndex].copyWith
          ..status = PangeaMatchStatus.accepted,
      );

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
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson(
          {
            "igctextDdata": igc.igcTextData?.toJson(),
            "matchIndex": matchIndex,
            "choiceIndex": choiceIndex,
          },
        ),
      );
      ErrorHandler.logError(e: err, s: stack);
      igc.igcTextData?.matches.clear();
    } finally {
      giveInputFocus();
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
        );
        return;
      }

      final int matchIndex = igc.igcTextData!.getTopMatchIndexForOffset(
        cursorOffset,
      );

      if (matchIndex == -1) {
        debugger(when: kDebugMode);
        throw Exception("Cannnot find the ignored match in igcTextData");
      }

      igc.igcTextData!.matches[matchIndex].status = PangeaMatchStatus.ignored;
      choreoRecord.addRecord(
        _textController.text,
        match: igc.igcTextData!.matches[matchIndex],
      );

      igc.igcTextData!.matches.removeAt(matchIndex);
    } catch (err, stack) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb.fromJson(
          {"igcTextData": igc.igcTextData?.toJson(), "offset": cursorOffset},
        ),
      );
      ErrorHandler.logError(
        e: err,
        s: stack,
      );
      igc.igcTextData?.matches.clear();
    } finally {
      setState();
      giveInputFocus();
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

  giveInputFocus() {
    Future.delayed(Duration.zero, () {
      chatController.inputFocus.requestFocus();
    });
  }

  String get currentText => _textController.text;

  PangeaTextController get textController => _textController;

  Future<String> get accessToken => pangeaController.userController.accessToken;

  clear() {
    choreoMode = ChoreoMode.igc;
    _lastChecked = null;
    isFetching = false;
    choreoRecord = ChoreoRecord.newRecord;
    itController.clear();
    igc.clear();
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
  }

  LanguageModel? get l2Lang {
    return pangeaController.languageController.activeL2Model(
      roomID: roomId,
    );
  }

  String? get l2LangCode => l2Lang?.langCode;

  LanguageModel? get l1Lang =>
      pangeaController.languageController.activeL1Model(
        roomID: roomId,
      );
  String? get l1LangCode => l1Lang?.langCode;

  String? get classId => roomId != null
      ? pangeaController.matrixState.client
          .getRoomById(roomId)
          ?.firstParentWithState(PangeaEventTypes.classSettings)
          ?.id
      : null;

  String? get userId => pangeaController.userController.userId;

  bool get _noChange =>
      _lastChecked != null && _lastChecked == _textController.text;

  void startLoading() {
    _lastChecked = _textController.text;
    isFetching = true;
    setState();
  }

  void stopLoading() {
    isFetching = false;
    setState();
  }

  get roomId => _roomId;
  void setRoomId(String? roomId) {
    _roomId = roomId ?? '';
  }

  bool get _useCustomInput => [
        EditType.keyboard,
        EditType.igc,
        EditType.alternativeTranslation,
      ].contains(_textController.editType);

  bool get editTypeIsKeyboard => EditType.keyboard == _textController.editType;

  String? get langCodeOfCurrentText {
    if (igc.detectedLangCode != null) return igc.detectedLangCode!;

    if (itController.isOpen) return l2LangCode!;

    return null;
  }

  setState() {
    if (!stateListener.isClosed) {
      stateListener.add(0);
    }
  }

  bool get showIsError => !itController.isOpen && errorService.isError;

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

  bool get translationEnabled =>
      pangeaController.permissionsController.isToolEnabled(
        ToolSetting.translations,
        chatController.room,
      );

  bool get isITandIGCEnabled =>
      pangeaController.permissionsController.isWritingAssistanceEnabled(
        chatController.room,
      );
}
