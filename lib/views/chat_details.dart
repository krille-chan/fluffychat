import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/list_items/participant_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/room_extension.dart';
import 'package:fluffychat/utils/room_state_enums_extensions.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:fluffychat/views/invitation_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_text/link_text.dart';
import 'package:toast/toast.dart';

class ChatDetails extends StatefulWidget {
  final Room room;

  const ChatDetails(this.room);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  List<User> members;
  bool topicEditMode = false;
  void setDisplaynameAction(BuildContext context, String displayname) async {
    final MatrixState matrix = Matrix.of(context);
    final success = await matrix.tryRequestWithLoadingDialog(
      widget.room.setName(displayname),
    );
    if (success != false) {
      Toast.show(
        "Displayname has been changed",
        context,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  void setCanonicalAliasAction(context, s) async {
    final String domain = widget.room.client.userID.split(":")[1];
    final String canonicalAlias = "%23" + s + "%3A" + domain;
    final Event aliasEvent = widget.room.getState("m.room.aliases", domain);
    final List aliases =
        aliasEvent != null ? aliasEvent.content["aliases"] ?? [] : [];
    if (aliases.indexWhere((s) => s == canonicalAlias) == -1) {
      List<String> newAliases = List.from(aliases);
      newAliases.add(canonicalAlias);
      final response = await Matrix.of(context).tryRequestWithLoadingDialog(
        widget.room.client.jsonRequest(
          type: HTTPType.GET,
          action: "/client/r0/directory/room/$canonicalAlias",
        ),
      );
      if (response == false) {
        final success = await Matrix.of(context).tryRequestWithLoadingDialog(
          widget.room.client.jsonRequest(
              type: HTTPType.PUT,
              action: "/client/r0/directory/room/$canonicalAlias",
              data: {"room_id": widget.room.id}),
        );
        if (success == false) return;
      }
    }
    await Matrix.of(context).tryRequestWithLoadingDialog(
      widget.room.client.jsonRequest(
          type: HTTPType.PUT,
          action:
              "/client/r0/rooms/${widget.room.id}/state/m.room.canonical_alias",
          data: {"alias": "#$s:$domain"}),
    );
  }

  void setTopicAction(BuildContext context, String displayname) async {
    setState(() => topicEditMode = false);
    final MatrixState matrix = Matrix.of(context);
    final success = await matrix.tryRequestWithLoadingDialog(
      widget.room.setDescription(displayname),
    );
    if (success != false) {
      Toast.show(
        "Group description has been changed",
        context,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  void setAvatarAction(BuildContext context) async {
    final File tempFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (tempFile == null) return;
    final MatrixState matrix = Matrix.of(context);
    final success = await matrix.tryRequestWithLoadingDialog(
      widget.room.setAvatar(
        MatrixFile(
          bytes: await tempFile.readAsBytes(),
          path: tempFile.path,
        ),
      ),
    );
    if (success != false) {
      Toast.show(
        "Avatar has been changed",
        context,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  void requestMoreMembersAction(BuildContext context) async {
    final List<User> participants = await Matrix.of(context)
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
      return Center(
        child: Text("You are no longer participating in this chat"),
      );
    }
    members ??= widget.room.getParticipants();
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
        appBar: AppBar(
          title: Text(widget.room.getLocalizedDisplayname(context)),
          actions: <Widget>[
            if (widget.room.canonicalAlias?.isNotEmpty ?? false)
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: widget.room.canonicalAlias),
                  );
                  Toast.show("Invitation link copied to clipboard", context,
                      duration: 5);
                },
              ),
            ChatSettingsPopupMenu(widget.room, false)
          ],
        ),
        body: ListView.builder(
          itemCount: members.length + 1 + (canRequestMoreMembers ? 1 : 0),
          itemBuilder: (BuildContext context, int i) => i == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ContentBanner(widget.room.avatar,
                        onEdit: widget.room.canSendEvent("m.room.avatar")
                            ? () => setAvatarAction(context)
                            : null),
                    Divider(height: 1),
                    topicEditMode
                        ? ListTile(
                            title: TextField(
                              textInputAction: TextInputAction.done,
                              onSubmitted: (s) => setTopicAction(context, s),
                              autofocus: true,
                              minLines: 1,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Group description:",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                                hintText: widget.room.topic ??
                                    "Set group description",
                              ),
                            ),
                          )
                        : ListTile(
                            leading: widget.room.canSendEvent("m.room.topic")
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.grey,
                                    child: Icon(Icons.edit),
                                  )
                                : null,
                            title: Text("Group description:",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold)),
                            subtitle: LinkText(
                              text: widget.room.topic?.isEmpty ?? true
                                  ? "Add a group description"
                                  : widget.room.topic,
                              linkStyle: TextStyle(color: Colors.blueAccent),
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            onTap: widget.room.canSendEvent("m.room.topic")
                                ? () => setState(() => topicEditMode = true)
                                : null,
                          ),
                    Divider(thickness: 8),
                    ListTile(
                      title: Text(
                        "Settings",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (widget.room.canSendEvent("m.room.name"))
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey,
                          child: Icon(Icons.people),
                        ),
                        title: TextField(
                          textInputAction: TextInputAction.done,
                          onSubmitted: (s) => setDisplaynameAction(context, s),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Change the name of the group",
                            labelStyle: TextStyle(color: Colors.black),
                            hintText:
                                widget.room.getLocalizedDisplayname(context),
                          ),
                        ),
                      ),
                    if (widget.room.canSendEvent("m.room.canonical_alias") &&
                        widget.room.joinRules == JoinRules.public)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey,
                          child: Icon(Icons.link),
                        ),
                        title: TextField(
                          textInputAction: TextInputAction.done,
                          onSubmitted: (s) =>
                              setCanonicalAliasAction(context, s),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Set invitation link",
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: widget.room.canonicalAlias
                                    ?.replaceAll("#", "") ??
                                "alias",
                            prefixText: "#",
                            suffixText: widget.room.client.userID.split(":")[1],
                          ),
                        ),
                      ),
                    PopupMenuButton(
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.grey,
                            child: Icon(Icons.public)),
                        title: Text("Who is allowed to join this group"),
                        subtitle: Text(
                          widget.room.joinRules.getLocalizedString(context),
                        ),
                      ),
                      onSelected: (JoinRules joinRule) =>
                          Matrix.of(context).tryRequestWithLoadingDialog(
                        widget.room.setJoinRules(joinRule),
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<JoinRules>>[
                        if (widget.room.canChangeJoinRules)
                          PopupMenuItem<JoinRules>(
                            value: JoinRules.public,
                            child: Text(
                                JoinRules.public.getLocalizedString(context)),
                          ),
                        if (widget.room.canChangeJoinRules)
                          PopupMenuItem<JoinRules>(
                            value: JoinRules.invite,
                            child: Text(
                                JoinRules.invite.getLocalizedString(context)),
                          ),
                      ],
                    ),
                    PopupMenuButton(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey,
                          child: Icon(Icons.visibility),
                        ),
                        title: Text("Visibility of the chat history"),
                        subtitle: Text(
                          widget.room.historyVisibility
                              .getLocalizedString(context),
                        ),
                      ),
                      onSelected: (HistoryVisibility historyVisibility) =>
                          Matrix.of(context).tryRequestWithLoadingDialog(
                        widget.room.setHistoryVisibility(historyVisibility),
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<HistoryVisibility>>[
                        if (widget.room.canChangeHistoryVisibility)
                          PopupMenuItem<HistoryVisibility>(
                            value: HistoryVisibility.invited,
                            child: Text(HistoryVisibility.invited
                                .getLocalizedString(context)),
                          ),
                        if (widget.room.canChangeHistoryVisibility)
                          PopupMenuItem<HistoryVisibility>(
                            value: HistoryVisibility.joined,
                            child: Text(HistoryVisibility.joined
                                .getLocalizedString(context)),
                          ),
                        if (widget.room.canChangeHistoryVisibility)
                          PopupMenuItem<HistoryVisibility>(
                            value: HistoryVisibility.shared,
                            child: Text(HistoryVisibility.shared
                                .getLocalizedString(context)),
                          ),
                        if (widget.room.canChangeHistoryVisibility)
                          PopupMenuItem<HistoryVisibility>(
                            value: HistoryVisibility.world_readable,
                            child: Text(HistoryVisibility.world_readable
                                .getLocalizedString(context)),
                          ),
                      ],
                    ),
                    if (widget.room.joinRules == JoinRules.public)
                      PopupMenuButton(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.grey,
                            child: Icon(Icons.info_outline),
                          ),
                          title: Text("Are guest users allowed to join"),
                          subtitle: Text(
                            widget.room.guestAccess.getLocalizedString(context),
                          ),
                        ),
                        onSelected: (GuestAccess guestAccess) =>
                            Matrix.of(context).tryRequestWithLoadingDialog(
                          widget.room.setGuestAccess(guestAccess),
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<GuestAccess>>[
                          if (widget.room.canChangeGuestAccess)
                            PopupMenuItem<GuestAccess>(
                              value: GuestAccess.can_join,
                              child: Text(
                                GuestAccess.can_join
                                    .getLocalizedString(context),
                              ),
                            ),
                          if (widget.room.canChangeGuestAccess)
                            PopupMenuItem<GuestAccess>(
                              value: GuestAccess.forbidden,
                              child: Text(
                                GuestAccess.forbidden
                                    .getLocalizedString(context),
                              ),
                            ),
                        ],
                      ),
                    Divider(thickness: 8),
                    ListTile(
                      title: Text(
                        "$actualMembersCount participant" +
                            (actualMembersCount > 1 ? "s:" : ":"),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    widget.room.canInvite
                        ? ListTile(
                            title: Text("Invite contact"),
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
                      title: Text(
                          "Load more ${actualMembersCount - members.length} participants"),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
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
  }
}
