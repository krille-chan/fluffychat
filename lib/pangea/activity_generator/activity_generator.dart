import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_generator/activity_generator_view.dart';
import 'package:fluffychat/pangea/activity_generator/activity_mode_list_repo.dart';
import 'package:fluffychat/pangea/activity_generator/activity_plan_generation_repo.dart';
import 'package:fluffychat/pangea/activity_generator/learning_objective_list_repo.dart';
import 'package:fluffychat/pangea/activity_generator/list_request_schema.dart';
import 'package:fluffychat/pangea/activity_generator/media_enum.dart';
import 'package:fluffychat/pangea/activity_generator/topic_list_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityGenerator extends StatefulWidget {
  final String roomID;
  const ActivityGenerator({
    required this.roomID,
    super.key,
  });

  @override
  ActivityGeneratorState createState() => ActivityGeneratorState();
}

class ActivityGeneratorState extends State<ActivityGenerator> {
  bool loading = false;
  Object? error;
  List<ActivityPlanModel>? activities;

  final formKey = GlobalKey<FormState>();

  final topicController = TextEditingController();
  final objectiveController = TextEditingController();
  final modeController = TextEditingController();

  MediaEnum selectedMedia = MediaEnum.nan;
  String? selectedLanguageOfInstructions;
  String? selectedTargetLanguage;
  LanguageLevelTypeEnum? selectedCefrLevel;
  int? selectedNumberOfParticipants;

  String? filename;

  List<ActivitySettingResponseSchema>? topicItems;
  List<ActivitySettingResponseSchema>? modeItems;
  List<ActivitySettingResponseSchema>? objectiveItems;

  @override
  void initState() {
    super.initState();

    selectedLanguageOfInstructions =
        MatrixState.pangeaController.languageController.userL1?.langCode;
    selectedTargetLanguage =
        MatrixState.pangeaController.languageController.userL2?.langCode;
    selectedCefrLevel = LanguageLevelTypeEnum.a1;
    selectedNumberOfParticipants = 3;
    _setMode();
    _setTopic();
    _setObjective();
  }

  @override
  void dispose() {
    topicController.dispose();
    objectiveController.dispose();
    modeController.dispose();
    super.dispose();
  }

  ActivitySettingRequestSchema get req => ActivitySettingRequestSchema(
        langCode:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.defaultLanguage,
      );

  ActivityPlanRequest get planRequest => ActivityPlanRequest(
        topic: topicController.text,
        mode: modeController.text,
        objective: objectiveController.text,
        media: selectedMedia,
        languageOfInstructions: selectedLanguageOfInstructions!,
        targetLanguage: selectedTargetLanguage!,
        cefrLevel: selectedCefrLevel!,
        numberOfParticipants: selectedNumberOfParticipants!,
      );

  Room? get room => Matrix.of(context).client.getRoomById(widget.roomID);

  String? validateNotNull(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).interactiveTranslatorRequired;
    }
    return null;
  }

  String? get _randomTopic => (topicItems?..shuffle())?.first.name;

  String? get _randomObjective => (objectiveItems?..shuffle())?.first.name;

  String? get _randomMode => (modeItems?..shuffle())?.first.name;

  bool get randomizeEnabled =>
      topicItems != null && objectiveItems != null && modeItems != null;

  void randomizeSelections() {
    final selectedTopic = _randomTopic;
    final selectedObjective = _randomObjective;
    final selectedMode = _randomMode;

    if (selectedTopic == null ||
        selectedObjective == null ||
        selectedMode == null) {
      return;
    }

    if (mounted) {
      setState(() {
        topicController.text = selectedTopic;
        objectiveController.text = selectedObjective;
        modeController.text = selectedMode;
      });
    }
  }

  void clearSelections() async {
    setState(() {
      topicController.clear();
      objectiveController.clear();
      modeController.clear();
      selectedMedia = MediaEnum.nan;
      selectedLanguageOfInstructions =
          MatrixState.pangeaController.languageController.userL1?.langCode;
      selectedTargetLanguage =
          MatrixState.pangeaController.languageController.userL2?.langCode;
      selectedCefrLevel = LanguageLevelTypeEnum.a1;
      selectedNumberOfParticipants = 3;
    });
  }

  void setSelectedNumberOfParticipants(int? value) {
    setState(() => selectedNumberOfParticipants = value);
  }

  void setSelectedTargetLanguage(String? value) {
    setState(() => selectedTargetLanguage = value);
  }

  void setSelectedLanguageOfInstructions(String? value) {
    setState(() => selectedLanguageOfInstructions = value);
  }

  void setSelectedCefrLevel(LanguageLevelTypeEnum? value) {
    setState(() => selectedCefrLevel = value);
  }

  ActivitySettingResponseSchema? get _selectedMode {
    return modeItems?.firstWhereOrNull(
      (element) => element.name.toLowerCase() == planRequest.mode.toLowerCase(),
    );
  }

  Future<void> _setTopic() async {
    final topic = await TopicListRepo.get(req);

    if (mounted) {
      setState(() {
        topicItems = topic;
      });
    }
  }

  Future<void> _setMode() async {
    final mode = await ActivityModeListRepo.get(req);

    if (mounted) {
      setState(() {
        modeItems = mode;
      });
      _setModeImageURL();
    }
  }

  Future<void> _setObjective() async {
    final objective = await LearningObjectiveListRepo.get(req);

    if (mounted) {
      setState(() {
        objectiveItems = objective;
      });
    }
  }

  Future<void> _setModeImageURL() async {
    final mode = _selectedMode;
    if (mode == null) return;

    final modeName =
        mode.defaultName.toLowerCase().replaceAll(RegExp(r'\s+'), '');

    if (!mounted || activities == null) return;
    final imageUrl =
        "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.modeImageFileStart}$modeName.jpg";
    setState(() {
      filename = imageUrl;
      for (ActivityPlanModel activity in activities!) {
        activity = ActivityPlanModel(
          req: activity.req,
          title: activity.title,
          learningObjective: activity.learningObjective,
          instructions: activity.instructions,
          vocab: activity.vocab,
          imageURL: imageUrl,
          roles: activity.roles,
          activityId: activity.activityId,
        );
      }
    });
  }

  void clearActivities() {
    setState(() {
      activities = null;
      filename = null;
    });
  }

  Future<void> generate({bool force = false}) async {
    setState(() {
      loading = true;
      error = null;
      activities = null;
    });

    try {
      final resp = await ActivityPlanGenerationRepo.get(
        planRequest,
        force: force,
      );
      activities = resp.activityPlans;
      await _setModeImageURL();
    } catch (e, s) {
      error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'activityPlanRequest': planRequest,
        },
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => ActivityGeneratorView(this);
}
