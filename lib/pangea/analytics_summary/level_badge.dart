import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_summary/level_bar_popup.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';

class LevelBadge extends StatelessWidget {
  final int level;
  final bool mini;

  const LevelBadge({
    required this.level,
    this.mini = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PressableButton(
      color: Theme.of(context).colorScheme.surfaceBright,
      borderRadius: BorderRadius.circular(15),
      buttonHeight: 2.5,
      onPressed: () {
        showDialog<LevelBarPopup>(
          context: context,
          builder: (c) => const LevelBarPopup(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.surfaceBright,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          "⭐ ${mini ? "$level" : L10n.of(context).levelShort(level)}",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
