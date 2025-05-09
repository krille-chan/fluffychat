// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/visibility.dart' as visible;

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

class ClassNameHeader extends StatelessWidget {
  final Room room;
  final ChatDetailsController controller;
  const ClassNameHeader({
    super.key,
    required this.room,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: !room.isDirectChat && room.canSendDefaultStates
          ? controller.setDisplaynameAction
          : null,
      onHover: !room.isDirectChat && room.canSendDefaultStates
          ? controller.hoverEditNameIcon
          : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25),
      ),
      icon: visible.Visibility(
        visible: controller.showEditNameIcon,
        child: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      label: room.isDirectChat
          ? Text(
              L10n.of(context).chatDetails,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            )
          : room.nameAndRoomTypeIcon(
              TextStyle(
                fontSize: 20,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
      // icon: Text(
      //   room.getLocalizedDisplayname(
      //     MatrixLocals(L10n.of(context)),
      //   ),
      //   style: TextStyle(
      //     fontSize: 20,
      //     color: Theme.of(context).textTheme.bodyText1!.color,
      //   ),
      // ),
    );
  }
}
