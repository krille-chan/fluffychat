import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat/chat_view.dart';
import 'package:fluffychat/pages/chat/event_info_dialog.dart';
import 'package:fluffychat/pages/chat/recording_dialog.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/ios_badge_client_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/account_bundles.dart';
import '../../utils/localized_exception_extension.dart';
import '../../utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'send_file_dialog.dart';
import 'send_location_dialog.dart';
import 'sticker_picker_dialog.dart';

class ChatPage extends StatelessWidget {
  final Widget? sideView;

  const ChatPage({Key? key, this.sideView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomId = context.vRouter.pathParameters['roomid'];
    final room =
        roomId == null ? null : Matrix.of(context).client.getRoomById(roomId);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: Text(L10n.of(context)!.oopsSomethingWentWrong)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Text(L10n.of(context)!.youAreNoLongerParticipatingInThisChat),
          ),
        ),
      );
    }
    return ChatPageWithRoom(sideView: sideView, room: room);
  }
}

class ChatPageWithRoom extends StatefulWidget {
  final Widget? sideView;
  final Room room;

  const ChatPageWithRoom({
    Key? key,
    required this.sideView,
    required this.room,
  }) : super(key: key);

  @override
  ChatController createState() => ChatController();
}

class ChatController extends State<ChatPageWithRoom> {
  Room get room => sendingClient.getRoomById(roomId) ?? widget.room;

  late Client sendingClient;

  Timeline? timeline;

  String? readMarkerEventId;

  String get roomId => widget.room.id;

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
    final bytesList = await showFutureLoadingDialog(
      context: context,
      future: () => Future.wait(
        details.files.map(
          (xfile) => xfile.readAsBytes(),
        ),
      ),
    );
    if (bytesList.error != null) return;

    final matrixFiles = <MatrixFile>[];
    for (var i = 0; i < bytesList.result!.length; i++) {
      matrixFiles.add(
        MatrixFile(
          bytes: bytesList.result![i],
          name: details.files[i].name,
        ).detectFileType,
      );
    }

    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        files: matrixFiles,
        room: room,
      ),
    );
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

  void saveSelectedEvent(context) => selectedEvents.single.saveFile(context);

  List<Event> selectedEvents = [];

  final Set<String> unfolded = {};

  Event? replyEvent;

  Event? editEvent;

  bool _scrolledUp = false;

  bool get showScrollDownButton =>
      _scrolledUp || timeline?.allowNewEvent == false;

  bool get selectMode => selectedEvents.isNotEmpty;

  final int _loadHistoryCount = 100;

  String inputText = '';

  String pendingText = '';

  bool showEmojiPicker = false;

  void recreateChat() async {
    final room = this.room;
    final userId = room.directChatMatrixID;
    if (userId == null) {
      throw Exception(
        'Try to recreate a room with is not a DM room. This should not be possible from the UI!',
      );
    }
    final success = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final client = room.client;
        final waitForSync = client.onSync.stream
            .firstWhere((s) => s.rooms?.leave?.containsKey(room.id) ?? false);
        await room.leave();
        await waitForSync;
        return await client.startDirectChat(userId);
      },
    );
    final roomId = success.result;
    if (roomId == null) return;
    VRouter.of(context).toSegments(['rooms', roomId]);
  }

  void leaveChat() async {
    final success = await showFutureLoadingDialog(
      context: context,
      future: room.leave,
    );
    if (success.error != null) return;
    VRouter.of(context).to('/rooms');
  }

  EmojiPickerType emojiPickerType = EmojiPickerType.keyboard;

  void requestHistory() async {
    if (!timeline!.canRequestHistory) return;
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

  void requestFuture() async {
    final timeline = this.timeline;
    if (timeline == null) return;
    if (!timeline.canRequestFuture) return;
    try {
      final mostRecentEventId = timeline.events.first.eventId;
      await timeline.requestFuture(historyCount: _loadHistoryCount);
      setReadMarker(eventId: mostRecentEventId);
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

  void _updateScrollController() {
    if (!mounted) {
      return;
    }
    setReadMarker();
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      requestHistory();
    } else if (scrollController.position.pixels == 0) {
      requestFuture();
    }
    if (timeline?.allowNewEvent == false ||
        scrollController.position.pixels > 0 && _scrolledUp == false) {
      setState(() => _scrolledUp = true);
    } else if (scrollController.position.pixels == 0 && _scrolledUp == true) {
      setState(() => _scrolledUp = false);
    }
  }

  void _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = prefs.getString('draft_$roomId');
    if (draft != null && draft.isNotEmpty) {
      sendController.text = draft;
      setState(() => inputText = draft);
    }
  }

  @override
  void initState() {
    scrollController.addListener(_updateScrollController);
    inputFocus.addListener(_inputFocusListener);
    _loadDraft();
    super.initState();
    sendingClient = Matrix.of(context).client;
    readMarkerEventId = room.fullyRead;
    loadTimelineFuture =
        _getTimeline(eventContextId: readMarkerEventId).onError(
      ErrorReporter(context, 'Unable to load timeline').onErrorCallback,
    );
  }

  void updateView() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void>? loadTimelineFuture;

  Future<void> _getTimeline({
    String? eventContextId,
    Duration timeout = const Duration(seconds: 7),
  }) async {
    await Matrix.of(context).client.roomsLoading;
    await Matrix.of(context).client.accountDataLoading;
    if (eventContextId != null &&
        (!eventContextId.isValidMatrixId || eventContextId.sigil != '\$')) {
      eventContextId = null;
    }
    try {
      timeline = await room
          .getTimeline(
            onUpdate: updateView,
            eventContextId: eventContextId,
          )
          .timeout(timeout);
    } catch (e, s) {
      Logs().w('Unable to load timeline on event ID $eventContextId', e, s);
      if (!mounted) return;
      timeline = await room.getTimeline(onUpdate: updateView);
      if (!mounted) return;
      if (e is TimeoutException || e is IOException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context)!.jumpToLastReadMessage),
            action: SnackBarAction(
              label: L10n.of(context)!.jump,
              onPressed: () => scrollToEventId(eventContextId!),
            ),
          ),
        );
      }
    }
    timeline!.requestKeys(onlineKeyBackupOnly: false);
    if (timeline!.events.isNotEmpty) {
      if (room.markedUnread) room.markUnread(false);
      setReadMarker();
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
      }
    });

    return;
  }

  Future<void>? _setReadMarkerFuture;

  void setReadMarker({String? eventId}) {
    if (_setReadMarkerFuture != null) return;
    if (eventId == null &&
        !room.hasNewMessages &&
        room.notificationCount == 0) {
      return;
    }
    if (!Matrix.of(context).webHasFocus) return;

    final timeline = this.timeline;
    if (timeline == null || timeline.events.isEmpty) return;

    eventId ??= timeline.events.first.eventId;
    Logs().v('Set read marker...', eventId);
    // ignore: unawaited_futures
    _setReadMarkerFuture = timeline.setReadMarker(eventId: eventId).then((_) {
      _setReadMarkerFuture = null;
    });
    room.client.updateIosBadge();
  }

  @override
  void dispose() {
    timeline?.cancelSubscriptions();
    timeline = null;
    inputFocus.removeListener(_inputFocusListener);
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void setSendingClient(Client c) {
    // first cancel typing with the old sending client
    if (currentlyTyping) {
      // no need to have the setting typing to false be blocking
      typingCoolDown?.cancel();
      typingCoolDown = null;
      room.setTyping(false);
      currentlyTyping = false;
    }
    // then cancel the old timeline
    // fixes bug with read reciepts and quick switching
    loadTimelineFuture = _getTimeline(eventContextId: room.fullyRead).onError(
      ErrorReporter(
        context,
        'Unable to load timeline after changing sending Client',
      ).onErrorCallback,
    );

    // then set the new sending client
    setState(() => sendingClient = c);
  }

  void setActiveClient(Client c) => setState(() {
        Matrix.of(context).setActiveClient(c);
      });

  Future<void> send() async {
    if (sendController.text.trim().isEmpty) return;
    _storeInputTimeoutTimer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('draft_$roomId');
    var parseCommands = true;

    final commandMatch = RegExp(r'^\/(\w+)').firstMatch(sendController.text);
    if (commandMatch != null &&
        !sendingClient.commands.keys.contains(commandMatch[1]!.toLowerCase())) {
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
    room.sendTextEvent(
      sendController.text,
      inReplyTo: replyEvent,
      editEventId: editEvent?.eventId,
      parseCommands: parseCommands,
    );
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
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        files: result.files
            .map(
              (xfile) => MatrixFile(
                bytes: xfile.bytes!,
                name: xfile.name,
              ).detectFileType,
            )
            .toList(),
        room: room,
      ),
    );
  }

  void sendImageAction() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: true,
    );
    if (result == null || result.files.isEmpty) return;

    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (c) => SendFileDialog(
        files: result.files
            .map(
              (xfile) => MatrixFile(
                bytes: xfile.bytes!,
                name: xfile.name,
              ).detectFileType,
            )
            .toList(),
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
        files: [
          MatrixImageFile(
            bytes: bytes,
            name: file.path,
          )
        ],
        room: room,
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
        files: [
          MatrixVideoFile(
            bytes: bytes,
            name: file.path,
          )
        ],
        room: room,
      ),
    );
  }

  void sendStickerAction() async {
    final sticker = await showAdaptiveBottomSheet<ImagePackImageContent>(
      context: context,
      builder: (c) => StickerPickerDialog(room: room),
    );
    if (sticker == null) return;
    final eventContent = <String, dynamic>{
      'body': sticker.body,
      if (sticker.info != null) 'info': sticker.info,
      'url': sticker.url.toString(),
    };
    // send the sticker
    await room.sendEvent(
      eventContent,
      type: EventTypes.Sticker,
    );
  }

  void voiceMessageAction() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (PlatformInfos.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt < 19) {
        showOkAlertDialog(
          context: context,
          title: L10n.of(context)!.unsupportedAndroidVersion,
          message: L10n.of(context)!.unsupportedAndroidVersionLong,
          okLabel: L10n.of(context)!.close,
        );
        return;
      }
    }

    if (await Record().hasPermission() == false) return;
    final result = await showDialog<RecordingResult>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (c) => const RecordingDialog(),
    );
    if (result == null) return;
    final audioFile = File(result.path);
    final file = MatrixAudioFile(
      bytes: audioFile.readAsBytesSync(),
      name: audioFile.path,
    );
    await room.sendFileEvent(
      file,
      inReplyTo: replyEvent,
      extraContent: {
        'info': {
          ...file.info,
          'duration': result.duration,
        },
        'org.matrix.msc3245.voice': {},
        'org.matrix.msc1767.audio': {
          'duration': result.duration,
          'waveform': result.waveform,
        },
      },
    ).catchError((e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            (e as Object).toLocalizedString(context),
          ),
        ),
      );
      return null;
    });
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
      builder: (c) => SendLocationDialog(room: room),
    );
  }

  String _getSelectedEventString() {
    var copyString = '';
    if (selectedEvents.length == 1) {
      return selectedEvents.first
          .getDisplayEvent(timeline!)
          .calcLocalizedBodyFallback(MatrixLocals(L10n.of(context)!));
    }
    for (final event in selectedEvents) {
      if (copyString.isNotEmpty) copyString += '\n\n';
      copyString += event.getDisplayEvent(timeline!).calcLocalizedBodyFallback(
            MatrixLocals(L10n.of(context)!),
            withSenderNamePrefix: true,
          );
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
      ],
    );
    if (score == null) return;
    final reason = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.whyDoYouWantToReportThis,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [DialogTextField(hintText: L10n.of(context)!.reason)],
    );
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
      SnackBar(content: Text(L10n.of(context)!.contentHasBeenReported)),
    );
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
                orElse: () => null,
              );
              if (client == null) {
                return;
              }
              final room = client.getRoomById(roomId)!;
              await Event.fromJson(event.toJson(), room).redactEvent();
            }
          } else {
            await event.remove();
          }
        },
      );
    }
    setState(() {
      showEmojiPicker = false;
      selectedEvents.clear();
    });
  }

  List<Client?> get currentRoomBundle {
    final clients = Matrix.of(context).currentBundle!;
    clients.removeWhere((c) => c!.getRoomById(roomId) == null);
    return clients;
  }

  bool get canRedactSelectedEvents {
    if (isArchived) return false;
    final clients = Matrix.of(context).currentBundle;
    for (final event in selectedEvents) {
      if (event.canRedact == false &&
          !(clients!.any((cl) => event.senderId == cl!.userID))) return false;
    }
    return true;
  }

  bool get canEditSelectedEvents {
    if (isArchived ||
        selectedEvents.length != 1 ||
        !selectedEvents.first.status.isSent) {
      return false;
    }
    return currentRoomBundle
        .any((cl) => selectedEvents.first.senderId == cl!.userID);
  }

  void forwardEventsAction() async {
    if (selectedEvents.length == 1) {
      Matrix.of(context).shareContent =
          selectedEvents.first.getDisplayEvent(timeline!).content;
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
    final eventIndex = timeline!.events.indexWhere((e) => e.eventId == eventId);
    if (eventIndex == -1) {
      setState(() {
        timeline = null;
        _scrolledUp = false;
        loadTimelineFuture = _getTimeline(
          eventContextId: eventId,
          timeout: const Duration(seconds: 30),
        ).onError(
          ErrorReporter(context, 'Unable to load timeline after scroll to ID')
              .onErrorCallback,
        );
      });
      await loadTimelineFuture;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollToEventId(eventId);
      });
      return;
    }
    await scrollController.scrollToIndex(
      eventIndex,
      preferPosition: AutoScrollPosition.middle,
    );
    _updateScrollController();
  }

  void scrollDown() async {
    if (!timeline!.allowNewEvent) {
      setState(() {
        timeline = null;
        _scrolledUp = false;
        loadTimelineFuture = _getTimeline().onError(
          ErrorReporter(context, 'Unable to load timeline after scroll down')
              .onErrorCallback,
        );
      });
      await loadTimelineFuture;
      setReadMarker(eventId: timeline!.events.first.eventId);
    }
    scrollController.jumpTo(0);
  }

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

  void forgetRoom() async {
    final result = await showFutureLoadingDialog(
      context: context,
      future: room.forget,
    );
    if (result.error != null) return;
    VRouter.of(context).to('/archive');
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
            TextPosition(offset: sendController.text.length),
          );
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
      await room.sendReaction(
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
      orElse: () => null,
    );
    if (client == null) {
      return;
    }
    setSendingClient(client);
    setState(() {
      pendingText = sendController.text;
      editEvent = selectedEvents.first;
      inputText = sendController.text =
          editEvent!.getDisplayEvent(timeline!).calcLocalizedBodyFallback(
                MatrixLocals(L10n.of(context)!),
                withSenderNamePrefix: false,
                hideReply: true,
              );
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
          message: room
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
      future: () => room.client.joinRoom(
        room
            .getState(EventTypes.RoomTombstone)!
            .parsedTombstoneContent
            .replacementRoom,
      ),
    );
    await showFutureLoadingDialog(
      context: context,
      future: room.leave,
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
      final events = room.pinnedEventIds
        ..removeWhere((oldEvent) => oldEvent == eventId);
      showFutureLoadingDialog(
        context: context,
        future: () => room.setPinnedEvents(events),
      );
    }
  }

  void pinEvent() {
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

  Timer? _storeInputTimeoutTimer;
  static const Duration _storeInputTimeout = Duration(milliseconds: 500);

  void onInputBarChanged(String text) {
    _storeInputTimeoutTimer?.cancel();
    _storeInputTimeoutTimer = Timer(_storeInputTimeout, () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('draft_$roomId', text);
    });
    setReadMarker();
    if (text.endsWith(' ') && Matrix.of(context).hasComplexBundles) {
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

  bool get isArchived =>
      {Membership.leave, Membership.ban}.contains(room.membership);

  void showEventInfo([Event? event]) =>
      (event ?? selectedEvents.single).showInfoDialog(context);

  void onPhoneButtonTap() async {
    // VoIP required Android SDK 21
    if (PlatformInfos.isAndroid) {
      DeviceInfoPlugin().androidInfo.then((value) {
        if (value.version.sdkInt < 21) {
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
          Matrix.of(context).voipPlugin!.voip.requestTurnServerCredentials(),
    );
    if (success.result != null) {
      final voipPlugin = Matrix.of(context).voipPlugin;
      try {
        await voipPlugin!.voip.inviteToCall(room.id, callType);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toLocalizedString(context))),
        );
      }
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
