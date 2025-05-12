import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';

class SpaceInviteButtons extends StatefulWidget {
  final Room room;
  // final ScrollController scrollController;
  const SpaceInviteButtons({
    super.key,
    required this.room,
    // required this.scrollController,
  });

  @override
  SpaceInviteButtonsController createState() => SpaceInviteButtonsController();
}

class SpaceInviteButtonsController extends State<SpaceInviteButtons> {
  // bool get isVisible {
  //   final context = (widget.key as GlobalKey).currentContext;
  //   if (context == null) return false;

  //   final renderBox = context.findRenderObject() as RenderBox;
  //   final position = renderBox.localToGlobal(Offset.zero);

  //   final size = renderBox.size;
  //   final screenHeight = MediaQuery.of(context).size.height;

  //   debugPrint("position: $position, size: $size, screenHeight: $screenHeight");

  //   // Check if any part of the widget is within the visible range
  //   return position.dy + size.height > 0 && position.dy < screenHeight;
  // }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => debugPrint("isVisible: $isVisible"),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final spaceCode = widget.room.classCode(context);
    if (spaceCode == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 150.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              right: 16.0,
              left: 16.0,
            ),
            child: ElevatedButton(
              child: Row(
                spacing: 8.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.share_outlined,
                  ),
                  Text(L10n.of(context).shareSpaceLink),
                ],
              ),
              onPressed: () async {
                final String initialUrl =
                    kIsWeb ? html.window.origin! : Environment.frontendURL;
                final link =
                    "$initialUrl/#/join_with_link?${SpaceConstants.classCode}=$spaceCode";
                await Clipboard.setData(
                  ClipboardData(
                    text: link,
                  ),
                );
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              right: 16.0,
              left: 16.0,
            ),
            child: ElevatedButton(
              child: Row(
                spacing: 8.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.share_outlined,
                  ),
                  Text(L10n.of(context).shareInviteCode(spaceCode)),
                ],
              ),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: spaceCode));
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
            ),
          ),
        ],
      ),
    );
  }
}
