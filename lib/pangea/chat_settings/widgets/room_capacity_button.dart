import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class RoomCapacityButton extends StatefulWidget {
  final Room? room;
  final ChatDetailsController? controller;
  final bool spaceMode;

  const RoomCapacityButton({
    super.key,
    this.room,
    this.controller,
    this.spaceMode = false,
  });

  @override
  RoomCapacityButtonState createState() => RoomCapacityButtonState();
}

class RoomCapacityButtonState extends State<RoomCapacityButton> {
  int? capacity;
  String? nonAdmins;

  RoomCapacityButtonState({Key? key});

  @override
  void initState() {
    super.initState();
    capacity = RoomSettingsRoomExtension(widget.room)?.capacity;
    widget.room?.numNonAdmins.then(
      (value) => setState(() {
        nonAdmins = value.toString();
        overCapacity();
      }),
    );
  }

  @override
  void didUpdateWidget(RoomCapacityButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room != widget.room) {
      capacity = RoomSettingsRoomExtension(widget.room)?.capacity;
      widget.room?.numNonAdmins.then(
        (value) => setState(() {
          nonAdmins = value.toString();
          overCapacity();
        }),
      );
    }
  }

  Future<void> overCapacity() async {
    if ((widget.room?.isRoomAdmin ?? false) &&
        capacity != null &&
        nonAdmins != null &&
        int.parse(nonAdmins!) > capacity!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            spaceMode
                ? L10n.of(context).chatExceedsCapacity
                : L10n.of(context).spaceExceedsCapacity,
          ),
        ),
      );
    }
  }

  bool get spaceMode =>
      (widget.room != null && widget.room!.isSpace) || widget.spaceMode;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Column(
      children: [
        ListTile(
          onTap: (widget.room?.isRoomAdmin ?? true) ? setRoomCapacity : null,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.reduce_capacity),
          ),
          trailing: Text(
            (capacity == null)
                ? L10n.of(context).noCapacityLimit
                : (nonAdmins != null)
                    ? '$nonAdmins/$capacity'
                    : '$capacity',
          ),
          title: Text(
            spaceMode
                ? L10n.of(context).spaceCapacity
                : L10n.of(context).chatCapacity,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> setCapacity(int newCapacity) async {
    capacity = newCapacity;
  }

  Future<void> setRoomCapacity() async {
    final input = await showTextInputDialog(
      context: context,
      title: spaceMode
          ? L10n.of(context).spaceCapacity
          : L10n.of(context).chatCapacity,
      message: spaceMode
          ? L10n.of(context).spaceCapacityExplanation
          : L10n.of(context).chatCapacityExplanation,
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
        if (nonAdmins != null && int.parse(value) < int.parse(nonAdmins!)) {
          return spaceMode
              ? L10n.of(context).spaceCapacitySetTooLow
              : L10n.of(context).chatCapacitySetTooLow;
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
      future: () => ((widget.room != null)
          ? (widget.room!.updateRoomCapacity(
              capacity = newCapacity,
            ))
          : setCapacity(newCapacity)),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            spaceMode
                ? L10n.of(context).spaceCapacityHasBeenChanged
                : L10n.of(context).chatCapacityHasBeenChanged,
          ),
        ),
      );
      setState(() {});
    }
  }
}
