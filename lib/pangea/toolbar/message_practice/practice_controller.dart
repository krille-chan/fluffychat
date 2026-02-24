import 'package:flutter/foundation.dart';

import 'package:async/async.dart';
import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';
import 'package:fluffychat/pangea/practice_activities/practice_generation_repo.dart';
import 'package:fluffychat/pangea/practice_activities/practice_selection.dart';
import 'package:fluffychat/pangea/practice_activities/practice_selection_repo.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/pangea/text_to_speech/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/message_practice/message_practice_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/message_practice/morph_selection.dart';
import 'package:fluffychat/pangea/toolbar/message_practice/practice_record_controller.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PracticeController with ChangeNotifier {
  final PangeaMessageEvent pangeaMessageEvent;

  PracticeController(this.pangeaMessageEvent) {
    _fetchPracticeSelection();
  }

  PracticeActivityModel? _activity;

  MessagePracticeMode _practiceMode = MessagePracticeMode.noneSelected;

  MorphSelection? _selectedMorph;
  PracticeChoice? _selectedChoice;

  PracticeSelection? practiceSelection;

  MessagePracticeMode get practiceMode => _practiceMode;
  MorphSelection? get selectedMorph => _selectedMorph;
  PracticeChoice? get selectedChoice => _selectedChoice;

  PracticeTarget? get currentTarget {
    final activityType = _practiceMode.associatedActivityType;
    if (activityType == null) return null;
    if (activityType == ActivityTypeEnum.morphId) {
      if (_selectedMorph == null) return null;
      return practiceSelection?.getMorphTarget(
        _selectedMorph!.token,
        _selectedMorph!.morph,
      );
    }
    return practiceSelection?.getTarget(activityType);
  }

  bool get showChoiceShimmer {
    if (_activity == null) return false;
    if (_activity is MorphMatchPracticeActivityModel) {
      return _selectedMorph != null &&
          !PracticeRecordController.hasResponse(_activity!.practiceTarget);
    }

    return _selectedChoice == null &&
        !PracticeRecordController.hasAnyCorrectChoices(
          _activity!.practiceTarget,
        );
  }

  bool get isTotallyDone =>
      isPracticeSessionDone(ActivityTypeEnum.emoji) &&
      isPracticeSessionDone(ActivityTypeEnum.wordMeaning) &&
      isPracticeSessionDone(ActivityTypeEnum.wordFocusListening) &&
      isPracticeSessionDone(ActivityTypeEnum.morphId);

  bool get isCurrentPracticeSessionDone {
    final activityType = _practiceMode.associatedActivityType;
    if (activityType == null) return false;
    return isPracticeSessionDone(activityType);
  }

  bool? wasCorrectMatch(PracticeChoice choice) {
    if (_activity == null) return false;
    return PracticeRecordController.wasCorrectMatch(
      _activity!.practiceTarget,
      choice,
    );
  }

  bool? wasCorrectChoice(String choice) {
    if (_activity == null) return false;
    return PracticeRecordController.wasCorrectChoice(
      _activity!.practiceTarget,
      choice,
    );
  }

  bool isPracticeSessionDone(ActivityTypeEnum activityType) =>
      practiceSelection
          ?.activities(activityType)
          .every((a) => PracticeRecordController.isCompleteByTarget(a)) ==
      true;

  bool isPracticeButtonEmpty(PangeaToken token) {
    final target = practiceTargetForToken(token);
    switch (_practiceMode) {
      // Keep open when completed if emoji assigned
      case MessagePracticeMode.wordEmoji:
        if (token.vocabConstructID.userSetEmoji != null) return false;
        return target == null;
      // Keep open when completed to show morph icon
      case MessagePracticeMode.wordMorph:
        return target == null;
      default:
        return target == null ||
            PracticeRecordController.isCompleteByToken(target, token);
    }
  }

  PracticeTarget? practiceTargetForToken(PangeaToken token) {
    if (_practiceMode.associatedActivityType == null) return null;
    return practiceSelection
        ?.activities(_practiceMode.associatedActivityType!)
        .firstWhereOrNull((a) => a.tokens.contains(token));
  }

  void updateToolbarMode(MessagePracticeMode mode) {
    _selectedChoice = null;
    _practiceMode = mode;
    if (_practiceMode != MessagePracticeMode.wordMorph) {
      _selectedMorph = null;
    }
    notifyListeners();
  }

  void updatePracticeMorph(MorphSelection newMorph) {
    _practiceMode = MessagePracticeMode.wordMorph;
    _selectedMorph = newMorph;
    notifyListeners();
  }

  void onChoiceSelect(PracticeChoice? choice) {
    if (_activity == null) return;
    if (_selectedChoice == choice) {
      _selectedChoice = null;
    } else {
      _selectedChoice = choice;
    }
    notifyListeners();
  }

  void onMatch(PangeaToken token, PracticeChoice choice) {
    if (_activity == null) return;
    final isCorrect = PracticeRecordController.onSelectChoice(
      choice.choiceContent,
      token,
      _activity!,
    );

    final targetId =
        "message-token-${token.text.uniqueKey}-${pangeaMessageEvent.eventId}";

    final updateService = MatrixState
        .pangeaController
        .matrixState
        .analyticsDataService
        .updateService;

    // we don't take off points for incorrect emoji matches
    if (_activity is! EmojiPracticeActivityModel || isCorrect) {
      final l2 =
          MatrixState.pangeaController.userController.userL2?.langCodeShort;
      if (l2 == null) {
        ErrorHandler.logError(
          e: "User L2 is null when trying to log construct use for token ${token.text.content} in practice activity",
          data: {
            "eventId": pangeaMessageEvent.eventId,
            "token": token.text.content,
            "activityType": _activity!.activityType.toString(),
          },
        );
        return;
      }

      final constructUseType = PracticeRecordController.lastResponse(
        _activity!.practiceTarget,
      )!.useType(_activity!.activityType);

      final constructs = [
        OneConstructUse(
          useType: constructUseType,
          lemma: token.lemma.text,
          constructType: ConstructTypeEnum.vocab,
          metadata: ConstructUseMetaData(
            roomId: pangeaMessageEvent.room.id,
            timeStamp: DateTime.now(),
            eventId: pangeaMessageEvent.eventId,
          ),
          category: token.pos,
          // in the case of a wrong answer, the cId doesn't match the token
          form: token.text.content,
          xp: constructUseType.pointValue,
        ),
      ];

      updateService.addAnalytics(targetId, constructs, l2);
    }

    if (isCorrect) {
      if (_activity is EmojiPracticeActivityModel) {
        updateService.setLemmaInfo(
          choice.form.cId,
          emoji: choice.choiceContent,
        );
      }

      if (_activity is LemmaMeaningPracticeActivityModel) {
        updateService.setLemmaInfo(
          choice.form.cId,
          meaning: choice.choiceContent,
        );
      }
    }

    if (_activity is LemmaMeaningPracticeActivityModel ||
        _activity is EmojiPracticeActivityModel) {
      TtsController.tryToSpeak(
        token.text.content,
        langCode: MatrixState.pangeaController.userController.userL2!.langCode,
        pos: token.pos,
        morph: token.morph.map((k, v) => MapEntry(k.name, v)),
      );
    }

    notifyListeners();
  }

  Future<void> _fetchPracticeSelection() async {
    if (pangeaMessageEvent.messageDisplayRepresentation?.tokens == null) return;
    practiceSelection = await PracticeSelectionRepo.get(
      pangeaMessageEvent.eventId,
      pangeaMessageEvent.messageDisplayLangCode,
      pangeaMessageEvent.messageDisplayRepresentation!.tokens!,
    );
  }

  Future<Result<PracticeActivityModel>> fetchActivityModel(
    PracticeTarget target,
  ) async {
    final req = MessageActivityRequest(
      userL1: MatrixState.pangeaController.userController.userL1!.langCode,
      userL2: MatrixState.pangeaController.userController.userL2!.langCode,
      activityQualityFeedback: null,
      target: target,
    );

    final result = await PracticeRepo.getPracticeActivity(
      req,
      messageInfo: pangeaMessageEvent.event.content,
    );
    if (result.isValue) {
      _activity = result.result;
    }

    return result;
  }
}
