import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/list_items/message.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/room_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import 'chat_list.dart';

class Chat extends StatefulWidget {
  final String id;

  const Chat(this.id, {Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Room room;

  Timeline timeline;

  MatrixState matrix;

  String seenByText = "";

  final ScrollController _scrollController = ScrollController();

  Timer typingCoolDown;
  Timer typingTimeout;
  bool currentlyTyping = false;

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          timeline.events.isNotEmpty &&
          timeline.events[timeline.events.length - 1].type !=
              EventTypes.RoomCreate) {
        await timeline.requestHistory(historyCount: 100);
      }
    });

    super.initState();
  }

  void updateView() {
    if (!mounted) return;

    String seenByText = "";
    if (timeline.events.isNotEmpty) {
      List lastReceipts = List.from(timeline.events.first.receipts);
      lastReceipts.removeWhere((r) =>
          r.user.id == room.client.userID ||
          r.user.id == timeline.events.first.senderId);
      if (lastReceipts.length == 1) {
        seenByText = I18n.of(context)
            .seenByUser(lastReceipts.first.user.calcDisplayname());
      } else if (lastReceipts.length == 2) {
        seenByText = seenByText = I18n.of(context).seenByUserAndUser(
            lastReceipts.first.user.calcDisplayname(),
            lastReceipts[1].user.calcDisplayname());
      } else if (lastReceipts.length > 2) {
        seenByText = I18n.of(context).seenByUserAndCountOthers(
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
    timeline ??= await room.getTimeline(onUpdate: updateView);
    updateView();
    return true;
  }

  @override
  void dispose() {
    timeline?.sub?.cancel();
    timeline = null;
    matrix.activeRoomId = "";
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void send() {
    if (sendController.text.isEmpty) return;
    room.sendTextEvent(sendController.text);
    sendController.text = "";
  }

  void sendFileAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show(I18n.of(context).notSupportedInWeb, context);
    }
    File file = await FilePicker.getFile();
    if (file == null) return;
    await matrix.tryRequestWithLoadingDialog(
      room.sendFileEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  void sendImageAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show(I18n.of(context).notSupportedInWeb, context);
    }
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await matrix.tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  void openCameraAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show(I18n.of(context).notSupportedInWeb, context);
    }
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await matrix.tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    matrix = Matrix.of(context);
    Client client = matrix.client;
    room ??= client.getRoomById(widget.id);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(I18n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }
    matrix.activeRoomId = widget.id;

    if (room.membership == Membership.invite) {
      matrix.tryRequestWithLoadingDialog(room.join());
    }

    String typingText = "";
    List<User> typingUsers = room.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);

    if (typingUsers.length == 1) {
      typingText = I18n.of(context).isTyping;
      if (typingUsers.first.id != room.directChatMatrixID) {
        typingText =
            I18n.of(context).userIsTyping(typingUsers.first.calcDisplayname());
      }
    } else if (typingUsers.length == 2) {
      typingText = I18n.of(context).userAndUserAreTyping(
          typingUsers.first.calcDisplayname(),
          typingUsers[1].calcDisplayname());
    } else if (typingUsers.length > 2) {
      typingText = I18n.of(context).userAndOthersAreTyping(
          typingUsers.first.calcDisplayname(),
          (typingUsers.length - 1).toString());
    }

    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(
        activeChat: widget.id,
      ),
      secondScaffold: Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(room.getLocalizedDisplayname(context)),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: typingText.isEmpty ? 0 : 20,
                child: Row(
                  children: <Widget>[
                    typingText.isEmpty
                        ? Container()
                        : Icon(Icons.edit,
                            color: Theme.of(context).primaryColor, size: 10),
                    SizedBox(width: 4),
                    Text(
                      typingText,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[ChatSettingsPopupMenu(room, !room.isDirectChat)],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
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
                      room.sendReadReceipt(timeline.events[0].eventId);
                    }

                    if (timeline.events.isEmpty) return Container();

                    return ListView.builder(
                        reverse: true,
                        itemCount: timeline.events.length + 1,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int i) {
                          return i == 0
                              ? AnimatedContainer(
                                  height: seenByText.isEmpty ? 0 : 24,
                                  duration: seenByText.isEmpty
                                      ? Duration(milliseconds: 0)
                                      : Duration(milliseconds: 500),
                                  alignment: timeline.events.first.senderId ==
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
                                  nextEvent:
                                      i >= 2 ? timeline.events[i - 2] : null);
                        });
                  },
                ),
              ),
              room.canSendDefaultMessages && room.membership == Membership.join
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, -1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          kIsWeb
                              ? Container()
                              : PopupMenuButton<String>(
                                  icon: Icon(Icons.add),
                                  onSelected: (String choice) async {
                                    if (choice == "file") {
                                      sendFileAction(context);
                                    } else if (choice == "image") {
                                      sendImageAction(context);
                                    }
                                    if (choice == "camera") {
                                      openCameraAction(context);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: "file",
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          child: Icon(Icons.attachment),
                                        ),
                                        title: Text(I18n.of(context).sendFile),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: "image",
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          child: Icon(Icons.image),
                                        ),
                                        title: Text(I18n.of(context).sendImage),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: "camera",
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.purple,
                                          foregroundColor: Colors.white,
                                          child: Icon(Icons.camera),
                                        ),
                                        title:
                                            Text(I18n.of(context).openCamera),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(width: 8),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextField(
                              minLines: 1,
                              maxLines: kIsWeb ? 1 : 8,
                              keyboardType: kIsWeb
                                  ? TextInputType.text
                                  : TextInputType.multiline,
                              onSubmitted: (t) => send(),
                              controller: sendController,
                              decoration: InputDecoration(
                                hintText: I18n.of(context).writeAMessage,
                                border: InputBorder.none,
                              ),
                              onChanged: (String text) {
                                this.typingCoolDown?.cancel();
                                this.typingCoolDown =
                                    Timer(Duration(seconds: 2), () {
                                  this.typingCoolDown = null;
                                  this.currentlyTyping = false;
                                  room.sendTypingInfo(false);
                                });
                                this.typingTimeout ??=
                                    Timer(Duration(seconds: 30), () {
                                  this.typingTimeout = null;
                                  this.currentlyTyping = false;
                                });
                                if (!this.currentlyTyping) {
                                  this.currentlyTyping = true;
                                  room.sendTypingInfo(true,
                                      timeout:
                                          Duration(seconds: 30).inMilliseconds);
                                }
                              },
                            ),
                          )),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () => send(),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
