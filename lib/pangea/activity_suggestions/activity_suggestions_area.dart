// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

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

  bool get _isColumnMode => FluffyThemes.isColumnMode(context);

  final List<ActivityPlanModel> _activityItems = [];
  final ScrollController _scrollController = ScrollController();
  final double cardHeight = 235.0;
  double get cardPadding => _isColumnMode ? 8.0 : 0.0;
  double get cardWidth => _isColumnMode ? 225.0 : 150.0;

  void _scrollToItem(int index) {
    final viewportDimension = _scrollController.position.viewportDimension;
    final double scrollOffset = _isColumnMode
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

  void _scrollToNextItem(AxisDirection direction) {
    final currentOffset = _scrollController.offset;
    final scrollAmount = _isColumnMode ? cardWidth : cardHeight;

    _scrollController.animateTo(
      (direction == AxisDirection.left
              ? currentOffset - scrollAmount
              : currentOffset + scrollAmount)
          .clamp(0.0, _scrollController.position.maxScrollExtent),
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
        horizontal: FluffyThemes.isColumnMode(context) ? 16.0 : 4.0,
      ),
      height: _isColumnMode ? cardHeight * 1.5 : null,
      child: _isColumnMode
          ? Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45.0,
                  ), // Space for buttons
                  child: ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    children: cards,
                  ),
                ),

                // Left button
                Positioned(
                  left: 0,
                  top: cardHeight / 1.5 - 20.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .cardColor
                          .withAlpha((0.8 * 255).toInt()),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _scrollToNextItem(AxisDirection.left),
                      iconSize: 24.0,
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),

                // Right button
                Positioned(
                  right: 0,
                  top: cardHeight / 1.5 - 20.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .cardColor
                          .withAlpha((0.8 * 255).toInt()),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _scrollToNextItem(AxisDirection.right),
                      iconSize: 24.0,
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),

                // Create Chat button
                Positioned(
                  right: 0,
                  top: cardHeight / 1.5 + 30.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor
                          .withAlpha((0.9 * 255).toInt()),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_comment, color: Colors.white),
                      tooltip: L10n.of(context).createOwnChat,
                      onPressed: () => context.go('/rooms/newgroup'),
                      iconSize: 24.0,
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox.expand(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 8.0,
                  children: cards,
                ),
              ),
            ),
    );
  }
}
