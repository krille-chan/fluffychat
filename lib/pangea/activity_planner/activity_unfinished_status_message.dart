import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_planner/activity_room_extension.dart';
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
  int? _selectedRole;

  void _selectRole(int role) {
    if (_selectedRole == role) return;
    if (mounted) setState(() => _selectedRole = role);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("HELLO. remainingRoles: ${widget.room.remainingRoles}");

    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final remainingRoles = widget.room.remainingRoles;
    final completed = widget.room.hasCompletedActivity;

    return Column(
      children: [
        if (!completed) ...[
          if (remainingRoles > 0)
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: List.generate(remainingRoles, (index) {
                return ActivityParticipantIndicator(
                  selected: _selectedRole == index,
                  onTap: () => _selectRole(index),
                );
              }),
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
              : _selectedRole != null
                  ? () {
                      showFutureLoadingDialog(
                        context: context,
                        future: widget.room.joinActivity,
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
