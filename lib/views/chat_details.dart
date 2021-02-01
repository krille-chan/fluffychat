import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:famedlysdk/famedlysdk.dart';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/list_items/participant_list_item.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_link_text/link_text.dart';

import '../utils/url_launcher.dart';

class ChatDetails extends StatefulWidget {
  final String roomId;

  const ChatDetails(this.roomId);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  Room room;
  List<User> members;
  void setDisplaynameAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).changeTheNameOfTheGroup,
      textFields: [
        DialogTextField(
          initialText: room.getLocalizedDisplayname(
            MatrixLocals(
              L10n.of(context),
            ),
          ),
        )
      ],
    );
    if (input == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setName(input.single),
    );
    if (success.error == null) {
      await FlushbarHelper.createSuccess(
              message: L10n.of(context).displaynameHasBeenChanged)
          .show(context);
    }
  }

  void setCanonicalAliasAction(context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).setInvitationLink,
      textFields: [
        DialogTextField(
          hintText: '#localpart:domain',
          initialText: L10n.of(context).alias.toLowerCase(),
        )
      ],
    );
    if (input == null) return;
    final domain = room.client.userID.domain;
    final canonicalAlias = '%23' + input.single + '%3A' + domain;
    final aliasEvent = room.getState('m.room.aliases', domain);
    final aliases =
        aliasEvent != null ? aliasEvent.content['aliases'] ?? [] : [];
    if (aliases.indexWhere((s) => s == canonicalAlias) == -1) {
      var newAliases = List<String>.from(aliases);
      newAliases.add(canonicalAlias);
      final response = await showFutureLoadingDialog(
        context: context,
        future: () => room.client.requestRoomAliasInformations(canonicalAlias),
      );
      if (response.error != null) {
        final success = await showFutureLoadingDialog(
          context: context,
          future: () => room.client.createRoomAlias(canonicalAlias, room.id),
        );
        if (success.error != null) return;
      }
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room.client.sendState(room.id, 'm.room.canonical_alias', {
        'alias': input.single,
      }),
    );
  }

  void setTopicAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).setGroupDescription,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).setGroupDescription,
          initialText: room.topic,
          minLines: 1,
          maxLines: 4,
        )
      ],
    );
    if (input == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setDescription(input.single),
    );
    if (success.error == null) {
      await FlushbarHelper.createSuccess(
              message: L10n.of(context).groupDescriptionHasBeenChanged)
          .show(context);
    }
  }

  void setAvatarAction(BuildContext context) async {
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result = await FilePickerCross.importFromStorage(
        type: FileTypeCross.image,
      );
      if (result == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName,
      );
    }

    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setAvatar(file),
    );
    if (success.error == null) {
      await FlushbarHelper.createSuccess(
              message: L10n.of(context).avatarHasBeenChanged)
          .show(context);
    }
  }

  void requestMoreMembersAction(BuildContext context) async {
    final participants = await showFutureLoadingDialog(
        context: context, future: () => room.requestParticipants());
    if (participants.error == null) {
      setState(() => members = participants.result);
    }
  }

  @override
  Widget build(BuildContext context) {
    room ??= Matrix.of(context).client.getRoomById(widget.roomId);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }
    members ??= room.getParticipants();
    members.removeWhere((u) => u.membership == Membership.leave);
    final actualMembersCount =
        room.mInvitedMemberCount + room.mJoinedMemberCount;
    final canRequestMoreMembers = members.length < actualMembersCount;
    return StreamBuilder(
        stream: room.onUpdate.stream,
        builder: (context, snapshot) {
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
                SliverAppBar(
                  leading: BackButton(),
                  expandedHeight: 300.0,
                  floating: true,
                  pinned: true,
                  actions: <Widget>[
                    if (room.canonicalAlias?.isNotEmpty ?? false)
                      IconButton(
                        icon: Icon(Icons.share_outlined),
                        onPressed: () => FluffyShare.share(
                            AppConfig.inviteLinkPrefix + room.canonicalAlias,
                            context),
                      ),
                    ChatSettingsPopupMenu(room, false)
                  ],
                  title: Text(
                      room.getLocalizedDisplayname(
                          MatrixLocals(L10n.of(context))),
                      style: TextStyle(
                          color: Theme.of(context)
                              .appBarTheme
                              .textTheme
                              .headline6
                              .color)),
                  backgroundColor: Theme.of(context).appBarTheme.color,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ContentBanner(room.avatar,
                        onEdit: room.canSendEvent('m.room.avatar')
                            ? () => setAvatarAction(context)
                            : null),
                  ),
                ),
              ],
              body: ListView.builder(
                itemCount: members.length + 1 + (canRequestMoreMembers ? 1 : 0),
                itemBuilder: (BuildContext context, int i) => i == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ListTile(
                            leading: room.canSendEvent('m.room.topic')
                                ? CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    foregroundColor: Colors.grey,
                                    child: Icon(Icons.edit_outlined),
                                  )
                                : null,
                            title: Text('${L10n.of(context).groupDescription}:',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                            subtitle: LinkText(
                              text: room.topic?.isEmpty ?? true
                                  ? L10n.of(context).addGroupDescription
                                  : room.topic,
                              linkStyle: TextStyle(color: Colors.blueAccent),
                              textStyle: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).textTheme.bodyText2.color,
                              ),
                              onLinkTap: (url) =>
                                  UrlLauncher(context, url).launchUrl(),
                            ),
                            onTap: room.canSendEvent('m.room.topic')
                                ? () => setTopicAction(context)
                                : null,
                          ),
                          Divider(thickness: 1),
                          ListTile(
                            title: Text(
                              L10n.of(context).settings,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (room.canSendEvent('m.room.name'))
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                foregroundColor: Colors.grey,
                                child: Icon(Icons.people_outlined),
                              ),
                              title: Text(
                                  L10n.of(context).changeTheNameOfTheGroup),
                              subtitle: Text(room.getLocalizedDisplayname(
                                  MatrixLocals(L10n.of(context)))),
                              onTap: () => setDisplaynameAction(context),
                            ),
                          if (room.canSendEvent('m.room.canonical_alias') &&
                              room.joinRules == JoinRules.public)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                foregroundColor: Colors.grey,
                                child: Icon(Icons.link_outlined),
                              ),
                              onTap: () => setCanonicalAliasAction(context),
                              title: Text(L10n.of(context).setInvitationLink),
                              subtitle: Text(
                                  (room.canonicalAlias?.isNotEmpty ?? false)
                                      ? room.canonicalAlias
                                      : L10n.of(context).none),
                            ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: Colors.grey,
                              child: Icon(Icons.insert_emoticon_outlined),
                            ),
                            title: Text(L10n.of(context).emoteSettings),
                            subtitle: Text(L10n.of(context).setCustomEmotes),
                            onTap: () async {
                              // okay, we need to test if there are any emote state events other than the default one
                              // if so, we need to be directed to a selection screen for which pack we want to look at
                              // otherwise, we just open the normal one.
                              if ((room.states
                                          .states['im.ponies.room_emotes'] ??
                                      <String, Event>{})
                                  .keys
                                  .any((String s) => s.isNotEmpty)) {
                                await AdaptivePageLayout.of(context)
                                    .pushNamed('/rooms/${room.id}/emotes');
                              } else {
                                await AdaptivePageLayout.of(context).pushNamed(
                                    '/settings/emotes',
                                    arguments: {'room': room});
                              }
                            },
                          ),
                          PopupMenuButton(
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  foregroundColor: Colors.grey,
                                  child: Icon(Icons.public_outlined)),
                              title: Text(
                                  L10n.of(context).whoIsAllowedToJoinThisGroup),
                              subtitle: Text(
                                room.joinRules.getLocalizedString(
                                    MatrixLocals(L10n.of(context))),
                              ),
                            ),
                            onSelected: (JoinRules joinRule) =>
                                showFutureLoadingDialog(
                              context: context,
                              future: () => room.setJoinRules(joinRule),
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<JoinRules>>[
                              if (room.canChangeJoinRules)
                                PopupMenuItem<JoinRules>(
                                  value: JoinRules.public,
                                  child: Text(JoinRules.public
                                      .getLocalizedString(
                                          MatrixLocals(L10n.of(context)))),
                                ),
                              if (room.canChangeJoinRules)
                                PopupMenuItem<JoinRules>(
                                  value: JoinRules.invite,
                                  child: Text(JoinRules.invite
                                      .getLocalizedString(
                                          MatrixLocals(L10n.of(context)))),
                                ),
                            ],
                          ),
                          PopupMenuButton(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                foregroundColor: Colors.grey,
                                child: Icon(Icons.visibility_outlined),
                              ),
                              title: Text(
                                  L10n.of(context).visibilityOfTheChatHistory),
                              subtitle: Text(
                                room.historyVisibility.getLocalizedString(
                                    MatrixLocals(L10n.of(context))),
                              ),
                            ),
                            onSelected: (HistoryVisibility historyVisibility) =>
                                showFutureLoadingDialog(
                              context: context,
                              future: () =>
                                  room.setHistoryVisibility(historyVisibility),
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<HistoryVisibility>>[
                              if (room.canChangeHistoryVisibility)
                                PopupMenuItem<HistoryVisibility>(
                                  value: HistoryVisibility.invited,
                                  child: Text(HistoryVisibility.invited
                                      .getLocalizedString(
                                          MatrixLocals(L10n.of(context)))),
                                ),
                              if (room.canChangeHistoryVisibility)
                                PopupMenuItem<HistoryVisibility>(
                                  value: HistoryVisibility.joined,
                                  child: Text(HistoryVisibility.joined
                                      .getLocalizedString(
                                          MatrixLocals(L10n.of(context)))),
                                ),
                              if (room.canChangeHistoryVisibility)
                                PopupMenuItem<HistoryVisibility>(
                                  value: HistoryVisibility.shared,
                                  child: Text(HistoryVisibility.shared
                                      .getLocalizedString(
                                          MatrixLocals(L10n.of(context)))),
                                ),
                              if (room.canChangeHistoryVisibility)
                                PopupMenuItem<HistoryVisibility>(
                                  value: HistoryVisibility.world_readable,
                                  child: Text(HistoryVisibility.world_readable
                                      .getLocalizedString(
                                          MatrixLocals(L10n.of(context)))),
                                ),
                            ],
                          ),
                          if (room.joinRules == JoinRules.public)
                            PopupMenuButton(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  foregroundColor: Colors.grey,
                                  child: Icon(Icons.info_outline),
                                ),
                                title: Text(
                                    L10n.of(context).areGuestsAllowedToJoin),
                                subtitle: Text(
                                  room.guestAccess.getLocalizedString(
                                      MatrixLocals(L10n.of(context))),
                                ),
                              ),
                              onSelected: (GuestAccess guestAccess) =>
                                  showFutureLoadingDialog(
                                context: context,
                                future: () => room.setGuestAccess(guestAccess),
                              ),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<GuestAccess>>[
                                if (room.canChangeGuestAccess)
                                  PopupMenuItem<GuestAccess>(
                                    value: GuestAccess.can_join,
                                    child: Text(
                                      GuestAccess.can_join.getLocalizedString(
                                          MatrixLocals(L10n.of(context))),
                                    ),
                                  ),
                                if (room.canChangeGuestAccess)
                                  PopupMenuItem<GuestAccess>(
                                    value: GuestAccess.forbidden,
                                    child: Text(
                                      GuestAccess.forbidden.getLocalizedString(
                                          MatrixLocals(L10n.of(context))),
                                    ),
                                  ),
                              ],
                            ),
                          ListTile(
                            title: Text(L10n.of(context).editChatPermissions),
                            subtitle:
                                Text(L10n.of(context).whoCanPerformWhichAction),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: Colors.grey,
                              child: Icon(Icons.edit_attributes_outlined),
                            ),
                            onTap: () => AdaptivePageLayout.of(context)
                                .pushNamed('/rooms/${room.id}/permissions'),
                          ),
                          Divider(thickness: 1),
                          ListTile(
                            title: Text(
                              actualMembersCount > 1
                                  ? L10n.of(context).countParticipants(
                                      actualMembersCount.toString())
                                  : L10n.of(context).emptyChat,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          room.canInvite
                              ? ListTile(
                                  title: Text(L10n.of(context).inviteContact),
                                  leading: CircleAvatar(
                                    child: Icon(Icons.add_outlined),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  onTap: () => AdaptivePageLayout.of(context)
                                      .pushNamed('/rooms/${room.id}/invite'),
                                )
                              : Container(),
                        ],
                      )
                    : i < members.length + 1
                        ? ParticipantListItem(members[i - 1])
                        : ListTile(
                            title: Text(L10n.of(context)
                                .loadCountMoreParticipants(
                                    (actualMembersCount - members.length)
                                        .toString())),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: Icon(
                                Icons.refresh,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () => requestMoreMembersAction(context),
                          ),
              ),
            ),
          );
        });
  }
}
