import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_list.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_details_row.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class ActivitySummary extends StatelessWidget {
  final ActivityPlanModel activity;
  final Room? room;

  final bool showInstructions;
  final VoidCallback toggleInstructions;

  final Function(String)? onTapParticipant;
  final bool Function(String)? canSelectParticipant;
  final bool Function(String)? isParticipantSelected;
  final double Function(ActivityRoleModel?)? getParticipantOpacity;

  const ActivitySummary({
    super.key,
    required this.activity,
    required this.showInstructions,
    required this.toggleInstructions,
    this.onTapParticipant,
    this.canSelectParticipant,
    this.isParticipantSelected,
    this.getParticipantOpacity,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        constraints: const BoxConstraints(
          maxWidth: FluffyThemes.columnWidth * 1.5,
        ),
        child: Column(
          spacing: 4.0,
          children: [
            ImageByUrl(
              imageUrl: activity.imageURL,
              width: 80.0,
              borderRadius: BorderRadius.circular(20),
            ),
            ActivityParticipantList(
              activity: activity,
              room: room,
              onTap: onTapParticipant,
              canSelect: canSelectParticipant,
              isSelected: isParticipantSelected,
              getOpacity: getParticipantOpacity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                spacing: 4.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Text(
                        activity.description,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      TextButton(
                        onPressed: toggleInstructions,
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          backgroundColor: theme.colorScheme.surface,
                        ),
                        child: Text(
                          showInstructions
                              ? L10n.of(context).less
                              : L10n.of(context).more,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showInstructions) ...[
                    Row(
                      spacing: 8.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activity.req.mode,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        Row(
                          spacing: 4.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.school, size: 12.0),
                            Text(
                              activity.req.cefrLevel.string,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ActivitySessionDetailsRow(
                      icon: Symbols.target,
                      iconSize: 16.0,
                      child: Text(
                        activity.learningObjective,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                    ActivitySessionDetailsRow(
                      icon: Symbols.steps,
                      iconSize: 16.0,
                      child: Text(
                        activity.instructions,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                    ActivitySessionDetailsRow(
                      icon: Symbols.dictionary,
                      iconSize: 16.0,
                      child: Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: activity.vocab
                            .map(
                              (vocab) => Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withAlpha(
                                    20,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    24.0,
                                  ),
                                ),
                                child: Text(
                                  vocab.lemma,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
