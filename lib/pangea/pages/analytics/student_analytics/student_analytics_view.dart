// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';

// import '../../../../utils/matrix_sdk_extensions/matrix_locals.dart';
// import '../base_analytics.dart';
// import 'student_analytics.dart';

// class StudentAnalyticsView extends StatelessWidget {
//   final StudentAnalyticsController controller;
//   const StudentAnalyticsView(this.controller, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String pageTitle = L10n.of(context).myLearning;
//     final TabData chatTabData = TabData(
//       type: AnalyticsEntryType.room,
//       icon: Icons.chat_bubble_outline,
//       items: (controller.chats)
//           .map(
//             (c) => TabItem(
//               avatar: c.avatar,
//               displayName:
//                   c.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
//               id: c.id,
//             ),
//           )
//           .toList(),
//       allowNavigateOnSelect: false,
//     );
//     final TabData classTabData = TabData(
//       type: AnalyticsEntryType.space,
//       icon: Icons.workspaces,
//       items: (controller.spaces ?? [])
//           .map(
//             (c) => TabItem(
//               avatar: c.avatar,
//               displayName:
//                   c.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
//               id: c.id,
//             ),
//           )
//           .toList(),
//       allowNavigateOnSelect: false,
//     );

//     return controller.userId != null
//         ? BaseAnalyticsPage(
//             selectedView: controller.widget.selectedView,
//             pageTitle: pageTitle,
//             tabs: [chatTabData, classTabData],
//             alwaysSelected: AnalyticsSelected(
//               controller.userId!,
//               AnalyticsEntryType.student,
//               L10n.of(context).allChatsAndClasses,
//             ),
//             myAnalyticsController: controller,
//             defaultSelected: AnalyticsSelected(
//               controller.userId!,
//               AnalyticsEntryType.student,
//               L10n.of(context).allChatsAndClasses,
//             ),
//             targetLanguages: controller.targetLanguages,
//           )
//         : const SizedBox();
//   }
// }
