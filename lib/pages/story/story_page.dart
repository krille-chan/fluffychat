import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/story/story_view.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/client_stories_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/ios_badge_client_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:fluffychat/utils/story_theme_data.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  StoryPageController createState() => StoryPageController();
}

class StoryPageController extends State<StoryPage> {
  int index = 0;
  int max = 0;
  Duration progress = Duration.zero;
  Timer? _progressTimer;
  bool loadingMode = false;

  final TextEditingController replyController = TextEditingController();
  final FocusNode replyFocus = FocusNode();

  final List<Event> events = [];

  Timeline? timeline;

  Event? get currentEvent => index < events.length ? events[index] : null;
  StoryThemeData get storyThemeData => StoryThemeData.fromJson(
        currentEvent?.content
                .tryGetMap<String, dynamic>(StoryThemeData.contentKey) ??
            {},
      );

  bool replyLoading = false;
  bool _modalOpened = false;

  VideoPlayerController? _videoPlayerController;

  void replyEmojiAction() async {
    if (replyLoading) return;
    _modalOpened = true;
    await showAdaptiveBottomSheet(
      context: context,
      builder: (context) => EmojiPicker(
        onEmojiSelected: (c, e) {
          Navigator.of(context).pop();
          replyAction(e.emoji);
        },
      ),
    );
    _modalOpened = false;
  }

  void replyAction([String? message]) async {
    message ??= replyController.text;
    if (message.isEmpty) return;
    final currentEvent = this.currentEvent;
    if (currentEvent == null) return;
    setState(() {
      replyLoading = true;
    });
    try {
      final client = Matrix.of(context).client;
      final roomId = await client.startDirectChat(currentEvent.senderId);
      var replyText = L10n.of(context)!.storyFrom(
        currentEvent.originServerTs.localizedTime(context),
        currentEvent.content.tryGet<String>('body') ?? '',
      );
      replyText = replyText.split('\n').map((line) => '> $line').join('\n');
      message = '$replyText\n\n$message';
      await client.getRoomById(roomId)!.sendTextEvent(message);
      replyController.clear();
      replyFocus.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context)!.replyHasBeenSent)),
      );
    } catch (e, s) {
      Logs().w('Unable to reply to story', e, s);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toLocalizedString(context))),
      );
    } finally {
      setState(() {
        replyLoading = false;
      });
    }
  }

  List<User> get currentSeenByUsers {
    final timeline = this.timeline;
    final currentEvent = this.currentEvent;
    if (timeline == null || currentEvent == null) return [];
    return Matrix.of(context).client.getRoomById(roomId)?.getSeenByUsers(
              timeline,
              eventId: currentEvent.eventId,
            ) ??
        [];
  }

  void share() async {
    Matrix.of(context).shareContent = currentEvent?.content;
    hold();
    VRouter.of(context).to('share');
  }

  void displaySeenByUsers() async {
    _modalOpened = true;
    await showAdaptiveBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(seenByUsersTitle),
        ),
        body: ListView.builder(
          itemCount: currentSeenByUsers.length,
          itemBuilder: (context, i) => ListTile(
            leading: Avatar(
              mxContent: currentSeenByUsers[i].avatarUrl,
              name: currentSeenByUsers[i].calcDisplayname(),
            ),
            title: Text(currentSeenByUsers[i].calcDisplayname()),
          ),
        ),
      ),
    );
    _modalOpened = false;
  }

  String get seenByUsersTitle {
    final seenByUsers = currentSeenByUsers;
    if (seenByUsers.isEmpty) return '';
    if (seenByUsers.length == 1) {
      return L10n.of(context)!.seenByUser(seenByUsers.single.calcDisplayname());
    }
    if (seenByUsers.length == 2) {
      return L10n.of(context)!.seenByUserAndUser(
        seenByUsers.first.calcDisplayname(),
        seenByUsers.last.calcDisplayname(),
      );
    }
    return L10n.of(context)!.seenByUserAndCountOthers(
      seenByUsers.first.calcDisplayname(),
      seenByUsers.length - 1,
    );
  }

  static const Duration _step = Duration(milliseconds: 50);
  static const Duration maxProgress = Duration(seconds: 5);

  void _restartTimer([bool reset = true]) {
    _progressTimer?.cancel();
    if (reset) progress = Duration.zero;
    _progressTimer = Timer.periodic(_step, (_) {
      if (replyFocus.hasFocus || _modalOpened) return;
      if (!mounted) {
        _progressTimer?.cancel();
        return;
      }
      if (loadingMode) return;
      setState(() {
        final video = _videoPlayerController;
        if (video == null) {
          progress += _step;
        } else {
          progress = video.value.position;
        }
      });
      final max = _videoPlayerController?.value.duration ?? maxProgress;
      if (progress >= max) {
        skip();
      }
    });
  }

  bool get isOwnStory {
    final client = Matrix.of(context).client;
    final room = client.getRoomById(roomId);
    if (room == null) return false;
    return room.ownPowerLevel >= 100;
  }

  String get roomId => VRouter.of(context).pathParameters['roomid'] ?? '';

  Future<VideoPlayerController?>? loadVideoControllerFuture;

  Future<VideoPlayerController?> loadVideoController(Event event) async {
    try {
      final matrixFile = await event.downloadAndDecryptAttachment();
      if (!mounted) return null;
      final tmpDirectory = await getTemporaryDirectory();
      final fileName =
          event.content.tryGet<String>('filename') ?? 'unknown_story_video.mp4';
      final file = File('${tmpDirectory.path}/$fileName');
      await file.writeAsBytes(matrixFile.bytes);
      if (!mounted) return null;
      final videoPlayerController =
          _videoPlayerController = VideoPlayerController.file(file);
      await videoPlayerController.initialize();
      await videoPlayerController.play();
      return videoPlayerController;
    } catch (e, s) {
      Logs().w('Unable to load video story. Try again...', e, s);
      await Future.delayed(const Duration(seconds: 3));
      return loadVideoController(event);
    }
  }

  void skip() {
    if (index + 1 >= max) {
      if (isOwnStory) {
        VRouter.of(context).to('/stories/create');
      } else {
        VRouter.of(context).to('/rooms');
      }
      return;
    }
    setState(() {
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
      loadVideoControllerFuture = null;
      index++;
    });
    _restartTimer();
    maybeSetReadMarker();
  }

  DateTime _holdedAt = DateTime.fromMicrosecondsSinceEpoch(0);

  bool isHold = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void hold([_]) {
    _holdedAt = DateTime.now();
    if (loadingMode) return;
    _progressTimer?.cancel();
    setState(() {
      isHold = true;
    });
  }

  void unhold([_]) {
    isHold = false;
    if (DateTime.now().millisecondsSinceEpoch -
            _holdedAt.millisecondsSinceEpoch <
        200) {
      skip();
      return;
    }
    _restartTimer(false);
  }

  void loadingModeOn() => _setLoadingMode(true);
  void loadingModeOff() => _setLoadingMode(false);

  final Map<String, Future<MatrixFile>> _fileCache = {};

  void _delete() async {
    final event = currentEvent;
    if (event == null) return;
    _modalOpened = true;
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context)!.deleteMessage,
          message: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.yes,
          cancelLabel: L10n.of(context)!.cancel,
        ) !=
        OkCancelResult.ok) {
      return;
    }
    await showFutureLoadingDialog(
      context: context,
      future: event.redactEvent,
    );
    setState(() {
      events.remove(event);
      _modalOpened = false;
    });
  }

  void _report() async {
    _modalOpened = true;
    final event = currentEvent;
    if (event == null) return;
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
            roomId,
            event.eventId,
            reason: reason.single,
            score: score,
          ),
    );
    _modalOpened = false;
    if (result.error != null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L10n.of(context)!.contentHasBeenReported)),
    );
  }

  Future<MatrixFile> downloadAndDecryptAttachment(
    Event event,
    bool getThumbnail,
  ) async {
    return _fileCache[event.eventId] ??=
        event.downloadAndDecryptAttachment(getThumbnail: getThumbnail);
  }

  void _setLoadingMode(bool mode) => loadingMode != mode
      ? WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            loadingMode = mode;
          });
        })
      : null;

  Uri? get avatar => Matrix.of(context)
      .client
      .getRoomById(roomId)
      ?.getState(EventTypes.RoomCreate)
      ?.senderFromMemoryOrFallback
      .avatarUrl;

  String get title =>
      Matrix.of(context)
          .client
          .getRoomById(roomId)
          ?.getState(EventTypes.RoomCreate)
          ?.senderFromMemoryOrFallback
          .calcDisplayname() ??
      'Story not found';

  Future<void>? loadStory;

  Future<void> _loadStory() async {
    try {
      final client = Matrix.of(context).client;
      await client.roomsLoading;
      await client.accountDataLoading;
      final room = client.getRoomById(roomId);
      if (room == null) return;
      if (room.membership != Membership.join) {
        final joinedFuture = room.client.onSync.stream
            .where((u) => u.rooms?.join?.containsKey(room.id) ?? false)
            .first;
        await room.join();
        await joinedFuture;
      }
      final timeline = this.timeline = await room.getTimeline();
      timeline.requestKeys();
      var events = timeline.events
          .where(
            (e) =>
                e.type == EventTypes.Message &&
                !e.redacted &&
                e.status == EventStatus.synced,
          )
          .toList();

      final hasOutdatedEvents = events.removeOutdatedEvents();

      // Request history if possible
      if (!hasOutdatedEvents &&
          timeline.events.first.type != EventTypes.RoomCreate &&
          events.length < 30) {
        try {
          await timeline
              .requestHistory(historyCount: 100)
              .timeout(const Duration(seconds: 5));
          events = timeline.events
              .where((e) => e.type == EventTypes.Message)
              .toList();
          events.removeOutdatedEvents();
        } catch (e, s) {
          Logs().d('Unable to request history in stories', e, s);
        }
      }

      max = events.length;
      if (events.isNotEmpty) {
        _restartTimer();
      }

      // Preload images and videos
      events
          .where(
            (event) => {MessageTypes.Image, MessageTypes.Video}
                .contains(event.messageType),
          )
          .forEach(
            (event) => downloadAndDecryptAttachment(
              event,
              event.messageType == MessageTypes.Video && PlatformInfos.isMobile,
            ),
          );

      // Reverse list
      this.events.clear();
      this.events.addAll(events.reversed.toList());

      // Set start position
      if (this.events.isNotEmpty) {
        final receiptId = room.roomAccountData['m.receipt']?.content
            .tryGetMap<String, dynamic>(room.client.userID!)
            ?.tryGet<String>('event_id');
        index = this.events.indexWhere((event) => event.eventId == receiptId);
        index++;
        if (index >= this.events.length) index = 0;
      }
      maybeSetReadMarker();
    } catch (e, s) {
      Logs().e('Unable to load story', e, s);
    }
    return;
  }

  void maybeSetReadMarker() {
    final currentEvent = this.currentEvent;
    if (currentEvent == null) return;
    final room = currentEvent.room;
    room.client.updateIosBadge();
    if (index == events.length - 1) {
      timeline!.setReadMarker();
      return;
    }
    if (!currentSeenByUsers.any((u) => u.id == u.room.client.userID)) {
      timeline!.setReadMarker(currentEvent.eventId);
    }
  }

  void onPopupStoryAction(PopupStoryAction action) async {
    switch (action) {
      case PopupStoryAction.report:
        _report();
        break;
      case PopupStoryAction.delete:
        _delete();
        break;
      case PopupStoryAction.message:
        final roomIdResult = await showFutureLoadingDialog(
          context: context,
          future: () =>
              currentEvent!.senderFromMemoryOrFallback.startDirectChat(),
        );
        if (roomIdResult.error != null) return;
        VRouter.of(context).toSegments(['rooms', roomIdResult.result!]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    loadStory ??= _loadStory();
    return StoryView(this);
  }
}

extension on List<Event> {
  bool removeOutdatedEvents() {
    final outdatedIndex = indexWhere(
      (event) =>
          DateTime.now().difference(event.originServerTs).inHours >
          ClientStoriesExtension.lifeTimeInHours,
    );
    if (outdatedIndex != -1) {
      removeRange(outdatedIndex, length);
      return true;
    }
    return false;
  }
}

enum PopupStoryAction {
  report,
  delete,
  message,
}
