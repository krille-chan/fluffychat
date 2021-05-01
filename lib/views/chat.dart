import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/views/ui/chat_ui.dart';
import 'package:fluffychat/views/recording_dialog.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'send_file_dialog.dart';
import '../utils/filtered_timeline_extension.dart';
import '../utils/matrix_file_extension.dart';

class Chat extends StatefulWidget {
  final String id;
  final String scrollToEventId;

  Chat(this.id, {Key key, this.scrollToEventId})
      : super(key: key ?? Key('chatroom-$id'));

  @override
  ChatController createState() => ChatController();
}

class ChatController extends State<Chat> {
  Room room;

  Timeline timeline;

  MatrixState matrix;

  final AutoScrollController scrollController = AutoScrollController();

  FocusNode inputFocus = FocusNode();

  Timer typingCoolDown;
  Timer typingTimeout;
  bool currentlyTyping = false;

  List<Event> selectedEvents = [];

  List<Event> filteredEvents;

  final Set<String> unfolded = {};

  Event replyEvent;

  Event editEvent;

  bool showScrollDownButton = false;

  bool get selectMode => selectedEvents.isNotEmpty;

  final int _loadHistoryCount = 100;

  String inputText = '';

  String pendingText = '';

  bool get canLoadMore => timeline.events.last.type != EventTypes.RoomCreate;

  void startCallAction() async {
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
    if (canLoadMore) {
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
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        timeline.events.isNotEmpty &&
        timeline.events[timeline.events.length - 1].type !=
            EventTypes.RoomCreate) {
      requestHistory();
    }
    if (scrollController.position.pixels > 0 && showScrollDownButton == false) {
      setState(() => showScrollDownButton = true);
    } else if (scrollController.position.pixels == 0 &&
        showScrollDownButton == true) {
      setState(() => showScrollDownButton = false);
    }
  }

  @override
  void initState() {
    scrollController.addListener(_updateScrollController);
    super.initState();
  }

  void updateView() {
    if (!mounted) return;
    setState(
      () {
        filteredEvents = timeline.getFilteredEvents(unfolded: unfolded);
      },
    );
  }

  void unfold(String eventId) {
    var i = filteredEvents.indexWhere((e) => e.eventId == eventId);
    setState(() {
      while (i < filteredEvents.length - 1 && filteredEvents[i].isState) {
        unfolded.add(filteredEvents[i].eventId);
        i++;
      }
      filteredEvents = timeline.getFilteredEvents(unfolded: unfolded);
    });
  }

  Future<bool> getTimeline() async {
    if (timeline == null) {
      timeline = await room.getTimeline(onUpdate: updateView);
      if (timeline.events.isNotEmpty) {
        // ignore: unawaited_futures
        room.setUnread(false).catchError((err) {
          if (err is MatrixException && err.errcode == 'M_FORBIDDEN') {
            // ignore if the user is not in the room (still joining)
            return;
          }
          throw err;
        });
      }
      if (room.notificationCount != null &&
          room.notificationCount > 0 &&
          timeline != null &&
          timeline.events.isNotEmpty &&
          Matrix.of(context).webHasFocus) {
        // ignore: unawaited_futures
        room.sendReadMarker(
          timeline.events.first.eventId,
          readReceiptLocationEventId: timeline.events.first.eventId,
        );
      }

      // when the scroll controller is attached we want to scroll to an event id, if specified
      // and update the scroll controller...which will trigger a request history, if the
      // "load more" button is visible on the screen
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          if (widget.scrollToEventId != null) {
            scrollToEventId(widget.scrollToEventId);
          }
          _updateScrollController();
        }
      });
    }
    filteredEvents = timeline.getFilteredEvents(unfolded: unfolded);
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

  void sendFileAction() async {
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

  void sendImageAction() async {
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

  void openCameraAction() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
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

  void voiceMessageAction() async {
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

  String _getSelectedEventString() {
    var copyString = '';
    if (selectedEvents.length == 1) {
      return selectedEvents.first
          .getDisplayEvent(timeline)
          .getLocalizedBody(MatrixLocals(L10n.of(context)));
    }
    for (final event in selectedEvents) {
      if (copyString.isNotEmpty) copyString += '\n\n';
      copyString += event.getDisplayEvent(timeline).getLocalizedBody(
          MatrixLocals(L10n.of(context)),
          withSenderNamePrefix: true);
    }
    return copyString;
  }

  void copyEventsAction() {
    Clipboard.setData(ClipboardData(text: _getSelectedEventString()));
    setState(() => selectedEvents.clear());
  }

  void reportEventAction() async {
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

  void redactEventsAction() async {
    final confirmed = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).messageWillBeRemovedWarning,
          okLabel: L10n.of(context).remove,
          cancelLabel: L10n.of(context).cancel,
          useRootNavigator: false,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return;
    for (final event in selectedEvents) {
      await showFutureLoadingDialog(
          context: context,
          future: () => event.status > 0 ? event.redact() : event.remove());
    }
    setState(() => selectedEvents.clear());
  }

  bool get canRedactSelectedEvents {
    for (final event in selectedEvents) {
      if (event.canRedact == false) return false;
    }
    return true;
  }

  void forwardEventsAction() async {
    if (selectedEvents.length == 1) {
      Matrix.of(context).shareContent = selectedEvents.first.content;
    } else {
      Matrix.of(context).shareContent = {
        'msgtype': 'm.text',
        'body': _getSelectedEventString(),
      };
    }
    setState(() => selectedEvents.clear());
    AdaptivePageLayout.of(context).popUntilIsFirst();
  }

  void sendAgainAction() {
    final event = selectedEvents.first;
    if (event.status == -1) {
      event.sendAgain();
    }
    final allEditEvents = event
        .aggregatedEvents(timeline, RelationshipTypes.edit)
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

  void scrollToEventId(String eventId) async {
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
          if (!canLoadMore) {
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
    await scrollController.scrollToIndex(eventIndex,
        preferPosition: AutoScrollPosition.middle);
    _updateScrollController();
  }

  void scrollDown() => scrollController.jumpTo(0);

  void pickEmojiAction(Iterable<Event> allReactionEvents) async {
    final emoji = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (innerContext) => Column(
        children: [
          Spacer(),
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                // recent emojis don't work, so we sadly have to re-implement them
                // https://github.com/JeffG05/emoji_picker/issues/31
                SharedPreferences.getInstance().then((prefs) {
                  final recents = prefs.getStringList('recents') ?? <String>[];
                  recents.insert(0, emoji.name);
                  // make sure we remove duplicates
                  prefs.setStringList('recents', recents.toSet().toList());
                });
                Navigator.of(innerContext, rootNavigator: false).pop(emoji);
              },
            ),
          ),
        ],
      ),
    );
    if (emoji == null) return;
    // make sure we don't send the same emoji twice
    if (allReactionEvents
        .any((e) => e.content['m.relates_to']['key'] == emoji.emoji)) return;
    return sendEmojiAction(emoji.emoji);
  }

  void sendEmojiAction(String emoji) async {
    await showFutureLoadingDialog(
      context: context,
      future: () => room.sendReaction(
        selectedEvents.single.eventId,
        emoji,
      ),
    );
    setState(() => selectedEvents.clear());
  }

  void clearSelectedEvents() => setState(() => selectedEvents.clear());

  void editSelectedEventAction() {
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
  }

  void onEventActionPopupMenuSelected(selected) {
    switch (selected) {
      case 'copy':
        copyEventsAction();
        break;
      case 'redact':
        redactEventsAction();
        break;
      case 'report':
        reportEventAction();
        break;
    }
  }

  void goToNewRoomAction() async {
    if (OkCancelResult.ok !=
        await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).goToTheNewRoom,
          message: room
              .getState(EventTypes.RoomTombstone)
              .parsedTombstoneContent
              .body,
          okLabel: L10n.of(context).ok,
          cancelLabel: L10n.of(context).cancel,
        )) {
      return;
    }
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => room.client.joinRoom(room
          .getState(EventTypes.RoomTombstone)
          .parsedTombstoneContent
          .replacementRoom),
    );
    await showFutureLoadingDialog(
      context: context,
      future: room.leave,
    );
    if (result.error == null) {
      await AdaptivePageLayout.of(context)
          .pushNamedAndRemoveUntilIsFirst('/rooms/${result.result}');
    }
  }

  void onSelectMessage(Event event) {
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
        (a, b) => a.originServerTs.compareTo(b.originServerTs),
      );
    }
  }

  int findChildIndexCallback(Key key, Map<String, int> thisEventsKeyMap) {
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
  }

  void onInputBarSubmitted(String text) {
    send();
    FocusScope.of(context).requestFocus(inputFocus);
  }

  void onAddPopupMenuButtonSelected(String choice) {
    if (choice == 'file') {
      sendFileAction();
    } else if (choice == 'image') {
      sendImageAction();
    }
    if (choice == 'camera') {
      openCameraAction();
    }
    if (choice == 'voice') {
      voiceMessageAction();
    }
  }

  void onInputBarChanged(String text) {
    typingCoolDown?.cancel();
    typingCoolDown = Timer(Duration(seconds: 2), () {
      typingCoolDown = null;
      currentlyTyping = false;
      room.sendTypingNotification(false);
    });
    typingTimeout ??= Timer(Duration(seconds: 30), () {
      typingTimeout = null;
      currentlyTyping = false;
    });
    if (!currentlyTyping) {
      currentlyTyping = true;
      room.sendTypingNotification(true,
          timeout: Duration(seconds: 30).inMilliseconds);
    }
    // Workaround for a current desktop bug
    if (!PlatformInfos.isBetaDesktop) {
      setState(() => inputText = text);
    }
  }

  void cancelReplyEventAction() => setState(() {
        if (editEvent != null) {
          inputText = sendController.text = pendingText;
          pendingText = '';
        }
        replyEvent = null;
        editEvent = null;
      });

  @override
  Widget build(BuildContext context) => ChatUI(this);
}
