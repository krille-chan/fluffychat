import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivitySuggestionCard extends StatelessWidget {
  final ActivityPlanModel activity;
  final Uint8List? image;
  final VoidCallback? onPressed;

  final double width;
  final double height;
  final bool selected;

  final VoidCallback onChange;

  const ActivitySuggestionCard({
    super.key,
    required this.activity,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.onChange,
    this.selected = false,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBookmarked = BookmarkedActivitiesRepo.isBookmarked(activity);

    return PressableButton(
      depressed: selected || onPressed == null,
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(24.0),
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceContainerHighest,
      colorFactor: theme.brightness == Brightness.dark ? 0.6 : 0.2,
      child: Container(
        decoration: BoxDecoration(
          border: selected
              ? Border.all(
                  color: theme.colorScheme.primary,
                )
              : null,
          borderRadius: BorderRadius.circular(24.0),
        ),
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
                  height: width - 16.0,
                  width: width - 16.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  margin: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: image != null
                        ? Image.memory(image!)
                        : activity.imageURL != null
                            ? activity.imageURL!.startsWith("mxc")
                                ? MxcImage(
                                    uri: Uri.parse(activity.imageURL!),
                                    width: width - 16.0,
                                    height: width - 16.0,
                                    cacheKey: activity.bookmarkId,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: activity.imageURL!,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const SizedBox(),
                                  )
                            : null,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 8.0,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                activity.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8.0,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 8.0,
                                children: [
                                  const Icon(
                                    Icons.group_outlined,
                                    size: 12.0,
                                  ),
                                  Text(
                                    "${activity.req.numberOfParticipants}",
                                    style: theme.textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                            if (activity.req.mode.isNotEmpty)
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    activity.req.mode,
                                    style: theme.textTheme.labelSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 4.0,
              right: 4.0,
              child: IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                onPressed: onPressed != null
                    ? () async {
                        await (isBookmarked
                            ? BookmarkedActivitiesRepo.remove(
                                activity.bookmarkId,
                              )
                            : BookmarkedActivitiesRepo.save(activity));
                        onChange();
                      }
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha(180),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
