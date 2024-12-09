// import 'package:fluffychat/widgets/matrix.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';

// import '../base_analytics.dart';
// import 'space_analytics.dart';

// class SpaceAnalyticsView extends StatelessWidget {
//   final SpaceAnalyticsV2Controller controller;
//   const SpaceAnalyticsView(this.controller, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String pageTitle = L10n.of(context).spaceAnalytics;
//     final TabData tab1 = TabData(
//       type: AnalyticsEntryType.room,
//       icon: Icons.chat_bubble_outline,
//       items: controller.chats
//           .map(
//             (room) => TabItem(
//               avatar: room.avatarUrl,
//               displayName: room.name ??
//                   Matrix.of(context)
//                       .client
//                       .getRoomById(room.roomId)
//                       ?.getLocalizedDisplayname() ??
//                   "",
//               id: room.roomId,
//             ),
//           )
//           .toList(),
//     );
//     final TabData tab2 = TabData(
//       type: AnalyticsEntryType.student,
//       icon: Icons.people_outline,
//       items: controller.students
//           .map(
//             (s) => TabItem(
//               avatar: s.avatarUrl,
//               displayName: s.calcDisplayname(),
//               id: s.id,
//             ),
//           )
//           .toList(),
//     );

//     return controller.spaceId != null
//         ? BaseAnalyticsPage(
//             selectedView: controller.widget.selectedView,
//             pageTitle: pageTitle,
//             tabs: [tab1, tab2],
//             alwaysSelected: AnalyticsSelected(
//               controller.spaceId!,
//               AnalyticsEntryType.space,
//               controller.spaceRoom?.name ?? "",
//             ),
//             defaultSelected: AnalyticsSelected(
//               controller.spaceId!,
//               AnalyticsEntryType.space,
//               controller.spaceRoom?.name ?? "",
//             ),
//             targetLanguages: controller.targetLanguages,
//           )
//         : const SizedBox();
//   }
// }
