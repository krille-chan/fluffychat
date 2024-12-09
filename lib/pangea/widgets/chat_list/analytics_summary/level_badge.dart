import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class LevelBadge extends StatelessWidget {
  final int level;
  const LevelBadge({
    required this.level,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.surfaceBright,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppConfig.gold,
            radius: 8,
            child: Icon(
              size: 12,
              Icons.star,
              color: Theme.of(context).colorScheme.surfaceBright,
              weight: 1000,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            L10n.of(context).levelShort(level),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
