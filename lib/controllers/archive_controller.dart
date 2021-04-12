import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/archive_view.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/material.dart';

class Archive extends StatefulWidget {
  @override
  ArchiveController createState() => ArchiveController();
}

class ArchiveController extends State<Archive> {
  List<Room> archive;

  Future<List<Room>> getArchive(BuildContext context) async {
    if (archive != null) return archive;
    return await Matrix.of(context).client.archive;
  }

  void forgetAction(int i) => setState(() => archive.removeAt(i));

  @override
  Widget build(BuildContext context) => ArchiveView(this);
}
