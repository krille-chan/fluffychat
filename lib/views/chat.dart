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

  final ScrollController _scrollController = ScrollController();

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

  Future<bool> getTimeline() async {
    timeline ??= await room.getTimeline(onUpdate: () {
      setState(() {});
    });
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

    if (room.membership == Membership.invite) room.join();

    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(
        activeChat: widget.id,
      ),
      secondScaffold: Scaffold(
        appBar: AppBar(
          title: Text(room.displayname),
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
                      itemCount: timeline.events.length,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int i) =>
                          Message(timeline.events[i]),
                    );
                  },
                ),
              ),
              Container(
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
                              if (choice == "camera") openCameraAction(context);
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
                        child: TextField(
                      minLines: 1,
                      maxLines: kIsWeb ? 1 : null,
                      keyboardType:
                          kIsWeb ? TextInputType.text : TextInputType.multiline,
                      onSubmitted: (t) => send(),
                      controller: sendController,
                      decoration: InputDecoration(
                        labelText: "Write a message...",
                        hintText: "You're message",
                        border: InputBorder.none,
                      ),
                    )),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => send(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
