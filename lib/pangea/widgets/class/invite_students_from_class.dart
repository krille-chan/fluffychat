// import 'dart:developer';

// import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';
// import 'package:future_loading_dialog/future_loading_dialog.dart';
// import 'package:matrix/matrix.dart';

// import '../../../utils/matrix_sdk_extensions/matrix_locals.dart';
// import '../../../widgets/avatar.dart';
// import '../../../widgets/matrix.dart';
// import '../../utils/error_handler.dart';
// import '../../utils/firebase_analytics.dart';

// class InviteStudentsFromClass extends StatefulWidget {
//   final String? roomId;
//   final bool startOpen;
//   final Function setParentState;

//   const InviteStudentsFromClass({
//     Key? key,
//     this.roomId,
//     this.startOpen = false,
//     required this.setParentState,
//   }) : super(key: key);

//   @override
//   InviteStudentsFromClassState createState() => InviteStudentsFromClassState();
// }

// class InviteStudentsFromClassState extends State<InviteStudentsFromClass> {
//   late Room? room;
//   late List<Room> otherSpaces;
//   late bool isOpen;
//   final List<String> invitedSpaces = [];
//   final List<String> kickedSpaces = [];

//   InviteStudentsFromClassState({Key? key, cont});

//   @override
//   void initState() {
//     room = widget.roomId != null
//         ? Matrix.of(context).client.getRoomById(widget.roomId!)
//         : null;

//     otherSpaces = Matrix.of(context)
//         .client
//         .rooms
//         .where((r) => r.isPangeaClass && r.id != widget.roomId)
//         .toList();

//     isOpen = widget.startOpen;

//     super.initState();
//   }

//   Future<void> inviteSpaceMembers(BuildContext context, Room spaceToInvite) =>
//       showFutureLoadingDialog(
//         context: context,
//         future: () async {
//           if (room == null) {
//             ErrorHandler.logError(m: 'Room is null in inviteSpaceMembers');
//             debugger(when: kDebugMode);
//             return;
//           }
//           final List<List<User>> existingMembers = await Future.wait([
//             room!.requestParticipants(),
//             spaceToInvite.requestParticipants(),
//           ]);
//           final List<User> roomMembers = existingMembers[0];
//           final List<User> spaceMembers = existingMembers[1];
//           final List<Future<void>> inviteFutures = [];
//           for (final spaceMember in spaceMembers
//               .where((element) => element.id != room!.client.userID)) {
//             if (!roomMembers.any((m) =>
//                 m.id == spaceMember.id && m.membership == Membership.join)) {
//               inviteFutures.add(inviteSpaceMember(spaceMember));
//               //add to invitedSpaces
//               invitedSpaces.add(spaceToInvite.id);
//               //if in kickedSpaces, remove
//               kickedSpaces.remove(spaceToInvite.id);
//             } else {
//               debugPrint('User ${spaceMember.id} is already in the room');
//             }
//           }
//           await Future.wait(inviteFutures);
//           debugPrint('Invited ${spaceMembers.length} members');
//           GoogleAnalytics.inviteClassToExchange(room!.id, spaceToInvite.id);
//           // setState(() {
//           //   widget.setParentState();
//           // });
//         },
//         onError: handleError,
//       );

//   //function for kicking single student and haandling error
//   Future<void> kickSpaceMember(User spaceMember) async {
//     try {
//       await room!.kick(spaceMember.id);
//       debugPrint('Kicked ${spaceMember.id}');
//     } catch (e) {
//       debugger(when: kDebugMode);
//       ErrorHandler.logError(e: e);
//     }
//   }

//   //function for adding single student and haandling error
//   Future<void> inviteSpaceMember(User spaceMember) async {
//     try {
//       await room!.invite(spaceMember.id);
//       debugPrint('added ${spaceMember.id}');
//     } catch (e) {
//       debugger(when: kDebugMode);
//       ErrorHandler.logError(e: e);
//     }
//   }

//   Future<void> kickSpaceMembers(BuildContext context, Room spaceToKick) =>
//       showFutureLoadingDialog(
//         context: context,
//         future: () async {
//           if (room == null) {
//             ErrorHandler.logError(m: 'Room is null in kickSpaceMembers');
//             debugger(when: kDebugMode);
//             return;
//           }
//           final List<List<User>> existingMembers = await Future.wait([
//             room!.requestParticipants(),
//             spaceToKick.requestParticipants(),
//           ]);
//           final List<User> roomMembers = existingMembers[0];
//           final List<User> spaceMembers = existingMembers[1];
//           final List<User> toKick = spaceMembers
//               .where((element) =>
//                   element.id != room!.client.userID &&
//                   roomMembers.any((m) => m.id == element.id))
//               .toList();
//           //add to kickedSpaces
//           kickedSpaces.add(spaceToKick.id);
//           //if in invitedSpaces, remove from invitedSpaces
//           invitedSpaces.remove(spaceToKick.id);
//           final List<Future<void>> kickFutures = [];

//           for (final spaceMember in toKick) {
//             kickFutures.add(kickSpaceMember(spaceMember));
//           }
//           await Future.wait(kickFutures);
//           GoogleAnalytics.kickClassFromExchange(room!.id, spaceToKick.id);
//           setState(() {
//             widget.setParentState();
//           });
//           return;
//         },
//         onError: handleError,
//       );

//   String handleError(dynamic exception) {
//     ErrorHandler.logError(
//         e: exception, m: 'Error inviting or kicking students');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(exception.toString()),
//       ),
//     );
//     return exception.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (room == null) return Container();
//     return Column(
//       children: [
//         ListTile(
//           title: Text(
//             L10n.of(context)!.inviteStudentsFromOtherClasses,
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.secondary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           leading: CircleAvatar(
//             backgroundColor: Theme.of(context).primaryColor,
//             foregroundColor: Colors.white,
//             radius: Avatar.defaultSize / 2,
//             child: const Icon(Icons.workspaces_outlined),
//           ),
//           trailing: Icon(
//             isOpen
//                 ? Icons.keyboard_arrow_down_outlined
//                 : Icons.keyboard_arrow_right_outlined,
//           ),
//           onTap: () => setState(() => isOpen = !isOpen),
//         ),
//         if (isOpen)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
//             child: Column(
//               children: [
//                 if (otherSpaces.isEmpty)
//                   ListTile(title: Text(L10n.of(context)!.noEligibleSpaces)),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: otherSpaces.length,
//                   itemBuilder: (BuildContext context, int i) {
//                     final bool canIAddSpaceChildren =
//                         otherSpaces[i].canIAddSpaceChild(room);
//                     return Column(
//                       children: [
//                         Opacity(
//                           opacity: canIAddSpaceChildren ? 1 : 0.5,
//                           child: InviteKickClass(
//                             room: otherSpaces[i],
//                             inviteCallback: (Room room) =>
//                                 inviteSpaceMembers(context, otherSpaces[i]),
//                             kickCallback: (Room room) =>
//                                 kickSpaceMembers(context, otherSpaces[i]),
//                             controller: this,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         // END: ed8c6549bwf9
//       ],
//     );
//   }
// }

// //listTile with two buttons - one to invite all students in the class and the other to kick them all out
// // parameters
// // 1. Room
// // 2. invite callback
// // 3. kick callback
// // when the user clicks either button, a dialog pops up asking for confirmation
// // after the dialog is confirmed, the callback is executed
// class InviteKickClass extends StatelessWidget {
//   final Room room;
//   final Function inviteCallback;
//   final Function kickCallback;
//   final InviteStudentsFromClassState controller;

//   const InviteKickClass({
//     Key? key,
//     required this.room,
//     required this.inviteCallback,
//     required this.kickCallback,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         room.getLocalizedDisplayname(
//           MatrixLocals(L10n.of(context)!),
//         ),
//       ),
//       leading: const SizedBox(
//         height: Avatar.defaultSize,
//         width: Avatar.defaultSize,
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             isSelected: controller.invitedSpaces.contains(room.id),
//             onPressed: () async {
//               final bool? result = await showDialog<bool>(
//                 context: context,
//                 builder: (BuildContext context) => AlertDialog(
//                   title: Text(
//                     L10n.of(context)!.inviteAllStudents,
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.secondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   content: Text(
//                     L10n.of(context)!.inviteAllStudentsConfirmation,
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(false),
//                       child: Text(L10n.of(context)!.cancel),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(true),
//                       child: Text(L10n.of(context)!.ok),
//                     ),
//                   ],
//                 ),
//               );
//               if (result != null && result) {
//                 inviteCallback(room);
//               }
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.remove),
//             isSelected: controller.kickedSpaces.contains(room.id),
//             onPressed: () async {
//               final bool? result = await showDialog<bool>(
//                 context: context,
//                 builder: (BuildContext context) => AlertDialog(
//                   title: Text(
//                     L10n.of(context)!.kickAllStudents,
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.secondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   content: Text(
//                     L10n.of(context)!.kickAllStudentsConfirmation,
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(false),
//                       child: Text(L10n.of(context)!.cancel),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(true),
//                       child: Text(L10n.of(context)!.ok),
//                     ),
//                   ],
//                 ),
//               );
//               if (result != null && result) {
//                 kickCallback(room);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
