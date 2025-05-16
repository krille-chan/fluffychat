// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySuggestionsArea extends StatefulWidget {
  final Axis? scrollDirection;
  final bool showTitle;

  final Room? room;

  const ActivitySuggestionsArea({
    super.key,
    this.scrollDirection,
    this.showTitle = false,
    this.room,
  });
  @override
  ActivitySuggestionsAreaState createState() => ActivitySuggestionsAreaState();
}

class ActivitySuggestionsAreaState extends State<ActivitySuggestionsArea> {
  StreamSubscription? _languageStream;

  @override
  void initState() {
    super.initState();
    _setActivityItems();

    _languageStream ??= MatrixState.pangeaController.userController.stateStream
        .listen((update) {
      if (update is Map<String, dynamic> &&
          (update.containsKey('prev_base_lang') ||
              update.containsKey('prev_target_lang'))) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _setActivityItems(),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _languageStream?.cancel();
    super.dispose();
  }

  bool _loading = true;
  bool get _isColumnMode => FluffyThemes.isColumnMode(context);

  final List<ActivityPlanModel> _activityItems = [];
  final ScrollController _scrollController = ScrollController();
  double get cardHeight => _isColumnMode ? 325.0 : 250.0;
  double get cardWidth => _isColumnMode ? 225.0 : 150.0;

  String get instructionLanguage =>
      MatrixState.pangeaController.languageController.userL1?.langCode ??
      LanguageKeys.defaultLanguage;
  String get targetLanguage =>
      MatrixState.pangeaController.languageController.userL2?.langCode ??
      LanguageKeys.defaultLanguage;

  Future<void> _setActivityItems() async {
    try {
      setState(() {
        _activityItems.clear();
        _loading = true;
      });

      final ActivityPlanRequest request = ActivityPlanRequest(
        topic: "",
        mode: "",
        objective: "",
        media: MediaEnum.nan,
        cefrLevel: LanguageLevelTypeEnum.a1,
        languageOfInstructions: instructionLanguage,
        targetLanguage: targetLanguage,
        numberOfParticipants: 3,
        count: 5,
      );
      final resp = await ActivitySearchRepo.get(request);
      _activityItems.addAll(resp.activityPlans);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final List<Widget> cards = _loading
        ? List.generate(5, (i) {
            return Shimmer.fromColors(
              baseColor: theme.colorScheme.primary.withAlpha(20),
              highlightColor: theme.colorScheme.primary.withAlpha(50),
              child: Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            );
          })
        : _activityItems
            .map((activity) {
              return ActivitySuggestionCard(
                activity: activity,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ActivityPlannerBuilder(
                        initialActivity: activity,
                        room: widget.room,
                        builder: (controller) {
                          return ActivitySuggestionDialog(
                            controller: controller,
                            buttonText: L10n.of(context).launch,
                          );
                        },
                      );
                    },
                  );
                },
                width: cardWidth,
                height: cardHeight,
                onChange: () {
                  if (mounted) setState(() {});
                },
              );
            })
            .cast<Widget>()
            .toList();

    final scrollDirection = widget.scrollDirection ??
        (_isColumnMode ? Axis.horizontal : Axis.vertical);

    return Column(
      spacing: 8.0,
      children: [
        if (widget.showTitle)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  L10n.of(context).chatWithActivities,
                  style: isColumnMode
                      ? theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)
                      : theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.menu_outlined),
                onPressed: () => context.go('/homepage/planner'),
                tooltip: L10n.of(context).activityPlannerTitle,
              ),
            ],
          ),
        Container(
          decoration: const BoxDecoration(),
          child: scrollDirection == Axis.horizontal
              ? Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 8.0,
                        children: cards,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 16.0,
                    spacing: 4.0,
                    children: cards,
                  ),
                ),
        ),
      ],
    );
  }
}
