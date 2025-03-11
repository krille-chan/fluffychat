import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';

class ActivitySuggestionCardContent extends StatelessWidget {
  final ActivityPlanModel activity;
  final ActivitySuggestionsAreaState controller;
  final bool isSelected;

  const ActivitySuggestionCardContent({
    super.key,
    required this.activity,
    required this.controller,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActivitySuggestionCardRow(
          icon: Icons.event_note_outlined,
          child: Text(
            activity.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isSelected)
          ActivitySuggestionCardRow(
            icon: Symbols.target,
            child: Text(
              activity.learningObjective,
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (isSelected)
          ActivitySuggestionCardRow(
            icon: Symbols.target,
            child: Text(
              activity.instructions,
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (isSelected)
          ActivitySuggestionCardRow(
            icon: Symbols.dictionary,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 54.0),
              child: SingleChildScrollView(
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
                            color: theme.colorScheme.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Text(
                            vocab.lemma,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        if (!isSelected)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 54.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Align(
                alignment: Alignment.topLeft,
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
                            color: theme.colorScheme.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Text(
                            vocab.lemma,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ActivitySuggestionCardRow(
          icon: Icons.group_outlined,
          child: Text(
            L10n.of(context).countParticipants(
              activity.req.numberOfParticipants,
            ),
            style: theme.textTheme.bodySmall,
          ),
        ),
        if (isSelected)
          Row(
            spacing: 6.0,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.onLaunch(activity),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: Text(
                    L10n.of(context).inviteAndLaunch,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                padding: const EdgeInsets.all(6.0),
                constraints:
                    const BoxConstraints(), // override default min size of 48px
                iconSize: 16.0,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => controller.setEditting(true),
              ),
            ],
          ),
      ],
    );
  }
}
