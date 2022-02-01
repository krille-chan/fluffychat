import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
    return ListTile(
      leading: Avatar(
        mxContent: room.avatar,
        name: room.displayname,
      ),
      contentPadding: EdgeInsets.zero,
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
      title: Text(room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
          maxLines: 1),
      subtitle: StreamBuilder<Object>(
        stream: Matrix.of(context)
            .client
            .onPresence
            .stream
            .where((p) => p.senderId == room.directChatMatrixID)
            .rateLimit(const Duration(seconds: 1)),
        builder: (context, snapshot) => Text(
          room.getLocalizedStatus(context),
          maxLines: 1,
          //overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
