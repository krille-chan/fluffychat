import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_response_model.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ActivityResultsCarousel extends StatelessWidget {
  final ActivityRoleModel selectedRole;
  final ParticipantSummaryModel summary;

  final VoidCallback? moveLeft;
  final VoidCallback? moveRight;

  final User? user;

  const ActivityResultsCarousel({
    super.key,
    required this.selectedRole,
    required this.moveLeft,
    required this.moveRight,
    required this.summary,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: moveLeft,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: PressableButton(
            onPressed: null,
            borderRadius: BorderRadius.circular(24.0),
            color: theme.brightness == Brightness.dark
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            colorFactor: theme.brightness == Brightness.dark ? 0.6 : 0.2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
              ),
              width: isColumnMode ? 225.0 : 175.0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Avatar(
                        size: isColumnMode ? 60.0 : 40.0,
                        mxContent: user?.avatarUrl,
                        name: user?.calcDisplayname() ??
                            summary.participantId.localpart,
                        userId: selectedRole.userId,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      selectedRole.role != null
                          ? "${selectedRole.role!} | ${selectedRole.userId.localpart}"
                          : "${selectedRole.userId.localpart}",
                      style: TextStyle(fontSize: isColumnMode ? 16.0 : 12.0),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      summary.feedback,
                      style: TextStyle(fontSize: isColumnMode ? 12.0 : 8.0),
                    ),
                    const SizedBox(height: 10.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            spacing: 4.0,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.school, size: 12.0),
                              Text(
                                summary.cefrLevel,
                                style: TextStyle(
                                  fontSize: isColumnMode ? 12.0 : 8.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...summary.superlatives.map(
                          (sup) => Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              sup,
                              style: TextStyle(
                                fontSize: isColumnMode ? 12.0 : 8.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: moveRight,
        ),
      ],
    );
  }
}
