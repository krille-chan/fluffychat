import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/list_items/message.dart';
import 'package:fluffychat/components/matrix.dart';
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
    String seenByText = "";
    if (timeline.events.isNotEmpty) {
      List lastReceipts = List.from(timeline.events.first.receipts);
      lastReceipts.removeWhere((r) =>
          r.user.id == room.client.userID ||
          r.user.id == timeline.events.first.senderId);
      if (lastReceipts.length == 1) {
        seenByText = "Seen by ${lastReceipts.first.user.calcDisplayname()}";
      } else if (lastReceipts.length == 2) {
        seenByText =
            "Seen by ${lastReceipts.first.user.calcDisplayname()} and ${lastReceipts[1].user.calcDisplayname()}";
      } else if (lastReceipts.length > 2) {
        seenByText =
            "Seen by ${lastReceipts.first.user.calcDisplayname()} and ${lastReceipts.length - 1} others";
      }
    }
    setState(() {
      this.seenByText = seenByText;
    });
  }

  Future<bool> getTimeline() async {
    timeline ??= await room.getTimeline(onUpdate: updateView);
    updateView();
    return true;
  }

  @override
  void dispose() {
    timeline?.sub?.cancel();
    super.dispose();
  }

  final TextEditingController sendController = TextEditingController();

  void send() {
    if (sendController.text.isEmpty) return;
    room.sendTextEvent(sendController.text);
    sendController.text = "";
  }

  void sendFileAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show("Not supported in web", context);
    }
    File file = await FilePicker.getFile();
    if (file == null) return;
    await Matrix.of(context).tryRequestWithLoadingDialog(
      room.sendFileEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  void sendImageAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show("Not supported in web", context);
    }
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await Matrix.of(context).tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  void openCameraAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show("Not supported in web", context);
    }
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await Matrix.of(context).tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Client client = Matrix.of(context).client;
    room ??= client.getRoomById(widget.id);
    if (room == null) {
      return Center(
        child: Text("You are no longer participating in this chat"),
      );
    }

    if (room.membership == Membership.invite) {
      Matrix.of(context).tryRequestWithLoadingDialog(room.join());
    }

    String typingText = "";
    List<User> typingUsers = room.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);

    if (typingUsers.length == 1) {
      typingText = "${typingUsers.first.calcDisplayname()} is typing...";
    } else if (typingUsers.length == 2) {
      typingText =
          "${typingUsers.first.calcDisplayname()} and ${typingUsers[1].calcDisplayname()} are typing...";
    } else if (typingUsers.length > 2) {
      typingText =
          "${typingUsers.first.calcDisplayname()} and ${typingUsers.length - 1} others are typing...";
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
              Text(room.displayname),
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
                    return ListView.builder(
                      reverse: true,
                      itemCount: timeline.events.length + 1,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int i) => i == 0
                          ? AnimatedContainer(
                              height: seenByText.isEmpty ? 0 : 36,
                              duration: seenByText.isEmpty
                                  ? Duration(milliseconds: 0)
                                  : Duration(milliseconds: 500),
                              alignment: timeline.events.first.senderId ==
                                      client.userID
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                seenByText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              padding: EdgeInsets.all(8),
                            )
                          : Message(timeline.events[i - 1]),
                    );
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
                                    const PopupMenuItem<String>(
                                      value: "file",
                                      child: ListTile(
                                        leading: Icon(Icons.attach_file),
                                        title: Text('Send file'),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "image",
                                      child: ListTile(
                                        leading: Icon(Icons.image),
                                        title: Text('Send image'),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "camera",
                                      child: ListTile(
                                        leading: Icon(Icons.camera),
                                        title: Text('Open camera'),
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(width: 8),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextField(
                              minLines: 1,
                              maxLines: kIsWeb ? 1 : null,
                              keyboardType: kIsWeb
                                  ? TextInputType.text
                                  : TextInputType.multiline,
                              onSubmitted: (t) => send(),
                              controller: sendController,
                              decoration: InputDecoration(
                                hintText: "Write a message...",
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
