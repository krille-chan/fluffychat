// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySuggestionsArea extends StatefulWidget {
  final Axis? scrollDirection;
  final bool showCreateChatCard;
  final bool showMakeActivityCard;

  final Room? room;

  const ActivitySuggestionsArea({
    super.key,
    this.scrollDirection,
    this.showCreateChatCard = true,
    this.showMakeActivityCard = true,
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

  bool get _isColumnMode => FluffyThemes.isColumnMode(context);

  final List<ActivityPlanModel> _activityItems = [];
  final ScrollController _scrollController = ScrollController();
  double get cardHeight => _isColumnMode ? 315.0 : 240.0;
  double get cardPadding => _isColumnMode ? 8.0 : 0.0;
  double get cardWidth => _isColumnMode ? 225.0 : 150.0;

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
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = _activityItems
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
            padding: cardPadding,
            onChange: () {
              if (mounted) setState(() {});
            },
          );
        })
        .cast<Widget>()
        .toList();

    final scrollDirection = widget.scrollDirection ??
        (_isColumnMode ? Axis.horizontal : Axis.vertical);

    return scrollDirection == Axis.horizontal
        ? ConstrainedBox(
            constraints: BoxConstraints(maxHeight: cardHeight + 36.0),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                children: cards,
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
          );
  }
}
