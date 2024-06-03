import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/common/list_placeholder.dart';
import 'package:fluffychat/pangea/widgets/common/p_circular_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import '../../../../widgets/matrix.dart';
import '../../../utils/sync_status_util_v2.dart';
import 'class_analytics_view.dart';

enum AnalyticsPageType { classList, student, classDetails }

class ClassAnalyticsPage extends StatefulWidget {
  const ClassAnalyticsPage({super.key});

  @override
  State<ClassAnalyticsPage> createState() => ClassAnalyticsV2Controller();
}

class ClassAnalyticsV2Controller extends State<ClassAnalyticsPage> {
  bool _initialized = false;
  // StreamSubscription<Event>? stateSub;
  // Timer? refreshTimer;

  List<SpaceRoomsChunk> chats = [];
  List<User> students = [];
  String? get classId => GoRouterState.of(context).pathParameters['classid'];
  Room? _classRoom;

  Room? get classRoom {
    if (_classRoom == null || _classRoom!.id != classId) {
      debugPrint("updating _classRoom");
      _classRoom = classId != null
          ? Matrix.of(context).client.getRoomById(classId!)
          : null;
    }
    return _classRoom;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (classRoom == null || (!(classRoom?.isSpace ?? false))) {
        context.go('/rooms');
      }
      getChatAndStudents();
    });
  }

  Future<void> getChatAndStudents() async {
    try {
      await classRoom?.requestParticipants();

      if (classRoom != null) {
        final response = await Matrix.of(context).client.getSpaceHierarchy(
              classRoom!.id,
              maxDepth: 1,
            );

        students = classRoom!.students;
        chats = response.rooms
            .where(
              (room) =>
                  room.roomId != classRoom!.id &&
                  room.roomType != PangeaRoomTypes.analytics,
            )
            .toList();
        chats.sort((a, b) => a.roomType == 'm.space' ? -1 : 1);
      }

      setState(() {
        _initialized = true;
      });
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   refreshTimer?.cancel();
  //   stateSub?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const PCircular();
    return PLoadingStatusV2(
      // if we everr want it rebuild the whole thing each time (and run initState again)
      // but this is computationally expensive!
      // key: UniqueKey(),
      shimmerChild: const ListPlaceholder(),
      // onFinish: () {
      //   getChatAndStudentAnalytics(context);
      // },
      child: ClassAnalyticsView(this),
    );
  }
}
