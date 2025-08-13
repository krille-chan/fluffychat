import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_list_tile.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class ActivityPinnedMessage extends StatefulWidget {
  final ChatController controller;
  const ActivityPinnedMessage(this.controller, {super.key});

  @override
  State<ActivityPinnedMessage> createState() => ActivityPinnedMessageState();
}

class ActivityPinnedMessageState extends State<ActivityPinnedMessage> {
  bool _showDropdown = false;

  Room get room => widget.controller.room;

  void _scrollToActivity() {
    final eventId = widget.controller.timeline?.events
        .firstWhereOrNull(
          (e) => e.type == PangeaEventTypes.activityPlan,
        )
        ?.eventId;
    if (eventId == null) return;
    widget.controller.scrollToEventId(eventId);
  }

  void _setShowDropdown(bool value) {
    if (value != _showDropdown) {
      setState(() {
        _showDropdown = value;
      });
    }
  }

  Future<void> _finishActivity({bool forAll = false}) async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        forAll
            ? await room.finishActivityForAll()
            : await room.finishActivity();
        if (mounted) {
          _setShowDropdown(false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // if the room has no activity, or if it doesn't have the permission
    // levels for sending the required events, don't show the pinned message
    if (!room.isActiveInActivity) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: _showDropdown ? 0 : null,
      child: Column(
        children: [
          AnimatedContainer(
            duration: FluffyThemes.animationDuration,
            decoration: BoxDecoration(
              color: _showDropdown
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
            ),
            child: ChatAppBarListTile(
              title: "🎯 ${room.activityPlan!.learningObjective}",
              leading: const SizedBox(width: 18.0),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ElevatedButton(
                  onPressed:
                      _showDropdown ? null : () => _setShowDropdown(true),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    backgroundColor: AppConfig.yellowDark,
                    foregroundColor: theme.colorScheme.surface,
                    disabledBackgroundColor:
                        AppConfig.yellowDark.withAlpha(100),
                    disabledForegroundColor:
                        theme.colorScheme.surface.withAlpha(100),
                  ),
                  child: Text(
                    L10n.of(context).endActivityTitle,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              onTap: _scrollToActivity,
            ),
          ),
          AnimatedSize(
            duration: FluffyThemes.animationDuration,
            curve: Curves.easeInOut,
            child: ClipRect(
              child: _showDropdown
                  ? Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        spacing: 12.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            L10n.of(context).endActivityDesc,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isColumnMode ? 16.0 : 12.0,
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl:
                                "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.endActivityAssetPath}",
                            width: isColumnMode ? 240.0 : 120.0,
                          ),
                          Row(
                            spacing: 12.0,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0,
                                    ),
                                    foregroundColor:
                                        theme.colorScheme.onSecondary,
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                  ),
                                  onPressed: _finishActivity,
                                  child: Text(
                                    L10n.of(context).endActivityTitle,
                                    style: TextStyle(
                                      fontSize: isColumnMode ? 16.0 : 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              if (room.isRoomAdmin)
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      foregroundColor:
                                          theme.colorScheme.onErrorContainer,
                                      backgroundColor:
                                          theme.colorScheme.errorContainer,
                                    ),
                                    onPressed: () =>
                                        _finishActivity(forAll: true),
                                    child: Text(
                                      L10n.of(context).endForAll,
                                      style: TextStyle(
                                        fontSize: isColumnMode ? 16.0 : 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          if (_showDropdown)
            Expanded(
              child: GestureDetector(
                onTap: () => _setShowDropdown(false),
                child: Container(color: Colors.black.withAlpha(100)),
              ),
            ),
        ],
      ),
    );
  }
}
