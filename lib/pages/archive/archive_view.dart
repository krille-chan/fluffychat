import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/archive/archive.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class ArchiveView extends StatelessWidget {
  final ArchiveController controller;

  const ArchiveView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Room>>(
      future: controller.getArchive(context),
      builder: (BuildContext context, snapshot) => Scaffold(
        appBar: AppBar(
          leading: const Center(child: BackButton()),
          title: Text(L10n.of(context).archive),
          actions: [
            if (snapshot.data?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: controller.forgetAllAction,
                  label: Text(L10n.of(context).clearArchive),
                  icon: const Icon(Icons.cleaning_services_outlined),
                ),
              ),
          ],
        ),
        body: MaxWidthBody(
          withScrolling: false,
          child: Builder(
            builder: (BuildContext context) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    L10n.of(context).oopsSomethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                );
              } else {
                if (controller.archive.isEmpty) {
                  return const Center(
                    child: Icon(Icons.archive_outlined, size: 80),
                  );
                }
                return ListView.builder(
                  itemCount: controller.archive.length,
                  itemBuilder: (BuildContext context, int i) => ChatListItem(
                    controller.archive[i],
                    onForget: () => controller.forgetRoomAction(i),
                    onTap: () => context
                        .go('/rooms/archive/${controller.archive[i].id}'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
