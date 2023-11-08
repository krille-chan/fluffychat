import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../../utils/matrix_sdk_extensions/matrix_locals.dart';
import '../base_analytics_page.dart';
import 'class_analytics.dart';

class ClassAnalyticsView extends StatelessWidget {
  final ClassAnalyticsV2Controller controller;
  const ClassAnalyticsView(this.controller, {Key? key}) : super(key: key);

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
              avatar: room.avatar,
              displayName:
                  room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
              id: room.id,
            ),
          )
          .toList(),
    );
    final TabData tab2 = TabData(
      type: AnalyticsEntryType.student,
      icon: Icons.people_outline,
      items: controller.students
          .map((s) => TabItem(
                avatar: s.avatarUrl,
                displayName: s.displayName ?? "unknown",
                id: s.id,
              ))
          .toList(),
    );

    return controller.classId != null
        ? BaseAnalyticsPage(
            pageTitle: pageTitle,
            tabData1: tab1,
            tabData2: tab2,
            defaultAnalyticsSelected: AnalyticsSelected(
              controller.classId!,
              AnalyticsEntryType.space,
              controller.className(context),
            ),
            refreshData: controller.getChatAndStudentAnalytics,
            alwaysSelected: AnalyticsSelected(
              controller.classId!,
              AnalyticsEntryType.space,
              controller.className(context),
            ),
          )
        : const SizedBox();
  }
}
