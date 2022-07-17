import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/spaces_hierarchy_proposal.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/public_room_bottom_sheet.dart';

class RecommendedRoomListItem extends StatelessWidget {
  final SpaceRoomsChunk room;

  const RecommendedRoomListItem({Key? key, required this.room})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leading = Avatar(
      mxContent: room.avatarUrl,
      name: room.name,
    );
    final title = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            room.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ),
        // number of joined users
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text.rich(
            TextSpan(children: [
              WidgetSpan(
                  child: Tooltip(
                    child: const Icon(
                      Icons.people_outlined,
                      size: 20,
                    ),
                    message: L10n.of(context)!
                        .numberRoomMembers(room.numJoinedMembers),
                  ),
                  alignment: PlaceholderAlignment.middle,
                  baseline: TextBaseline.alphabetic),
              TextSpan(text: ' ${room.numJoinedMembers}')
            ]),
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodyText2!.color,
            ),
          ),
        ),
      ],
    );
    final subtitle = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            room.topic ?? 'topic',
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2!.color,
            ),
          ),
        ),
      ],
    );
    void handler() => showModalBottomSheet(
          context: context,
          builder: (c) => PublicRoomBottomSheet(
            roomAlias: room.canonicalAlias!,
            outerContext: context,
            chunk: room,
          ),
        );
    if (room.roomType == 'm.space') {
      return Material(
        color: Colors.transparent,
        child: ExpansionTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          onExpansionChanged: (open) {
            if (!open) handler();
          },
          children: [
            SpacesHierarchyProposals(space: room.roomId),
          ],
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          onTap: handler,
        ),
      );
    }
  }
}
