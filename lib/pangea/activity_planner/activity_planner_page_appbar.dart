import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';

class ActivityPlannerPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final PageMode pageMode;
  final Function(PageMode) setPageMode;
  const ActivityPlannerPageAppBar({
    required this.pageMode,
    required this.setPageMode,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return AppBar(
      leading: pageMode != PageMode.settings &&
              pageMode != PageMode.generatedActivities
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            )
          : IconButton(
              onPressed: () => setPageMode(
                pageMode == PageMode.settings
                    ? PageMode.featuredActivities
                    : PageMode.settings,
              ),
              icon: const Icon(Icons.arrow_back),
            ),
      title: pageMode == PageMode.savedActivities
          ? Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmarks),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(l10n.myBookmarkedActivities),
                  ),
                ],
              ),
            )
          : Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_note_outlined),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.activityPlannerTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        IconButton(
          onPressed: () => setPageMode(PageMode.settings),
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}
