import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page_appbar.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activity_list.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
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
    final theme = Theme.of(context);
    Widget body = const SizedBox();
    switch (pageMode) {
      case PageMode.savedActivities:
        body = BookmarkedActivitiesList(
          room: room,
          controller: this,
        );
        break;
      case PageMode.featuredActivities:
        body = Expanded(
          child: SingleChildScrollView(
            child: ActivitySuggestionsArea(
              scrollDirection: Axis.vertical,
              room: room,
            ),
          ),
        );
        break;
    }

    return Scaffold(
      appBar: ActivityPlannerPageAppBar(
        pageMode: pageMode,
        roomID: widget.roomID,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800.0),
          child: Column(
            children: [
              if ([PageMode.featuredActivities, PageMode.savedActivities]
                  .contains(pageMode))
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    alignment: WrapAlignment.center,
                    children: [
                      FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        label: Row(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Symbols.star_shine, size: 24.0),
                            Text(L10n.of(context).featuredActivities),
                          ],
                        ),
                        selected: pageMode == PageMode.featuredActivities,
                        onSelected: (_) => _setPageMode(
                          PageMode.featuredActivities,
                        ),
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        label: Row(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.save_outlined, size: 24.0),
                            Text(L10n.of(context).saved),
                          ],
                        ),
                        selected: pageMode == PageMode.savedActivities,
                        onSelected: (_) => _setPageMode(
                          PageMode.savedActivities,
                        ),
                      ),
                      FilterChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        label: Row(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomizedSvg(
                              svgUrl:
                                  "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.crayonIconPath}",
                              colorReplacements: {
                                "#CDBEF9": colorToHex(
                                  theme.colorScheme.secondary,
                                ),
                              },
                              height: 24.0,
                              width: 24.0,
                            ),
                            Text(L10n.of(context).createActivity),
                          ],
                        ),
                        selected: false,
                        onSelected: (_) => context.go(
                          '/rooms/${widget.roomID}/details/planner/generator',
                        ),
                      ),
                    ],
                  ),
                ),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
