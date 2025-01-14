import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/chat_settings/widgets/class_invitation_buttons.dart';
import '../../../pages/chat_details/chat_details.dart';

class SpaceDetailsToggleAddStudentsTile extends StatelessWidget {
  const SpaceDetailsToggleAddStudentsTile({
    super.key,
    required this.controller,
  });

  final ChatDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            L10n.of(context).addStudents,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            child: const Icon(
              Icons.add,
            ),
          ),
          trailing: Icon(
            controller.displayAddStudentOptions
                ? Icons.keyboard_arrow_down_outlined
                : Icons.keyboard_arrow_right_outlined,
          ),
          onTap: controller.toggleAddStudentOptions,
        ),
        if (controller.displayAddStudentOptions)
          ClassInvitationButtons(roomId: controller.roomId!),
      ],
    );
  }
}
