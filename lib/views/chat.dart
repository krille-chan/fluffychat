import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/dialogs/presence_dialog.dart';
import 'package:fluffychat/components/dialogs/recording_dialog.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/encryption_button.dart';
import 'package:fluffychat/components/list_items/message.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/components/reply_content.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memoryfilepicker/memoryfilepicker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:image_picker/image_picker.dart';

import 'chat_details.dart';
import 'chat_list.dart';
import '../components/input_bar.dart';

class ChatView extends StatelessWidget {
  final String id;

  const ChatView(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(
        activeChat: id,
      ),
      secondScaffold: _Chat(id),
    );
  }
}

class _Chat extends StatefulWidget {
  final String id;

  const _Chat(this.id, {Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<_Chat> {
  Room room;

  Timeline timeline;

  MatrixState matrix;

  String seenByText = '';

  final ScrollController _scrollController = ScrollController();

  FocusNode inputFocus = FocusNode();

  Timer typingCoolDown;
  Timer typingTimeout;
  bool currentlyTyping = false;

  List<Event> selectedEvents = [];

  Event replyEvent;

  bool showScrollDownButton = false;

  bool get selectMode => selectedEvents.isNotEmpty;

  bool _loadingHistory = false;

  final int _loadHistoryCount = 100;

  String inputText = '';

  bool get _canLoadMore => timeline.events.last.type != EventTypes.RoomCreate;

  void requestHistory() async {
    if (_canLoadMore) {
      setState(() => _loadingHistory = true);
      try {
        await timeline.requestHistory(historyCount: _loadHistoryCount);
      } catch (e) {
        debugPrint('Error loading history: ' + e.toString());
      }
      if (mounted) setState(() => _loadingHistory = false);
    }
  }

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          timeline.events.isNotEmpty &&
          timeline.events[timeline.events.length - 1].type !=
              EventTypes.RoomCreate) {
        requestHistory();
      }
      if (_scrollController.position.pixels > 0 &&
          showScrollDownButton == false) {
        setState(() => showScrollDownButton = true);
      } else if (_scrollController.position.pixels == 0 &&
          showScrollDownButton == true) {
        setState(() => showScrollDownButton = false);
      }
    });

    super.initState();
  }

  void updateView() {
    if (!mounted) return;

    var seenByText = '';
    if (timeline.events.isNotEmpty) {
      var lastReceipts = List.from(timeline.events.first.receipts);
      lastReceipts.removeWhere((r) =>
          r.user.id == room.client.userID ||
          r.user.id == timeline.events.first.senderId);
      if (lastReceipts.length == 1) {
        seenByText = L10n.of(context)
            .seenByUser(lastReceipts.first.user.calcDisplayname());
      } else if (lastReceipts.length == 2) {
        seenByText = seenByText = L10n.of(context).seenByUserAndUser(
            lastReceipts.first.user.calcDisplayname(),
            lastReceipts[1].user.calcDisplayname());
      } else if (lastReceipts.length > 2) {
        seenByText = L10n.of(context).seenByUserAndCountOthers(
            lastReceipts.first.user.calcDisplayname(),
            (lastReceipts.length - 1).toString());
      }
    }
    if (timeline != null) {
      setState(() {
        this.seenByText = seenByText;
      });
    }
  }

  Future<bool> getTimeline() async {
    if (timeline == null) {
      timeline = await room.getTimeline(onUpdate: updateView);
      if (timeline.events.isNotEmpty) {
        unawaited(room.sendReadReceipt(timeline.events.first.eventId));
      }
      if (timeline.events.length < _loadHistoryCount) {
        requestHistory();
      }
    }
    updateView();
    return true;
  }

  @override
  void dispose() {
    timeline?.cancelSubscriptions();
    timeline = null;
    matrix.activeRoomId = '';
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void send() {
    if (sendController.text.isEmpty) return;
    room.sendTextEvent(sendController.text, inReplyTo: replyEvent);
    sendController.text = '';
    if (replyEvent != null) {
      setState(() => replyEvent = null);
    }

    setState(() => inputText = '');
  }

  void sendFileAction(BuildContext context) async {
    var file = await MemoryFilePicker.getFile();
    if (file == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      room.sendFileEvent(
        MatrixFile(bytes: file.bytes, path: file.path),
      ),
    );
  }

  void sendImageAction(BuildContext context) async {
    var file = await MemoryFilePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: await file.bytes, path: file.path),
      ),
    );
  }

  void openCameraAction(BuildContext context) async {
    var file = await MemoryFilePicker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: file.bytes, path: file.path),
      ),
    );
  }

  void voiceMessageAction(BuildContext context) async {
    String result;
    await showDialog(
        context: context,
        builder: (context) => RecordingDialog(
              onFinished: (r) => result = r,
            ));
    if (result == null) return;
    final audioFile = File(result);
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      room.sendAudioEvent(
        MatrixFile(bytes: audioFile.readAsBytesSync(), path: audioFile.path),
      ),
    );
  }

  String _getSelectedEventString(BuildContext context) {
    var copyString = '';
    if (selectedEvents.length == 1) {
      return selectedEvents.first.getLocalizedBody(L10n.of(context));
    }
    for (var event in selectedEvents) {
      if (copyString.isNotEmpty) copyString += '\n\n';
      copyString +=
          event.getLocalizedBody(L10n.of(context), withSenderNamePrefix: true);
    }
    return copyString;
  }

  void copyEventsAction(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _getSelectedEventString(context)));
    setState(() => selectedEvents.clear());
  }

  void redactEventsAction(BuildContext context) async {
    var confirmed = await SimpleDialogs(context).askConfirmation(
      titleText: L10n.of(context).messageWillBeRemovedWarning,
      confirmText: L10n.of(context).remove,
    );
    if (!confirmed) return;
    for (var event in selectedEvents) {
      await SimpleDialogs(context).tryRequestWithLoadingDialog(
          event.status > 0 ? event.redact() : event.remove());
    }
    setState(() => selectedEvents.clear());
  }

  bool get canRedactSelectedEvents {
    for (var event in selectedEvents) {
      if (event.canRedact == false) return false;
    }
    return true;
  }

  void forwardEventsAction(BuildContext context) async {
    if (selectedEvents.length == 1) {
      Matrix.of(context).shareContent = selectedEvents.first.content;
    } else {
      Matrix.of(context).shareContent = {
        'msgtype': 'm.text',
        'body': _getSelectedEventString(context),
      };
    }
    setState(() => selectedEvents.clear());
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void sendAgainAction() {
    selectedEvents.first.sendAgain();
    setState(() => selectedEvents.clear());
  }

  void replyAction() {
    setState(() {
      replyEvent = selectedEvents.first;
      selectedEvents.clear();
    });
    inputFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    matrix = Matrix.of(context);
    var client = matrix.client;
    room ??= client.getRoomById(widget.id);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }
    matrix.activeRoomId = widget.id;

    if (room.membership == Membership.invite) {
      SimpleDialogs(context).tryRequestWithLoadingDialog(room.join());
    }

    var typingText = '';
    var typingUsers = room.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);

    if (typingUsers.length == 1) {
      typingText = L10n.of(context).isTyping;
      if (typingUsers.first.id != room.directChatMatrixID) {
        typingText =
            L10n.of(context).userIsTyping(typingUsers.first.calcDisplayname());
      }
    } else if (typingUsers.length == 2) {
      typingText = L10n.of(context).userAndUserAreTyping(
          typingUsers.first.calcDisplayname(),
          typingUsers[1].calcDisplayname());
    } else if (typingUsers.length > 2) {
      typingText = L10n.of(context).userAndOthersAreTyping(
          typingUsers.first.calcDisplayname(),
          (typingUsers.length - 1).toString());
    }

    return Scaffold(
      appBar: AppBar(
        leading: selectMode
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => setState(() => selectedEvents.clear()),
              )
            : null,
        titleSpacing: 0,
        title: selectedEvents.isEmpty
            ? StreamBuilder<Object>(
                stream: Matrix.of(context)
                    .client
                    .onPresence
                    .stream
                    .where((p) => p.senderId == room.directChatMatrixID),
                builder: (context, snapshot) {
                  return ListTile(
                    leading: Avatar(room.avatar, room.displayname),
                    contentPadding: EdgeInsets.zero,
                    onTap: () =>
                        room.isDirectChat && room.directChatPresence == null
                            ? null
                            : room.isDirectChat
                                ? showDialog(
                                    context: context,
                                    builder: (c) => PresenceDialog(
                                      room.directChatPresence,
                                      avatarUrl: room.avatar,
                                      displayname: room.displayname,
                                    ),
                                  )
                                : Navigator.of(context).push(
                                    AppRoute.defaultRoute(
                                      context,
                                      ChatDetails(room),
                                    ),
                                  ),
                    title: Text(room.getLocalizedDisplayname(L10n.of(context)),
                        maxLines: 1),
                    subtitle: typingText.isEmpty
                        ? Text(
                            room.getLocalizedStatus(context),
                            maxLines: 1,
                          )
                        : Row(
                            children: <Widget>[
                              Icon(Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                  size: 13),
                              SizedBox(width: 4),
                              Text(
                                typingText,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  );
                })
            : Text(L10n.of(context)
                .numberSelected(selectedEvents.length.toString())),
        actions: selectMode
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () => copyEventsAction(context),
                ),
                if (canRedactSelectedEvents)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => redactEventsAction(context),
                  ),
              ]
            : <Widget>[ChatSettingsPopupMenu(room, !room.isDirectChat)],
      ),
      floatingActionButton: showScrollDownButton
          ? Padding(
              padding: const EdgeInsets.only(bottom: 56.0),
              child: FloatingActionButton(
                child: Icon(Icons.arrow_downward,
                    color: Theme.of(context).primaryColor),
                onPressed: () => _scrollController.jumpTo(0),
                foregroundColor: Theme.of(context).textTheme.bodyText2.color,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                mini: true,
              ),
            )
          : null,
      body: Stack(
        children: <Widget>[
          if (Matrix.of(context).wallpaper != null)
            Opacity(
              opacity: 0.66,
              child: Image.file(
                Matrix.of(context).wallpaper,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Column(
            children: <Widget>[
              if (_loadingHistory) LinearProgressIndicator(),
              Expanded(
                child: FutureBuilder<bool>(
                  future: getTimeline(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (room.notificationCount != null &&
                        room.notificationCount > 0 &&
                        timeline != null &&
                        timeline.events.isNotEmpty) {
                      room.sendReadReceipt(timeline.events.first.eventId);
                    }

                    if (timeline.events.isEmpty) return Container();

                    return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: max(
                              0,
                              (MediaQuery.of(context).size.width -
                                      AdaptivePageLayout.defaultMinWidth *
                                          3.5) /
                                  2),
                        ),
                        reverse: true,
                        itemCount: timeline.events.length + 2,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int i) {
                          return i == timeline.events.length + 1
                              ? _canLoadMore && !_loadingHistory
                                  ? FlatButton(
                                      child: Text(
                                        L10n.of(context).loadMore,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onPressed: requestHistory,
                                    )
                                  : Container()
                              : i == 0
                                  ? AnimatedContainer(
                                      height: seenByText.isEmpty ? 0 : 24,
                                      duration: seenByText.isEmpty
                                          ? Duration(milliseconds: 0)
                                          : Duration(milliseconds: 500),
                                      alignment:
                                          timeline.events.first.senderId ==
                                                  client.userID
                                              ? Alignment.topRight
                                              : Alignment.topLeft,
                                      child: Text(
                                        seenByText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        bottom: 8,
                                      ),
                                    )
                                  : Message(timeline.events[i - 1],
                                      onAvatarTab: (Event event) {
                                      sendController.text +=
                                          ' ${event.senderId}';
                                    }, onSelect: (Event event) {
                                      if (!event.redacted) {
                                        if (selectedEvents.contains(event)) {
                                          setState(
                                            () => selectedEvents.remove(event),
                                          );
                                        } else {
                                          setState(
                                            () => selectedEvents.add(event),
                                          );
                                        }
                                        selectedEvents.sort(
                                          (a, b) => a.originServerTs
                                              .compareTo(b.originServerTs),
                                        );
                                      }
                                    },
                                      longPressSelect: selectedEvents.isEmpty,
                                      selected: selectedEvents
                                          .contains(timeline.events[i - 1]),
                                      timeline: timeline,
                                      nextEvent: i >= 2
                                          ? timeline.events[i - 2]
                                          : null);
                        });
                  },
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: replyEvent != null ? 56 : 0,
                child: Material(
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => setState(() => replyEvent = null),
                      ),
                      Expanded(
                        child: ReplyContent(replyEvent),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).secondaryHeaderColor,
                thickness: 1,
              ),
              room.canSendDefaultMessages && room.membership == Membership.join
                  ? Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).backgroundColor.withOpacity(0.8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: selectMode
                            ? <Widget>[
                                Container(
                                  height: 56,
                                  child: FlatButton(
                                    onPressed: () =>
                                        forwardEventsAction(context),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.keyboard_arrow_left),
                                        Text(L10n.of(context).forward),
                                      ],
                                    ),
                                  ),
                                ),
                                selectedEvents.length == 1
                                    ? selectedEvents.first.status > 0
                                        ? Container(
                                            height: 56,
                                            child: FlatButton(
                                              onPressed: () => replyAction(),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(L10n.of(context).reply),
                                                  Icon(Icons
                                                      .keyboard_arrow_right),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 56,
                                            child: FlatButton(
                                              onPressed: () =>
                                                  sendAgainAction(),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(L10n.of(context)
                                                      .tryToSendAgain),
                                                  SizedBox(width: 4),
                                                  Icon(Icons.send, size: 16),
                                                ],
                                              ),
                                            ),
                                          )
                                    : Container(),
                              ]
                            : <Widget>[
                                if (inputText.isEmpty)
                                  Container(
                                    height: 56,
                                    alignment: Alignment.center,
                                    child: PopupMenuButton<String>(
                                      icon: Icon(Icons.add),
                                      onSelected: (String choice) async {
                                        if (choice == 'file') {
                                          sendFileAction(context);
                                        } else if (choice == 'image') {
                                          sendImageAction(context);
                                        }
                                        if (choice == 'camera') {
                                          openCameraAction(context);
                                        }
                                        if (choice == 'voice') {
                                          voiceMessageAction(context);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'file',
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              child: Icon(Icons.attachment),
                                            ),
                                            title:
                                                Text(L10n.of(context).sendFile),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'image',
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              child: Icon(Icons.image),
                                            ),
                                            title: Text(
                                                L10n.of(context).sendImage),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                        ),
                                        if (!kIsWeb)
                                          PopupMenuItem<String>(
                                            value: 'camera',
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.purple,
                                                foregroundColor: Colors.white,
                                                child: Icon(Icons.camera_alt),
                                              ),
                                              title: Text(
                                                  L10n.of(context).openCamera),
                                              contentPadding: EdgeInsets.all(0),
                                            ),
                                          ),
                                        if (!kIsWeb)
                                          PopupMenuItem<String>(
                                            value: 'voice',
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                child: Icon(Icons.mic),
                                              ),
                                              title: Text(L10n.of(context)
                                                  .voiceMessage),
                                              contentPadding: EdgeInsets.all(0),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: EncryptionButton(room),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: InputBar(
                                      room: room,
                                      minLines: 1,
                                      maxLines: kIsWeb ? 1 : 8,
                                      keyboardType: kIsWeb
                                          ? TextInputType.text
                                          : TextInputType.multiline,
                                      onSubmitted: (String text) {
                                        send();
                                        FocusScope.of(context)
                                            .requestFocus(inputFocus);
                                      },
                                      focusNode: inputFocus,
                                      controller: sendController,
                                      decoration: InputDecoration(
                                        hintText:
                                            L10n.of(context).writeAMessage,
                                        hintMaxLines: 1,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (String text) {
                                        typingCoolDown?.cancel();
                                        typingCoolDown =
                                            Timer(Duration(seconds: 2), () {
                                          typingCoolDown = null;
                                          currentlyTyping = false;
                                          room.sendTypingInfo(false);
                                        });
                                        typingTimeout ??=
                                            Timer(Duration(seconds: 30), () {
                                          typingTimeout = null;
                                          currentlyTyping = false;
                                        });
                                        if (!currentlyTyping) {
                                          currentlyTyping = true;
                                          room.sendTypingInfo(true,
                                              timeout: Duration(seconds: 30)
                                                  .inMilliseconds);
                                        }
                                        setState(() => inputText = text);
                                      },
                                    ),
                                  ),
                                ),
                                if (!kIsWeb && inputText.isEmpty)
                                  Container(
                                    height: 56,
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      icon: Icon(Icons.mic),
                                      onPressed: () =>
                                          voiceMessageAction(context),
                                    ),
                                  ),
                                if (kIsWeb || inputText.isNotEmpty)
                                  Container(
                                    height: 56,
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () => send(),
                                    ),
                                  ),
                              ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
