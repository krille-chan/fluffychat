import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activities/activity_constants.dart';
import 'package:fluffychat/pangea/activities/activity_duration_popup.dart';
import 'package:fluffychat/pangea/activities/countdown.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivityStateEvent extends StatefulWidget {
  final Event event;

  const ActivityStateEvent({required this.event, super.key});

  @override
  State<ActivityStateEvent> createState() => ActivityStateEventState();
}

class ActivityStateEventState extends State<ActivityStateEvent> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final delay = activityPlan?.endAt != null
        ? activityPlan!.endAt!.difference(now)
        : null;

    if (delay != null && delay > Duration.zero) {
      _timer = Timer(delay, () {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  ActivityPlanModel? get activityPlan {
    try {
      return ActivityPlanModel.fromJson(widget.event.content);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activityPlan == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final double imageWidth = isColumnMode ? 240.0 : 175.0;

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400.0,
        ),
        margin: const EdgeInsets.all(18.0),
        child: Column(
          spacing: 12.0,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: AnimatedSize(
                duration: FluffyThemes.animationDuration,
                child: Text(
                  activityPlan!.markdown,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontSize:
                        AppConfig.fontSizeFactor * AppConfig.messageFontSize,
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: FluffyThemes.animationDuration,
              child: IntrinsicHeight(
                child: Row(
                  spacing: 12.0,
                  children: [
                    Container(
                      height: imageWidth,
                      width: imageWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: activityPlan!.imageURL != null
                            ? activityPlan!.imageURL!.startsWith("mxc")
                                ? MxcImage(
                                    uri: Uri.parse(
                                      activityPlan!.imageURL!,
                                    ),
                                    width: imageWidth,
                                    height: imageWidth,
                                    cacheKey: activityPlan!.bookmarkId,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: activityPlan!.imageURL!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (
                                      context,
                                      url,
                                      error,
                                    ) =>
                                        const SizedBox(),
                                  )
                            : const SizedBox(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 9.0,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: SizedBox.expand(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  foregroundColor:
                                      theme.colorScheme.onPrimaryContainer,
                                ),
                                onPressed: () async {
                                  final Duration? duration = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ActivityDurationPopup(
                                        initialValue: activityPlan?.duration ??
                                            const Duration(days: 1),
                                      );
                                    },
                                  );

                                  if (duration == null) return;

                                  showFutureLoadingDialog(
                                    context: context,
                                    future: () =>
                                        widget.event.room.sendActivityPlan(
                                      activityPlan!.copyWith(
                                        endAt: DateTime.now().add(duration),
                                        duration: duration,
                                      ),
                                    ),
                                  );
                                },
                                child: CountDown(
                                  deadline: activityPlan!.endAt,
                                  iconSize: 20.0,
                                  textSize: 16.0,
                                ),
                              ),
                            ),
                          ), // Optional spacing between buttons
                          Expanded(
                            child: SizedBox.expand(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: theme.colorScheme.error,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                ),
                                onPressed: () {
                                  showFutureLoadingDialog(
                                    context: context,
                                    future: () =>
                                        widget.event.room.sendActivityPlan(
                                      activityPlan!.copyWith(
                                        endAt: DateTime.now(),
                                        duration: Duration.zero,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  L10n.of(context).endNow,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityFinishedEvent extends StatelessWidget {
  const ActivityFinishedEvent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400.0,
        ),
        margin: const EdgeInsets.all(18.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            spacing: 12.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.of(context).activityEnded,
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontSize: 16.0,
                ),
              ),
              CachedNetworkImage(
                width: 120.0,
                imageUrl:
                    "${AppConfig.assetsBaseURL}/${ActivityConstants.activityFinishedAsset}",
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
