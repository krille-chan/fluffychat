import 'dart:async';

import 'package:flutter/material.dart';

import 'package:async/async.dart';

import 'package:fluffychat/pangea/choreographer/assistance_state_enum.dart';
import 'package:fluffychat/pangea/choreographer/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/choreo_mode_enum.dart';
import 'package:fluffychat/pangea/choreographer/choreo_record_model.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_state_extension.dart';
import 'package:fluffychat/pangea/choreographer/igc/igc_controller.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/it/completed_it_step_model.dart';
import 'package:fluffychat/pangea/choreographer/pangea_message_content_model.dart';
import 'package:fluffychat/pangea/choreographer/text_editing/edit_type_enum.dart';
import 'package:fluffychat/pangea/choreographer/text_editing/pangea_text_controller.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/events/repo/token_api_models.dart';
import 'package:fluffychat/pangea/events/repo/tokens_repo.dart';
import 'package:fluffychat/pangea/languages/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/tool_settings_enum.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/text_to_speech/tts_controller.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../../widgets/matrix.dart';
import 'choreographer_error_controller.dart';
import 'it/it_controller.dart';

class Choreographer extends ChangeNotifier {
  final FocusNode inputFocus;

  late final PangeaTextController textController;
  late final ITController itController;
  late final IgcController igcController;
  late final ChoreographerErrorController errorService;

  ChoreoRecordModel? _choreoRecord;

  final ValueNotifier<bool> _isFetching = ValueNotifier(false);
  final ValueNotifier<int> _timesDismissedIT = ValueNotifier(0);

  int _timesClicked = 0;
  Timer? _debounceTimer;
  String? _lastChecked;
  ChoreoModeEnum _choreoMode = ChoreoModeEnum.igc;

  DateTime? _lastIgcError;
  DateTime? _lastTokensError;
  int _igcErrorBackoff = ChoreoConstants.defaultErrorBackoffSeconds;
  int _tokenErrorBackoff = ChoreoConstants.defaultErrorBackoffSeconds;

  StreamSubscription? _languageSub;
  StreamSubscription? _settingsUpdateSub;
  StreamSubscription? _acceptedContinuanceSub;
  StreamSubscription? _updatedMatchSub;

  Choreographer(this.inputFocus) {
    _initialize();
  }

  int get timesClicked => _timesClicked;
  ValueNotifier<bool> get isFetching => _isFetching;
  ValueNotifier<int> get timesDismissedIT => _timesDismissedIT;
  ChoreoModeEnum get choreoMode => _choreoMode;
  String get currentText => textController.text;

  ChoreoRecordModel get _record => _choreoRecord ??= ChoreoRecordModel(
    originalText: textController.text,
    choreoSteps: [],
    openMatches: [],
  );

  bool _backoffRequest(DateTime? error, int backoffSeconds) {
    if (error == null) return false;
    final secondsSinceError = DateTime.now().difference(error).inSeconds;
    return secondsSinceError <= backoffSeconds;
  }

  void _initialize() {
    textController = PangeaTextController(choreographer: this);
    textController.addListener(_onChange);

    errorService = ChoreographerErrorController();
    errorService.addListener(notifyListeners);

    itController = ITController(
      (e) => errorService.setErrorAndLock(ChoreoError(raw: e)),
    );
    itController.open.addListener(_onUpdateITOpenStatus);
    itController.editing.addListener(_onSubmitSourceTextEdits);

    igcController = IgcController(
      (e) {
        errorService.setErrorAndLock(ChoreoError(raw: e));
        _lastIgcError = DateTime.now();
        _igcErrorBackoff *= 2;
      },
      () {
        _igcErrorBackoff = ChoreoConstants.defaultErrorBackoffSeconds;
      },
    );

    _languageSub ??= MatrixState
        .pangeaController
        .userController
        .languageStream
        .stream
        .listen((update) {
          clear();
        });

    _settingsUpdateSub ??= MatrixState
        .pangeaController
        .userController
        .settingsUpdateStream
        .stream
        .listen((_) {
          notifyListeners();
        });

    _acceptedContinuanceSub ??= itController.acceptedContinuanceStream.stream
        .listen(_onAcceptContinuance);

    _updatedMatchSub ??= igcController.matchUpdateStream.stream.listen(
      _onUpdateMatch,
    );
  }

  void clear() {
    _lastChecked = null;
    _timesClicked = 0;
    _isFetching.value = false;
    _choreoRecord = null;
    itController.closeIT();
    itController.clearSourceText();
    itController.clearSession();
    igcController.clear();
    _resetDebounceTimer();
    _setChoreoMode(ChoreoModeEnum.igc);
  }

  @override
  void dispose() {
    errorService.removeListener(notifyListeners);
    itController.open.removeListener(_onCloseIT);
    itController.editing.removeListener(_onSubmitSourceTextEdits);
    textController.removeListener(_onChange);

    _languageSub?.cancel();
    _settingsUpdateSub?.cancel();
    _acceptedContinuanceSub?.cancel();
    _updatedMatchSub?.cancel();
    _debounceTimer?.cancel();

    igcController.dispose();
    itController.dispose();
    errorService.dispose();
    textController.dispose();
    _isFetching.dispose();
    _timesDismissedIT.dispose();

    TtsController.stop();
    super.dispose();
  }

  void onPaste(String value) => _record.pastedStrings.add(value);

  void onClickSend() {
    if (assistanceState == AssistanceStateEnum.fetched) {
      _timesClicked++;

      // if user is doing IT, call closeIT here to
      // ensure source text is replaced when needed
      if (itController.open.value && _timesClicked > 1) {
        itController.closeIT(dismiss: true);
      }
    }
  }

  void _setChoreoMode(ChoreoModeEnum mode) {
    _choreoMode = mode;
    notifyListeners();
  }

  void _resetDebounceTimer() {
    if (_debounceTimer != null) {
      _debounceTimer?.cancel();
      _debounceTimer = null;
    }
  }

  void _startLoading() {
    _lastChecked = textController.text;
    _isFetching.value = true;
    notifyListeners();
  }

  void _stopLoading() {
    _isFetching.value = false;
    notifyListeners();
  }

  /// Handles any changes to the text input
  void _onChange() {
    // listener triggers when edit type changes, even if text didn't
    // so prevent unnecessary calls
    if (_lastChecked != null && _lastChecked == textController.text) {
      return;
    }
    // update assistance state from no message => not fetched and vice versa
    if (_lastChecked == null ||
        _lastChecked!.trim().isEmpty ||
        textController.text.trim().isEmpty) {
      notifyListeners();
    }

    // if the user cleared the text, reset everything
    if (textController.editType == EditTypeEnum.keyboard &&
        _lastChecked != null &&
        _lastChecked!.isNotEmpty &&
        textController.text.isEmpty) {
      clear();
    }

    _lastChecked = textController.text;
    if (errorService.isError) return;
    if (textController.editType == EditTypeEnum.keyboard) {
      if (igcController.currentText != null ||
          itController.sourceText.value != null) {
        igcController.clear();
        itController.clearSourceText();
        notifyListeners();
      }

      _resetDebounceTimer();
      _debounceTimer ??= Timer(
        const Duration(milliseconds: ChoreoConstants.msBeforeIGCStart),
        () => requestWritingAssistance(),
      );
    }
    textController.editType = EditTypeEnum.keyboard;
  }

  Future<void> requestWritingAssistance({bool manual = false}) async {
    if (assistanceState != AssistanceStateEnum.notFetched) return;
    final SubscriptionStatus canSendStatus =
        MatrixState.pangeaController.subscriptionController.subscriptionStatus;

    if (canSendStatus != SubscriptionStatus.subscribed ||
        MatrixState.pangeaController.userController.userL2 == null ||
        MatrixState.pangeaController.userController.userL1 == null ||
        (!ToolSetting.interactiveGrammar.enabled &&
            !ToolSetting.interactiveTranslator.enabled) ||
        (!ToolSetting.autoIGC.enabled &&
            !manual &&
            _choreoMode != ChoreoModeEnum.it) ||
        _backoffRequest(_lastIgcError, _igcErrorBackoff)) {
      return;
    }

    _resetDebounceTimer();
    _startLoading();

    await igcController.getIGCTextData(textController.text, []);

    // init choreo record to record the original text before any matches are applied
    _choreoRecord ??= ChoreoRecordModel(
      originalText: textController.text,
      choreoSteps: [],
      openMatches: [],
    );

    if (igcController.openNormalizationMatches.isNotEmpty) {
      await igcController.acceptNormalizationMatches();
    } else {
      // trigger a re-render of the text field to show IGC matches
      textController.setSystemText(textController.text, EditTypeEnum.igc);
    }

    _stopLoading();
  }

  /// Re-runs IGC with user feedback and updates the UI.
  Future<bool> rerunWithFeedback(String feedbackText) async {
    MatrixState.pAnyState.closeAllOverlays();
    igcController.clearMatches();
    igcController.clearCurrentText();

    _startLoading();
    final success = await igcController.rerunWithFeedback(feedbackText);
    if (success && igcController.openNormalizationMatches.isNotEmpty) {
      await igcController.acceptNormalizationMatches();
    }
    _stopLoading();

    return success;
  }

  Future<PangeaMessageContentModel> getMessageContent(String message) async {
    TokensResponseModel? tokensResp;
    final l2LangCode =
        MatrixState.pangeaController.userController.userL2?.langCode;
    final l1LangCode =
        MatrixState.pangeaController.userController.userL1?.langCode;
    if (l1LangCode != null &&
        l2LangCode != null &&
        !_backoffRequest(_lastTokensError, _tokenErrorBackoff)) {
      final res =
          await TokensRepo.get(
            MatrixState.pangeaController.userController.accessToken,
            TokensRequestModel(
              fullText: message,
              senderL1: l1LangCode,
              senderL2: l2LangCode,
            ),
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              return Result.error("Token request timed out");
            },
          );

      if (res.isError) {
        _lastTokensError = DateTime.now();
        _tokenErrorBackoff *= 2;
      } else {
        // reset backoff on success
        _tokenErrorBackoff = ChoreoConstants.defaultErrorBackoffSeconds;
      }

      tokensResp = res.isValue ? res.result : null;
    }

    final hasOriginalWritten =
        _record.includedIT && itController.sourceText.value != null;

    return PangeaMessageContentModel(
      message: message,
      choreo: _record,
      originalWritten: hasOriginalWritten
          ? PangeaRepresentation(
              langCode: l1LangCode ?? LanguageKeys.unknownLanguage,
              text: itController.sourceText.value!,
              originalWritten: true,
              originalSent: false,
            )
          : null,
      tokensSent: tokensResp != null
          ? PangeaMessageTokens(
              tokens: tokensResp.tokens,
              detections: tokensResp.detections,
            )
          : null,
    );
  }

  void _onUpdateITOpenStatus() {
    itController.open.value ? _onOpenIT() : _onCloseIT();
    notifyListeners();
  }

  void _onOpenIT() {
    inputFocus.unfocus();
    final itMatch = igcController.openMatches.firstWhere(
      (match) => match.updatedMatch.isITStart,
      orElse: () =>
          throw Exception("Attempted to open IT without an ITStart match"),
    );

    igcController.clear();
    itMatch.setStatus(PangeaMatchStatusEnum.accepted);
    _record.addRecord("", match: itMatch.updatedMatch);

    _setChoreoMode(ChoreoModeEnum.it);
    textController.setSystemText("", EditTypeEnum.it);
  }

  void _onCloseIT() {
    if (itController.dismissed &&
        currentText.isEmpty &&
        itController.sourceText.value != null) {
      textController.setSystemText(
        itController.sourceText.value!,
        EditTypeEnum.itDismissed,
      );
    }

    if (itController.dismissed) {
      _timesDismissedIT.value = _timesDismissedIT.value + 1;
    }
    _setChoreoMode(ChoreoModeEnum.igc);
    errorService.resetError();
  }

  void _onSubmitSourceTextEdits() {
    if (itController.editing.value) return;
    textController.setSystemText("", EditTypeEnum.it);
  }

  void _onAcceptContinuance(CompletedITStepModel step) {
    textController.setSystemText(
      textController.text + step.continuances[step.chosen].text,
      EditTypeEnum.it,
    );

    _record.addRecord(textController.text, step: step);
    inputFocus.requestFocus();
    notifyListeners();
  }

  void clearMatches(Object error) {
    MatrixState.pAnyState.closeAllOverlays();
    igcController.clearMatches();
    errorService.setError(ChoreoError(raw: error));
  }

  void _onUpdateMatch(PangeaMatchState match) {
    textController.setSystemText(igcController.currentText!, EditTypeEnum.igc);

    switch (match.updatedMatch.status) {
      case PangeaMatchStatusEnum.accepted:
      case PangeaMatchStatusEnum.automatic:
      case PangeaMatchStatusEnum.viewed:
        _record.addRecord(textController.text, match: match.updatedMatch);
      case PangeaMatchStatusEnum.undo:
        _record.choreoSteps.removeWhere(
          (step) =>
              step.acceptedOrIgnoredMatch?.match == match.updatedMatch.match,
        );
      default:
        throw Exception("Unhandled match status: ${match.updatedMatch.status}");
    }

    inputFocus.requestFocus();
    notifyListeners();
  }
}
