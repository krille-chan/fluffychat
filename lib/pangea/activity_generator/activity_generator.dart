import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_generator/activity_generator_view.dart';
import 'package:fluffychat/pangea/activity_planner/activity_mode_list_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_generation_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_response.dart';
import 'package:fluffychat/pangea/activity_planner/learning_objective_list_repo.dart';
import 'package:fluffychat/pangea/activity_planner/list_request_schema.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_planner/topic_list_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityGenerator extends StatefulWidget {
  const ActivityGenerator({super.key});

  @override
  ActivityGeneratorState createState() => ActivityGeneratorState();
}

class ActivityGeneratorState extends State<ActivityGenerator> {
  bool loading = false;
  String? error;
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

  String? avatarURL;
  String? filename;

  @override
  void initState() {
    super.initState();
    selectedLanguageOfInstructions =
        MatrixState.pangeaController.languageController.userL1?.langCode;
    selectedTargetLanguage =
        MatrixState.pangeaController.languageController.userL2?.langCode;
    selectedCefrLevel = LanguageLevelTypeEnum.a1;
    selectedNumberOfParticipants = 3;
    _setModeImageURL();
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
            MatrixState.pangeaController.languageController.userL2?.langCode ??
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

  Future<List<ActivitySettingResponseSchema>> get topicItems =>
      TopicListRepo.get(req);

  Future<List<ActivitySettingResponseSchema>> get modeItems =>
      ActivityModeListRepo.get(req);

  Future<List<ActivitySettingResponseSchema>> get objectiveItems =>
      LearningObjectiveListRepo.get(req);

  String? validateNotNull(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).interactiveTranslatorRequired;
    }
    return null;
  }

  Future<String> _randomTopic() async {
    final topics = await topicItems;
    return (topics..shuffle()).first.name;
  }

  Future<String> _randomObjective() async {
    final objectives = await objectiveItems;
    return (objectives..shuffle()).first.name;
  }

  Future<String> _randomMode() async {
    final modes = await modeItems;
    return (modes..shuffle()).first.name;
  }

  void randomizeSelections() async {
    final selectedTopic = await _randomTopic();
    final selectedObjective = await _randomObjective();
    final selectedMode = await _randomMode();

    setState(() {
      topicController.text = selectedTopic;
      objectiveController.text = selectedObjective;
      modeController.text = selectedMode;
    });
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

  void setSelectedMedia(MediaEnum? value) {
    if (value == null) return;
    setState(() => selectedMedia = value);
  }

  Future<ActivitySettingResponseSchema?> get _selectedMode async {
    final modes = await modeItems;
    return modes.firstWhereOrNull(
      (element) => element.name.toLowerCase() == planRequest.mode.toLowerCase(),
    );
  }

  Future<void> _setModeImageURL() async {
    final mode = await _selectedMode;
    if (mode == null) return;

    final modeName =
        mode.defaultName.toLowerCase().replaceAll(RegExp(r'\s+'), '');

    if (!mounted) return;
    setState(() {
      filename =
          "${ActivitySuggestionsConstants.modeImageFileStart}$modeName.jpg";
      avatarURL = "${AppConfig.assetsBaseURL}/$filename";
    });
  }

  Future<void> onEdit(int index, ActivityPlanModel updatedActivity) async {
    // in this case we're editing an activity plan that was generated recently
    // via the repo and should be updated in the cached response
    if (activities != null) {
      activities?[index] = updatedActivity;
      ActivityPlanGenerationRepo.set(
        planRequest,
        ActivityPlanResponse(activityPlans: activities!),
      );
    }

    setState(() {});
  }

  void update() => setState(() {});

  Future<void> generate() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      await _setModeImageURL();
      final resp = await ActivityPlanGenerationRepo.get(planRequest);
      for (final activity in resp.activityPlans) {
        activity.imageURL = avatarURL;
      }
      activities = resp.activityPlans;
    } catch (e, s) {
      error = e.toString();
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
