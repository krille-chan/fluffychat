import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/chat_settings/pages/room_details_buttons.dart';
import 'package:fluffychat/pangea/chat_settings/pages/space_details_content.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpaceDetailsButtonRow extends StatefulWidget {
  final SpaceSettingsTabs? selectedTab;
  final Function(SpaceSettingsTabs) onTabSelected;
  final List<ButtonDetails> buttons;

  final ChatDetailsController controller;
  final Room room;

  const SpaceDetailsButtonRow({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.buttons,
    required this.controller,
    required this.room,
  });

  @override
  State<SpaceDetailsButtonRow> createState() => SpaceDetailsButtonRowState();
}

class SpaceDetailsButtonRowState extends State<SpaceDetailsButtonRow> {
  StreamSubscription? notificationChangeSub;

  @override
  void initState() {
    super.initState();
    notificationChangeSub ??= Matrix.of(context)
        .client
        .onSync
        .stream
        .where(
          (syncUpdate) =>
              syncUpdate.accountData?.any(
                (accountData) => accountData.type == 'm.push_rules',
              ) ??
              false,
        )
        .listen(
          (u) => setState(() {}),
        );
  }

  @override
  void dispose() {
    notificationChangeSub?.cancel();
    super.dispose();
  }

  final double _buttonHeight = 84.0;
  final double _miniButtonWidth = 50.0;

  Room get room => widget.room;

  @override
  Widget build(BuildContext context) {
    final buttons = widget.buttons
        .where(
          (button) => button.visible,
        )
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final fullButtonCapacity = (availableWidth / 120.0).floor() - 1;

        final mini = fullButtonCapacity < 4;

        final List<ButtonDetails> mainViewButtons =
            buttons.where((button) => button.showInMainView).toList();
        final List<ButtonDetails> otherButtons =
            buttons.where((button) => !button.showInMainView).toList();

        return Row(
          spacing: FluffyThemes.isColumnMode(context) ? 12.0 : 0.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(mainViewButtons.length + 1, (index) {
            if (index == mainViewButtons.length) {
              if (otherButtons.isEmpty) {
                return const SizedBox();
              }

              return Expanded(
                child: RoomDetailsButton(
                  mini: mini,
                  buttonDetails: ButtonDetails(
                    title: L10n.of(context).more,
                    icon: const Icon(Icons.more_horiz_outlined),
                    onPressed: () =>
                        widget.onTabSelected(SpaceSettingsTabs.more),
                  ),
                  height: mini ? _miniButtonWidth : _buttonHeight,
                  selected: widget.selectedTab == SpaceSettingsTabs.more,
                ),
              );
            }

            final button = mainViewButtons[index];
            return Expanded(
              child: RoomDetailsButton(
                mini: mini,
                buttonDetails: button,
                height: mini ? _miniButtonWidth : _buttonHeight,
                selected: widget.selectedTab == button.tab,
              ),
            );
          }),
        );
      },
    );
  }
}
