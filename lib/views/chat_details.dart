import 'package:famedlysdk/famedlysdk.dart';
import 'package:famedlysdk/matrix_api.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/list_items/participant_list_item.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:fluffychat/views/invitation_selection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_text/link_text.dart';
import './settings_emotes.dart';

class ChatDetails extends StatefulWidget {
  final Room room;

  const ChatDetails(this.room);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  List<User> members;
  void setDisplaynameAction(BuildContext context) async {
    var enterText = SimpleDialogs(context).enterText(
      titleText: L10n.of(context).changeTheNameOfTheGroup,
      labelText: L10n.of(context).changeTheNameOfTheGroup,
      hintText: widget.room.getLocalizedDisplayname(L10n.of(context)),
    );
    final displayname = await enterText;
    if (displayname == null) return;
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.setName(displayname),
    );
    if (success != false) {
      BotToast.showText(text: L10n.of(context).displaynameHasBeenChanged);
    }
  }

  void setCanonicalAliasAction(context) async {
    final s = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).setInvitationLink,
      labelText: L10n.of(context).setInvitationLink,
      hintText: L10n.of(context).alias.toLowerCase(),
      prefixText: '#',
      suffixText: ':' + widget.room.client.userID.domain,
    );
    if (s == null) return;
    final domain = widget.room.client.userID.domain;
    final canonicalAlias = '%23' + s + '%3A' + domain;
    final aliasEvent = widget.room.getState('m.room.aliases', domain);
    final aliases =
        aliasEvent != null ? aliasEvent.content['aliases'] ?? [] : [];
    if (aliases.indexWhere((s) => s == canonicalAlias) == -1) {
      var newAliases = List<String>.from(aliases);
      newAliases.add(canonicalAlias);
      final response = await SimpleDialogs(context).tryRequestWithLoadingDialog(
        widget.room.client.api.requestRoomAliasInformations(canonicalAlias),
      );
      if (response == false) {
        final success =
            await SimpleDialogs(context).tryRequestWithLoadingDialog(
          widget.room.client.api
              .createRoomAlias(canonicalAlias, widget.room.id),
        );
        if (success == false) return;
      }
    }
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.client.api
          .sendState(widget.room.id, 'm.room.canonical_alias', {
        'alias': '#$s:$domain',
      }),
    );
  }

  void setTopicAction(BuildContext context) async {
    final displayname = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).setGroupDescription,
      labelText: L10n.of(context).setGroupDescription,
      hintText: (widget.room.topic?.isNotEmpty ?? false)
          ? widget.room.topic
          : L10n.of(context).addGroupDescription,
      multiLine: true,
    );
    if (displayname == null) return;
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.setDescription(displayname),
    );
    if (success != false) {
      BotToast.showText(text: L10n.of(context).groupDescriptionHasBeenChanged);
    }
  }

  void setAvatarAction(BuildContext context) async {
    final tempFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (tempFile == null) return;
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.setAvatar(
        MatrixFile(
          bytes: await tempFile.readAsBytes(),
          path: tempFile.path,
        ),
      ),
    );
    if (success != false) {
      BotToast.showText(text: L10n.of(context).avatarHasBeenChanged);
    }
  }

  void requestMoreMembersAction(BuildContext context) async {
    final List<User> participants = await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(widget.room.requestParticipants());
    if (participants != null) setState(() => members = participants);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }
    members ??= widget.room.getParticipants();
    members.removeWhere((u) => u.membership == Membership.leave);
    final actualMembersCount =
        widget.room.mInvitedMemberCount + widget.room.mJoinedMemberCount;
    final canRequestMoreMembers = members.length < actualMembersCount;
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(
        activeChat: widget.room.id,
      ),
      secondScaffold: StreamBuilder(
          stream: widget.room.onUpdate.stream,
          builder: (context, snapshot) {
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
                  SliverAppBar(
                    expandedHeight: 300.0,
                    floating: true,
                    pinned: true,
                    actions: <Widget>[
                      if (widget.room.canonicalAlias?.isNotEmpty ?? false)
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: widget.room.canonicalAlias),
                            );
                            BotToast.showText(
                                text: L10n.of(context).copiedToClipboard);
                          },
                        ),
                      ChatSettingsPopupMenu(widget.room, false)
                    ],
                    title: Text(
                        widget.room.getLocalizedDisplayname(L10n.of(context)),
                        style: TextStyle(
                            color: Theme.of(context)
                                .appBarTheme
                                .textTheme
                                .headline6
                                .color)),
                    backgroundColor: Theme.of(context).appBarTheme.color,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ContentBanner(widget.room.avatar,
                          onEdit: widget.room.canSendEvent('m.room.avatar') &&
                                  !kIsWeb
                              ? () => setAvatarAction(context)
                              : null),
                    ),
                  ),
                ],
                body: ListView.builder(
                  itemCount:
                      members.length + 1 + (canRequestMoreMembers ? 1 : 0),
                  itemBuilder: (BuildContext context, int i) => i == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              leading: widget.room.canSendEvent('m.room.topic')
                                  ? CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      foregroundColor: Colors.grey,
                                      child: Icon(Icons.edit),
                                    )
                                  : null,
                              title: Text(
                                  '${L10n.of(context).groupDescription}:',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                              subtitle: LinkText(
                                text: widget.room.topic?.isEmpty ?? true
                                    ? L10n.of(context).addGroupDescription
                                    : widget.room.topic,
                                linkStyle: TextStyle(color: Colors.blueAccent),
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .color,
                                ),
                              ),
                              onTap: widget.room.canSendEvent('m.room.topic')
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
                            if (widget.room.canSendEvent('m.room.name'))
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  foregroundColor: Colors.grey,
                                  child: Icon(Icons.people),
                                ),
                                title: Text(
                                    L10n.of(context).changeTheNameOfTheGroup),
                                subtitle: Text(widget.room
                                    .getLocalizedDisplayname(L10n.of(context))),
                                onTap: () => setDisplaynameAction(context),
                              ),
                            if (widget.room
                                    .canSendEvent('m.room.canonical_alias') &&
                                widget.room.joinRules == JoinRules.public)
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  foregroundColor: Colors.grey,
                                  child: Icon(Icons.link),
                                ),
                                onTap: () => setCanonicalAliasAction(context),
                                title: Text(L10n.of(context).setInvitationLink),
                                subtitle: Text(
                                    (widget.room.canonicalAlias?.isNotEmpty ??
                                            false)
                                        ? widget.room.canonicalAlias
                                        : L10n.of(context).none),
                              ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                foregroundColor: Colors.grey,
                                child: Icon(Icons.insert_emoticon),
                              ),
                              title: Text(L10n.of(context).emoteSettings),
                              onTap: () async =>
                                  await Navigator.of(context).push(
                                AppRoute.defaultRoute(
                                  context,
                                  EmotesSettingsView(room: widget.room),
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    foregroundColor: Colors.grey,
                                    child: Icon(Icons.public)),
                                title: Text(L10n.of(context)
                                    .whoIsAllowedToJoinThisGroup),
                                subtitle: Text(
                                  widget.room.joinRules
                                      .getLocalizedString(L10n.of(context)),
                                ),
                              ),
                              onSelected: (JoinRules joinRule) =>
                                  SimpleDialogs(context)
                                      .tryRequestWithLoadingDialog(
                                widget.room.setJoinRules(joinRule),
                              ),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<JoinRules>>[
                                if (widget.room.canChangeJoinRules)
                                  PopupMenuItem<JoinRules>(
                                    value: JoinRules.public,
                                    child: Text(JoinRules.public
                                        .getLocalizedString(L10n.of(context))),
                                  ),
                                if (widget.room.canChangeJoinRules)
                                  PopupMenuItem<JoinRules>(
                                    value: JoinRules.invite,
                                    child: Text(JoinRules.invite
                                        .getLocalizedString(L10n.of(context))),
                                  ),
                              ],
                            ),
                            PopupMenuButton(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  foregroundColor: Colors.grey,
                                  child: Icon(Icons.visibility),
                                ),
                                title: Text(L10n.of(context)
                                    .visibilityOfTheChatHistory),
                                subtitle: Text(
                                  widget.room.historyVisibility
                                      .getLocalizedString(L10n.of(context)),
                                ),
                              ),
                              onSelected:
                                  (HistoryVisibility historyVisibility) =>
                                      SimpleDialogs(context)
                                          .tryRequestWithLoadingDialog(
                                widget.room
                                    .setHistoryVisibility(historyVisibility),
                              ),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<HistoryVisibility>>[
                                if (widget.room.canChangeHistoryVisibility)
                                  PopupMenuItem<HistoryVisibility>(
                                    value: HistoryVisibility.invited,
                                    child: Text(HistoryVisibility.invited
                                        .getLocalizedString(L10n.of(context))),
                                  ),
                                if (widget.room.canChangeHistoryVisibility)
                                  PopupMenuItem<HistoryVisibility>(
                                    value: HistoryVisibility.joined,
                                    child: Text(HistoryVisibility.joined
                                        .getLocalizedString(L10n.of(context))),
                                  ),
                                if (widget.room.canChangeHistoryVisibility)
                                  PopupMenuItem<HistoryVisibility>(
                                    value: HistoryVisibility.shared,
                                    child: Text(HistoryVisibility.shared
                                        .getLocalizedString(L10n.of(context))),
                                  ),
                                if (widget.room.canChangeHistoryVisibility)
                                  PopupMenuItem<HistoryVisibility>(
                                    value: HistoryVisibility.world_readable,
                                    child: Text(HistoryVisibility.world_readable
                                        .getLocalizedString(L10n.of(context))),
                                  ),
                              ],
                            ),
                            if (widget.room.joinRules == JoinRules.public)
                              PopupMenuButton(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    foregroundColor: Colors.grey,
                                    child: Icon(Icons.info_outline),
                                  ),
                                  title: Text(
                                      L10n.of(context).areGuestsAllowedToJoin),
                                  subtitle: Text(
                                    widget.room.guestAccess
                                        .getLocalizedString(L10n.of(context)),
                                  ),
                                ),
                                onSelected: (GuestAccess guestAccess) =>
                                    SimpleDialogs(context)
                                        .tryRequestWithLoadingDialog(
                                  widget.room.setGuestAccess(guestAccess),
                                ),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<GuestAccess>>[
                                  if (widget.room.canChangeGuestAccess)
                                    PopupMenuItem<GuestAccess>(
                                      value: GuestAccess.can_join,
                                      child: Text(
                                        GuestAccess.can_join.getLocalizedString(
                                            L10n.of(context)),
                                      ),
                                    ),
                                  if (widget.room.canChangeGuestAccess)
                                    PopupMenuItem<GuestAccess>(
                                      value: GuestAccess.forbidden,
                                      child: Text(
                                        GuestAccess.forbidden
                                            .getLocalizedString(
                                                L10n.of(context)),
                                      ),
                                    ),
                                ],
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
                            widget.room.canInvite
                                ? ListTile(
                                    title: Text(L10n.of(context).inviteContact),
                                    leading: CircleAvatar(
                                      child: Icon(Icons.add),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    onTap: () => Navigator.of(context).push(
                                      AppRoute.defaultRoute(
                                        context,
                                        InvitationSelection(widget.room),
                                      ),
                                    ),
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
          }),
    );
  }
}
