import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';

class ActivitySuggestionCard extends StatelessWidget {
  final ActivityPlanModel activity;
  final VoidCallback onPressed;

  final double width;
  final double height;
  final double padding;

  const ActivitySuggestionCard({
    super.key,
    required this.activity,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: PressableButton(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(24.0),
        color: theme.colorScheme.primary,
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    width: width,
                    decoration: BoxDecoration(
                      image: activity.imageURL != null
                          ? DecorationImage(
                              image: NetworkImage(activity.imageURL!),
                            )
                          : null,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 12.0,
                        left: 12.0,
                        right: 12.0,
                        bottom: 12.0,
                      ),
                      child: Column(
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
                                            color: theme.colorScheme.primary
                                                .withAlpha(50),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
