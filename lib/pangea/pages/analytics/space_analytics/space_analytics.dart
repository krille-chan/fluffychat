// import 'dart:async';
// import 'dart:developer';

// import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
// import 'package:fluffychat/pangea/enum/bar_chart_view_enum.dart';
// import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
// import 'package:fluffychat/pangea/models/language_model.dart';
// import 'package:fluffychat/pangea/utils/error_handler.dart';
// import 'package:fluffychat/pangea/widgets/common/list_placeholder.dart';
// import 'package:fluffychat/pangea/widgets/common/p_circular_loader.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:matrix/matrix.dart';

// import '../../../../widgets/matrix.dart';
// import '../../../utils/sync_status_util_v2.dart';

// class SpaceAnalyticsPage extends StatefulWidget {
//   final BarChartViewSelection selectedView;
//   const SpaceAnalyticsPage({super.key, required this.selectedView});

//   @override
//   State<SpaceAnalyticsPage> createState() => SpaceAnalyticsV2Controller();
// }

// class SpaceAnalyticsV2Controller extends State<SpaceAnalyticsPage> {
//   bool _initialized = false;
//   // StreamSubscription<Event>? stateSub;
//   // Timer? refreshTimer;

//   List<SpaceRoomsChunk> chats = [];
//   List<User> students = [];
//   String? get spaceId => GoRouterState.of(context).pathParameters['spaceid'];
//   Room? _spaceRoom;
//   List<LanguageModel> targetLanguages = [];

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () async {
//       if (spaceRoom == null || (!(spaceRoom?.isSpace ?? false))) {
//         context.go('/rooms');
//       }
//       getChatAndStudents();
//     });
//   }

//   Room? get spaceRoom {
//     if (_spaceRoom == null || _spaceRoom!.id != spaceId) {
//       debugPrint("updating _spaceRoom");
//       _spaceRoom = spaceId != null
//           ? Matrix.of(context).client.getRoomById(spaceId!)
//           : null;
//       if (_spaceRoom == null) {
//         context.go('/rooms/analytics');
//         return null;
//       }
//       getChatAndStudents().then((_) => setTargetLanguages());
//     }
//     return _spaceRoom;
//   }

//   Future<void> getChatAndStudents() async {
//     try {
//       await spaceRoom?.requestParticipants();

//       if (spaceRoom != null) {
//         final response = await Matrix.of(context).client.getSpaceHierarchy(
//               spaceRoom!.id,
//             );

//         students = spaceRoom!.students;
//         chats = response.rooms
//             .where(
//               (room) =>
//                   room.roomId != spaceRoom!.id &&
//                   room.roomType != PangeaRoomTypes.analytics,
//             )
//             .toList();
//         chats.sort((a, b) => a.roomType == 'm.space' ? -1 : 1);
//       }

//       setState(() {
//         _initialized = true;
//       });
//     } catch (err, s) {
//       debugger(when: kDebugMode);
//       ErrorHandler.logError(e: err, s: s);
//     }
//   }

//   Future<void> setTargetLanguages() async {
//     // get a list of language models, sorted by the
//     // number of students who are learning that language
//     targetLanguages = await spaceRoom?.targetLanguages() ?? [];
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_initialized) return const PCircular();
//     return PLoadingStatusV2(
//       // if we everr want it rebuild the whole thing each time (and run initState again)
//       // but this is computationally expensive!
//       // key: UniqueKey(),
//       shimmerChild: const ListPlaceholder(),
//       // onFinish: () {
//       //   getChatAndStudentAnalytics(context);
//       // },
//       child: SpaceAnalyticsView(this),
//     );
//   }
// }
