// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
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
  @override
  void initState() {
    super.initState();
    _setActivityItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _loading = true;
  bool get _isColumnMode => FluffyThemes.isColumnMode(context);

  final List<ActivityPlanModel> _activityItems = [];
  final ScrollController _scrollController = ScrollController();
  double get cardHeight => _isColumnMode ? 325.0 : 250.0;
  double get cardWidth => _isColumnMode ? 225.0 : 150.0;

  Future<void> _setActivityItems() async {
    try {
      final ActivityPlanRequest request = ActivityPlanRequest(
        topic: "",
        mode: "",
        objective: "",
        media: MediaEnum.nan,
        cefrLevel: LanguageLevelTypeEnum.a1,
        languageOfInstructions: LanguageKeys.defaultLanguage,
        targetLanguage:
            MatrixState.pangeaController.languageController.userL2?.langCode ??
                LanguageKeys.defaultLanguage,
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
                      return ActivitySuggestionDialog(
                        activity: activity,
                        buttonText: L10n.of(context).inviteAndLaunch,
                        room: widget.room,
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
                  L10n.of(context).startChat,
                  style: isColumnMode
                      ? theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)
                      : theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                spacing: 8.0,
                children: [
                  InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => context.go('/rooms/newgroup'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 10.0,
                      ),
                      child: Row(
                        spacing: 8.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomizedSvg(
                            svgUrl:
                                "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.plusIconPath}",
                            colorReplacements: {
                              "#CDBEF9": colorToHex(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            },
                            height: 16.0,
                            width: 16.0,
                          ),
                          Text(
                            isColumnMode
                                ? L10n.of(context).createOwnChat
                                : L10n.of(context).chat,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => context.go('/rooms/planner'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 10.0,
                      ),
                      child: Row(
                        spacing: 8.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomizedSvg(
                            svgUrl:
                                "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.crayonIconPath}",
                            colorReplacements: {
                              "#CDBEF9": colorToHex(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            },
                            height: 16.0,
                            width: 16.0,
                          ),
                          Text(
                            isColumnMode
                                ? L10n.of(context).makeYourOwnActivity
                                : L10n.of(context).createActivity,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
