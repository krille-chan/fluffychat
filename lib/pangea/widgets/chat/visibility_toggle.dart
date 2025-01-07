import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/matrix.dart';

class VisibilityToggle extends StatelessWidget {
  final Room? room;
  final Color? iconColor;
  final Future<void> Function(matrix.Visibility) setVisibility;
  final Future<void> Function(JoinRules) setJoinRules;
  final bool spaceMode;
  final matrix.Visibility visibility;
  final JoinRules joinRules;

  final bool showSearchToggle;

  const VisibilityToggle({
    required this.setVisibility,
    required this.setJoinRules,
    this.room,
    this.iconColor,
    this.spaceMode = false,
    this.visibility = matrix.Visibility.private,
    this.joinRules = JoinRules.knock,
    this.showSearchToggle = true,
    super.key,
  });

  bool get _isPublic => room != null
      ? room!.joinRules == matrix.JoinRules.public
      : joinRules == matrix.JoinRules.public;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile.adaptive(
          activeColor: AppConfig.activeToggleColor,
          title: Text(
            L10n.of(context).requireCodeToJoin,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          secondary: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.key_outlined),
          ),
          value: !_isPublic,
          onChanged: (value) =>
              setJoinRules(value ? JoinRules.knock : JoinRules.public),
        ),
        FutureBuilder(
          future: room != null
              ? Matrix.of(context).client.getRoomVisibilityOnDirectory(room!.id)
              : null,
          builder: (context, snapshot) {
            return SwitchListTile.adaptive(
              activeColor: AppConfig.activeToggleColor,
              title: Text(
                L10n.of(context).canFindInSearch,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              secondary: CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: iconColor,
                child: const Icon(Icons.search_outlined),
              ),
              value: room != null
                  ? snapshot.data == matrix.Visibility.public
                  : visibility == matrix.Visibility.public,
              onChanged: (value) => setVisibility(
                value ? matrix.Visibility.public : matrix.Visibility.private,
              ),
            );
          },
        ),
      ],
    );
  }
}
