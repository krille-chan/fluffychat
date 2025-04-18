import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

Future<Room> getReportsDM(User teacher, Room space) async {
  final String roomId = await teacher.startDirectChat(
    enableEncryption: false,
  );
  space.setSpaceChild(
    roomId,
    suggested: false,
  );
  return space.client.getRoomById(roomId)!;
}

void reportEvent(
  Event event,
  ChatController controller,
  BuildContext context,
) async {
  final score = await showModalActionPopup<int>(
    context: context,
    title: L10n.of(context).reportMessage,
    message: L10n.of(context).whyDoYouWantToReportThis,
    cancelLabel: L10n.of(context).cancel,
    actions: [
      AdaptiveModalAction(
        value: 1,
        label: L10n.of(context).offensive,
      ),
      AdaptiveModalAction(
        value: 2,
        label: L10n.of(context).translationProblem,
      ),
      AdaptiveModalAction(
        value: 3,
        label: L10n.of(context).other,
      ),
    ],
  );
  if (score == null) return;

  final reason = await showTextInputDialog(
    context: context,
    title: L10n.of(context).whyDoYouWantToReportThis,
    okLabel: L10n.of(context).ok,
    cancelLabel: L10n.of(context).cancel,
    hintText: L10n.of(context).reason,
    autoSubmit: true,
  );

  if (score == 1) {
    await reportOffensiveMessage(
      context,
      event.room.id,
      reason,
      event.senderId,
      event.content['body'].toString(),
    );
    controller.clearSelectedEvents();
    return;
  }

  ErrorHandler.logError(
    e: "User reported message with eventId ${event.eventId}",
    data: {
      "content": event.content,
      "eventID": event.eventId,
      "roomID": event.room.id,
      "userID": event.senderId,
      "reason": reason,
    },
  );
}

Future<void> reportOffensiveMessage(
  BuildContext context,
  String roomId,
  String? reason,
  String reportedUserId,
  String reportedMessage,
) async {
  final Room? reportedInRoom = Matrix.of(context).client.getRoomById(roomId);
  if (reportedInRoom == null) {
    throw ("Null room with id $roomId in reportMessage");
  }

  final resp = await showFutureLoadingDialog<List<SpaceTeacher>>(
    context: context,
    future: () async {
      final List<SpaceTeacher> teachers =
          await getReportTeachers(context, reportedInRoom);
      if (teachers.isEmpty) {
        throw L10n.of(context).noTeachersFound;
      }
      return teachers;
    },
  );

  if (resp.isError || resp.result == null || resp.result!.isEmpty) {
    return;
  }

  final List<SpaceTeacher>? selectedTeachers = await showDialog(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) =>
        TeacherSelectDialog(teachers: resp.result!),
  );

  if (selectedTeachers == null || selectedTeachers.isEmpty) {
    return;
  }

  await showFutureLoadingDialog(
    context: context,
    future: () async {
      final List<Room> reportDMs = [];
      for (final SpaceTeacher teacher in selectedTeachers) {
        final Room reportDM = await getReportsDM(
          teacher.teacher,
          teacher.space,
        );
        reportDMs.add(reportDM);
      }

      final String reportingUserId = Matrix.of(context).client.userID ?? "";
      final String roomName = reportedInRoom.getLocalizedDisplayname();
      final String messageTitle = L10n.of(context).reportMessageTitle(
        reportingUserId,
        reportedUserId,
        roomName,
      );
      final String messageBody = L10n.of(context).reportMessageBody(
        reportedMessage,
        reason ?? L10n.of(context).none,
      );
      final String message = "$messageTitle\n\n$messageBody";
      for (final Room reportDM in reportDMs) {
        final event = <String, dynamic>{
          'msgtype': PangeaEventTypes.report,
          'body': message,
        };
        await reportDM.sendEvent(event);
      }
    },
  );
}

Future<List<SpaceTeacher>> getReportTeachers(
  BuildContext context,
  Room room,
) async {
  // create a list of teachers and their assosiated spaces
  // prioritize the spaces that are parents of the report room
  final List<SpaceTeacher> teachers = [];

  final List<Room> reportRoomParentSpaces = room.spaceParents
      .where((parentSpace) => parentSpace.roomId != null)
      .map(
        (parentSpace) =>
            Matrix.of(context).client.getRoomById(parentSpace.roomId!),
      )
      .where((parentSpace) => parentSpace != null)
      .cast<Room>()
      .toList();

  for (final Room space in reportRoomParentSpaces) {
    final List<User> spaceTeachers = await space.teachers;
    for (final User spaceTeacher in spaceTeachers) {
      if (!teachers.any((teacher) => teacher.teacher.id == spaceTeacher.id) &&
          spaceTeacher.id != Matrix.of(context).client.userID) {
        teachers.add(SpaceTeacher(spaceTeacher, space));
      }
    }
  }

  final List<Room> otherSpaces = Matrix.of(context)
      .client
      .rooms
      .where((room) => room.isSpace && !reportRoomParentSpaces.contains(room))
      .toList();

  for (final space in otherSpaces) {
    for (final spaceTeacher in await space.teachers) {
      if (!teachers.any((teacher) => teacher.teacher.id == spaceTeacher.id) &&
          spaceTeacher.id != Matrix.of(context).client.userID) {
        teachers.add(SpaceTeacher(spaceTeacher, space));
      }
    }
  }

  return teachers;
}

class TeacherSelectDialog extends StatefulWidget {
  final List<SpaceTeacher> teachers;
  const TeacherSelectDialog({super.key, required this.teachers});

  @override
  State<StatefulWidget> createState() => _TeacherSelectDialogState();
}

class _TeacherSelectDialogState extends State<TeacherSelectDialog> {
  final List<SpaceTeacher> _selectedItems = [];

  void _itemChange(SpaceTeacher itemValue, bool isSelected) {
    setState(() {
      isSelected
          ? _selectedItems.add(itemValue)
          : _selectedItems.remove(itemValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        L10n.of(context).reportToTeacher,
        style: const TextStyle(fontSize: 16),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.teachers
              .map(
                (teacher) => CheckboxListTile(
                  value: _selectedItems.contains(teacher),
                  title: Text(teacher.teacher.id),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) => _itemChange(teacher, isChecked!),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L10n.of(context).cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selectedItems),
          child: Text(L10n.of(context).submit),
        ),
      ],
    );
  }
}

class SpaceTeacher {
  final User teacher;
  final Room space;

  SpaceTeacher(this.teacher, this.space);
}
