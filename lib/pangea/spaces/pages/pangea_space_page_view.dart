import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_details/participant_list_item.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/spaces/pages/pangea_space_page.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/user_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class PangeaSpacePageView extends StatelessWidget {
  final PangeaSpacePageState controller;
  final LoadParticipantsUtilState participantsLoader;
  const PangeaSpacePageView(
    this.controller, {
    required this.participantsLoader,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final room = controller.widget.space;

    final displayname = room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)),
    );

    final filteredParticipants = participantsLoader
        .filteredParticipants("")
        .where((u) => u.id != BotName.byEnvironment)
        .toList();

    final bool showMedals = !participantsLoader.loading &&
        controller.searchController.text.isEmpty &&
        filteredParticipants.isNotEmpty;

    final Widget leaderboardHeader = ListTile(
      tileColor: Color.lerp(AppConfig.gold, Colors.black, 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      visualDensity: const VisualDensity(vertical: -4.0),
      title: Text(
        L10n.of(context).leaderboard,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      trailing: Icon(
        controller.expanded
            ? Icons.keyboard_arrow_down_outlined
            : Icons.keyboard_arrow_right_outlined,
      ),
      onTap: controller.toggleExpanded,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: theme.appBarTheme.elevation,
            backgroundColor: theme.appBarTheme.backgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.go(
                  '/rooms/${room.id}/details',
                ),
              ),
            ],
            shape: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MaxWidthBody(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Avatar(
                              mxContent: room.avatar,
                              name: displayname,
                              size: Avatar.defaultSize * 2.5,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  onPressed: () => FluffyShare.share(
                                    displayname,
                                    context,
                                    copyOnly: true,
                                  ),
                                  icon: const Icon(
                                    Icons.copy_outlined,
                                    size: 16,
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        theme.colorScheme.onSurface,
                                  ),
                                  label: Text(
                                    displayname,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                Row(
                                  spacing: 8.0,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => context.push(
                                        '/rooms/${room.id}/details/members',
                                      ),
                                      icon: const Icon(
                                        Icons.group_outlined,
                                        size: 14,
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            theme.colorScheme.secondary,
                                      ),
                                      label: Text(
                                        L10n.of(context).countParticipants(
                                          (room.summary.mInvitedMemberCount ??
                                                  0) +
                                              (room.summary
                                                      .mJoinedMemberCount ??
                                                  0),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => context.push(
                                        '/rooms/${room.id}/details/invite',
                                      ),
                                      icon: const Icon(
                                        Icons.group_add_outlined,
                                        size: 14,
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            theme.colorScheme.secondary,
                                      ),
                                      label: Text(
                                        L10n.of(context).invite,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(color: theme.dividerColor, height: 1),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        child: SelectableLinkify(
                          text: room.topic.isEmpty
                              ? room.isSpace
                                  ? L10n.of(context).noSpaceDescriptionYet
                                  : L10n.of(context).noChatDescriptionYet
                              : room.topic,
                          options: const LinkifyOptions(humanize: false),
                          linkStyle: const TextStyle(
                            color: Colors.blueAccent,
                            decorationColor: Colors.blueAccent,
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: room.topic.isEmpty
                                ? FontStyle.italic
                                : FontStyle.normal,
                            color: theme.textTheme.bodyMedium!.color,
                            decorationColor: theme.textTheme.bodyMedium!.color,
                          ),
                          onOpen: (url) =>
                              UrlLauncher(context, url.url).launchUrl(),
                        ),
                      ),
                      if (constraints.maxWidth <= 800) leaderboardHeader,
                      if (constraints.maxWidth <= 800 && controller.expanded)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            spacing: 16.0,
                            children: [
                              SizedBox(
                                width: 200.0,
                                child: LeaderboardMedals(
                                  isVisible: showMedals,
                                  participants: filteredParticipants,
                                  smallRadius: Avatar.defaultSize * 0.7,
                                  largeRadius: Avatar.defaultSize,
                                ),
                              ),
                              if (filteredParticipants.isNotEmpty)
                                Expanded(
                                  child: Column(
                                    children: filteredParticipants
                                        .take(3)
                                        .mapIndexed((i, user) {
                                      return TrophyParticipantListItem(
                                        index: i,
                                        user: user,
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (constraints.maxWidth > 800)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: theme.dividerColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                  width: 350.0,
                  child: Column(
                    spacing: 16.0,
                    children: [
                      leaderboardHeader,
                      if (controller.expanded)
                        Expanded(
                          child: Column(
                            children: [
                              LeaderboardMedals(
                                isVisible: showMedals,
                                participants: filteredParticipants,
                                padding: EdgeInsets.only(
                                  top: showMedals ? 16.0 : 0,
                                  left: showMedals ? 42.0 : 0,
                                  right: showMedals ? 42.0 : 0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: participantsLoader.loading
                                              ? const CircularProgressIndicator
                                                  .adaptive()
                                              : Text(
                                                  L10n.of(context)
                                                      .countParticipants(
                                                    participantsLoader
                                                        .participants.length,
                                                  ),
                                                ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.group_add_outlined,
                                          ),
                                          iconSize: 20.0,
                                          onPressed: () => context.push(
                                            '/rooms/${room.id}/details/members',
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      controller: controller.searchController,
                                      focusNode: controller.searchFocusNode,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: theme
                                            .colorScheme.secondaryContainer,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(99),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        hintText: L10n.of(context).search,
                                        hintStyle: TextStyle(
                                          color: theme
                                              .colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        prefixIcon: controller.searchController
                                                .text.isNotEmpty
                                            ? IconButton(
                                                tooltip:
                                                    L10n.of(context).cancel,
                                                icon: const Icon(
                                                  Icons.close_outlined,
                                                ),
                                                onPressed:
                                                    controller.cancelSearch,
                                                color: theme.colorScheme
                                                    .onPrimaryContainer,
                                              )
                                            : IconButton(
                                                onPressed:
                                                    controller.startSearch,
                                                icon: Icon(
                                                  Icons.search_outlined,
                                                  color: theme.colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    if (participantsLoader.loading) {
                                      return const Column(
                                        children: [
                                          CircularProgressIndicator.adaptive(),
                                        ],
                                      );
                                    }

                                    if (participantsLoader.error != null) {
                                      return Text(
                                        L10n.of(context).oopsSomethingWentWrong,
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      itemCount: filteredParticipants.length,
                                      itemBuilder: (context, index) {
                                        return TrophyParticipantListItem(
                                          index: index,
                                          user: filteredParticipants[index],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class LeaderboardMedal extends StatelessWidget {
  final User user;
  final Color color;
  final double radius;
  final double iconSize;
  final double iconRadius;

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  const LeaderboardMedal(
    this.user, {
    required this.color,
    required this.radius,
    required this.iconSize,
    required this.iconRadius,
    this.top,
    this.left,
    this.right,
    this.bottom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom != null ? bottom! + 10.0 : null,
          child: CircleAvatar(
            radius: radius + 3.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: const Alignment(0.5, -0.5),
                  end: const Alignment(-0.5, 0.5),
                  colors: <Color>[
                    color,
                    Colors.white,
                    color,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: top != null ? 3.0 : null,
          left: left != null ? 3.0 : null,
          right: right != null ? 3.0 : null,
          bottom: bottom != null ? bottom! + 10.0 + 3.0 : null,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => UserDialog.show(
                context: context,
                profile: Profile(
                  userId: user.id,
                  displayName: user.displayName,
                  avatarUrl: user.avatarUrl,
                ),
              ),
              child: Center(
                child: Avatar(
                  mxContent: user.avatarUrl,
                  name: user.calcDisplayname(),
                  size: radius * 2,
                  presenceUserId: user.id,
                  showPresence: false,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: top != null ? ((radius + 3.0) * 2) - iconRadius : null,
          left: left != null ? radius + 3.0 - iconRadius : null,
          right: right != null ? radius + 3.0 - iconRadius : null,
          bottom: bottom,
          child: CircleAvatar(
            backgroundColor: color,
            radius: iconRadius,
            child: Icon(
              Symbols.trophy,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
      ],
    );
  }
}

class LeaderboardMedals extends StatelessWidget {
  final bool isVisible;
  final List<User> participants;
  final EdgeInsets? padding;

  final double? largeRadius;
  final double? smallRadius;

  const LeaderboardMedals({
    super.key,
    required this.isVisible,
    required this.participants,
    this.largeRadius,
    this.smallRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      height: isVisible ? Avatar.defaultSize * 3.5 : 0.0,
      // padding: EdgeInsets.only(
      //   top: isVisible ? 16.0 : 0,
      //   left: isVisible ? 42.0 : 0,
      //   right: isVisible ? 42.0 : 0,
      // ),
      padding: padding,
      child: !isVisible
          ? const SizedBox.shrink()
          : Stack(
              children: [
                if (participants.length > 1)
                  LeaderboardMedal(
                    participants[1],
                    color: Colors.grey[400]!,
                    radius: smallRadius ?? Avatar.defaultSize * 0.75,
                    iconSize: 16.0,
                    iconRadius: 10.0,
                    bottom: 0.0,
                    left: 0.0,
                  ),
                if (participants.isNotEmpty)
                  LeaderboardMedal(
                    participants[0],
                    color: AppConfig.gold,
                    radius: largeRadius ?? Avatar.defaultSize * 1.25,
                    iconSize: 20.0,
                    iconRadius: 16.0,
                    top: 0.0,
                    right: 0.0,
                    left: 0.0,
                  ),
                if (participants.length > 2)
                  LeaderboardMedal(
                    participants[2],
                    color: Colors.brown[400]!,
                    radius: smallRadius ?? Avatar.defaultSize * 0.75,
                    bottom: 0.0,
                    right: 0.0,
                    iconSize: 16.0,
                    iconRadius: 10.0,
                  ),
              ],
            ),
    );
  }
}

class TrophyParticipantListItem extends StatelessWidget {
  final int index;
  final User user;

  const TrophyParticipantListItem({
    required this.index,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => UserDialog.show(
        context: context,
        profile: Profile(
          userId: user.id,
          displayName: user.displayName,
          avatarUrl: user.avatarUrl,
        ),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerRight,
            width: 32.0,
            child: (index < 3)
                ? Icon(
                    Symbols.trophy,
                    color: index == 0
                        ? AppConfig.gold
                        : index == 1
                            ? Colors.grey[400]
                            : index == 2
                                ? Colors.brown[400]
                                : null,
                  )
                : null,
          ),
          Expanded(
            child: AbsorbPointer(
              child: ParticipantListItem(user),
            ),
          ),
        ],
      ),
    );
  }
}
