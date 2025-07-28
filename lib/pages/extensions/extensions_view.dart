import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../widgets/extension_card.dart';
import 'extensions.dart';

class ExtensionsView extends StatelessWidget {
  final ExtensionsController controller;

  const ExtensionsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(L10n.of(context).extensions),
      ),
      body: MaxWidthBody(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.of(context).availableExtensions,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  ExtensionCard(
                    icon: Icons.live_tv_outlined,
                    type: ExtensionType.live,
                    title: L10n.of(context).live,
                    subtitle: L10n.of(context).liveBroadcastRadioHemp,
                    roomId: controller.roomId,
                    roomName: controller.roomName,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
