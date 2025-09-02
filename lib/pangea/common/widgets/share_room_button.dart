import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';

class ShareRoomButton extends StatelessWidget {
  final Room room;
  const ShareRoomButton({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    if (room.classCode == null) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton(
      child: const Icon(Symbols.upload),
      onSelected: (value) async {
        final spaceCode = room.classCode!;
        String toCopy = spaceCode;
        if (value == 0) {
          final String initialUrl =
              kIsWeb ? html.window.origin! : Environment.frontendURL;
          toCopy =
              "$initialUrl/#/join_with_link?${SpaceConstants.classCode}=${room.classCode}";
        }

        await Clipboard.setData(ClipboardData(text: toCopy));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              L10n.of(context).copiedToClipboard,
            ),
          ),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: ListTile(
            title: Text(L10n.of(context).shareSpaceLink),
            contentPadding: const EdgeInsets.all(0),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            title: Text(
              L10n.of(context).shareInviteCode(room.classCode!),
            ),
            contentPadding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
