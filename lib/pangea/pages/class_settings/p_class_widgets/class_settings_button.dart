import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class ClassSettingsButton extends StatelessWidget {
  const ClassSettingsButton({Key? key}) : super(key: key);

  // final PangeaController _pangeaController = MatrixState.pangeaController;

  @override
  Widget build(BuildContext context) {
    // final roomId = GoRouterState.of(context).pathParameters['roomid'];

    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Column(
      children: [
        ListTile(
          // enabled: roomId != null &&
          //     _pangeaController.classController
          //             .getClassModelBySpaceIdLocal(roomId) !=
          //         null,
          title: Text(
            L10n.of(context)!.classSettings,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(L10n.of(context)!.classSettingsDesc),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.settings_outlined),
          ),
          onTap: () => context.go('/class_settings'),
        ),
      ],
    );
  }
}
