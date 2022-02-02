import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/link.dart';

class WidgetsBottomSheet extends StatelessWidget {
  final Room room;

  const WidgetsBottomSheet({Key? key, required this.room}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == room.widgets.length) {
          return ListTile(
            title: Text(L10n.of(context)!.integrationsNotImplemented),
            leading: const Icon(Icons.info),
          );
        }
        final widget = room.widgets[index];
        return Link(
          builder: (context, callback) {
            return ListTile(
              title: Text(widget.name),
              subtitle: Text(widget.type),
              onTap: callback,
            );
          },
          target: LinkTarget.blank,
          uri: Uri.parse(widget.url),
        );
      },
      itemCount: room.widgets.length + 1,
    );
  }
}
