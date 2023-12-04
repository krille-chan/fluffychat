import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../../../utils/matrix_sdk_extensions/matrix_locals.dart';
import '../base_analytics_page.dart';
import 'student_analytics.dart';

class StudentAnalyticsView extends StatelessWidget {
  final StudentAnalyticsController controller;
  const StudentAnalyticsView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Room> chats = controller.chats(context);
    final List<Room> spaces = controller.spaces(context);

    final String pageTitle = L10n.of(context)!.myLearning;
    final TabData chatTabData = TabData(
      type: AnalyticsEntryType.room,
      icon: Icons.chat_bubble_outline,
      items: chats
          .map((c) => TabItem(
                avatar: c.avatar,
                displayName:
                    c.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
                id: c.id,
              ))
          .toList(),
      allowNavigateOnSelect: false,
    );
    final TabData classTabData = TabData(
        type: AnalyticsEntryType.space,
        icon: Icons.workspaces,
        items: spaces
            .map((c) => TabItem(
                  avatar: c.avatar,
                  displayName: c
                      .getLocalizedDisplayname(MatrixLocals(L10n.of(context)!)),
                  id: c.id,
                ))
            .toList(),
        allowNavigateOnSelect: false);

    return controller.userId != null
        ? BaseAnalyticsPage(
            pageTitle: pageTitle,
            tabData1: chatTabData,
            tabData2: classTabData,
            defaultAnalyticsSelected: AnalyticsSelected(
                controller.userId!,
                AnalyticsEntryType.student,
                L10n.of(context)!.allChatsAndClasses),
            refreshData: controller.getClassAndChatAnalytics,
            alwaysSelected: AnalyticsSelected(
                controller.userId!,
                AnalyticsEntryType.student,
                L10n.of(context)!.allChatsAndClasses),
          )
        : const SizedBox();
  }
}
