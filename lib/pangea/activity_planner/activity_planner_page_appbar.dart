import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
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
      leadingWidth: FluffyThemes.isColumnMode(context) ? 150.0 : 50.0,
      leading: Container(
        padding: const EdgeInsets.only(left: 16.0),
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        FluffyThemes.isColumnMode(context)
            ? Container(
                width: 150.0,
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => context.go("/rooms/planner"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                  ),
                  child: Text(
                    L10n.of(context).makeYourOwn,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            : const SizedBox(width: 50.0),
      ],
    );
  }
}
