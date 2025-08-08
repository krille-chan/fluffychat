import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class ActivityUnfinishedStatusMessage extends StatefulWidget {
  final Room room;
  const ActivityUnfinishedStatusMessage({
    super.key,
    required this.room,
  });

  @override
  ActivityUnfinishedStatusMessageState createState() =>
      ActivityUnfinishedStatusMessageState();
}

class ActivityUnfinishedStatusMessageState
    extends State<ActivityUnfinishedStatusMessage> {
  String? _selectedRoleId;

  void _selectRole(String id) {
    if (_selectedRoleId == id) return;
    if (mounted) setState(() => _selectedRoleId = id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final completed = widget.room.hasCompletedActivity;

    final availableRoles = widget.room.activityPlan!.roles;
    final assignedRoles = widget.room.activityRoles?.roles ?? {};
    final remainingRoles = availableRoles.length - assignedRoles.length;

    final unassignedIds = availableRoles.keys
        .where((id) => !assignedRoles.containsKey(id))
        .toList();

    return Column(
      children: [
        if (!completed) ...[
          if (unassignedIds.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 12.0,
              children: unassignedIds.map((id) {
                return ActivityParticipantIndicator(
                  availableRole: availableRoles[id]!,
                  selected: _selectedRoleId == id,
                  onTap: () => _selectRole(id),
                  avatarUrl: availableRoles[id]?.avatarUrl,
                );
              }).toList(),
            ),
          const SizedBox(height: 16.0),
          Text(
            remainingRoles > 0
                ? L10n.of(context).unjoinedActivityMessage
                : L10n.of(context).fullActivityMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isColumnMode ? 16.0 : 12.0,
            ),
          ),
          const SizedBox(height: 16.0),
        ],
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            backgroundColor: theme.colorScheme.primaryContainer,
          ),
          onPressed: completed
              ? () {
                  showFutureLoadingDialog(
                    context: context,
                    future: widget.room.continueActivity,
                  );
                }
              : _selectedRoleId != null
                  ? () {
                      showFutureLoadingDialog(
                        context: context,
                        future: () => widget.room.joinActivity(
                          availableRoles[_selectedRoleId!]!,
                        ),
                      );
                    }
                  : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                completed
                    ? L10n.of(context).continueText
                    : L10n.of(context).confirmRole,
                style: TextStyle(
                  fontSize: isColumnMode ? 16.0 : 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
