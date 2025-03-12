// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/activity_suggestions/create_chat_card.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySuggestionsArea extends StatefulWidget {
  const ActivitySuggestionsArea({super.key});

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

  final List<ActivityPlanModel> _activityItems = [];
  final ScrollController _scrollController = ScrollController();

  final double cardHeight = 235.0;
  final double cardPadding = 8.0;
  double get cardWidth => FluffyThemes.isColumnMode(context) ? 225.0 : 160.0;

  void _scrollToItem(int index) {
    final viewportDimension = _scrollController.position.viewportDimension;
    final double scrollOffset = FluffyThemes.isColumnMode(context)
        ? index * cardWidth - (viewportDimension / 2) + (cardWidth / 2)
        : (index + 1) * (cardHeight + 8.0);

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final safeOffset = scrollOffset.clamp(0.0, maxScrollExtent);

    if (safeOffset == _scrollController.offset) {
      return;
    }

    _scrollController.animateTo(
      safeOffset,
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
    );
  }

  Future<void> _setActivityItems() async {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = _activityItems
        .mapIndexed((i, activity) {
          return ActivitySuggestionCard(
            activity: activity,
            onPressed: () {
              _scrollToItem(i);
              showDialog(
                context: context,
                builder: (context) {
                  return ActivitySuggestionDialog(
                    activity: activity,
                  );
                },
              );
            },
            width: cardWidth,
            height: cardHeight,
            padding: cardPadding,
          );
        })
        .cast<Widget>()
        .toList();

    cards.insert(
      0,
      CreateChatCard(
        width: cardWidth,
        height: cardHeight,
        padding: cardPadding,
      ),
    );

    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: FluffyThemes.isColumnMode(context) ? 16.0 : 0.0,
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Wrap(
          children: cards,
        ),
      ),
    );
  }
}
