import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pangea/analytics_page/activity_archive.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class ActivityArchiveView extends StatelessWidget {
  final ActivityArchiveState controller;
  const ActivityArchiveView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MaxWidthBody(
      withScrolling: false,
      child: Builder(
        builder: (BuildContext context) {
          if (controller.archive.isEmpty) {
            return const Center(
              child: Icon(Icons.archive_outlined, size: 80),
            );
          }
          return ListView.builder(
            itemCount: controller.archive.length,
            itemBuilder: (BuildContext context, int i) => ChatListItem(
              controller.archive[i],
              onForget: () {
                showFutureLoadingDialog(
                  context: context,
                  future: () => controller.removeArchivedChat(
                    controller.archive[i],
                  ),
                );
              },
              onTap: () =>
                  context.go('/rooms/analytics/${controller.archive[i].id}'),
            ),
          );
        },
      ),
    );
  }
}
