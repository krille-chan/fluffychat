import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/list_items/participant_list_item.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:fluffychat/views/invitation_selection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_text/link_text.dart';

class ChatDetails extends StatefulWidget {
  final Room room;

  const ChatDetails(this.room);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  List<User> members;
  void setDisplaynameAction(BuildContext context) async {
    final String displayname = await SimpleDialogs(context).enterText(
      titleText: I18n.of(context).changeTheNameOfTheGroup,
      labelText: I18n.of(context).changeTheNameOfTheGroup,
      hintText: widget.room.getLocalizedDisplayname(I18n.of(context)),
    );
    if (displayname == null) return;
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.setName(displayname),
    );
    if (success != false) {
      showToast(I18n.of(context).displaynameHasBeenChanged);
    }
  }

  void setCanonicalAliasAction(context) async {
    final String s = await SimpleDialogs(context).enterText(
      titleText: I18n.of(context).setInvitationLink,
      labelText: I18n.of(context).setInvitationLink,
      hintText: I18n.of(context).alias.toLowerCase(),
      prefixText: "#",
      suffixText: ":" + widget.room.client.userID.domain,
    );
    if (s == null) return;
    final String domain = widget.room.client.userID.domain;
    final String canonicalAlias = "%23" + s + "%3A" + domain;
    final Event aliasEvent = widget.room.getState("m.room.aliases", domain);
    final List aliases =
        aliasEvent != null ? aliasEvent.content["aliases"] ?? [] : [];
    if (aliases.indexWhere((s) => s == canonicalAlias) == -1) {
      List<String> newAliases = List.from(aliases);
      newAliases.add(canonicalAlias);
      final response = await SimpleDialogs(context).tryRequestWithLoadingDialog(
        widget.room.client.jsonRequest(
          type: HTTPType.GET,
          action: "/client/r0/directory/room/$canonicalAlias",
        ),
      );
      if (response == false) {
        final success =
            await SimpleDialogs(context).tryRequestWithLoadingDialog(
          widget.room.client.jsonRequest(
              type: HTTPType.PUT,
              action: "/client/r0/directory/room/$canonicalAlias",
              data: {"room_id": widget.room.id}),
        );
        if (success == false) return;
      }
    }
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.client.jsonRequest(
          type: HTTPType.PUT,
          action:
              "/client/r0/rooms/${widget.room.id}/state/m.room.canonical_alias",
          data: {"alias": "#$s:$domain"}),
    );
  }

  void setTopicAction(BuildContext context) async {
    final String displayname = await SimpleDialogs(context).enterText(
      titleText: I18n.of(context).setGroupDescription,
      labelText: I18n.of(context).setGroupDescription,
      hintText: (widget.room.topic?.isNotEmpty ?? false)
          ? widget.room.topic
          : I18n.of(context).addGroupDescription,
      multiLine: true,
    );
    if (displayname == null) return;
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      widget.room.setDescription(displayname),
    );
    if (success != false) {
      showToast(I18n.of(context).groupDescriptionHasBeenChanged);
    }
  }

  void setAvatarAction(BuildContext context) async {
    final File tempFile = await ImagePicker.pickImage(
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
      showToast(I18n.of(context).avatarHasBeenChanged);
    }
  }

  void requestMoreMembersAction(BuildContext context) async {
    final List<User> participants = await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(widget.room.requestParticipants());
    if (participants != null) setState(() => members = participants);
  }

  StreamSubscription onUpdate;

  @override
  void dispose() {
    onUpdate?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(I18n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }
    members ??= widget.room.getParticipants();
    members.removeWhere((u) => u.membership == Membership.leave);
    final int actualMembersCount =
        widget.room.mInvitedMemberCount + widget.room.mJoinedMemberCount;
    final bool canRequestMoreMembers = members.length < actualMembersCount;
    this.onUpdate ??= widget.room.onUpdate.stream
        .listen((id) => setState(() => members = null));
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(
        activeChat: widget.room.id,
      ),
      secondScaffold: Scaffold(
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
                      showToast(I18n.of(context).copiedToClipboard);
                    },
                  ),
                ChatSettingsPopupMenu(widget.room, false)
              ],
              title: Text(widget.room.getLocalizedDisplayname(I18n.of(context)),
                  style: TextStyle(
                      color:
                          Theme.of(context).appBarTheme.textTheme.title.color)),
              backgroundColor: Theme.of(context).appBarTheme.color,
              flexibleSpace: FlexibleSpaceBar(
                background: ContentBanner(widget.room.avatar,
                    onEdit: widget.room.canSendEvent("m.room.avatar") && !kIsWeb
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
                        leading: widget.room.canSendEvent("m.room.topic")
                            ? CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                foregroundColor: Colors.grey,
                                child: Icon(Icons.edit),
                              )
                            : null,
                        title: Text("${I18n.of(context).groupDescription}:",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold)),
                        subtitle: LinkText(
                          text: widget.room.topic?.isEmpty ?? true
                              ? I18n.of(context).addGroupDescription
                              : widget.room.topic,
                          linkStyle: TextStyle(color: Colors.blueAccent),
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.body1.color,
                          ),
                        ),
                        onTap: widget.room.canSendEvent("m.room.topic")
                            ? () => setTopicAction(context)
                            : null,
                      ),
                      Divider(thickness: 1),
                      ListTile(
                        title: Text(
                          I18n.of(context).settings,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.room.canSendEvent("m.room.name"))
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            foregroundColor: Colors.grey,
                            child: Icon(Icons.people),
                          ),
                          title: Text(I18n.of(context).changeTheNameOfTheGroup),
                          subtitle: Text(widget.room
                              .getLocalizedDisplayname(I18n.of(context))),
                          onTap: () => setDisplaynameAction(context),
                        ),
                      if (widget.room.canSendEvent("m.room.canonical_alias") &&
                          widget.room.joinRules == JoinRules.public)
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            foregroundColor: Colors.grey,
                            child: Icon(Icons.link),
                          ),
                          onTap: () => setCanonicalAliasAction(context),
                          title: Text(I18n.of(context).setInvitationLink),
                          subtitle: Text(
                              (widget.room.canonicalAlias?.isNotEmpty ?? false)
                                  ? widget.room.canonicalAlias
                                  : I18n.of(context).none),
                        ),
                      PopupMenuButton(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: Colors.grey,
                              child: Icon(Icons.public)),
                          title: Text(
                              I18n.of(context).whoIsAllowedToJoinThisGroup),
                          subtitle: Text(
                            widget.room.joinRules
                                .getLocalizedString(I18n.of(context)),
                          ),
                        ),
                        onSelected: (JoinRules joinRule) =>
                            SimpleDialogs(context).tryRequestWithLoadingDialog(
                          widget.room.setJoinRules(joinRule),
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<JoinRules>>[
                          if (widget.room.canChangeJoinRules)
                            PopupMenuItem<JoinRules>(
                              value: JoinRules.public,
                              child: Text(JoinRules.public
                                  .getLocalizedString(I18n.of(context))),
                            ),
                          if (widget.room.canChangeJoinRules)
                            PopupMenuItem<JoinRules>(
                              value: JoinRules.invite,
                              child: Text(JoinRules.invite
                                  .getLocalizedString(I18n.of(context))),
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
                          title:
                              Text(I18n.of(context).visibilityOfTheChatHistory),
                          subtitle: Text(
                            widget.room.historyVisibility
                                .getLocalizedString(I18n.of(context)),
                          ),
                        ),
                        onSelected: (HistoryVisibility historyVisibility) =>
                            SimpleDialogs(context).tryRequestWithLoadingDialog(
                          widget.room.setHistoryVisibility(historyVisibility),
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<HistoryVisibility>>[
                          if (widget.room.canChangeHistoryVisibility)
                            PopupMenuItem<HistoryVisibility>(
                              value: HistoryVisibility.invited,
                              child: Text(HistoryVisibility.invited
                                  .getLocalizedString(I18n.of(context))),
                            ),
                          if (widget.room.canChangeHistoryVisibility)
                            PopupMenuItem<HistoryVisibility>(
                              value: HistoryVisibility.joined,
                              child: Text(HistoryVisibility.joined
                                  .getLocalizedString(I18n.of(context))),
                            ),
                          if (widget.room.canChangeHistoryVisibility)
                            PopupMenuItem<HistoryVisibility>(
                              value: HistoryVisibility.shared,
                              child: Text(HistoryVisibility.shared
                                  .getLocalizedString(I18n.of(context))),
                            ),
                          if (widget.room.canChangeHistoryVisibility)
                            PopupMenuItem<HistoryVisibility>(
                              value: HistoryVisibility.world_readable,
                              child: Text(HistoryVisibility.world_readable
                                  .getLocalizedString(I18n.of(context))),
                            ),
                        ],
                      ),
                      if (widget.room.joinRules == JoinRules.public)
                        PopupMenuButton(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: Colors.grey,
                              child: Icon(Icons.info_outline),
                            ),
                            title:
                                Text(I18n.of(context).areGuestsAllowedToJoin),
                            subtitle: Text(
                              widget.room.guestAccess
                                  .getLocalizedString(I18n.of(context)),
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
                                  GuestAccess.can_join
                                      .getLocalizedString(I18n.of(context)),
                                ),
                              ),
                            if (widget.room.canChangeGuestAccess)
                              PopupMenuItem<GuestAccess>(
                                value: GuestAccess.forbidden,
                                child: Text(
                                  GuestAccess.forbidden
                                      .getLocalizedString(I18n.of(context)),
                                ),
                              ),
                          ],
                        ),
                      Divider(thickness: 1),
                      ListTile(
                        title: Text(
                          actualMembersCount > 1
                              ? I18n.of(context).countParticipants(
                                  actualMembersCount.toString())
                              : I18n.of(context).emptyChat,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      widget.room.canInvite
                          ? ListTile(
                              title: Text(I18n.of(context).inviteContact),
                              leading: CircleAvatar(
                                child: Icon(Icons.add),
                                backgroundColor: Theme.of(context).primaryColor,
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
                        title: Text(I18n.of(context).loadCountMoreParticipants(
                            (actualMembersCount - members.length).toString())),
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
      ),
    );
  }
}
