import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/list_items/participant_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/room_extension.dart';
import 'package:fluffychat/utils/room_state_enums_extensions.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:fluffychat/views/invitation_selection.dart';
import 'package:flutter/foundation.dart';
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
        I18n.of(context).displaynameHasBeenChanged,
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
        I18n.of(context).groupDescriptionHasBeenChanged,
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
        I18n.of(context).avatarHasBeenChanged,
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
                  Toast.show(I18n.of(context).copiedToClipboard, context,
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
                        onEdit:
                            widget.room.canSendEvent("m.room.avatar") && !kIsWeb
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
                                labelText:
                                    "${I18n.of(context).groupDescription}:",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                                hintText: widget.room.topic ??
                                    I18n.of(context).setGroupDescription,
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
                                  ? I18n.of(context).addGroupDescription
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
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey,
                          child: Icon(Icons.people),
                        ),
                        title: TextField(
                          textInputAction: TextInputAction.done,
                          onSubmitted: (s) => setDisplaynameAction(context, s),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: I18n.of(context).changeTheNameOfTheGroup,
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
                            labelText: I18n.of(context).setInvitationLink,
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: widget.room.canonicalAlias
                                    ?.replaceAll("#", "") ??
                                I18n.of(context).alias,
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
                        title:
                            Text(I18n.of(context).whoIsAllowedToJoinThisGroup),
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
                        title:
                            Text(I18n.of(context).visibilityOfTheChatHistory),
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
                          title: Text(I18n.of(context).areGuestsAllowedToJoin),
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
                    Divider(height: 1),
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
