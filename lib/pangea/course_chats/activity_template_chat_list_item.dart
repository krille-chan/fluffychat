import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_chats/extended_space_rooms_chunk.dart';
import 'package:fluffychat/pangea/course_chats/open_roles_indicator.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ActivityTemplateChatListItem extends StatelessWidget {
  final Room space;
  final Function(SpaceRoomsChunk) joinActivity;
  final ActivityPlanModel activity;
  final List<ExtendedSpaceRoomsChunk> sessions;

  const ActivityTemplateChatListItem({
    super.key,
    required this.space,
    required this.joinActivity,
    required this.activity,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Column(
        spacing: 10.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: ImageByUrl(
                imageUrl: activity.imageURL,
                width: Avatar.defaultSize,
                borderRadius: BorderRadius.circular(
                  AppConfig.borderRadius / 2,
                ),
                replacement: Avatar(
                  name: activity.title,
                  borderRadius: BorderRadius.circular(
                    AppConfig.borderRadius / 2,
                  ),
                ),
              ),
              trailing: Row(
                spacing: 2.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 8.0,
                  ),
                  Text(
                    "${sessions.length}",
                    style: const TextStyle(
                      fontSize: 8.0,
                    ),
                  ),
                ],
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      activity.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...sessions.map(
            (e) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                  bottom: 4.0,
                  right: 4.0,
                  left: 14.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OpenRolesIndicator(
                        totalSlots: activity.req.numberOfParticipants,
                        userIds: e.userIds,
                        space: space,
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                      width: 40.0,
                      child: ElevatedButton(
                        onPressed: () => joinActivity(e.chunk),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                        ),
                        child: Text(
                          L10n.of(context).join,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
