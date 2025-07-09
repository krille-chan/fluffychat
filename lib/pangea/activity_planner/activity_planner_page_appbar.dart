import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';

class ActivityPlannerPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final PageMode pageMode;
  final String roomID;

  const ActivityPlannerPageAppBar({
    required this.pageMode,
    required this.roomID,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return AppBar(
      leading: FluffyThemes.isColumnMode(context)
          ? Row(
              children: [
                const SizedBox(width: 8.0),
                BackButton(
                  onPressed: Navigator.of(context).pop,
                ),
              ],
            )
          : null,
      title: pageMode == PageMode.savedActivities
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.save),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(l10n.mySavedActivities),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
