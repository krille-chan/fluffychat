import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat/chat_view.dart';
import 'package:fluffychat/pages/chat/event_info_dialog.dart';
import 'package:fluffychat/pages/chat/recording_dialog.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/event_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/ios_badge_client_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/callkeep_manager.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/account_bundles.dart';
import '../../utils/localized_exception_extension.dart';
import '../../utils/matrix_sdk_extensions.dart/filtered_timeline_extension.dart';
import '../../utils/matrix_sdk_extensions.dart/matrix_file_extension.dart';
import 'send_file_dialog.dart';
import 'send_location_dialog.dart';
import 'sticker_picker_dialog.dart';

class Chat extends StatefulWidget {
  final Widget? sideView;

  const Chat({Key? key, this.sideView}) : super(key: key);

  @override
  ChatController createState() => ChatController();
}

class ChatController extends State<Chat> {
  Room? room;

  Client? sendingClient;

  Timeline? timeline;

  MatrixState? matrix;

  String? get roomId => context.vRouter.pathParameters['roomid'];

  final AutoScrollController scrollController = AutoScrollController();

  FocusNode inputFocus = FocusNode();

  Timer? typingCoolDown;
  Timer? typingTimeout;
  bool currentlyTyping = false;
  bool dragging = false;

  void onDragEntered(_) => setState(() => dragging = true);

  void onDragExited(_) => setState(() => dragging = false);

  void onDragDone(DropDoneDetails details) async {
    setState(() => dragging = false);
    for (final xfile in details.files) {
      final bytes = await xfile.readAsBytes();
      await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (c) => SendFileDialog(
          file: MatrixFile(
            bytes: bytes,
            name: xfile.name,
          ).detectFileType,
          room: room!,
        ),
      );
    }
  }

  bool get canSaveSelectedEvent =>
      selectedEvents.length == 1 &&
      {
        MessageTypes.Video,
        MessageTypes.Image,
        MessageTypes.Sticker,
        MessageTypes.Audio,
        MessageTypes.File,
      }.contains(selectedEvents.single.messageType);

  void saveSelectedEvent() => selectedEvents.single.saveFile(context);

  List<Event> selectedEvents = [];

  late List<Event> filteredEvents;

  final Set<String> unfolded = {};

  Event? replyEvent;

  Event? editEvent;

  bool showScrollDownButton = false;

  bool get selectMode => selectedEvents.isNotEmpty;

  final int _loadHistoryCount = 100;

  String inputText = '';

  String pendingText = '';

  bool get canLoadMore =>
      timeline!.events.isEmpty ||
      timeline!.events.last.type != EventTypes.RoomCreate;

  bool showEmojiPicker = false;

  EmojiPickerType emojiPickerType = EmojiPickerType.keyboard;

  void requestHistory() async {
    if (canLoadMore) {
      try {
        await timeline!.requestHistory(historyCount: _loadHistoryCount);
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (err).toLocalizedString(context),
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
    setReadMarker();
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        timeline!.events.isNotEmpty &&
        timeline!.events[timeline!.events.length - 1].type !=
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
    inputFocus.addListener(_inputFocusListener);
    final voipPlugin = Matrix.of(context).voipPlugin;

    if (voipPlugin != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        CallKeepManager().setVoipPlugin(voipPlugin);
        CallKeepManager().initialize().catchError((_) => true);
      });
    }
    super.initState();
  }

  void updateView() {
    if (!mounted) return;
    setState(
      () {
        filteredEvents = timeline!.getFilteredEvents(unfolded: unfolded);
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
      filteredEvents = timeline!.getFilteredEvents(unfolded: unfolded);
    });
  }

  Future<bool> getTimeline() async {
    if (timeline == null) {
      timeline = await room!.getTimeline(onUpdate: updateView);
      if (timeline!.events.isNotEmpty) {
        if (room!.markedUnread) room!.markUnread(false);
        setReadMarker();
      }

      // when the scroll controller is attached we want to scroll to an event id, if specified
      // and update the scroll controller...which will trigger a request history, if the
      // "load more" button is visible on the screen
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        if (mounted) {
          final event = VRouter.of(context).queryParameters['event'];
          if (event != null) {
            scrollToEventId(event);
          }
          _updateScrollController();
        }
      });
    }
    filteredEvents = timeline!.getFilteredEvents(unfolded: unfolded);
    timeline!.requestKeys();
    return true;
  }

  Future<void>? _setReadMarkerFuture;

  void setReadMarker([_]) {
    if (_setReadMarkerFuture == null &&
        (room!.hasNewMessages || room!.notificationCount > 0) &&
        timeline != null &&
        timeline!.events.isNotEmpty &&
        Matrix.of(context).webHasFocus) {
      Logs().v('Set read marker...');
      // ignore: unawaited_futures
      _setReadMarkerFuture = timeline!.setReadMarker().then((_) {
        _setReadMarkerFuture = null;
      });
      room!.client.updateIosBadge();
    }
  }

  @override
  void dispose() {
    timeline?.cancelSubscriptions();
    timeline = null;
    inputFocus.removeListener(_inputFocusListener);
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void setSendingClient(Client? c) {
    // first cancle typing with the old sending client
    if (currentlyTyping) {
      // no need to have the setting typing to false be blocking
      typingCoolDown?.cancel();
      typingCoolDown = null;
      room!.setTyping(false);
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
        !room!.client.commands.keys.contains(commandMatch[1]!.toLowerCase())) {
      final l10n = L10n.of(context)!;
      final dialogResult = await showOkCancelAlertDialog(
        context: context,
        useRootNavigator: false,
        title: l10n.commandInvalid,
        message: l10n.commandMissing(commandMatch[0]!),
        okLabel: l10n.sendAsText,
        cancelLabel: l10n.cancel,
      );
      if (dialogResult == OkCancelResult.cancel) return;
      parseCommands = false;
    }

    // ignore: unawaited_futures
    room!.sendTextEvent(sendController.text,
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
    if (result.fileName == null) return;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        file: MatrixFile(
          bytes: result.toUint8List(),
          name: result.fileName!,
        ).detectFileType,
        room: room!,
      ),
    );
  }

  void sendImageAction() async {
    final result =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    if (result.fileName == null) return;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        file: MatrixImageFile(
          bytes: result.toUint8List(),
          name: result.fileName!,
        ),
        room: room!,
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
        room: room!,
      ),
    );
  }

  void openVideoCameraAction() async {
    // Make sure the textfield is unfocused before opening the camera
    FocusScope.of(context).requestFocus(FocusNode());
    final file = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        file: MatrixVideoFile(
          bytes: bytes,
          name: file.path,
        ),
        room: room!,
      ),
    );
  }

  void sendStickerAction() async {
    final sticker = await showModalBottomSheet<ImagePackImageContent>(
      context: context,
      useRootNavigator: false,
      builder: (c) => StickerPickerDialog(room: room!),
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
      future: () => room!.sendEvent(
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
          room!.sendFileEvent(file, inReplyTo: replyEvent, extraContent: {
        'info': {
          ...file.info,
          'duration': result.duration,
        },
        'org.matrix.msc3245.voice': {},
        'org.matrix.msc1767.audio': {
          'duration': result.duration,
          'waveform': result.waveform,
        },
      }),
    );
    setState(() {
      replyEvent = null;
    });
  }

  void emojiPickerAction() {
    if (showEmojiPicker) {
      inputFocus.requestFocus();
    } else {
      inputFocus.unfocus();
    }
    emojiPickerType = EmojiPickerType.keyboard;
    setState(() => showEmojiPicker = !showEmojiPicker);
  }

  void _inputFocusListener() {
    if (showEmojiPicker && inputFocus.hasFocus) {
      emojiPickerType = EmojiPickerType.keyboard;
      setState(() => showEmojiPicker = false);
    }
  }

  void sendLocationAction() async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendLocationDialog(room: room!),
    );
  }

  String _getSelectedEventString() {
    var copyString = '';
    if (selectedEvents.length == 1) {
      return selectedEvents.first
          .getDisplayEvent(timeline!)
          .getLocalizedBody(MatrixLocals(L10n.of(context)!));
    }
    for (final event in selectedEvents) {
      if (copyString.isNotEmpty) copyString += '\n\n';
      copyString += event.getDisplayEvent(timeline!).getLocalizedBody(
          MatrixLocals(L10n.of(context)!),
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
        title: L10n.of(context)!.reportMessage,
        message: L10n.of(context)!.howOffensiveIsThisContent,
        cancelLabel: L10n.of(context)!.cancel,
        okLabel: L10n.of(context)!.ok,
        actions: [
          AlertDialogAction(
            key: -100,
            label: L10n.of(context)!.extremeOffensive,
          ),
          AlertDialogAction(
            key: -50,
            label: L10n.of(context)!.offensive,
          ),
          AlertDialogAction(
            key: 0,
            label: L10n.of(context)!.inoffensive,
          ),
        ]);
    if (score == null) return;
    final reason = await showTextInputDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context)!.whyDoYouWantToReportThis,
        okLabel: L10n.of(context)!.ok,
        cancelLabel: L10n.of(context)!.cancel,
        textFields: [DialogTextField(hintText: L10n.of(context)!.reason)]);
    if (reason == null || reason.single.isEmpty) return;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.reportContent(
            event.roomId!,
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
        SnackBar(content: Text(L10n.of(context)!.contentHasBeenReported)));
  }

  void redactEventsAction() async {
    final confirmed = await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.messageWillBeRemovedWarning,
          okLabel: L10n.of(context)!.remove,
          cancelLabel: L10n.of(context)!.cancel,
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
                    (cl) => selectedEvents.first.senderId == cl!.userID,
                    orElse: () => null);
                if (client == null) {
                  return;
                }
                final room = client.getRoomById(roomId!)!;
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

  List<Client?> get currentRoomBundle {
    final clients = matrix!.currentBundle!;
    clients.removeWhere((c) => c!.getRoomById(roomId!) == null);
    return clients;
  }

  bool get canRedactSelectedEvents {
    final clients = matrix!.currentBundle;
    for (final event in selectedEvents) {
      if (event.canRedact == false &&
          !(clients!.any((cl) => event.senderId == cl!.userID))) return false;
    }
    return true;
  }

  bool get canEditSelectedEvents {
    if (selectedEvents.length != 1 || !selectedEvents.first.status.isSent) {
      return false;
    }
    return currentRoomBundle
        .any((cl) => selectedEvents.first.senderId == cl!.userID);
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
        .aggregatedEvents(timeline!, RelationshipTypes.edit)
        .where((e) => e.status.isError);
    for (final e in allEditEvents) {
      e.sendAgain();
    }
    setState(() => selectedEvents.clear());
  }

  void replyAction({Event? replyTo}) {
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
              final event = await timeline!.getEventById(eventId);
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
                await timeline!.requestHistory(historyCount: _loadHistoryCount);
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

  void onEmojiSelected(_, Emoji? emoji) {
    switch (emojiPickerType) {
      case EmojiPickerType.reaction:
        senEmojiReaction(emoji);
        break;
      case EmojiPickerType.keyboard:
        typeEmoji(emoji);
        onInputBarChanged(sendController.text);
        break;
    }
  }

  void senEmojiReaction(Emoji? emoji) {
    setState(() => showEmojiPicker = false);
    if (emoji == null) return;
    // make sure we don't send the same emoji twice
    if (_allReactionEvents
        .any((e) => e.content['m.relates_to']['key'] == emoji.emoji)) return;
    return sendEmojiAction(emoji.emoji);
  }

  void typeEmoji(Emoji? emoji) {
    if (emoji == null) return;
    final text = sendController.text;
    final selection = sendController.selection;
    final newText = sendController.text.isEmpty
        ? emoji.emoji
        : text.replaceRange(selection.start, selection.end, emoji.emoji);
    sendController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        // don't forget an UTF-8 combined emoji might have a length > 1
        offset: selection.baseOffset + emoji.emoji.length,
      ),
    );
  }

  late Iterable<Event> _allReactionEvents;

  void emojiPickerBackspace() {
    switch (emojiPickerType) {
      case EmojiPickerType.reaction:
        setState(() => showEmojiPicker = false);
        break;
      case EmojiPickerType.keyboard:
        sendController
          ..text = sendController.text.characters.skipLast(1).toString()
          ..selection = TextSelection.fromPosition(
              TextPosition(offset: sendController.text.length));
        break;
    }
  }

  void pickEmojiReactionAction(Iterable<Event> allReactionEvents) async {
    _allReactionEvents = allReactionEvents;
    emojiPickerType = EmojiPickerType.reaction;
    setState(() => showEmojiPicker = true);
  }

  void sendEmojiAction(String? emoji) async {
    final events = List<Event>.from(selectedEvents);
    setState(() => selectedEvents.clear());
    for (final event in events) {
      await room!.sendReaction(
        event.eventId,
        emoji!,
      );
    }
  }

  void clearSelectedEvents() => setState(() {
        selectedEvents.clear();
        showEmojiPicker = false;
      });

  void clearSingleSelectedEvent() {
    if (selectedEvents.length <= 1) {
      clearSelectedEvents();
    }
  }

  void editSelectedEventAction() {
    final client = currentRoomBundle.firstWhere(
        (cl) => selectedEvents.first.senderId == cl!.userID,
        orElse: () => null);
    if (client == null) {
      return;
    }
    setSendingClient(client);
    setState(() {
      pendingText = sendController.text;
      editEvent = selectedEvents.first;
      inputText = sendController.text = editEvent!
          .getDisplayEvent(timeline!)
          .getLocalizedBody(MatrixLocals(L10n.of(context)!),
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
          title: L10n.of(context)!.goToTheNewRoom,
          message: room!
              .getState(EventTypes.RoomTombstone)!
              .parsedTombstoneContent
              .body,
          okLabel: L10n.of(context)!.ok,
          cancelLabel: L10n.of(context)!.cancel,
        )) {
      return;
    }
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => room!.client.joinRoom(room!
          .getState(EventTypes.RoomTombstone)!
          .parsedTombstoneContent
          .replacementRoom),
    );
    await showFutureLoadingDialog(
      context: context,
      future: room!.leave,
    );
    if (result.error == null) {
      VRouter.of(context).toSegments(['rooms', result.result!]);
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

  int? findChildIndexCallback(Key key, Map<String, int> thisEventsKeyMap) {
    // this method is called very often. As such, it has to be optimized for speed.
    if (key is! ValueKey) {
      return null;
    }
    final eventId = key.value;
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
    if (choice == 'camera-video') {
      openVideoCameraAction();
    }
    if (choice == 'sticker') {
      sendStickerAction();
    }
    if (choice == 'location') {
      sendLocationAction();
    }
  }

  unpinEvent(String eventId) async {
    final response = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.unpin,
      message: L10n.of(context)!.confirmEventUnpin,
      okLabel: L10n.of(context)!.unpin,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (response == OkCancelResult.ok) {
      final events = room!.pinnedEventIds
        ..removeWhere((oldEvent) => oldEvent == eventId);
      showFutureLoadingDialog(
        context: context,
        future: () => room!.setPinnedEvents(events),
      );
    }
  }

  void pinEvent() {
    final room = this.room;
    if (room == null) return;
    final pinnedEventIds = room.pinnedEventIds;
    final selectedEventIds = selectedEvents.map((e) => e.eventId).toSet();
    final unpin = selectedEventIds.length == 1 &&
        pinnedEventIds.contains(selectedEventIds.single);
    if (unpin) {
      pinnedEventIds.removeWhere(selectedEventIds.contains);
    } else {
      pinnedEventIds.addAll(selectedEventIds);
    }
    showFutureLoadingDialog(
      context: context,
      future: () => room.setPinnedEvents(pinnedEventIds),
    );
  }

  void onInputBarChanged(String text) {
    setReadMarker();
    if (text.endsWith(' ') && matrix!.hasComplexBundles) {
      final clients = currentRoomBundle;
      for (final client in clients) {
        final prefix = client!.sendPrefix;
        if ((prefix.isNotEmpty) &&
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
      room!.setTyping(false);
    });
    typingTimeout ??= Timer(const Duration(seconds: 30), () {
      typingTimeout = null;
      currentlyTyping = false;
    });
    if (!currentlyTyping) {
      currentlyTyping = true;
      room!
          .setTyping(true, timeout: const Duration(seconds: 30).inMilliseconds);
    }
    setState(() => inputText = text);
  }

  void showEventInfo([Event? event]) =>
      (event ?? selectedEvents.single).showInfoDialog(context);

  void onPhoneButtonTap() async {
    // VoIP required Android SDK 21
    if (PlatformInfos.isAndroid) {
      DeviceInfoPlugin().androidInfo.then((value) {
        if ((value.version.sdkInt ?? 16) < 21) {
          Navigator.pop(context);
          showOkAlertDialog(
            context: context,
            title: L10n.of(context)!.unsupportedAndroidVersion,
            message: L10n.of(context)!.unsupportedAndroidVersionLong,
            okLabel: L10n.of(context)!.close,
          );
        }
      });
    }
    final callType = await showModalActionSheet<CallType>(
      context: context,
      title: L10n.of(context)!.warning,
      message: L10n.of(context)!.videoCallsBetaWarning,
      cancelLabel: L10n.of(context)!.cancel,
      actions: [
        SheetAction(
          label: L10n.of(context)!.voiceCall,
          icon: Icons.phone_outlined,
          key: CallType.kVoice,
        ),
        SheetAction(
          label: L10n.of(context)!.videoCall,
          icon: Icons.video_call_outlined,
          key: CallType.kVideo,
        ),
      ],
    );
    if (callType == null) return;

    final success = await showFutureLoadingDialog(
        context: context,
        future: () =>
            Matrix.of(context).voipPlugin!.voip.requestTurnServerCredentials());
    if (success.result != null) {
      final voipPlugin = Matrix.of(context).voipPlugin;
      await voipPlugin!.voip.inviteToCall(room!.id, callType).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((e as Object).toLocalizedString(context))),
        );
      });
    } else {
      await showOkAlertDialog(
        context: context,
        title: L10n.of(context)!.unavailable,
        okLabel: L10n.of(context)!.next,
        useRootNavigator: false,
      );
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
  Widget build(BuildContext context) => ChatView(this);
}

enum EmojiPickerType { reaction, keyboard }
