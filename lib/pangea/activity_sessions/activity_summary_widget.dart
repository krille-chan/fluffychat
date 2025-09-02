import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_list.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class ActivitySummary extends StatelessWidget {
  final Room room;

  final bool showInstructions;
  final VoidCallback toggleInstructions;

  final Function(String)? onTapParticipant;
  final bool Function(String)? canSelectParticipant;
  final bool Function(String)? isParticipantSelected;
  final double Function(ActivityRoleModel?)? getParticipantOpacity;

  const ActivitySummary({
    super.key,
    required this.room,
    required this.showInstructions,
    required this.toggleInstructions,
    this.onTapParticipant,
    this.canSelectParticipant,
    this.isParticipantSelected,
    this.getParticipantOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final activity = room.activityPlan;
    if (activity == null) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        constraints: const BoxConstraints(
          maxWidth: FluffyThemes.columnWidth * 1.5,
        ),
        child: Column(
          spacing: 12.0,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ImageByUrl(
                imageUrl: activity.imageURL,
                width: 80.0,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Text(
              activity.learningObjective,
              style: const TextStyle(fontSize: 12.0),
            ),
            ActivityParticipantList(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        GestureDetector(
                          onTap: toggleInstructions,
                          child: Row(
                            spacing: 4.0,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                showInstructions
                                    ? L10n.of(context).hideInstructions
                                    : L10n.of(context).seeInstructions,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                              Icon(
                                showInstructions
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 12.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showInstructions) ...[
                    ActivitySuggestionCardRow(
                      icon: Symbols.target,
                      iconSize: 16.0,
                      child: Text(
                        activity.learningObjective,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                    ActivitySuggestionCardRow(
                      icon: Symbols.steps,
                      iconSize: 16.0,
                      child: Text(
                        activity.instructions,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                    ActivitySuggestionCardRow(
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
