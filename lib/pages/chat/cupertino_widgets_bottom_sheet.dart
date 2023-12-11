import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/link.dart';

import 'edit_widgets_dialog.dart';

class CupertinoWidgetsBottomSheet extends StatelessWidget {
  final Room room;

  const CupertinoWidgetsBottomSheet({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(L10n.of(context)!.matrixWidgets),
      actions: [
        ...room.widgets.map(
          (widget) => Link(
            builder: (context, callback) {
              return CupertinoActionSheetAction(
                onPressed: callback ?? () {},
                child: Text(widget.name ?? widget.url),
              );
            },
            target: LinkTarget.blank,
            uri: Uri.parse(widget.url),
          ),
        ),
        CupertinoActionSheetAction(
          child: Text(L10n.of(context)!.editWidgets),
          onPressed: () {
            Navigator.of(context).pop();
            showCupertinoDialog(
              context: context,
              builder: (context) => EditWidgetsDialog(room: room),
              useRootNavigator: false,
            );
          },
        ),
        CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: Text(L10n.of(context)!.cancel),
        ),
      ],
    );
  }
}
