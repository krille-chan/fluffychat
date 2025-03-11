import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_content.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_edit_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';

class ActivitySuggestionCard extends StatelessWidget {
  final ActivityPlanModel activity;
  final ActivitySuggestionsAreaState controller;
  final VoidCallback onPressed;

  final double width;
  final double height;

  const ActivitySuggestionCard({
    super.key,
    required this.activity,
    required this.controller,
    required this.onPressed,
    required this.width,
    required this.height,
  });

  bool get _isSelected => controller.selectedActivity == activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PressableButton(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(24.0),
        color: theme.colorScheme.primary,
        child: AnimatedContainer(
          duration: FluffyThemes.animationDuration,
          height: controller.isEditing && _isSelected
              ? 675
              : _isSelected
                  ? 400
                  : height,
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
                              image: controller.avatar == null || !_isSelected
                                  ? NetworkImage(activity.imageURL!)
                                  : MemoryImage(controller.avatar!)
                                      as ImageProvider<Object>,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 12.0,
                        right: 12.0,
                        bottom: 12.0,
                      ),
                      child: controller.isEditing && _isSelected
                          ? ActivitySuggestionEditCard(
                              activity: activity,
                              controller: controller,
                            )
                          : ActivitySuggestionCardContent(
                              activity: activity,
                              isSelected: _isSelected,
                              controller: controller,
                            ),
                    ),
                  ),
                ],
              ),
              if (controller.isEditing && _isSelected)
                Positioned(
                  top: 75.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(90),
                    onTap: controller.selectPhoto,
                    child: const CircleAvatar(
                      radius: 16.0,
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
