import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/archive.dart';
import 'package:fluffychat/widgets/list_items/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ArchiveView extends StatelessWidget {
  final ArchiveController controller;

  const ArchiveView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Room>>(
      future: controller.getArchive(context),
      builder: (BuildContext context, snapshot) => Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text(L10n.of(context).archive),
          actions: [
            if (snapshot.hasData &&
                controller.archive != null &&
                controller.archive.isNotEmpty)
              TextButton(
                onPressed: controller.forgetAllAction,
                child: Text(L10n.of(context).clearArchive),
              )
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                L10n.of(context).oopsSomethingWentWrong,
                textAlign: TextAlign.center,
              ));
            }
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2));
            } else {
              controller.archive = snapshot.data;
              if (controller.archive.isEmpty) {
                return Center(child: Icon(Icons.archive_outlined, size: 80));
              }
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
      ),
    );
  }
}
