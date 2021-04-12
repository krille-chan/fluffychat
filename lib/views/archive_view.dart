import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/controllers/archive_controller.dart';
import 'package:fluffychat/views/widgets/list_items/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ArchiveView extends StatelessWidget {
  final ArchiveController controller;

  const ArchiveView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).archive),
      ),
      body: FutureBuilder<List<Room>>(
        future: controller.getArchive(context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              L10n.of(context).oopsSomethingWentWrong,
              textAlign: TextAlign.center,
            ));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            controller.archive = snapshot.data;
            return ListView.builder(
              itemCount: controller.archive.length,
              itemBuilder: (BuildContext context, int i) => ChatListItem(
                controller.archive[i],
                onForget: controller.forgetAction,
              ),
            );
          }
        },
      ),
    );
  }
}
