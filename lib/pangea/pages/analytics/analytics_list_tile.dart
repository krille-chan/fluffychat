import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import '../../../../utils/date_time_extension.dart';
import '../../../widgets/avatar.dart';
import '../../../widgets/matrix.dart';
import '../../models/chart_analytics_model.dart';
import 'base_analytics_page.dart';
import 'list_summary_analytics.dart';

class AnalyticsListTile extends StatelessWidget {
  const AnalyticsListTile({
    Key? key,
    required this.model,
    required this.displayName,
    required this.avatar,
    required this.type,
    required this.id,
    required this.selected,
    required this.onTap,
    required this.allowNavigateOnSelect,
  }) : super(key: key);

  final Uri? avatar;
  final String displayName;
  final AnalyticsEntryType type;
  final String id;
  final ChartAnalyticsModel? model;
  final bool selected;
  final bool allowNavigateOnSelect;

  final void Function(AnalyticsSelected) onTap;

  @override
  Widget build(BuildContext context) {
    final Room? room = Matrix.of(context).client.getRoomById(id);
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Colors.transparent,
      child: ListTile(
        leading: type == AnalyticsEntryType.privateChats
            ? CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                radius: Avatar.defaultSize / 2,
                child: const Icon(Icons.forum),
              )
            : Avatar(
                mxContent: avatar,
                name: displayName,
                littleIcon: room?.roomTypeIcon,
              ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
            Tooltip(
              message: L10n.of(context)!.timeOfLastMessage,
              child: Text(
                model?.lastMessage?.localizedTimeShort(context) ?? "",
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
            ),
          ],
        ),
        subtitle: ListSummaryAnalytics(
          chartAnalytics: model,
        ),
        selected: selected,
        onTap: () => (room?.isSpace ?? false) && allowNavigateOnSelect
            ? context.go(
                '/rooms/analytics/${room!.id}',
              )
            : onTap(
                AnalyticsSelected(
                  id,
                  type,
                  displayName,
                ),
              ),
        trailing: (room?.isSpace ?? false) &&
                type != AnalyticsEntryType.privateChats &&
                allowNavigateOnSelect
            ? const Icon(Icons.chevron_right)
            : null,
      ),
    );
  }
}
