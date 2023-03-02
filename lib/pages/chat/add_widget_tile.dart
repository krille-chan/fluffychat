import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/add_widget_tile_view.dart';

class AddWidgetTile extends StatefulWidget {
  final Room room;

  const AddWidgetTile({Key? key, required this.room}) : super(key: key);

  @override
  State<AddWidgetTile> createState() => AddWidgetTileState();
}

class AddWidgetTileState extends State<AddWidgetTile> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String widgetType = 'm.etherpad';

  late final bool initiallyExpanded;

  String? nameError;
  String? urlError;

  @override
  void initState() {
    initiallyExpanded = widget.room.widgets.isEmpty;
    super.initState();
  }

  void setWidgetType(String value) => setState(() => widgetType = value);

  void addWidget() {
    try {
      nameError = null;
      urlError = null;

      final room = widget.room;
      final name = nameController.text;
      final uri = Uri.tryParse(urlController.text);

      if (name.length < 3) {
        setState(() {
          nameError = L10n.of(context)!.widgetNameError;
        });
        return;
      }

      if (uri == null || uri.scheme != 'https') {
        setState(() {
          urlError = L10n.of(context)!.widgetUrlError;
        });
        return;
      }
      setState(() {});

      late MatrixWidget matrixWidget;
      switch (widgetType) {
        case 'm.etherpad':
          matrixWidget = MatrixWidget.etherpad(room, name, uri);
          break;
        case 'm.jitsi':
          matrixWidget = MatrixWidget.jitsi(room, name, uri);
          break;
        case 'm.video':
          matrixWidget = MatrixWidget.video(room, name, uri);
          break;
        default:
          matrixWidget = MatrixWidget.custom(room, name, uri);
          break;
      }
      widget.room.addWidget(matrixWidget);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context)!.errorAddingWidget)),
      );
    }
  }

  @override
  Widget build(BuildContext context) => AddWidgetTileView(controller: this);
}
