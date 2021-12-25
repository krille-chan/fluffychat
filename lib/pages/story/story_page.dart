//@dart=2.12

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/story/story_view.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/client_stories_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
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

  final List<Event> events = [];

  Event? get currentEvent => index < events.length ? events[index] : null;

  final TextEditingController replyController = TextEditingController();

  static const Duration _step = Duration(milliseconds: 50);
  static const Duration maxProgress = Duration(seconds: 5);

  void _restartTimer([bool reset = true]) {
    _progressTimer?.cancel();
    if (reset) progress = Duration.zero;
    _progressTimer = Timer.periodic(_step, (_) {
      if (!mounted) {
        _progressTimer?.cancel();
        return;
      }
      if (loadingMode) return;
      setState(() {
        progress = progress += _step;
      });
      if (progress > maxProgress) {
        skip();
      }
    });
  }

  String get roomId => VRouter.of(context).pathParameters['roomid'] ?? '';

  Future<VideoPlayerController> loadVideoController(Event event) async {
    final matrixFile = await event.downloadAndDecryptAttachment();
    final tmpDirectory = await getTemporaryDirectory();
    final file = File(tmpDirectory.path + matrixFile.name);
    final videoPlayerController = VideoPlayerController.file(file)
      ..setLooping(true);
    await videoPlayerController.initialize();
    videoPlayerController.play();
    return videoPlayerController;
  }

  void skip() {
    if (index + 1 >= max) {
      VRouter.of(context).to('/rooms');
      return;
    }
    setState(() {
      index++;
    });
    _restartTimer();
  }

  DateTime _holdedAt = DateTime.fromMicrosecondsSinceEpoch(0);

  void hold(_) {
    _holdedAt = DateTime.now();
    if (loadingMode) return;
    _progressTimer?.cancel();
  }

  void unhold([_]) {
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

  Future<MatrixFile> downloadAndDecryptAttachment(
      Event event, bool getThumbnail) async {
    return _fileCache[event.eventId] ??=
        event.downloadAndDecryptAttachment(getThumbnail: getThumbnail);
  }

  void _setLoadingMode(bool mode) => loadingMode != mode
      ? WidgetsBinding.instance?.addPostFrameCallback((_) {
          setState(() {
            loadingMode = mode;
          });
        })
      : null;

  Uri? get avatar => Matrix.of(context)
      .client
      .getRoomById(roomId)
      ?.getState(EventTypes.RoomCreate)
      ?.sender
      .avatarUrl;

  String get title =>
      Matrix.of(context)
          .client
          .getRoomById(roomId)
          ?.getState(EventTypes.RoomCreate)
          ?.sender
          .calcDisplayname() ??
      'Story not found';

  Future<void>? loadStory;

  Future<void> _loadStory() async {
    final room = Matrix.of(context).client.getRoomById(roomId);
    if (room == null) return;
    if (room.membership != Membership.join) {
      final joinedFuture = room.client.onSync.stream
          .where((u) => u.rooms?.join?.containsKey(room.id) ?? false)
          .first;
      await room.join();
      await joinedFuture;
    }
    final timeline = await room.getTimeline();
    timeline.requestKeys();
    var events =
        timeline.events.where((e) => e.type == EventTypes.Message).toList();

    final hasOutdatedEvents = events.removeOutdatedEvents();

    // Request history if possible
    if (!hasOutdatedEvents &&
        timeline.events.first.type != EventTypes.RoomCreate &&
        events.length < 30) {
      try {
        await timeline.requestHistory(historyCount: 100);
        events =
            timeline.events.where((e) => e.type == EventTypes.Message).toList();
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
        .where((event) => {MessageTypes.Image, MessageTypes.Video}
            .contains(event.messageType))
        .forEach((event) => downloadAndDecryptAttachment(event,
            event.messageType == MessageTypes.Video && PlatformInfos.isMobile));

    if (!events.last.receipts
        .any((receipt) => receipt.user.id == room.client.userID)) {
      for (var j = 0; j < events.length; j++) {
        if (events[j]
            .receipts
            .any((receipt) => receipt.user.id == room.client.userID)) {
          index = j;
          room.setReadMarker(
            events[index].eventId,
            mRead: events[index].eventId,
          );
          break;
        }
      }
    }
    this.events.clear();
    this.events.addAll(events.reversed.toList());
    return;
  }

  @override
  Widget build(BuildContext context) {
    loadStory ??= _loadStory();
    return StoryView(this);
  }
}

extension on List<Event> {
  bool removeOutdatedEvents() {
    final outdatedIndex = indexWhere((event) =>
        DateTime.now().difference(event.originServerTs).inHours >
        ClientStoriesExtension.lifeTimeInHours);
    if (outdatedIndex != -1) {
      removeRange(outdatedIndex, length);
      return true;
    }
    return false;
  }
}
