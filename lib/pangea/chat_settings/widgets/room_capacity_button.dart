import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class RoomCapacityButton extends StatefulWidget {
  final Room room;
  final ChatDetailsController? controller;

  const RoomCapacityButton({
    super.key,
    required this.room,
    this.controller,
  });

  @override
  RoomCapacityButtonState createState() => RoomCapacityButtonState();
}

class RoomCapacityButtonState extends State<RoomCapacityButton> {
  int? get capacity => widget.room.capacity;
  int get memberCount => widget.room.summary.mJoinedMemberCount ?? 1;

  RoomCapacityButtonState({Key? key});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Column(
      children: [
        ListTile(
          onTap: setRoomCapacity,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.reduce_capacity),
          ),
          trailing: Text(
            (capacity == null)
                ? L10n.of(context).noCapacityLimit
                : '$memberCount/$capacity',
          ),
          title: Text(
            L10n.of(context).chatCapacity,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> setRoomCapacity() async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).chatCapacity,
      message: L10n.of(context).chatCapacityExplanation,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      initialText: ((capacity != null) ? '$capacity' : ''),
      keyboardType: TextInputType.number,
      maxLength: 3,
      validator: (value) {
        if (value.isEmpty ||
            int.tryParse(value) == null ||
            int.parse(value) < 0) {
          return L10n.of(context).enterNumber;
        }
        if (int.parse(value) < memberCount) {
          return L10n.of(context).chatCapacitySetTooLow;
        }
        return null;
      },
    );
    if (input == null || input.isEmpty || int.tryParse(input) == null) {
      return;
    }

    final newCapacity = int.parse(input);
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => widget.room.updateRoomCapacity(newCapacity),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).chatCapacityHasBeenChanged),
        ),
      );
      setState(() {});
    }
  }
}
