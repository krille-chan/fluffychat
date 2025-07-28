import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'extensions_view.dart';
import 'package:fluffychat/l10n/l10n.dart';

class Extensions extends StatefulWidget {
  final String roomId;

  const Extensions({super.key, required this.roomId});

  @override
  ExtensionsController createState() => ExtensionsController();
}

class ExtensionsController extends State<Extensions> {
  Room? get _room => Matrix.of(context).client.getRoomById(widget.roomId);

  String get roomId => widget.roomId;

  String get roomName {
    final room = _room;
    if (room != null && room.name.isNotEmpty) {
      return room.name;
    }
    return L10n.of(context).thisRoom.toLowerCase();
  }

  @override
  Widget build(BuildContext context) => ExtensionsView(this);
}

enum ExtensionType {
  live,
}
