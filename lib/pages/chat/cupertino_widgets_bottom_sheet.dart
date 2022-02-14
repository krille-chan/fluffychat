import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/link.dart';

class CupertinoWidgetsBottomSheet extends StatelessWidget {
  final Room room;

  const CupertinoWidgetsBottomSheet({Key? key, required this.room})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(L10n.of(context)!.matrixWidgets),
      actions: [
        ...room.widgets.map(
          (widget) => Link(
            builder: (context, callback) {
              return CupertinoActionSheetAction(
                child: Text(widget.name ?? widget.url),
                onPressed: callback ?? () {},
              );
            },
            target: LinkTarget.blank,
            uri: Uri.parse(widget.url),
          ),
        ),
        CupertinoActionSheetAction(
          child: Text(L10n.of(context)!.integrationsNotImplemented),
          onPressed: () {},
        ),
        CupertinoActionSheetAction(
          child: Text(L10n.of(context)!.cancel),
          onPressed: Navigator.of(context).pop,
        ),
      ],
    );
  }
}
