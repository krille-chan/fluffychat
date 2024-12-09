import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

Future<void> reportMessage(
  BuildContext context,
  String roomId,
  String reason,
  String reportedUserId,
  String reportedMessage,
) async {
  final Room? reportedInRoom = Matrix.of(context).client.getRoomById(roomId);
  if (reportedInRoom == null) {
    throw ("Null room with id $roomId in reportMessage");
  }

  final List<SpaceTeacher> teachers =
      await getReportTeachers(context, reportedInRoom);
  if (teachers.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          L10n.of(context).noTeachersFound,
        ),
      ),
    );
    return;
  }

  final List<SpaceTeacher>? selectedTeachers = await showDialog(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) => TeacherSelectDialog(teachers: teachers),
  );

  if (selectedTeachers == null || selectedTeachers.isEmpty) {
    return;
  }

  final List<Room> reportDMs = [];
  for (final SpaceTeacher teacher in selectedTeachers) {
    final Room reportDM = await Matrix.of(context).client.getReportsDM(
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
    reason,
  );
  final String message = "$messageTitle\n\n$messageBody";
  for (final Room reportDM in reportDMs) {
    final event = <String, dynamic>{
      'msgtype': PangeaEventTypes.report,
      'body': message,
    };
    await reportDM.sendEvent(event);
  }
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
      .spacesImIn
      .where((space) => !reportRoomParentSpaces.contains(space))
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
