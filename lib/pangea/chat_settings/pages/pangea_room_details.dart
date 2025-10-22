import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/chat_settings/pages/chat_details_content.dart';
import 'package:fluffychat/pangea/chat_settings/pages/space_details_content.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PangeaRoomDetailsView extends StatelessWidget {
  final ChatDetailsController controller;

  const PangeaRoomDetailsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(controller.roomId!);
    if (room == null || room.membership == Membership.leave) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    return StreamBuilder(
      stream: room.client.onRoomState.stream
          .where((update) => update.roomId == room.id),
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            appBar: room.isSpace
                ? null
                : AppBar(
                    leading: controller.widget.embeddedCloseButton ??
                        const Center(child: BackButton()),
                  ),
            body: Padding(
              padding: const EdgeInsetsGeometry.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: MaxWidthBody(
                maxWidth: 900,
                showBorder: false,
                innerPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                withScrolling: !room.isSpace,
                child: room.isSpace
                    ? SpaceDetailsContent(controller, room)
                    : ChatDetailsContent(controller, room),
              ),
            ),
          ),
        );
      },
    );
  }
}
