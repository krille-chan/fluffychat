import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/list_items/chat_list_item.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  List<Room> archive;

  Future<List<Room>> getArchive(BuildContext context) async {
    if (archive != null) return archive;
    return await Matrix.of(context).client.archive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).archive),
      ),
      body: FutureBuilder<List<Room>>(
        future: getArchive(context),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            archive = snapshot.data;
            return ListView.builder(
              itemCount: archive.length,
              itemBuilder: (BuildContext context, int i) => ChatListItem(
                  archive[i],
                  onForget: () => setState(() => archive.removeAt(i))),
            );
          }
        },
      ),
    );
  }
}
