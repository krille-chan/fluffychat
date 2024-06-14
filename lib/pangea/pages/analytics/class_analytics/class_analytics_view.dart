import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../base_analytics.dart';
import 'class_analytics.dart';

class ClassAnalyticsView extends StatelessWidget {
  final ClassAnalyticsV2Controller controller;
  const ClassAnalyticsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    // final String pageTitle =
    //     "${L10n.of(context)!.classAnalytics}: ${controller.className(context)}";
    final String pageTitle = L10n.of(context)!.classAnalytics;
    final TabData tab1 = TabData(
      type: AnalyticsEntryType.room,
      icon: Icons.chat_bubble_outline,
      items: controller.chats
          .map(
            (room) => TabItem(
              avatar: room.avatarUrl,
              displayName: room.name ??
                  Matrix.of(context)
                      .client
                      .getRoomById(room.roomId)
                      ?.getLocalizedDisplayname() ??
                  "",
              id: room.roomId,
            ),
          )
          .toList(),
    );
    final TabData tab2 = TabData(
      type: AnalyticsEntryType.student,
      icon: Icons.people_outline,
      items: controller.students
          .map(
            (s) => TabItem(
              avatar: s.avatarUrl,
              displayName: s.calcDisplayname(),
              id: s.id,
            ),
          )
          .toList(),
    );

    return controller.classId != null
        ? BaseAnalyticsPage(
            selectedView: controller.widget.selectedView,
            pageTitle: pageTitle,
            tabs: [tab1, tab2],
            alwaysSelected: AnalyticsSelected(
              controller.classId!,
              AnalyticsEntryType.space,
              controller.classRoom?.name ?? "",
            ),
            defaultSelected: AnalyticsSelected(
              controller.classId!,
              AnalyticsEntryType.space,
              controller.classRoom?.name ?? "",
            ),
          )
        : const SizedBox();
  }
}
