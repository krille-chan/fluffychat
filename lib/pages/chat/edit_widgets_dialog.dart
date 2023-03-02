import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'add_widget_tile.dart';

class EditWidgetsDialog extends StatelessWidget {
  final Room room;

  const EditWidgetsDialog({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(L10n.of(context)!.editWidgets),
      children: [
        ...room.widgets.map(
          (e) => ListTile(
            title: Text(e.name ?? e.type),
            leading: IconButton(
              onPressed: () {
                room.deleteWidget(e.id!);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ),
        AddWidgetTile(room: room),
      ],
    );
  }
}
