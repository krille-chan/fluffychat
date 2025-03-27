import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page_appbar.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activity_list.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum PageMode {
  featuredActivities,
  savedActivities,
}

class ActivityPlannerPage extends StatefulWidget {
  final String roomID;
  const ActivityPlannerPage({super.key, required this.roomID});

  @override
  ActivityPlannerPageState createState() => ActivityPlannerPageState();
}

class ActivityPlannerPageState extends State<ActivityPlannerPage> {
  PageMode pageMode = PageMode.featuredActivities;
  Room? get room => Matrix.of(context).client.getRoomById(widget.roomID);

  void _setPageMode(PageMode? mode) {
    if (mode == null) return;
    setState(() => pageMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const SizedBox();
    switch (pageMode) {
      case PageMode.savedActivities:
        body = BookmarkedActivitiesList(
          room: room,
          controller: this,
        );
        break;
      case PageMode.featuredActivities:
        body = const Expanded(
          child: SingleChildScrollView(
            child: ActivitySuggestionsArea(
              scrollDirection: Axis.vertical,
              includeCustomCards: false,
            ),
          ),
        );
        break;
    }

    return Scaffold(
      appBar: ActivityPlannerPageAppBar(
        pageMode: pageMode,
        setPageMode: _setPageMode,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800.0),
          child: Column(
            children: [
              if ([PageMode.featuredActivities, PageMode.savedActivities]
                  .contains(pageMode))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SegmentedButton<PageMode>(
                        selected: {pageMode},
                        onSelectionChanged: (modes) =>
                            _setPageMode(modes.first),
                        segments: [
                          ButtonSegment(
                            value: PageMode.featuredActivities,
                            label: Text(L10n.of(context).featuredActivities),
                          ),
                          ButtonSegment(
                            value: PageMode.savedActivities,
                            label: Text(L10n.of(context).yourBookmarks),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              body,
              if (!FluffyThemes.isColumnMode(context))
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => context.go("/rooms/planner"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 0.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          L10n.of(context).makeYourOwn,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
