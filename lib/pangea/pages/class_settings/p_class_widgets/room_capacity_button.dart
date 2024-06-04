import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

class RoomCapacityButton extends StatelessWidget {
  final Room room;
  final ChatDetailsController? controller;
  const RoomCapacityButton({
    super.key,
    required this.room,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    // Edit - use FutureBuilder to allow async call
    // String nonAdmins = (await room.numNonAdmins).toString;
    return Column(
      children: [
        ListTile(
          onTap: room.isRoomAdmin ? controller!.setCapacityAction : null,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.reduce_capacity),
          ),
          subtitle: Text(
            // Edit
            // '$nonAdmins/${room.capacity}',
            (room.capacity ?? L10n.of(context)!.capacityNotSet),
          ),
          title: Text(
            L10n.of(context)!.roomCapacity,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

void setClassCapacity(Room room, BuildContext context) {
  final TextEditingController myTextFieldController =
      TextEditingController(text: (room.capacity ?? ''));
  showDialog(
    context: context,
    useRootNavigator: false,
    builder: (BuildContext context) => AlertDialog(
      title: Text(
        L10n.of(context)!.roomCapacity,
      ),
      content: TextFormField(
        controller: myTextFieldController,
        keyboardType: TextInputType.number,
        maxLength: 2,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
      actions: [
        TextButton(
          child: Text(L10n.of(context)!.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(L10n.of(context)!.ok),
          onPressed: () async {
            if (myTextFieldController.text == "") return;
            final success = await showFutureLoadingDialog(
              context: context,
              future: () => room.updateRoomCapacity(myTextFieldController.text),
            );
            if (success.error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    L10n.of(context)!.groupDescriptionHasBeenChanged,
                  ), // Edit
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}
