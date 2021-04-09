import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/views/widgets/avatar.dart';
import 'package:fluffychat/views/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/views/widgets/connection_status_header.dart';
import 'package:fluffychat/views/widgets/dialogs/recording_dialog.dart';
import 'package:fluffychat/views/widgets/unread_badge_back_button.dart';
import 'package:fluffychat/config/themes.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/views/widgets/encryption_button.dart';
import 'package:fluffychat/views/widgets/list_items/message.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:fluffychat/views/widgets/reply_content.dart';
import 'package:fluffychat/views/widgets/user_bottom_sheet.dart';
import 'package:fluffychat/config/app_emojis.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to_action/swipe_to_action.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../views/widgets/dialogs/send_file_dialog.dart';
import '../views/widgets/input_bar.dart';
import '../utils/filtered_timeline_extension.dart';
import '../utils/matrix_file_extension.dart';

class Chat extends StatefulWidget {
  final String id;
  final String scrollToEventId;

  Chat(this.id, {Key key, this.scrollToEventId})
      : super(key: key ?? Key('chatroom-$id'));

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Room room;

  Timeline timeline;

  MatrixState matrix;

  final AutoScrollController _scrollController = AutoScrollController();

  FocusNode inputFocus = FocusNode();

  Timer typingCoolDown;
  Timer typingTimeout;
  bool currentlyTyping = false;

  List<Event> selectedEvents = [];

  List<Event> filteredEvents;

  final Set<String> _unfolded = {};

  Event replyEvent;

  Event editEvent;

  bool showScrollDownButton = false;

  bool get selectMode => selectedEvents.isNotEmpty;

  final int _loadHistoryCount = 100;

  String inputText = '';

  String pendingText = '';

  bool get _canLoadMore => timeline.events.last.type != EventTypes.RoomCreate;

  void startCallAction(BuildContext context) async {
    final url =
        '${AppConfig.jitsiInstance}${Uri.encodeComponent(Matrix.of(context).client.generateUniqueTransactionId())}';

    final success = await showFutureLoadingDialog(
        context: context,
        future: () => room.sendEvent({
              'msgtype': Matrix.callNamespace,
              'body': url,
            }));
    if (success.error != null) return;
    await launch(url);
  }

  void requestHistory() async {
    if (_canLoadMore) {
      try {
        await timeline.requestHistory(historyCount: _loadHistoryCount);
      } catch (err) {
        AdaptivePageLayout.of(context).showSnackBar(
            SnackBar(content: Text(err.toLocalizedString(context))));
      }
    }
  }

  void _updateScrollController() {
    if (!mounted) {
      return;
    }
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
  }

  @override
  void initState() {
    _scrollController.addListener(_updateScrollController);
    super.initState();
  }

  void updateView() {
    if (!mounted) return;
    setState(
      () {
        filteredEvents = timeline.getFilteredEvents(unfolded: _unfolded);
      },
    );
  }

  void _unfold(String eventId) {
    var i = filteredEvents.indexWhere((e) => e.eventId == eventId);
    setState(() {
      while (i < filteredEvents.length - 1 && filteredEvents[i].isState) {
        _unfolded.add(filteredEvents[i].eventId);
        i++;
      }
      filteredEvents = timeline.getFilteredEvents(unfolded: _unfolded);
    });
  }

  Future<bool> getTimeline(BuildContext context) async {
    if (timeline == null) {
      timeline = await room.getTimeline(onUpdate: updateView);
      if (timeline.events.isNotEmpty) {
        unawaited(room.setUnread(false).catchError((err) {
          if (err is MatrixException && err.errcode == 'M_FORBIDDEN') {
            // ignore if the user is not in the room (still joining)
            return;
          }
          throw err;
        }));
      }

      // when the scroll controller is attached we want to scroll to an event id, if specified
      // and update the scroll controller...which will trigger a request history, if the
      // "load more" button is visible on the screen
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          if (widget.scrollToEventId != null) {
            _scrollToEventId(widget.scrollToEventId, context: context);
          }
          _updateScrollController();
        }
      });
    }
    updateView();
    return true;
  }

  @override
  void dispose() {
    timeline?.cancelSubscriptions();
    timeline = null;
    matrix.client.activeRoomId = '';
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void send() {
    if (sendController.text.trim().isEmpty) return;
    room.sendTextEvent(sendController.text,
        inReplyTo: replyEvent, editEventId: editEvent?.eventId);
    sendController.text = pendingText;

    setState(() {
      inputText = pendingText;
      replyEvent = null;
      editEvent = null;
      pendingText = '';
    });
  }

  void sendFileAction(BuildContext context) async {
    final result =
        await FilePickerCross.importFromStorage(type: FileTypeCross.any);
    if (result == null) return;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        file: MatrixFile(
          bytes: result.toUint8List(),
          name: result.fileName,
        ).detectFileType,
        room: room,
      ),
    );
  }

  void sendImageAction(BuildContext context) async {
    final result =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    if (result == null) return;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        file: MatrixImageFile(
          bytes: result.toUint8List(),
          name: result.fileName,
        ),
        room: room,
      ),
    );
  }

  void openCameraAction(BuildContext context) async {
    var file = await ImagePicker().getImage(source: ImageSource.camera);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        file: MatrixImageFile(
          bytes: bytes,
          name: file.path,
        ),
        room: room,
      ),
    );
  }

  void voiceMessageAction(BuildContext context) async {
    if (await Permission.microphone.isGranted != true) {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;
    }
    final result = await showDialog<String>(
      context: context,
      builder: (c) => RecordingDialog(),
      useRootNavigator: false,
    );
    if (result == null) return;
    final audioFile = File(result);
    // as we already explicitly say send in the recording dialog,
    // we do not need the send file dialog anymore. We can just send this straight away.
    await showFutureLoadingDialog(
      context: context,
      future: () => room.sendFileEvent(
        MatrixAudioFile(
            bytes: audioFile.readAsBytesSync(), name: audioFile.path),
      ),
    );
  }

  String _getSelectedEventString(BuildContext context) {
    var copyString = '';
    if (selectedEvents.length == 1) {
      return selectedEvents.first
          .getDisplayEvent(timeline)
          .getLocalizedBody(MatrixLocals(L10n.of(context)));
    }
    for (var event in selectedEvents) {
      if (copyString.isNotEmpty) copyString += '\n\n';
      copyString += event.getDisplayEvent(timeline).getLocalizedBody(
          MatrixLocals(L10n.of(context)),
          withSenderNamePrefix: true);
    }
    return copyString;
  }

  void copyEventsAction(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _getSelectedEventString(context)));
    setState(() => selectedEvents.clear());
  }

  void reportEventAction(BuildContext context) async {
    final event = selectedEvents.single;
    final score = await showConfirmationDialog<int>(
        context: context,
        title: L10n.of(context).howOffensiveIsThisContent,
        useRootNavigator: false,
        actions: [
          AlertDialogAction(
            key: -100,
            label: L10n.of(context).extremeOffensive,
          ),
          AlertDialogAction(
            key: -50,
            label: L10n.of(context).offensive,
          ),
          AlertDialogAction(
            key: 0,
            label: L10n.of(context).inoffensive,
          ),
        ]);
    if (score == null) return;
    final reason = await showTextInputDialog(
        context: context,
        title: L10n.of(context).whyDoYouWantToReportThis,
        okLabel: L10n.of(context).ok,
        cancelLabel: L10n.of(context).cancel,
        useRootNavigator: false,
        textFields: [DialogTextField(hintText: L10n.of(context).reason)]);
    if (reason == null || reason.single.isEmpty) return;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.reportEvent(
            event.roomId,
            event.eventId,
            reason.single,
            score,
          ),
    );
    if (result.error != null) return;
    setState(() => selectedEvents.clear());
    AdaptivePageLayout.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).contentHasBeenReported)));
  }

  void redactEventsAction(BuildContext context) async {
    var confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).messageWillBeRemovedWarning,
          okLabel: L10n.of(context).remove,
          cancelLabel: L10n.of(context).cancel,
          useRootNavigator: false,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return;
    for (var event in selectedEvents) {
      await showFutureLoadingDialog(
          context: context,
          future: () => event.status > 0 ? event.redact() : event.remove());
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
    AdaptivePageLayout.of(context).popUntilIsFirst();
  }

  void sendAgainAction(Timeline timeline) {
    final event = selectedEvents.first;
    if (event.status == -1) {
      event.sendAgain();
    }
    final allEditEvents = event
        .aggregatedEvents(timeline, RelationshipTypes.Edit)
        .where((e) => e.status == -1);
    for (final e in allEditEvents) {
      e.sendAgain();
    }
    setState(() => selectedEvents.clear());
  }

  void replyAction({Event replyTo}) {
    setState(() {
      replyEvent = replyTo ?? selectedEvents.first;
      selectedEvents.clear();
    });
    inputFocus.requestFocus();
  }

  void _scrollToEventId(String eventId, {BuildContext context}) async {
    var eventIndex = filteredEvents.indexWhere((e) => e.eventId == eventId);
    if (eventIndex == -1) {
      // event id not found...maybe we can fetch it?
      // the try...finally is here to start and close the loading dialog reliably
      final task = Future.microtask(() async {
        // okay, we first have to fetch if the event is in the room
        try {
          final event = await timeline.getEventById(eventId);
          if (event == null) {
            // event is null...meaning something is off
            return;
          }
        } catch (err) {
          if (err is MatrixException && err.errcode == 'M_NOT_FOUND') {
            // event wasn't found, as the server gave a 404 or something
            return;
          }
          rethrow;
        }
        // okay, we know that the event *is* in the room
        while (eventIndex == -1) {
          if (!_canLoadMore) {
            // we can't load any more events but still haven't found ours yet...better stop here
            return;
          }
          try {
            await timeline.requestHistory(historyCount: _loadHistoryCount);
          } catch (err) {
            if (err is TimeoutException) {
              // loading the history timed out...so let's do nothing
              return;
            }
            rethrow;
          }
          eventIndex = filteredEvents.indexWhere((e) => e.eventId == eventId);
        }
      });
      if (context != null) {
        await showFutureLoadingDialog(context: context, future: () => task);
      } else {
        await task;
      }
    }
    if (!mounted) {
      return;
    }
    await _scrollController.scrollToIndex(eventIndex,
        preferPosition: AutoScrollPosition.middle);
    _updateScrollController();
  }

  void _pickEmojiAction(
      BuildContext context, Iterable<Event> allReactionEvents) async {
    final emoji = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Column(
        children: [
          Spacer(),
          EmojiPicker(
            onEmojiSelected: (emoji, category) {
              // recent emojis don't work, so we sadly have to re-implement them
              // https://github.com/JeffG05/emoji_picker/issues/31
              SharedPreferences.getInstance().then((prefs) {
                final recents = prefs.getStringList('recents') ?? <String>[];
                recents.insert(0, emoji.name);
                // make sure we remove duplicates
                prefs.setStringList('recents', recents.toSet().toList());
              });
              Navigator.of(context, rootNavigator: false).pop<Emoji>(emoji);
            },
          ),
        ],
      ),
    );
    if (emoji == null) return;
    // make sure we don't send the same emoji twice
    if (allReactionEvents
        .any((e) => e.content['m.relates_to']['key'] == emoji.emoji)) return;
    return _sendEmojiAction(context, emoji.emoji);
  }

  void _sendEmojiAction(BuildContext context, String emoji) async {
    await showFutureLoadingDialog(
      context: context,
      future: () => room.sendReaction(
        selectedEvents.single.eventId,
        emoji,
      ),
    );
    setState(() => selectedEvents.clear());
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
    matrix.client.activeRoomId = widget.id;

    if (room.membership == Membership.invite) {
      showFutureLoadingDialog(context: context, future: () => room.join());
    }

    return Scaffold(
      appBar: AppBar(
        leading: selectMode
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => setState(() => selectedEvents.clear()),
                tooltip: L10n.of(context).close,
              )
            : AdaptivePageLayout.of(context).columnMode(context)
                ? null
                : UnreadBadgeBackButton(roomId: widget.id),
        titleSpacing:
            AdaptivePageLayout.of(context).columnMode(context) ? null : 0,
        title: selectedEvents.isEmpty
            ? StreamBuilder(
                stream: room.onUpdate.stream,
                builder: (context, snapshot) => ListTile(
                      leading: Avatar(room.avatar, room.displayname),
                      contentPadding: EdgeInsets.zero,
                      onTap: room.isDirectChat
                          ? () => showModalBottomSheet(
                                context: context,
                                builder: (c) => UserBottomSheet(
                                  user: room.getUserByMXIDSync(
                                      room.directChatMatrixID),
                                  onMention: () => sendController.text +=
                                      '${room.directChatMatrixID} ',
                                ),
                              )
                          : () => AdaptivePageLayout.of(context)
                                      .viewDataStack
                                      .length <
                                  3
                              ? AdaptivePageLayout.of(context)
                                  .pushNamed('/rooms/${room.id}/details')
                              : null,
                      title: Text(
                          room.getLocalizedDisplayname(
                              MatrixLocals(L10n.of(context))),
                          maxLines: 1),
                      subtitle: room.getLocalizedTypingText(context).isEmpty
                          ? StreamBuilder<Object>(
                              stream: Matrix.of(context)
                                  .client
                                  .onPresence
                                  .stream
                                  .where((p) =>
                                      p.senderId == room.directChatMatrixID),
                              builder: (context, snapshot) => Text(
                                    room.getLocalizedStatus(context),
                                    maxLines: 1,
                                    //overflow: TextOverflow.ellipsis,
                                  ))
                          : Row(
                              children: <Widget>[
                                Icon(Icons.edit_outlined,
                                    color: Theme.of(context).accentColor,
                                    size: 13),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    room.getLocalizedTypingText(context),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ))
            : Text(L10n.of(context)
                .numberSelected(selectedEvents.length.toString())),
        actions: selectMode
            ? <Widget>[
                if (selectedEvents.length == 1 &&
                    selectedEvents.first.status > 0 &&
                    selectedEvents.first.senderId == client.userID)
                  IconButton(
                    icon: Icon(Icons.edit_outlined),
                    tooltip: L10n.of(context).edit,
                    onPressed: () {
                      setState(() {
                        pendingText = sendController.text;
                        editEvent = selectedEvents.first;
                        inputText = sendController.text = editEvent
                            .getDisplayEvent(timeline)
                            .getLocalizedBody(MatrixLocals(L10n.of(context)),
                                withSenderNamePrefix: false, hideReply: true);
                        selectedEvents.clear();
                      });
                      inputFocus.requestFocus();
                    },
                  ),
                PopupMenuButton(
                  onSelected: (selected) {
                    switch (selected) {
                      case 'copy':
                        copyEventsAction(context);
                        break;
                      case 'redact':
                        redactEventsAction(context);
                        break;
                      case 'report':
                        reportEventAction(context);
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'copy',
                      child: Text(L10n.of(context).copy),
                    ),
                    if (canRedactSelectedEvents)
                      PopupMenuItem(
                        value: 'redact',
                        child: Text(
                          L10n.of(context).redactMessage,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    if (selectedEvents.length == 1)
                      PopupMenuItem(
                        value: 'report',
                        child: Text(
                          L10n.of(context).reportMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ]
            : <Widget>[
                if (room.canSendDefaultStates)
                  IconButton(
                    tooltip: L10n.of(context).videoCall,
                    icon: Icon(Icons.video_call_outlined),
                    onPressed: () => startCallAction(context),
                  ),
                ChatSettingsPopupMenu(room, !room.isDirectChat),
              ],
      ),
      floatingActionButton: showScrollDownButton
          ? Padding(
              padding: const EdgeInsets.only(bottom: 56.0),
              child: FloatingActionButton(
                onPressed: () => _scrollController.jumpTo(0),
                foregroundColor: Theme.of(context).textTheme.bodyText2.color,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                mini: true,
                child: Icon(Icons.arrow_downward_outlined,
                    color: Theme.of(context).primaryColor),
              ),
            )
          : null,
      body: Stack(
        children: <Widget>[
          if (Matrix.of(context).wallpaper != null)
            Image.file(
              Matrix.of(context).wallpaper,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          SafeArea(
            child: Column(
              children: <Widget>[
                ConnectionStatusHeader(),
                if (room.getState(EventTypes.RoomTombstone) != null)
                  Container(
                    height: 56,
                    color: Theme.of(context).secondaryHeaderColor,
                    child: ListTile(
                      leading: Icon(Icons.upgrade_outlined),
                      title: Text(room
                          .getState(EventTypes.RoomTombstone)
                          .parsedTombstoneContent
                          .body),
                      onTap: () async {
                        final result = await showFutureLoadingDialog(
                          context: context,
                          future: () => room.client.joinRoom(room
                              .getState(EventTypes.RoomTombstone)
                              .parsedTombstoneContent
                              .replacementRoom),
                        );
                        await showFutureLoadingDialog(
                          context: context,
                          future: () => room.leave(),
                        );
                        if (result.error == null) {
                          await AdaptivePageLayout.of(context)
                              .pushNamedAndRemoveUntilIsFirst(
                                  '/rooms/${result.result}');
                        }
                      },
                    ),
                  ),
                Expanded(
                  child: FutureBuilder<bool>(
                    future: getTimeline(context),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (room.notificationCount != null &&
                          room.notificationCount > 0 &&
                          timeline != null &&
                          timeline.events.isNotEmpty &&
                          Matrix.of(context).webHasFocus) {
                        room.sendReadMarker(
                          timeline.events.first.eventId,
                          readReceiptLocationEventId:
                              timeline.events.first.eventId,
                        );
                      }

                      // create a map of eventId --> index to greatly improve performance of
                      // ListView's findChildIndexCallback
                      final thisEventsKeyMap = <String, int>{};
                      for (var i = 0; i < filteredEvents.length; i++) {
                        thisEventsKeyMap[filteredEvents[i].eventId] = i;
                      }

                      final horizontalPadding = max(
                              0,
                              (MediaQuery.of(context).size.width -
                                      FluffyThemes.columnWidth *
                                          (AdaptivePageLayout.of(context)
                                                      .currentViewData
                                                      .rightView !=
                                                  null
                                              ? 4.5
                                              : 3.5)) /
                                  2)
                          .toDouble();

                      return ListView.custom(
                        padding: EdgeInsets.only(
                          top: 16,
                          left: horizontalPadding,
                          right: horizontalPadding,
                        ),
                        reverse: true,
                        controller: _scrollController,
                        childrenDelegate: SliverChildBuilderDelegate(
                          (BuildContext context, int i) {
                            return i == filteredEvents.length + 1
                                ? timeline.isRequestingHistory
                                    ? Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      )
                                    : _canLoadMore
                                        ? TextButton(
                                            onPressed: requestHistory,
                                            child: Text(
                                              L10n.of(context).loadMore,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          )
                                        : Container()
                                : i == 0
                                    ? StreamBuilder(
                                        stream: room.onUpdate.stream,
                                        builder: (_, __) {
                                          final seenByText =
                                              room.getLocalizedSeenByText(
                                            context,
                                            timeline,
                                            filteredEvents,
                                            _unfolded,
                                          );
                                          return AnimatedContainer(
                                            height: seenByText.isEmpty ? 0 : 24,
                                            duration: seenByText.isEmpty
                                                ? Duration(milliseconds: 0)
                                                : Duration(milliseconds: 300),
                                            alignment:
                                                filteredEvents.first.senderId ==
                                                        client.userID
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft,
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              bottom: 8,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                seenByText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : AutoScrollTag(
                                        key: ValueKey(
                                            filteredEvents[i - 1].eventId),
                                        index: i - 1,
                                        controller: _scrollController,
                                        child: Swipeable(
                                          key: ValueKey(
                                              filteredEvents[i - 1].eventId),
                                          background: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Center(
                                              child: Icon(Icons.reply_outlined),
                                            ),
                                          ),
                                          direction: SwipeDirection.endToStart,
                                          onSwipe: (direction) => replyAction(
                                              replyTo: filteredEvents[i - 1]),
                                          child: Message(filteredEvents[i - 1],
                                              onAvatarTab: (Event event) =>
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (c) =>
                                                        UserBottomSheet(
                                                      user: event.sender,
                                                      onMention: () =>
                                                          sendController.text +=
                                                              '${event.senderId} ',
                                                    ),
                                                  ),
                                              unfold: _unfold,
                                              onSelect: (Event event) {
                                                if (!event.redacted) {
                                                  if (selectedEvents
                                                      .contains(event)) {
                                                    setState(
                                                      () => selectedEvents
                                                          .remove(event),
                                                    );
                                                  } else {
                                                    setState(
                                                      () => selectedEvents
                                                          .add(event),
                                                    );
                                                  }
                                                  selectedEvents.sort(
                                                    (a, b) => a.originServerTs
                                                        .compareTo(
                                                            b.originServerTs),
                                                  );
                                                }
                                              },
                                              scrollToEventId:
                                                  (String eventId) =>
                                                      _scrollToEventId(eventId,
                                                          context: context),
                                              longPressSelect:
                                                  selectedEvents.isEmpty,
                                              selected: selectedEvents.contains(
                                                  filteredEvents[i - 1]),
                                              timeline: timeline,
                                              nextEvent: i >= 2
                                                  ? filteredEvents[i - 2]
                                                  : null),
                                        ),
                                      );
                          },
                          childCount: filteredEvents.length + 2,
                          findChildIndexCallback: (Key key) {
                            // this method is called very often. As such, it has to be optimized for speed.
                            if (!(key is ValueKey)) {
                              return null;
                            }
                            final eventId = (key as ValueKey).value;
                            if (!(eventId is String)) {
                              return null;
                            }
                            // first fetch the last index the event was at
                            final index = thisEventsKeyMap[eventId];
                            if (index == null) {
                              return null;
                            }
                            // we need to +1 as 0 is the typing thing at the bottom
                            return index + 1;
                          },
                        ),
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: (editEvent == null &&
                          replyEvent == null &&
                          room.canSendDefaultMessages &&
                          selectedEvents.length == 1)
                      ? 56
                      : 0,
                  child: Material(
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Builder(builder: (context) {
                      if (!(editEvent == null &&
                          replyEvent == null &&
                          selectedEvents.length == 1)) {
                        return Container();
                      }
                      var emojis = List<String>.from(AppEmojis.emojis);
                      final allReactionEvents = selectedEvents.first
                          .aggregatedEvents(
                              timeline, RelationshipTypes.Reaction)
                          ?.where((event) =>
                              event.senderId == event.room.client.userID &&
                              event.type == 'm.reaction');

                      allReactionEvents.forEach((event) {
                        try {
                          emojis.remove(event.content['m.relates_to']['key']);
                        } catch (_) {}
                      });
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: emojis.length + 1,
                        itemBuilder: (c, i) => i == emojis.length
                            ? InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => _pickEmojiAction(
                                    context, allReactionEvents),
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: Icon(Icons.add_outlined),
                                ),
                              )
                            : InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () =>
                                    _sendEmojiAction(context, emojis[i]),
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  child: Text(
                                    emojis[i],
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                      );
                    }),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: editEvent != null || replyEvent != null ? 56 : 0,
                  child: Material(
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          tooltip: L10n.of(context).close,
                          icon: Icon(Icons.close),
                          onPressed: () => setState(() {
                            if (editEvent != null) {
                              inputText = sendController.text = pendingText;
                              pendingText = '';
                            }
                            replyEvent = null;
                            editEvent = null;
                          }),
                        ),
                        Expanded(
                          child: replyEvent != null
                              ? ReplyContent(replyEvent, timeline: timeline)
                              : _EditContent(
                                  editEvent?.getDisplayEvent(timeline)),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                room.canSendDefaultMessages &&
                        room.membership == Membership.join
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: selectMode
                              ? <Widget>[
                                  Container(
                                    height: 56,
                                    child: TextButton(
                                      onPressed: () =>
                                          forwardEventsAction(context),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons
                                              .keyboard_arrow_left_outlined),
                                          Text(L10n.of(context).forward),
                                        ],
                                      ),
                                    ),
                                  ),
                                  selectedEvents.length == 1
                                      ? selectedEvents.first
                                                  .getDisplayEvent(timeline)
                                                  .status >
                                              0
                                          ? Container(
                                              height: 56,
                                              child: TextButton(
                                                onPressed: () => replyAction(),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                        L10n.of(context).reply),
                                                    Icon(Icons
                                                        .keyboard_arrow_right),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 56,
                                              child: TextButton(
                                                onPressed: () =>
                                                    sendAgainAction(timeline),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(L10n.of(context)
                                                        .tryToSendAgain),
                                                    SizedBox(width: 4),
                                                    Icon(Icons.send_outlined,
                                                        size: 16),
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
                                        icon: Icon(Icons.add_outlined),
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
                                                child: Icon(
                                                    Icons.attachment_outlined),
                                              ),
                                              title: Text(
                                                  L10n.of(context).sendFile),
                                              contentPadding: EdgeInsets.all(0),
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'image',
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                                child:
                                                    Icon(Icons.image_outlined),
                                              ),
                                              title: Text(
                                                  L10n.of(context).sendImage),
                                              contentPadding: EdgeInsets.all(0),
                                            ),
                                          ),
                                          if (PlatformInfos.isMobile)
                                            PopupMenuItem<String>(
                                              value: 'camera',
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.purple,
                                                  foregroundColor: Colors.white,
                                                  child: Icon(Icons
                                                      .camera_alt_outlined),
                                                ),
                                                title: Text(L10n.of(context)
                                                    .openCamera),
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                              ),
                                            ),
                                          if (PlatformInfos.isMobile)
                                            PopupMenuItem<String>(
                                              value: 'voice',
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  child: Icon(
                                                      Icons.mic_none_outlined),
                                                ),
                                                title: Text(L10n.of(context)
                                                    .voiceMessage),
                                                contentPadding:
                                                    EdgeInsets.all(0),
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
                                        autofocus: !PlatformInfos.isMobile,
                                        keyboardType: !PlatformInfos.isMobile
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
                                          enabledBorder: InputBorder.none,
                                          filled: false,
                                        ),
                                        onChanged: (String text) {
                                          typingCoolDown?.cancel();
                                          typingCoolDown =
                                              Timer(Duration(seconds: 2), () {
                                            typingCoolDown = null;
                                            currentlyTyping = false;
                                            room.sendTypingNotification(false);
                                          });
                                          typingTimeout ??=
                                              Timer(Duration(seconds: 30), () {
                                            typingTimeout = null;
                                            currentlyTyping = false;
                                          });
                                          if (!currentlyTyping) {
                                            currentlyTyping = true;
                                            room.sendTypingNotification(true,
                                                timeout: Duration(seconds: 30)
                                                    .inMilliseconds);
                                          }
                                          // Workaround for a current desktop bug
                                          if (!PlatformInfos.isBetaDesktop) {
                                            setState(() => inputText = text);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  if (PlatformInfos.isMobile &&
                                      inputText.isEmpty)
                                    Container(
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        tooltip: L10n.of(context).voiceMessage,
                                        icon: Icon(Icons.mic_none_outlined),
                                        onPressed: () =>
                                            voiceMessageAction(context),
                                      ),
                                    ),
                                  if (!PlatformInfos.isMobile ||
                                      inputText.isNotEmpty)
                                    Container(
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: Icon(Icons.send_outlined),
                                        onPressed: () => send(),
                                        tooltip: L10n.of(context).send,
                                      ),
                                    ),
                                ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditContent extends StatelessWidget {
  final Event event;

  _EditContent(this.event);

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return Container();
    }
    return Row(
      children: <Widget>[
        Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
        ),
        Container(width: 15.0),
        Text(
          event?.getLocalizedBody(
                MatrixLocals(L10n.of(context)),
                withSenderNamePrefix: false,
                hideReply: true,
              ) ??
              '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2.color,
          ),
        ),
      ],
    );
  }
}
