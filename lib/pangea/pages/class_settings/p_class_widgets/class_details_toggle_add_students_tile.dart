// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';

// Project imports:
import '../../../../pages/chat_details/chat_details.dart';

class SpaceDetailsToggleAddStudentsTile extends StatelessWidget {
  const SpaceDetailsToggleAddStudentsTile({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChatDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        L10n.of(context)!.addStudents,
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
      trailing: Icon(controller.displayAddStudentOptions
          ? Icons.keyboard_arrow_down_outlined
          : Icons.keyboard_arrow_right_outlined),
      onTap: controller.toggleAddStudentOptions,
    );
  }
}
