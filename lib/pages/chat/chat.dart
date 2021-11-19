import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat_view.dart';
import 'package:fluffychat/pages/chat/event_info_dialog.dart';
import 'package:fluffychat/pages/chat/recording_dialog.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/account_bundles.dart';
import '../../utils/localized_exception_extension.dart';
import '../../utils/matrix_sdk_extensions.dart/filtered_timeline_extension.dart';
import '../../utils/matrix_sdk_extensions.dart/matrix_file_extension.dart';
import '../new_private_chat/send_file_dialog.dart';
import '../new_private_chat/send_location_dialog.dart';
import 'sticker_picker_dialog.dart';

class Chat extends StatefulWidget {
  final Widget sideView;

  const Chat({Key key, this.sideView}) : super(key: key);

  @override
  ChatController createState() => ChatController();
}

class ChatController extends State<Chat> {
  Room room;

  Client sendingClient;

  Timeline timeline;

  MatrixState matrix;

  String get roomId => context.vRouter.pathParameters['roomid'];

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

  bool get canLoadMore =>
      timeline.events.isEmpty ||
      timeline.events.last.type != EventTypes.RoomCreate;

  bool showEmojiPicker = false;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (err as Object).toLocalizedString(context),
            ),
          ),
        );
        rethrow;
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
        room.markUnread(false).catchError((err) {
          if (err is MatrixException && err.errcode == 'M_FORBIDDEN') {
            // ignore if the user is not in the room (still joining)
            return;
          }
          throw err;
        });
      }

      // when the scroll controller is attached we want to scroll to an event id, if specified
      // and update the scroll controller...which will trigger a request history, if the
      // "load more" button is visible on the screen
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          final event = VRouter.of(context).queryParameters['event'];
          if (event != null) {
            scrollToEventId(event);
          }
          _updateScrollController();
        }
      });
    }
    filteredEvents = timeline.getFilteredEvents(unfolded: unfolded);
    if (room.notificationCount != null &&
        room.notificationCount > 0 &&
        timeline != null &&
        timeline.events.isNotEmpty &&
        Matrix.of(context).webHasFocus) {
      // ignore: unawaited_futures
      timeline.setReadMarker();
      if (PlatformInfos.isIOS) {
        // Workaround for iOS not clearing notifications with fcm_shared_isolate
        if (!room.client.rooms.any((r) =>
            r.membership == Membership.invite ||
            (r.notificationCount != null && r.notificationCount > 0))) {
          // ignore: unawaited_futures
          FlutterLocalNotificationsPlugin().cancelAll();
          FlutterAppBadger.removeBadge();
        }
      }
    }
    return true;
  }

  @override
  void dispose() {
    timeline?.cancelSubscriptions();
    timeline = null;
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void setSendingClient(Client c) {
    // first cancle typing with the old sending client
    if (currentlyTyping) {
      // no need to have the setting typing to false be blocking
      typingCoolDown?.cancel();
      typingCoolDown = null;
      room.setTyping(false);
      currentlyTyping = false;
    }
    // then set the new sending client
    setState(() => sendingClient = c);
  }

  void setActiveClient(Client c) => setState(() {
        Matrix.of(context).setActiveClient(c);
      });

  Future<void> send() async {
    if (sendController.text.trim().isEmpty) return;
    var parseCommands = true;

    final commandMatch = RegExp(r'^\/(\w+)').firstMatch(sendController.text);
    if (commandMatch != null &&
        !room.client.commands.keys.contains(commandMatch[1].toLowerCase())) {
      final l10n = L10n.of(context);
      final dialogResult = await showOkCancelAlertDialog(
        context: context,
        useRootNavigator: false,
        title: l10n.commandInvalid,
        message: l10n.commandMissing(commandMatch[0]),
        okLabel: l10n.sendAsText,
        cancelLabel: l10n.cancel,
      );
      if (dialogResult == null || dialogResult == OkCancelResult.cancel) return;
      parseCommands = false;
    }

    // ignore: unawaited_futures
    room.sendTextEvent(sendController.text,
        inReplyTo: replyEvent,
        editEventId: editEvent?.eventId,
        parseCommands: parseCommands);
    sendController.value = TextEditingValue(
      text: pendingText,
      selection: const TextSelection.collapsed(offset: 0),
    );

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
    // Make sure the textfield is unfocused before opening the camera
    FocusScope.of(context).requestFocus(FocusNode());
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
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

  void sendStickerAction() async {
    final sticker = await showModalBottomSheet<ImagePackImageContent>(
      context: context,
      useRootNavigator: false,
      builder: (c) => StickerPickerDialog(room: room),
    );
    if (sticker == null) return;
    final eventContent = <String, dynamic>{
      'body': sticker.body,
      if (sticker.info != null) 'info': sticker.info,
      'url': sticker.url.toString(),
    };
    // send the sticker
    await showFutureLoadingDialog(
      context: context,
      future: () => room.sendEvent(
        eventContent,
        type: EventTypes.Sticker,
      ),
    );
  }

  void voiceMessageAction() async {
    if (await Record().hasPermission() == false) return;
    final result = await showDialog<RecordingResult>(
      context: context,
      useRootNavigator: false,
      builder: (c) => const RecordingDialog(),
    );
    if (result == null) return;
    final audioFile = File(result.path);
    final file = MatrixAudioFile(
      bytes: audioFile.readAsBytesSync(),
      name: audioFile.path,
    );
    await showFutureLoadingDialog(
      context: context,
      future: () =>
          room.sendFileEvent(file, inReplyTo: replyEvent, extraContent: {
        'info': {
          ...file.info,
          'duration': result.duration,
        },
        'org.matrix.msc3245.voice': {},
      }),
    );
    setState(() {
      replyEvent = null;
    });
  }

  void sendLocationAction() async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendLocationDialog(room: room),
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
    setState(() {
      showEmojiPicker = false;
      selectedEvents.clear();
    });
  }

  void reportEventAction() async {
    final event = selectedEvents.single;
    final score = await showConfirmationDialog<int>(
        context: context,
        title: L10n.of(context).reportMessage,
        message: L10n.of(context).howOffensiveIsThisContent,
        cancelLabel: L10n.of(context).cancel,
        okLabel: L10n.of(context).ok,
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
        useRootNavigator: false,
        context: context,
        title: L10n.of(context).whyDoYouWantToReportThis,
        okLabel: L10n.of(context).ok,
        cancelLabel: L10n.of(context).cancel,
        textFields: [DialogTextField(hintText: L10n.of(context).reason)]);
    if (reason == null || reason.single.isEmpty) return;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.reportContent(
            event.roomId,
            event.eventId,
            reason: reason.single,
            score: score,
          ),
    );
    if (result.error != null) return;
    setState(() {
      showEmojiPicker = false;
      selectedEvents.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).contentHasBeenReported)));
  }

  void redactEventsAction() async {
    final confirmed = await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).messageWillBeRemovedWarning,
          okLabel: L10n.of(context).remove,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return;
    for (final event in selectedEvents) {
      await showFutureLoadingDialog(
          context: context,
          future: () async {
            if (event.status.isSent) {
              if (event.canRedact) {
                await event.redactEvent();
              } else {
                final client = currentRoomBundle.firstWhere(
                    (cl) => selectedEvents.first.senderId == cl.userID,
                    orElse: () => null);
                if (client == null) {
                  return;
                }
                final room = client.getRoomById(roomId);
                await Event.fromJson(event.toJson(), room).redactEvent();
              }
            } else {
              await event.remove();
            }
          });
    }
    setState(() {
      showEmojiPicker = false;
      selectedEvents.clear();
    });
  }

  List<Client> get currentRoomBundle {
    final clients = matrix.currentBundle;
    clients.removeWhere((c) => c.getRoomById(roomId) == null);
    return clients;
  }

  bool get canRedactSelectedEvents {
    final clients = matrix.currentBundle;
    for (final event in selectedEvents) {
      if (event.canRedact == false &&
          !(clients.any((cl) => event.senderId == cl.userID))) return false;
    }
    return true;
  }

  bool get canEditSelectedEvents {
    if (selectedEvents.length != 1 || !selectedEvents.first.status.isSent) {
      return false;
    }
    return currentRoomBundle
        .any((cl) => selectedEvents.first.senderId == cl.userID);
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
    VRouter.of(context).to('/rooms');
  }

  void sendAgainAction() {
    final event = selectedEvents.first;
    if (event.status.isError) {
      event.sendAgain();
    }
    final allEditEvents = event
        .aggregatedEvents(timeline, RelationshipTypes.edit)
        .where((e) => e.status.isError);
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
      await showFutureLoadingDialog(
          context: context,
          future: () async {
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
              eventIndex =
                  filteredEvents.indexWhere((e) => e.eventId == eventId);
            }
          });
    }
    if (!mounted) {
      return;
    }
    await scrollController.scrollToIndex(
      eventIndex,
      preferPosition: AutoScrollPosition.middle,
    );
    _updateScrollController();
  }

  void scrollDown() => scrollController.jumpTo(0);

  void onEmojiSelected(_, emoji) {
    setState(() => showEmojiPicker = false);
    if (emoji == null) return;
    // make sure we don't send the same emoji twice
    if (_allReactionEvents
        .any((e) => e.content['m.relates_to']['key'] == emoji.emoji)) return;
    return sendEmojiAction(emoji.emoji);
  }

  Iterable<Event> _allReactionEvents;

  void cancelEmojiPicker() => setState(() => showEmojiPicker = false);

  void pickEmojiAction(Iterable<Event> allReactionEvents) async {
    _allReactionEvents = allReactionEvents;
    setState(() => showEmojiPicker = true);
  }

  void sendEmojiAction(String emoji) async {
    final events = List<Event>.from(selectedEvents);
    setState(() => selectedEvents.clear());
    for (final event in events) {
      await room.sendReaction(
        event.eventId,
        emoji,
      );
    }
  }

  void clearSelectedEvents() => setState(() {
        selectedEvents.clear();
        showEmojiPicker = false;
      });

  void editSelectedEventAction() {
    final client = currentRoomBundle.firstWhere(
        (cl) => selectedEvents.first.senderId == cl.userID,
        orElse: () => null);
    if (client == null) {
      return;
    }
    setSendingClient(client);
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

  void goToNewRoomAction() async {
    if (OkCancelResult.ok !=
        await showOkCancelAlertDialog(
          useRootNavigator: false,
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
      VRouter.of(context).toSegments(['rooms', result.result]);
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
    if (key is! ValueKey) {
      return null;
    }
    final eventId = (key as ValueKey).value;
    if (eventId is! String) {
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

  void onInputBarSubmitted(_) {
    send();
    FocusScope.of(context).requestFocus(inputFocus);
  }

  void onAddPopupMenuButtonSelected(String choice) {
    if (choice == 'file') {
      sendFileAction();
    }
    if (choice == 'image') {
      sendImageAction();
    }
    if (choice == 'camera') {
      openCameraAction();
    }
    if (choice == 'sticker') {
      sendStickerAction();
    }
    if (choice == 'voice') {
      voiceMessageAction();
    }
    if (choice == 'location') {
      sendLocationAction();
    }
  }

  void onInputBarChanged(String text) {
    if (text.endsWith(' ') && matrix.hasComplexBundles) {
      final clients = currentRoomBundle;
      for (final client in clients) {
        final prefix = client.sendPrefix;
        if ((prefix?.isNotEmpty ?? false) &&
            text.toLowerCase() == '${prefix.toLowerCase()} ') {
          setSendingClient(client);
          setState(() {
            inputText = '';
            sendController.text = '';
          });
          return;
        }
      }
    }
    typingCoolDown?.cancel();
    typingCoolDown = Timer(const Duration(seconds: 2), () {
      typingCoolDown = null;
      currentlyTyping = false;
      room.setTyping(false);
    });
    typingTimeout ??= Timer(const Duration(seconds: 30), () {
      typingTimeout = null;
      currentlyTyping = false;
    });
    if (!currentlyTyping) {
      currentlyTyping = true;
      room.setTyping(true, timeout: const Duration(seconds: 30).inMilliseconds);
    }
    setState(() => inputText = text);
  }

  void showEventInfo([Event event]) =>
      (event ?? selectedEvents.single).showInfoDialog(context);

  void cancelReplyEventAction() => setState(() {
        if (editEvent != null) {
          inputText = sendController.text = pendingText;
          pendingText = '';
        }
        replyEvent = null;
        editEvent = null;
      });

  @override
  Widget build(BuildContext context) => ChatView(this);
}
