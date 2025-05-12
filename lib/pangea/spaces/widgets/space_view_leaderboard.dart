import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/spaces/pages/pangea_space_page_view.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';
import 'package:fluffychat/widgets/avatar.dart';

class SpaceViewLeaderboard extends StatefulWidget {
  final Room space;

  const SpaceViewLeaderboard({
    required this.space,
    super.key,
  });

  @override
  State<SpaceViewLeaderboard> createState() => SpaceViewLeaderboardState();
}

class SpaceViewLeaderboardState extends State<SpaceViewLeaderboard> {
  bool _expanded = true;

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    if (FluffyThemes.isColumnMode(context)) {
      return const SizedBox.shrink();
    }

    return LoadParticipantsUtil(
      space: widget.space,
      builder: (participantsLoader) {
        final filteredParticipants = participantsLoader
            .filteredParticipants("")
            .where((u) => u.id != BotName.byEnvironment)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16.0,
          children: [
            ListTile(
              tileColor: Color.lerp(AppConfig.gold, Colors.black, 0.3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              visualDensity: const VisualDensity(vertical: -4.0),
              title: Text(
                L10n.of(context).leaderboard,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              trailing: Icon(
                _expanded
                    ? Icons.keyboard_arrow_down_outlined
                    : Icons.keyboard_arrow_right_outlined,
              ),
              onTap: _toggleExpanded,
            ),
            if (_expanded)
              Column(
                children: [
                  SizedBox(
                    width: 225.0,
                    child: LeaderboardMedals(
                      isVisible: !participantsLoader.loading &&
                          filteredParticipants.isNotEmpty,
                      participants: filteredParticipants,
                      smallRadius: Avatar.defaultSize * 0.7,
                      largeRadius: Avatar.defaultSize,
                    ),
                  ),
                  Column(
                    children: filteredParticipants.take(3).mapIndexed(
                      (index, user) {
                        return TrophyParticipantListItem(
                          index: index,
                          user: filteredParticipants[index],
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
