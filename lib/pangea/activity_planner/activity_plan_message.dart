import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';
import 'package:swipe_to_action/swipe_to_action.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../config/app_config.dart';

class ActivityPlanMessage extends StatelessWidget {
  final Event event;
  final Timeline timeline;
  final bool animateIn;
  final void Function()? resetAnimateIn;
  final ChatController controller;
  final bool highlightMarker;

  const ActivityPlanMessage(
    this.event, {
    required this.timeline,
    required this.controller,
    this.animateIn = false,
    this.resetAnimateIn,
    this.highlightMarker = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.pangeaEditingEvent?.eventId == event.eventId) {
        controller.clearEditingEvent();
      }
    });

    final theme = Theme.of(context);
    final color = theme.brightness == Brightness.dark
        ? theme.colorScheme.onSecondary
        : theme.colorScheme.primary;
    final textColor = ThemeData.light().colorScheme.onPrimary;

    final displayEvent = event.getDisplayEvent(timeline);
    const roundedCorner = Radius.circular(AppConfig.borderRadius);
    const borderRadius = BorderRadius.all(roundedCorner);

    final resetAnimateIn = this.resetAnimateIn;
    var animateIn = this.animateIn;

    final row = StatefulBuilder(
      builder: (context, setState) {
        if (animateIn && resetAnimateIn != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            animateIn = false;
            if (context.mounted) {
              setState(resetAnimateIn);
            }
          });
        }
        return AnimatedSize(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          clipBehavior: Clip.none,
          alignment: Alignment.bottomLeft,
          child: animateIn
              ? const SizedBox(height: 0, width: double.infinity)
              : Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => controller.showToolbar(event),
                        onLongPress: () => controller.showToolbar(event),
                        borderRadius:
                            BorderRadius.circular(AppConfig.borderRadius / 2),
                        child: Material(
                          borderRadius:
                              BorderRadius.circular(AppConfig.borderRadius / 2),
                          color: highlightMarker
                              ? theme.colorScheme.secondaryContainer
                                  .withAlpha(128)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => controller.showToolbar(event),
                        onLongPress: () => controller.showToolbar(event),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AnimatedOpacity(
                              opacity: animateIn
                                  ? 0
                                  : event.messageType ==
                                              MessageTypes.BadEncrypted ||
                                          event.status.isSending
                                      ? 0.5
                                      : 1,
                              duration: FluffyThemes.animationDuration,
                              curve: FluffyThemes.animationCurve,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: borderRadius,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CompositedTransformTarget(
                                  link: MatrixState.pAnyState
                                      .layerLinkAndKey(
                                        event.eventId,
                                      )
                                      .link,
                                  child: Container(
                                    key: MatrixState.pAnyState
                                        .layerLinkAndKey(
                                          event.eventId,
                                        )
                                        .key,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        AppConfig.borderRadius,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    constraints: const BoxConstraints(
                                      maxWidth: FluffyThemes.columnWidth * 1.5,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        MessageContent(
                                          displayEvent,
                                          textColor: textColor,
                                          borderRadius: borderRadius,
                                          controller: controller,
                                          immersionMode: false,
                                          timeline: timeline,
                                          linkColor: theme.brightness ==
                                                  Brightness.light
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onPrimary,
                                        ),
                                        if (event.hasAggregatedEvents(
                                          timeline,
                                          RelationshipTypes.edit,
                                        ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4.0,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (event.hasAggregatedEvents(
                                                  timeline,
                                                  RelationshipTypes.edit,
                                                )) ...[
                                                  Icon(
                                                    Icons.edit_outlined,
                                                    color: textColor
                                                        .withAlpha(164),
                                                    size: 14,
                                                  ),
                                                  Text(
                                                    ' - ${displayEvent.originServerTs.localizedTimeShort(context)}',
                                                    style: TextStyle(
                                                      color:
                                                          textColor.withAlpha(
                                                        164,
                                                      ),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 4.0,
                                right: 4.0,
                              ),
                              child: MessageReactions(event, timeline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );

    Widget container;

    container = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Material(
                borderRadius: BorderRadius.circular(AppConfig.borderRadius * 2),
                color: theme.colorScheme.surface.withAlpha(128),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  child: Text(
                    event.originServerTs.localizedTime(context),
                    style: TextStyle(
                      fontSize: 12 * AppConfig.fontSizeFactor,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        row,
      ],
    );

    container = Material(type: MaterialType.transparency, child: container);

    return Center(
      child: Swipeable(
        key: ValueKey(event.eventId),
        background: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(
            child: Icon(Icons.check_outlined),
          ),
        ),
        direction: AppConfig.swipeRightToLeftToReply
            ? SwipeDirection.endToStart
            : SwipeDirection.startToEnd,
        onSwipe: (_) {},
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: FluffyThemes.columnWidth * 2.5,
          ),
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 4.0,
            bottom: 4.0,
          ),
          child: container,
        ),
      ),
    );
  }
}
