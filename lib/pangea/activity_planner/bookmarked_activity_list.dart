import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/user/controllers/user_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class BookmarkedActivitiesList extends StatefulWidget {
  final Room room;
  const BookmarkedActivitiesList({
    super.key,
    required this.room,
  });

  @override
  BookmarkedActivitiesListState createState() =>
      BookmarkedActivitiesListState();
}

class BookmarkedActivitiesListState extends State<BookmarkedActivitiesList> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarkedActivities();
  }

  List<ActivityPlanModel> get _bookmarkedActivities =>
      _userController.getBookmarkedActivitiesSync();

  bool get _isColumnMode => FluffyThemes.isColumnMode(context);

  double get cardHeight => _isColumnMode ? 325.0 : 250.0;
  double get cardWidth => _isColumnMode ? 225.0 : 150.0;

  UserController get _userController =>
      MatrixState.pangeaController.userController;

  Future<void> _loadBookmarkedActivities() async {
    try {
      setState(() => _loading = true);
      await _userController.getBookmarkedActivities();
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'roomId': widget.room.id,
        },
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (_bookmarkedActivities.isEmpty) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            l10n.noSavedActivities,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 800.0,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 16.0,
            spacing: 4.0,
            children: _bookmarkedActivities.map((activity) {
              return ActivityPlannerBuilder(
                initialActivity: activity,
                room: widget.room,
                builder: (controller) {
                  return ActivitySuggestionCard(
                    controller: controller,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ActivitySuggestionDialog(
                            controller: controller,
                            buttonText: l10n.launchActivityButton,
                          );
                        },
                      );
                    },
                    width: cardWidth,
                    height: cardHeight,
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
