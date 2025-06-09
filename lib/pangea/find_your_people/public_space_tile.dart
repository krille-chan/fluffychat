import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicator_button.dart';
import 'package:fluffychat/pangea/public_spaces/public_room_bottom_sheet.dart';
import 'package:fluffychat/widgets/avatar.dart';

class PublicSpaceTile extends StatelessWidget {
  final PublicRoomsChunk space;
  const PublicSpaceTile({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    final bool isColumnMode = FluffyThemes.isColumnMode(context);

    return HoverButton(
      onPressed: () => PublicRoomBottomSheet.show(
        context: context,
        chunk: space,
      ),
      borderRadius: BorderRadius.circular(10.0),
      hoverOpacity: 0.1,
      child: Padding(
        padding: isColumnMode
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.all(0.0),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: isColumnMode ? 80.0 : 58.0,
              child: Row(
                children: [
                  Avatar(
                    mxContent: space.avatarUrl,
                    name: space.name,
                    size: isColumnMode ? 80.0 : 58.0,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 8.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            space.name ?? '',
                            style: TextStyle(
                              fontSize: isColumnMode ? 20.0 : 14.0,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.group,
                                size: isColumnMode ? 20.0 : 16.0,
                              ),
                              Text(
                                L10n.of(context).countParticipants(
                                  space.numJoinedMembers,
                                ),
                                style: TextStyle(
                                  fontSize: isColumnMode ? 16.0 : 12.0,
                                  height: 1.2,
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
            ),
            if (isColumnMode && space.topic != null && space.topic!.isNotEmpty)
              Text(
                space.topic!,
                style: const TextStyle(
                  fontSize: 16.0,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
