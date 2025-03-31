import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivitySuggestionCard extends StatelessWidget {
  final ActivityPlanModel activity;
  final Uint8List? image;
  final VoidCallback? onPressed;

  final double width;
  final double height;
  final double padding;
  final bool selected;

  final VoidCallback onChange;

  const ActivitySuggestionCard({
    super.key,
    required this.activity,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.padding,
    required this.onChange,
    this.selected = false,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBookmarked = BookmarkedActivitiesRepo.isBookmarked(activity);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: PressableButton(
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
                    height: 100,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: image != null
                          ? Image.memory(image!)
                          : activity.imageURL != null
                              ? activity.imageURL!.startsWith("mxc")
                                  ? MxcImage(
                                      uri: Uri.parse(activity.imageURL!),
                                      width: width,
                                      height: 100,
                                      cacheKey: activity.bookmarkId,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: activity.imageURL!,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error,
                                        color: theme.colorScheme.error,
                                      ),
                                    )
                              : null,
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
              Positioned(
                top: 4.0,
                right: 4.0,
                child: IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  ),
                  onPressed: onPressed != null
                      ? () async {
                          final uniqueID =
                              "${activity.title.replaceAll(RegExp(r'\s+'), '-')}-${DateTime.now().millisecondsSinceEpoch}";
                          await (isBookmarked
                              ? BookmarkedActivitiesRepo.remove(
                                  activity.bookmarkId!,
                                )
                              : BookmarkedActivitiesRepo.save(
                                  activity,
                                  uniqueID,
                                ));
                          onChange();
                        }
                      : null,
                  iconSize: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
