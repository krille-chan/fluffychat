import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/list_items/chat_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
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

  final ScrollController _scrollController = ScrollController();
  bool _scrolledToTop = true;

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels > 0 && _scrolledToTop) {
        setState(() => _scrolledToTop = false);
      } else if (_scrollController.position.pixels == 0 && !_scrolledToTop) {
        setState(() => _scrolledToTop = true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).archive),
        elevation: _scrolledToTop ? 0 : null,
      ),
      body: FutureBuilder<List<Room>>(
        future: getArchive(context),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            archive = snapshot.data;
            return ListView.builder(
              controller: _scrollController,
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
