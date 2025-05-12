import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ClassInvitationButtons extends StatelessWidget {
  final String roomId;
  const ClassInvitationButtons({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final Room? room = Matrix.of(context).client.getRoomById(roomId);
    if (room == null) return Text(L10n.of(context).oopsSomethingWentWrong);

    final copyClassLinkListTile = ListTile(
      title: Text(
        L10n.of(context).copyClassLink,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(L10n.of(context).copyClassLinkDesc),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
        child: const Icon(
          Icons.copy_outlined,
        ),
      ),
      onTap: () async {
        final String initialUrl =
            kIsWeb ? html.window.origin! : Environment.frontendURL;
        final link =
            "$initialUrl/#/join_with_link?${SpaceConstants.classCode}=${room.classCode(context)}";
        await Clipboard.setData(ClipboardData(text: link));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).copiedToClipboard)),
        );
      },
    );

    final spaceCode = room.classCode(context);
    Widget? copyCodeListTile;
    if (spaceCode != null) {
      copyCodeListTile = ListTile(
        title: Text(
          "${L10n.of(context).copyClassCode}: $spaceCode",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(L10n.of(context).copyClassCodeDesc),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
          child: const Icon(
            Icons.copy,
          ),
        ),
        onTap: () async {
          //PTODO-Lala: Standarize toast
          //PTODO - explore using Fluffyshare for this
          await Clipboard.setData(ClipboardData(text: spaceCode));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(L10n.of(context).copiedToClipboard)),
          );
        },
      );
    }

    // final inviateWithEmailListTile = ListTile(
    //   enabled: false,
    //   //PTODO - add to copy
    //   title: const Text("Invite with email"),
    //   subtitle: const Text("Coming soon"),
    //   leading: CircleAvatar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     foregroundColor: Colors.white,
    //     radius: Avatar.defaultSize / 2,
    //     child: const Icon(Icons.email_outlined),
    //   ),
    //   //PTODO: Add invite with email functionality
    //   //  onTap: () => VRouter.of(context).to('invite'),
    // );

    // final addFromGoogleClassooomListTile = ListTile(
    //   enabled: false,
    //   //PTODO - add to copy
    //   title: Text(
    //     L10n.of(context).addFromGoogleClassroom,
    //     style: TextStyle(
    //       color: Theme.of(context).colorScheme.secondary,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   subtitle: Text(L10n.of(context).addFromGoogleClassroomDesc),
    //   leading: CircleAvatar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     foregroundColor: Colors.white,
    //     radius: Avatar.defaultSize / 2,
    //     child: SvgPicture.asset(
    //       "assets/pangea/google.svg",
    //       height: 20,
    //       width: 20,
    //     ),
    //   ),
    //   //PTODO: Add via google classroom functionality
    //   //  onTap: () => VRouter.of(context).to('invite'),
    // );

    return Column(
      children: [
        // inviteStudentByUserNameTile,
        copyClassLinkListTile,
        if (copyCodeListTile != null) copyCodeListTile,
        // inviateWithEmailListTile,
        // addFromGoogleClassooomListTile,
      ],
    );
  }
}
