import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import '../../../../utils/date_time_extension.dart';
import '../../../widgets/avatar.dart';
import '../../../widgets/matrix.dart';
import '../../models/chart_analytics_model.dart';
import 'base_analytics.dart';
import 'list_summary_analytics.dart';

class AnalyticsListTile extends StatefulWidget {
  const AnalyticsListTile({
    super.key,
    required this.model,
    required this.displayName,
    required this.avatar,
    required this.type,
    required this.id,
    required this.allowNavigateOnSelect,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    this.showSpaceAnalytics = true,
  });

  final Uri? avatar;
  final String displayName;
  final AnalyticsEntryType type;
  final String id;
  final ChartAnalyticsModel? model;
  final bool allowNavigateOnSelect;
  final void Function(AnalyticsSelected) onTap;
  final bool selected;
  final bool enabled;
  final bool showSpaceAnalytics;

  @override
  AnalyticsListTileState createState() => AnalyticsListTileState();
}

class AnalyticsListTileState extends State<AnalyticsListTile> {
  @override
  Widget build(BuildContext context) {
    final Room? room = Matrix.of(context).client.getRoomById(widget.id);
    return Material(
      color: widget.selected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Colors.transparent,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: Tooltip(
          message: widget.enabled
              ? ""
              : widget.type == AnalyticsEntryType.room
                  ? L10n.of(context)!.joinToView
                  : L10n.of(context)!.studentAnalyticsNotAvailable,
          child: ListTile(
            leading: widget.type == AnalyticsEntryType.privateChats
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    radius: Avatar.defaultSize / 2,
                    child: const Icon(Icons.forum),
                  )
                : Avatar(
                    mxContent: widget.avatar,
                    name: widget.displayName,
                    littleIcon: room?.roomTypeIcon,
                  ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.displayName,
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
                    widget.model?.lastMessage?.localizedTimeShort(context) ??
                        "",
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: widget.showSpaceAnalytics || !(room?.isSpace ?? false)
                ? ListSummaryAnalytics(
                    chartAnalytics: widget.model,
                  )
                : null,
            selected: widget.selected,
            enabled: widget.enabled,
            onTap: () {
              (room?.isSpace ?? false) && widget.allowNavigateOnSelect
                  ? context.go(
                      '/rooms/analytics/${room!.id}',
                    )
                  : widget.onTap(
                      AnalyticsSelected(
                        widget.id,
                        widget.type,
                        widget.displayName,
                      ),
                    );
            },
            trailing: (room?.isSpace ?? false) &&
                    widget.type != AnalyticsEntryType.privateChats &&
                    widget.allowNavigateOnSelect
                ? const Icon(Icons.chevron_right)
                : null,
          ),
        ),
      ),
    );
  }
}
