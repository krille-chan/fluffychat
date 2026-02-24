import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_data/analytics_updater_mixin.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/example_message_util.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_constants.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_data_service.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_session_controller.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_ui_controller.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_view.dart';
import 'package:fluffychat/pangea/common/utils/async_state.dart';
import 'package:fluffychat/pangea/languages/language_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SelectedMorphChoice {
  final MorphFeaturesEnum feature;
  final String tag;

  const SelectedMorphChoice({required this.feature, required this.tag});
}

class AnalyticsPracticeNotifier extends ChangeNotifier {
  String? _lastSelectedChoice;
  bool showHint = false;
  final Set<String> _clickedChoices = {};

  int correctAnswersSelected(MultipleChoicePracticeActivityModel? activity) {
    if (activity == null) return 0;
    final allAnswers = activity.multipleChoiceContent.answers;
    return _clickedChoices.where((c) => allAnswers.contains(c)).length;
  }

  bool enableHintPress(
    MultipleChoicePracticeActivityModel? activity,
    int hintsUsed,
  ) {
    if (showHint) return false;
    return switch (activity) {
      VocabAudioPracticeActivityModel() => true,
      _ => hintsUsed < AnalyticsPracticeConstants.maxHints,
    };
  }

  SelectedMorphChoice? selectedMorphChoice(
    MultipleChoicePracticeActivityModel? activity,
  ) {
    if (activity is! MorphPracticeActivityModel) return null;
    if (_lastSelectedChoice == null) return null;
    return SelectedMorphChoice(
      feature: activity.morphFeature,
      tag: _lastSelectedChoice!,
    );
  }

  bool activityComplete(MultipleChoicePracticeActivityModel? activity) {
    if (activity == null) return false;
    final allAnswers = activity.multipleChoiceContent.answers;
    return allAnswers.every((answer) => _clickedChoices.contains(answer));
  }

  bool hasSelectedChoice(String choice) => _clickedChoices.contains(choice);

  void clearActivityState() {
    _lastSelectedChoice = null;
    _clickedChoices.clear();
    showHint = false;
  }

  void toggleShowHint() {
    showHint = !showHint;
    notifyListeners();
  }

  void selectChoice(String choice) {
    _clickedChoices.add(choice);
    _lastSelectedChoice = choice;
    notifyListeners();
  }
}

typedef ActivityNotifier =
    ValueNotifier<AsyncState<MultipleChoicePracticeActivityModel>>;

class AnalyticsPractice extends StatefulWidget {
  static bool bypassExitConfirmation = true;

  final ConstructTypeEnum type;
  const AnalyticsPractice({super.key, required this.type});

  @override
  AnalyticsPracticeState createState() => AnalyticsPracticeState();
}

class AnalyticsPracticeState extends State<AnalyticsPractice>
    with AnalyticsUpdater {
  final PracticeSessionController _sessionController =
      PracticeSessionController();

  final AnalyticsPracticeDataService _dataService =
      AnalyticsPracticeDataService();

  late final AnalyticsPracticeAnalyticsController _analyticsController;
  StreamSubscription<void>? _languageStreamSubscription;

  final ActivityNotifier activityState = ActivityNotifier(
    const AsyncState.idle(),
  );
  final AnalyticsPracticeNotifier notifier = AnalyticsPracticeNotifier();
  final ValueNotifier<double> progress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();

    _analyticsController = AnalyticsPracticeAnalyticsController(
      Matrix.of(context).analyticsDataService,
    );

    _addLanguageSubscription();
    startSession();
  }

  @override
  void dispose() {
    _languageStreamSubscription?.cancel();
    notifier.dispose();
    activityState.dispose();
    progress.dispose();
    super.dispose();
  }

  PracticeSessionController get session => _sessionController;
  AnalyticsPracticeDataService get data => _dataService;

  LanguageModel? get _l2 => MatrixState.pangeaController.userController.userL2;

  MultipleChoicePracticeActivityModel? get activity {
    final state = activityState.value;
    if (state is! AsyncLoaded<MultipleChoicePracticeActivityModel>) {
      return null;
    }

    return state.value;
  }

  Future<double> get levelProgress =>
      _analyticsController.levelProgress(_l2!.langCodeShort);

  Future<List<InlineSpan>?> get exampleMessage async {
    final activity = this.activity;
    if (activity == null) return null;

    return switch (activity) {
      VocabAudioPracticeActivityModel() =>
        activity.exampleMessage.exampleMessage,
      MorphCategoryPracticeActivityModel() =>
        activity.exampleMessageInfo.exampleMessage,
      _ => ExampleMessageUtil.getExampleMessage(
        await _analyticsController.getTargetTokenConstruct(
          activity.practiceTarget,
          _l2!.langCodeShort,
        ),
      ),
    };
  }

  bool _autoLaunchNextActivity(MultipleChoicePracticeActivityModel activity) =>
      activity is! VocabAudioPracticeActivityModel;

  void _clearState() {
    _dataService.clear();
    _sessionController.clear();
    AnalyticsPractice.bypassExitConfirmation = true;
    _clearActivityState();
  }

  void _clearActivityState({bool loadingActivity = false}) {
    notifier.clearActivityState();
    activityState.value = loadingActivity
        ? AsyncState.loading()
        : AsyncState.idle();
  }

  void _addLanguageSubscription() {
    _languageStreamSubscription ??= MatrixState
        .pangeaController
        .userController
        .languageStream
        .stream
        .listen((_) => _onLanguageUpdate());
  }

  Future<void> _onLanguageUpdate() async {
    try {
      _clearState();
      await _analyticsController.waitForUpdate();
      await startSession();
    } catch (e) {
      if (mounted) {
        activityState.value = AsyncState.error(e);
      }
    }
  }

  void onHintPressed({bool increment = true}) {
    if (increment) _sessionController.updateHintsPressed();
    notifier.toggleShowHint();
  }

  void _playActivityAudio(MultipleChoicePracticeActivityModel activity) =>
      AnalyticsPracticeUiController.playTargetAudio(
        activity,
        widget.type,
        _l2!.langCodeShort,
      );

  Future<void> startSession() async {
    _clearState();
    await _analyticsController.waitForAnalytics();
    await _sessionController.startSession(widget.type);
    if (mounted) setState(() {});

    if (_sessionController.sessionError != null) {
      AnalyticsPractice.bypassExitConfirmation = true;
    } else {
      progress.value = _sessionController.progress;
      await _continueSession();
    }
  }

  Future<void> _completeSession() async {
    _sessionController.completeSession();
    setState(() {});

    final bonus = _sessionController.bonusUses;
    await _analyticsController.addSessionAnalytics(bonus, _l2!.langCodeShort);
    AnalyticsPractice.bypassExitConfirmation = true;
  }

  Future<void> _continueSession() async {
    if (activityState.value
        is AsyncLoading<MultipleChoicePracticeActivityModel>) {
      return;
    }

    _clearActivityState(loadingActivity: true);

    try {
      final resp = await _sessionController.getNextActivity(
        skipActivity,
        _dataService.prefetchActivityInfo,
      );

      if (resp != null) {
        _playActivityAudio(resp);
        AnalyticsPractice.bypassExitConfirmation = false;
        activityState.value = AsyncState.loaded(resp);
      } else {
        await _completeSession();
      }
    } catch (e) {
      AnalyticsPractice.bypassExitConfirmation = true;
      activityState.value = AsyncState.error(e);
    }
  }

  Future<void> onSelectChoice(String choiceContent) async {
    final activity = this.activity;
    if (activity == null) return;

    // Mark this choice as clicked so it can't be clicked again
    if (notifier.hasSelectedChoice(choiceContent)) return;
    notifier.selectChoice(choiceContent);

    final uses = activity.constructUses(choiceContent);
    _sessionController.submitAnswer(uses);
    await _analyticsController.addCompletedActivityAnalytics(
      uses,
      AnalyticsPracticeUiController.getChoiceTargetId(
        choiceContent,
        widget.type,
      ),
      _l2!.langCodeShort,
    );

    if (!notifier.activityComplete(activity)) return;

    _playActivityAudio(activity);

    if (_autoLaunchNextActivity(activity)) {
      await Future.delayed(
        const Duration(milliseconds: 1000),
        startNextActivity,
      );
    }
  }

  Future<void> startNextActivity() async {
    _sessionController.completeActivity();
    progress.value = _sessionController.progress;

    _sessionController.session?.isComplete == true
        ? await _completeSession()
        : await _continueSession();
  }

  Future<void> skipActivity(MessageActivityRequest request) async {
    // Record a 0 XP use so that activity isn't chosen again soon
    _sessionController.skipActivity();
    progress.value = _sessionController.progress;

    await _analyticsController.addSkippedActivityAnalytics(
      request.target,
      _l2!.langCodeShort,
    );
  }

  @override
  Widget build(BuildContext context) => AnalyticsPracticeView(this);
}
