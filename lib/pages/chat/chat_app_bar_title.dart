import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ChatAppBarTitle extends StatelessWidget {
  final ChatController controller;
  const ChatAppBarTitle(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = controller.room;
    if (room == null) {
      return Container();
    }
    if (controller.selectedEvents.isNotEmpty) {
      return Text(controller.selectedEvents.length.toString());
    }
    final directChatMatrixID = room.directChatMatrixID;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: directChatMatrixID != null
          ? () => showModalBottomSheet(
                context: context,
                builder: (c) => UserBottomSheet(
                  user: room.getUserByMXIDSync(directChatMatrixID),
                  outerContext: context,
                  onMention: () => controller.sendController.text +=
                      '${room.getUserByMXIDSync(directChatMatrixID).mention} ',
                ),
              )
          : () => VRouter.of(context).toSegments(['rooms', room.id, 'details']),
      child: Row(
        children: [
          Avatar(
            mxContent: room.avatar,
            name: room.displayname,
            size: 32,
          ),
          const SizedBox(width: 12),
          Text(
            room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
            maxLines: 1,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
