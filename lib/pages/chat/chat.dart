import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:async/async.dart' as async;
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat_view.dart';
import 'package:fluffychat/pages/chat/event_info_dialog.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pages/chat/start_poll_bottom_sheet.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_chat_controller.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_chat_extension.dart';
import 'package:fluffychat/pangea/analytics_data/analytics_update_dispatcher.dart';
import 'package:fluffychat/pangea/analytics_data/analytics_updater_mixin.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_banner.dart';
import 'package:fluffychat/pangea/analytics_misc/message_analytics_feedback.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat/utils/unlocked_morphs_snackbar.dart';
import 'package:fluffychat/pangea/chat/widgets/event_too_large_dialog.dart';
import 'package:fluffychat/pangea/choreographer/assistance_state_enum.dart';
import 'package:fluffychat/pangea/choreographer/choreo_constants.dart';
import 'package:fluffychat/pangea/choreographer/choreo_record_model.dart';
import 'package:fluffychat/pangea/choreographer/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_state_extension.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/text_editing/edit_type_enum.dart';
import 'package:fluffychat/pangea/choreographer/text_editing/pangea_text_controller.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/common/widgets/transparent_backdrop.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/languages/language_constants.dart';
import 'package:fluffychat/pangea/languages/language_service.dart';
import 'package:fluffychat/pangea/learning_settings/disable_language_tools_popup.dart';
import 'package:fluffychat/pangea/learning_settings/language_mismatch_repo.dart';
import 'package:fluffychat/pangea/learning_settings/p_language_dialog.dart';
import 'package:fluffychat/pangea/navigation/navigation_util.dart';
import 'package:fluffychat/pangea/spaces/load_participants_builder.dart';
import 'package:fluffychat/pangea/speech_to_text/audio_encoding_enum.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_repo.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_request_model.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_response_model.dart';
import 'package:fluffychat/pangea/subscription/widgets/paywall_card.dart';
import 'package:fluffychat/pangea/token_info_feedback/show_token_feedback_dialog.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_request.dart';
import 'package:fluffychat/pangea/toolbar/message_practice/message_practice_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance/tokens_util.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/filtered_timeline_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/other_party_can_receive.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/show_scaffold_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/share_scaffold_dialog.dart';
import '../../utils/localized_exception_extension.dart';
import 'send_file_dialog.dart';
import 'send_location_dialog.dart';

// #Pangea
class _TimelineUpdateNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
// Pangea#

class ChatPage extends StatelessWidget {
  final String roomId;
  final List<ShareItem>? shareItems;
  final String? eventId;

  // #Pangea
  final Widget? backButton;
  // Pangea#

  const ChatPage({
    super.key,
    required this.roomId,
    this.eventId,
    this.shareItems,
    // #Pangea
    this.backButton,
    // Pangea#
  });

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(roomId);
    // #Pangea
    if (room?.isSpace == true &&
        GoRouterState.of(context).fullPath?.endsWith(":roomid") == true) {
      ErrorHandler.logError(
        e: "Space chat opened",
        s: StackTrace.current,
        data: {"roomId": roomId},
      );
      NavigationUtil.goToSpaceRoute(null, [], context);
    }

    if (room == null || room.membership == Membership.leave) {
      // if (room == null) {
      // Pangea#
      return Scaffold(
        appBar: AppBar(title: Text(L10n.of(context).oopsSomethingWentWrong)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
          ),
        ),
      );
    }

    return ChatPageWithRoom(
      key: Key('chat_page_${roomId}_$eventId'),
      room: room,
      shareItems: shareItems,
      eventId: eventId,
      // #Pangea
      backButton: backButton,
      // Pangea#
    );
  }
}

class ChatPageWithRoom extends StatefulWidget {
  final Room room;
  final List<ShareItem>? shareItems;
  final String? eventId;

  // #Pangea
  final Widget? backButton;
  // Pangea#

  const ChatPageWithRoom({
    super.key,
    required this.room,
    this.shareItems,
    this.eventId,
    // #Pangea
    this.backButton,
    // Pangea#
  });

  @override
  ChatController createState() => ChatController();
}

class ChatController extends State<ChatPageWithRoom>
    with WidgetsBindingObserver, AnalyticsUpdater {
  // #Pangea
  final PangeaController pangeaController = MatrixState.pangeaController;
  late Choreographer choreographer;
  late GoRouter _router;

  StreamSubscription? _levelSubscription;
  StreamSubscription? _constructsSubscription;
  StreamSubscription? _tokensSubscription;

  StreamSubscription? _botAudioSubscription;
  final timelineUpdateNotifier = _TimelineUpdateNotifier();
  late final ActivityChatController activityController;
  final ValueNotifier<bool> scrollableNotifier = ValueNotifier(false);
  // Pangea#
  Room get room => sendingClient.getRoomById(roomId) ?? widget.room;

  late Client sendingClient;

  Timeline? timeline;

  String? activeThreadId;

  late final String readMarkerEventId;

  String get roomId => widget.room.id;

  final AutoScrollController scrollController = AutoScrollController();

  late final FocusNode inputFocus;

  Timer? typingCoolDown;
  Timer? typingTimeout;
  bool currentlyTyping = false;
  // #Pangea
  // bool dragging = false;

  // void onDragEntered(dynamic _) => setState(() => dragging = true);

  // void onDragExited(dynamic _) => setState(() => dragging = false);

  // void onDragDone(DropDoneDetails details) async {
  //   setState(() => dragging = false);
  //   if (details.files.isEmpty) return;

  //   await showAdaptiveDialog(
  //     context: context,
  //     builder: (c) => SendFileDialog(
  //       files: details.files,
  //       room: room,
  //       outerContext: context,
  //       threadRootEventId: activeThreadId,
  //       threadLastEventId: threadLastEventId,
  //     ),
  //   );
  // }
  // Pangea#

  bool get canSaveSelectedEvent =>
      selectedEvents.length == 1 &&
      {
        MessageTypes.Video,
        MessageTypes.Image,
        MessageTypes.Sticker,
        MessageTypes.Audio,
        MessageTypes.File,
      }.contains(selectedEvents.single.messageType);

  void saveSelectedEvent(BuildContext context) =>
      selectedEvents.single.saveFile(context);

  List<Event> selectedEvents = [];

  final Set<String> unfolded = {};

  // #Pangea
  // Event? replyEvent;

  // Event? editEvent;

  ValueNotifier<Event?> replyEvent = ValueNotifier(null);
  ValueNotifier<Event?> editEvent = ValueNotifier(null);
  // Pangea#

  bool _scrolledUp = false;

  bool get showScrollDownButton =>
      _scrolledUp || timeline?.allowNewEvent == false;

  bool get selectMode => selectedEvents.isNotEmpty;

  final int _loadHistoryCount = 100;

  String pendingText = '';

  bool showEmojiPicker = false;

  String? get threadLastEventId {
    final threadId = activeThreadId;
    if (threadId == null) return null;
    return timeline?.events
        .filterByVisibleInGui(threadId: threadId)
        .firstOrNull
        ?.eventId;
  }

  void enterThread(String eventId) => setState(() {
    activeThreadId = eventId;
    selectedEvents.clear();
  });

  void closeThread() => setState(() {
    activeThreadId = null;
    selectedEvents.clear();
  });

  void recreateChat() async {
    final room = this.room;
    final userId = room.directChatMatrixID;
    if (userId == null) {
      throw Exception(
        'Try to recreate a room with is not a DM room. This should not be possible from the UI!',
      );
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room.invite(userId),
    );
  }

  void leaveChat() async {
    final success = await showFutureLoadingDialog(
      context: context,
      future: room.leave,
    );
    if (success.error != null) return;
    // #Pangea
    // context.go('/rooms');
    NavigationUtil.goToSpaceRoute(null, [], context);
    // Pangea#
  }

  // #Pangea
  // void requestHistory([dynamic _]) async {
  Future<void> requestHistory() async {
    if (timeline == null) return;
    if (!timeline!.canRequestHistory) return;
    // Pangea#
    Logs().v('Requesting history...');
    await timeline?.requestHistory(historyCount: _loadHistoryCount);
  }

  void requestFuture() async {
    final timeline = this.timeline;
    if (timeline == null) return;
    Logs().v('Requesting future...');

    final mostRecentEvent = timeline.events.filterByVisibleInGui().firstOrNull;

    await timeline.requestFuture(historyCount: _loadHistoryCount);

    if (mostRecentEvent != null) {
      setReadMarker(eventId: mostRecentEvent.eventId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = timeline.events.filterByVisibleInGui().indexOf(
          mostRecentEvent,
        );
        if (index >= 0) {
          scrollController.scrollToIndex(
            index,
            preferPosition: AutoScrollPosition.begin,
          );
        }
      });
    }
  }

  void _updateScrollController() {
    if (!mounted) {
      return;
    }
    if (!scrollController.hasClients) return;
    // #Pangea
    // if (timeline?.allowNewEvent == false ||
    //     scrollController.position.pixels > 0 && _scrolledUp == false) {
    //   setState(() => _scrolledUp = true);
    // } else if (scrollController.position.pixels <= 0 && _scrolledUp == true) {
    //   setState(() => _scrolledUp = false);
    //   setReadMarker();
    // }
    // Pangea#
  }

  void _loadDraft() async {
    final prefs = Matrix.of(context).store;
    final draft = prefs.getString('draft_$roomId');
    if (draft != null && draft.isNotEmpty) {
      // #Pangea
      // sendController.text = draft;
      sendController.setSystemText(draft, EditTypeEnum.other);
      // Pangea#
    }
  }

  void _shareItems([dynamic _]) {
    final shareItems = widget.shareItems;
    if (shareItems == null || shareItems.isEmpty) return;
    if (!room.otherPartyCanReceiveMessages) {
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.errorContainer,
          closeIconColor: theme.colorScheme.onErrorContainer,
          content: Text(
            L10n.of(context).otherPartyNotLoggedIn,
            style: TextStyle(color: theme.colorScheme.onErrorContainer),
          ),
          showCloseIcon: true,
        ),
      );
      return;
    }
    for (final item in shareItems) {
      if (item is FileShareItem) continue;
      if (item is TextShareItem) room.sendTextEvent(item.value);
      if (item is ContentShareItem) room.sendEvent(item.value);
    }
    final files = shareItems
        .whereType<FileShareItem>()
        .map((item) => item.value)
        .toList();
    if (files.isEmpty) return;
    showAdaptiveDialog(
      context: context,
      builder: (c) => SendFileDialog(
        files: files,
        room: room,
        outerContext: context,
        threadRootEventId: activeThreadId,
        threadLastEventId: threadLastEventId,
      ),
    );
  }

  KeyEventResult _customEnterKeyHandling(FocusNode node, KeyEvent evt) {
    if (!HardwareKeyboard.instance.isShiftPressed &&
        evt.logicalKey.keyLabel == 'Enter' &&
        AppSettings.sendOnEnter.value) {
      if (evt is KeyDownEvent) {
        // #Pangea
        // send();
        onInputBarSubmitted();
        // Pangea#
      }
      return KeyEventResult.handled;
    } else if (evt.logicalKey.keyLabel == 'Enter' && evt is KeyDownEvent) {
      final currentLineNum =
          sendController.text
              .substring(0, sendController.selection.baseOffset)
              .split('\n')
              .length -
          1;
      final currentLine = sendController.text.split('\n')[currentLineNum];

      for (final pattern in [
        '- [ ] ',
        '- [x] ',
        '* [ ] ',
        '* [x] ',
        '- ',
        '* ',
        '+ ',
      ]) {
        if (currentLine.startsWith(pattern)) {
          if (currentLine == pattern) {
            return KeyEventResult.ignored;
          }
          sendController.text += '\n$pattern';
          return KeyEventResult.handled;
        }
      }

      return KeyEventResult.ignored;
    } else {
      return KeyEventResult.ignored;
    }
  }

  @override
  void initState() {
    inputFocus = FocusNode(onKeyEvent: _customEnterKeyHandling);

    scrollController.addListener(_updateScrollController);
    // #Pangea
    // inputFocus.addListener(_inputFocusListener);
    // Pangea#

    // #Pangea
    // _loadDraft();
    // Pangea#
    WidgetsBinding.instance.addPostFrameCallback(_shareItems);
    super.initState();
    _displayChatDetailsColumn = ValueNotifier(
      AppSettings.displayChatDetailsColumn.value,
    );

    sendingClient = Matrix.of(context).client;
    final lastEventThreadId =
        room.lastEvent?.relationshipType == RelationshipTypes.thread
        ? room.lastEvent?.relationshipEventId
        : null;
    readMarkerEventId = room.hasNewMessages
        ? lastEventThreadId ?? room.fullyRead
        : '';
    WidgetsBinding.instance.addObserver(this);
    _tryLoadTimeline();
    // #Pangea
    _pangeaInit();
    _loadDraft();
    // Pangea#
  }

  // #Pangea
  void _onLevelUp(LevelUpdate update) {
    if (MatrixState.pangeaController.subscriptionController.isSubscribed !=
        false) {
      LevelUpUtil.showLevelUpDialog(update.newLevel, update.prevLevel, context);
    }
  }

  void _onUnlockConstructs(Set<ConstructIdentifier> constructs) {
    if (constructs.isEmpty) return;
    ConstructNotificationUtil.addUnlockedConstruct(
      List.from(constructs),
      context,
    );
  }

  void _onTokenUpdate(Set<ConstructIdentifier> constructs) {
    if (constructs.isEmpty) return;
    TokensUtil.clearNewTokenCache();
  }

  Future<void> _botAudioListener(SyncUpdate update) async {
    if (update.rooms?.join?[roomId]?.timeline?.events == null) return;
    final timeline = update.rooms!.join![roomId]!.timeline!;
    final botAudioEvent = timeline.events!.firstWhereOrNull(
      (e) =>
          e.senderId == BotName.byEnvironment &&
          e.content.tryGet<String>('msgtype') == MessageTypes.Audio &&
          DateTime.now().difference(e.originServerTs) <
              const Duration(seconds: 10),
    );
    if (botAudioEvent == null) return;

    final matrix = Matrix.of(context);
    if (matrix.voiceMessageEventId.value != null) return;

    matrix.voiceMessageEventId.value = botAudioEvent.eventId;
    matrix.audioPlayer?.dispose();
    matrix.audioPlayer = AudioPlayer();

    final event = Event.fromMatrixEvent(botAudioEvent, room);
    final audioFile = await event.getPangeaAudioFile();
    if (audioFile == null) return;

    if (!kIsWeb) {
      final tempDir = await getTemporaryDirectory();

      File? file;
      file = File('${tempDir.path}/${audioFile.name}');
      await file.writeAsBytes(audioFile.bytes);
      matrix.audioPlayer!.setFilePath(file.path);
    } else {
      matrix.audioPlayer!.setAudioSource(
        BytesAudioSource(audioFile.bytes, audioFile.mimeType),
      );
    }

    matrix.audioPlayer!.play();
  }

  void _pangeaInit() {
    choreographer = Choreographer(inputFocus);
    choreographer.timesDismissedIT.addListener(_onCloseIT);
    final updater = Matrix.of(context).analyticsDataService.updateDispatcher;

    _levelSubscription = updater.levelUpdateStream.stream.listen(_onLevelUp);

    _constructsSubscription = updater.unlockedConstructsStream.stream.listen(
      _onUnlockConstructs,
    );

    _tokensSubscription = updater.newConstructsStream.stream.listen(
      _onTokenUpdate,
    );

    _botAudioSubscription = room.client.onSync.stream.listen(_botAudioListener);

    activityController = ActivityChatController(
      userID: Matrix.of(context).client.userID!,
      room: room,
    );

    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      LanguageService.showDialogOnEmptyLanguage(
        context,
        () =>
            () => setState(() {}),
      );
    });
  }
  // Pangea#

  final Set<String> expandedEventIds = {};

  void expandEventsFrom(Event event, bool expand) {
    final events = timeline!.events.filterByVisibleInGui(
      threadId: activeThreadId,
    );
    final start = events.indexOf(event);
    setState(() {
      for (var i = start; i < events.length; i++) {
        final event = events[i];
        if (!event.isCollapsedState) return;
        if (expand) {
          expandedEventIds.add(event.eventId);
        } else {
          expandedEventIds.remove(event.eventId);
        }
      }
    });
  }

  void _tryLoadTimeline() async {
    final initialEventId = widget.eventId;
    loadTimelineFuture = _getTimeline();
    try {
      await loadTimelineFuture;
      // We launched the chat with a given initial event ID:
      if (initialEventId != null) {
        scrollToEventId(initialEventId);
        return;
      }

      var readMarkerEventIndex = readMarkerEventId.isEmpty
          ? -1
          : timeline!.events
                .filterByVisibleInGui(
                  exceptionEventId: readMarkerEventId,
                  threadId: activeThreadId,
                )
                .indexWhere((e) => e.eventId == readMarkerEventId);

      // Read marker is existing but not found in first events. Try a single
      // requestHistory call before opening timeline on event context:
      if (readMarkerEventId.isNotEmpty && readMarkerEventIndex == -1) {
        await timeline?.requestHistory(historyCount: _loadHistoryCount);
        readMarkerEventIndex = timeline!.events
            .filterByVisibleInGui(
              exceptionEventId: readMarkerEventId,
              threadId: activeThreadId,
            )
            .indexWhere((e) => e.eventId == readMarkerEventId);
      }

      if (readMarkerEventIndex > 1) {
        Logs().v('Scroll up to visible event', readMarkerEventId);
        scrollToEventId(readMarkerEventId, highlightEvent: false);
        return;
      } else if (readMarkerEventId.isNotEmpty && readMarkerEventIndex == -1) {
        _showScrollUpMaterialBanner(readMarkerEventId);
      }

      // Mark room as read on first visit if requirements are fulfilled
      setReadMarker();

      if (!mounted) return;
    } catch (e, s) {
      ErrorReporter(context, 'Unable to load timeline').onErrorCallback(e, s);
      rethrow;
    }
  }

  String? scrollUpBannerEventId;

  void discardScrollUpBannerEventId() => setState(() {
    scrollUpBannerEventId = null;
  });

  void _showScrollUpMaterialBanner(String eventId) => setState(() {
    scrollUpBannerEventId = eventId;
  });

  void updateView() {
    if (!mounted) return;
    setReadMarker();
    // #Pangea
    // setState(() {});
    if (mounted) timelineUpdateNotifier.notify();
    // Pangea#
  }

  Future<void>? loadTimelineFuture;

  int? animateInEventIndex;

  void onInsert(int i) {
    // setState will be called by updateView() anyway
    if (timeline?.allowNewEvent == true) animateInEventIndex = i;
  }

  // #Pangea
  List<Event> get visibleEvents =>
      timeline?.events.where((x) => x.isVisibleInGui).toList() ?? <Event>[];
  // Pangea#

  Future<void> _getTimeline({String? eventContextId}) async {
    await Matrix.of(context).client.roomsLoading;
    await Matrix.of(context).client.accountDataLoading;
    if (eventContextId != null &&
        (!eventContextId.isValidMatrixId || eventContextId.sigil != '\$')) {
      eventContextId = null;
    }
    try {
      timeline?.cancelSubscriptions();
      timeline = await room.getTimeline(
        onUpdate: updateView,
        eventContextId: eventContextId,
        onInsert: onInsert,
      );
      // #Pangea
      if (visibleEvents.length < 10 && timeline != null) {
        var prevNumEvents = timeline!.events.length;
        await requestHistory();
        var numRequests = 0;
        while (timeline != null &&
            timeline!.events.length > prevNumEvents &&
            visibleEvents.length < 10 &&
            numRequests <= 5) {
          prevNumEvents = timeline!.events.length;
          await requestHistory();
          numRequests++;
        }
      }
      // Pangea#
    } catch (e, s) {
      Logs().w('Unable to load timeline on event ID $eventContextId', e, s);
      if (!mounted) return;
      timeline = await room.getTimeline(
        onUpdate: updateView,
        onInsert: onInsert,
      );
      if (!mounted) return;
      if (e is TimeoutException || e is IOException) {
        _showScrollUpMaterialBanner(eventContextId!);
      }
    }
    timeline!.requestKeys(onlineKeyBackupOnly: false);
    if (room.markedUnread) room.markUnread(false);

    return;
  }

  String? scrollToEventIdMarker;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // #Pangea
    super.didChangeAppLifecycleState(state);
    // On iOS, if the toolbar is open and the app is closed, then the user goes
    // back to do more toolbar activities, the toolbar buttons / selection don't
    // update properly. So, when the user closes the app, close the toolbar overlay.
    if (state == AppLifecycleState.paused) {
      clearSelectedEvents();
    }
    if (state == AppLifecycleState.hidden && !stopMediaStream.isClosed) {
      stopMediaStream.add(null);
    }
    // Pangea#
    if (state != AppLifecycleState.resumed) return;
    if (!mounted) return;
    setReadMarker();
  }

  Future<void>? _setReadMarkerFuture;

  void setReadMarker({String? eventId}) {
    // #Pangea
    if (room.client.userID == null ||
        eventId != null &&
            (eventId.contains("web") ||
                eventId.contains("android") ||
                eventId.contains("ios"))) {
      return;
    }
    // Pangea#
    if (eventId?.isValidMatrixId == false) return;
    if (_setReadMarkerFuture != null) return;
    if (_scrolledUp) return;
    if (scrollUpBannerEventId != null) return;

    if (eventId == null &&
        !room.hasNewMessages &&
        room.notificationCount == 0) {
      return;
    }

    // Do not send read markers when app is not in foreground
    if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }

    final timeline = this.timeline;
    if (timeline == null || timeline.events.isEmpty) return;

    Logs().d('Set read marker...', eventId);
    // ignore: unawaited_futures
    _setReadMarkerFuture = timeline
        .setReadMarker(
          eventId: eventId,
          public: AppSettings.sendPublicReadReceipts.value,
        )
        // #Pangea
        // .then((_) {
        //   _setReadMarkerFuture = null;
        // });
        .then((_) {
          _setReadMarkerFuture = null;
        })
        .catchError((e, s) {
          ErrorHandler.logError(
            e: PangeaWarningError("Failed to set read marker: $e"),
            s: s,
            data: {'eventId': eventId, 'roomId': roomId},
          );
          Sentry.captureException(
            e,
            stackTrace: s,
            withScope: (scope) {
              scope.setTag('where', 'setReadMarker');
            },
          );
        });
    // Pangea#
    if (eventId == null || eventId == timeline.room.lastEvent?.eventId) {
      Matrix.of(context).backgroundPush?.cancelNotification(roomId);
    }
  }

  @override
  void dispose() {
    timeline?.cancelSubscriptions();
    timeline = null;
    // #Pangea
    // inputFocus.removeListener(_inputFocusListener);
    WidgetsBinding.instance.removeObserver(this);
    _storeInputTimeoutTimer?.cancel();
    _displayChatDetailsColumn.dispose();
    timelineUpdateNotifier.dispose();
    typingCoolDown?.cancel();
    typingTimeout?.cancel();
    scrollController.removeListener(_updateScrollController);
    choreographer.dispose();
    activityController.dispose();
    MatrixState.pAnyState.closeAllOverlays(force: true);
    stopMediaStream.close();
    _levelSubscription?.cancel();
    _botAudioSubscription?.cancel();
    _constructsSubscription?.cancel();
    _tokensSubscription?.cancel();
    _router.routeInformationProvider.removeListener(_onRouteChanged);
    choreographer.timesDismissedIT.removeListener(_onCloseIT);
    scrollController.dispose();
    inputFocus.dispose();
    depressMessageButton.dispose();
    scrollableNotifier.dispose();
    TokensUtil.clearNewTokenCache();
    //Pangea#
    super.dispose();
  }

  // #Pangea
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = GoRouter.of(context);
    _router.routeInformationProvider.addListener(_onRouteChanged);
    if (room.isSpace && _router.state.path == ":roomid") {
      ErrorHandler.logError(
        e: "Space chat opened",
        s: StackTrace.current,
        data: {"roomId": roomId},
      );
      NavigationUtil.goToSpaceRoute(null, [], context);
    }
  }

  void _onRouteChanged() {
    if (!stopMediaStream.isClosed) {
      stopMediaStream.add(null);
    }
    MatrixState.pAnyState.closeAllOverlays();
  }

  // TextEditingController sendController = TextEditingController();
  PangeaTextController get sendController => choreographer.textController;
  // Pangea#

  void setSendingClient(Client c) {
    // #Pangea
    // // first cancel typing with the old sending client
    // if (currentlyTyping) {
    //   // no need to have the setting typing to false be blocking
    //   typingCoolDown?.cancel();
    //   typingCoolDown = null;
    //   room.setTyping(false);
    //   currentlyTyping = false;
    // }
    // // then cancel the old timeline
    // // fixes bug with read reciepts and quick switching
    // loadTimelineFuture = _getTimeline(eventContextId: room.fullyRead).onError(
    //   ErrorReporter(
    //     context,
    //     'Unable to load timeline after changing sending Client',
    //   ).onErrorCallback,
    // );

    // // then set the new sending client
    // setState(() => sendingClient = c);
    // Pangea#
  }

  // #Pangea
  // void setActiveClient(Client c) => setState(() {
  //   Matrix.of(context).setActiveClient(c);
  // });
  // Pangea#

  // #Pangea
  Event? pangeaEditingEvent;
  void clearEditingEvent() {
    pangeaEditingEvent = null;
  }

  /// Add a fake event to the timeline to visually indicate that a message is being sent.
  /// Used when tokenizing after message send, specifically because tokenization for some
  /// languages takes some time.
  Future<String?> sendFakeMessage(Event? edit, Event? reply) async {
    if (sendController.text.trim().isEmpty) return null;
    final message = sendController.text;
    sendController.setSystemText("", EditTypeEnum.other);

    return room.sendFakeMessage(
      text: message,
      inReplyTo: reply,
      editEventId: edit?.eventId,
    );
  }

  // Future<void> send() async {
  //   if (sendController.text.trim().isEmpty) return;
  Future<void> send() async {
    // Close span card if open
    MatrixState.pAnyState.closeAllOverlays();

    final message = sendController.text;
    final edit = editEvent.value;
    final reply = replyEvent.value;
    editEvent.value = null;
    replyEvent.value = null;
    pendingText = '';

    final tempEventId = await sendFakeMessage(edit, reply);
    if (!inputFocus.hasFocus) {
      inputFocus.requestFocus();
    }

    final content = await choreographer.getMessageContent(message);
    choreographer.clear();

    if (message.trim().isEmpty) return;
    // Pangea#
    _storeInputTimeoutTimer?.cancel();
    final prefs = Matrix.of(context).store;
    prefs.remove('draft_$roomId');
    var parseCommands = true;

    // #Pangea
    // final commandMatch = RegExp(r'^\/(\w+)').firstMatch(sendController.text);
    final commandMatch = RegExp(r'^\/(\w+)').firstMatch(message);
    // Pangea#
    if (commandMatch != null &&
        !sendingClient.commands.keys.contains(commandMatch[1]!.toLowerCase())) {
      // #Pangea
      // final l10n = L10n.of(context);
      // final dialogResult = await showOkCancelAlertDialog(
      //   context: context,
      //   title: l10n.commandInvalid,
      //   message: l10n.commandMissing(commandMatch[0]!),
      //   okLabel: l10n.sendAsText,
      //   cancelLabel: l10n.cancel,
      // );
      // if (dialogResult == OkCancelResult.cancel) return;
      // Pangea#
      parseCommands = false;
    }

    // ignore: unawaited_futures
    // #Pangea
    // room.sendTextEvent(
    //   sendController.text,
    //   inReplyTo: replyEvent,
    //   editEventId: editEvent.eventId,
    //   parseCommands: parseCommands,
    //   threadRootEventId: activeThreadId,
    // );
    // If the message and the sendController text don't match, it's possible
    // that there was a delay in tokenization before send, and the user started
    // typing a new message. We don't want to erase that, so only reset the input
    // bar text if the message is the same as the sendController text.
    if (message == sendController.text) {
      sendController.setSystemText("", EditTypeEnum.other);
    }

    final previousEdit = edit;
    if (showEmojiPicker) {
      hideEmojiPicker();
    }

    room
        .pangeaSendTextEvent(
          message,
          inReplyTo: reply,
          editEventId: edit?.eventId,
          parseCommands: parseCommands,
          originalWritten: content.originalWritten,
          tokensSent: content.tokensSent,
          tokensWritten: content.tokensWritten,
          choreo: content.choreo,
          txid: tempEventId,
          threadRootEventId: activeThreadId,
        )
        .then((String? msgEventId) async {
          // #Pangea
          // There's a listen in my_analytics_controller that decides when to auto-update
          // analytics based on when / how many messages the logged in user send. This
          // stream sends the data for newly sent messages.
          _sendMessageAnalytics(
            msgEventId,
            originalSent: PangeaRepresentation(
              langCode:
                  content.tokensSent?.detections?.firstOrNull?.langCode ??
                  LanguageKeys.unknownLanguage,
              text: message,
              originalSent: true,
              originalWritten: false,
            ),
            tokensSent: content.tokensSent,
            choreo: content.choreo,
          );

          if (previousEdit != null) {
            pangeaEditingEvent = previousEdit;
          }

          final spaceCode = room.classCode;
          if (spaceCode != null) {
            GoogleAnalytics.sendMessage(room.id, spaceCode);
          }

          if (msgEventId == null) {
            ErrorHandler.logError(
              e: Exception('msgEventId is null'),
              s: StackTrace.current,
              data: {
                'roomId': roomId,
                'text': message,
                'inReplyTo': reply?.eventId,
                'editEventId': edit?.eventId,
              },
            );
            return;
          }
        })
        .catchError((err, s) {
          if (err is EventTooLarge) {
            showAdaptiveDialog(
              context: context,
              builder: (context) => const EventTooLargeDialog(),
            );
            return;
          }
          ErrorHandler.logError(
            e: err,
            s: s,
            data: {
              'roomId': roomId,
              'text': message,
              'inReplyTo': reply?.eventId,
              'editEventId': edit?.eventId,
            },
          );
        });
    // sendController.value = TextEditingValue(
    //   text: pendingText,
    //   selection: const TextSelection.collapsed(offset: 0),
    // );

    // setState(() {
    //   sendController.text = pendingText;
    //   _inputTextIsEmpty = pendingText.isEmpty;
    //   replyEvent = null;
    //   editEvent = null;
    //   pendingText = '';
    // });
    // Pangea#
  }

  void sendFileAction({FileType type = FileType.any}) async {
    final files = await selectFiles(context, allowMultiple: true, type: type);
    if (files.isEmpty) return;
    await showAdaptiveDialog(
      context: context,
      builder: (c) => SendFileDialog(
        files: files,
        room: room,
        outerContext: context,
        threadRootEventId: activeThreadId,
        threadLastEventId: threadLastEventId,
      ),
    );
  }

  void sendImageFromClipBoard(Uint8List? image) async {
    if (image == null) return;
    await showAdaptiveDialog(
      context: context,
      builder: (c) => SendFileDialog(
        files: [XFile.fromData(image)],
        room: room,
        outerContext: context,
        threadRootEventId: activeThreadId,
        threadLastEventId: threadLastEventId,
      ),
    );
  }

  void openCameraAction() async {
    // Make sure the textfield is unfocused before opening the camera
    FocusScope.of(context).requestFocus(FocusNode());
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file == null) return;

    await showAdaptiveDialog(
      context: context,
      builder: (c) => SendFileDialog(
        files: [file],
        room: room,
        outerContext: context,
        threadRootEventId: activeThreadId,
        threadLastEventId: threadLastEventId,
      ),
    );
  }

  void openVideoCameraAction() async {
    // Make sure the textfield is unfocused before opening the camera
    FocusScope.of(context).requestFocus(FocusNode());
    final file = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 1),
    );
    if (file == null) return;

    await showAdaptiveDialog(
      context: context,
      builder: (c) => SendFileDialog(
        files: [file],
        room: room,
        outerContext: context,
        threadRootEventId: activeThreadId,
        threadLastEventId: threadLastEventId,
      ),
    );
  }

  Future<void> onVoiceMessageSend(
    String path,
    int duration,
    List<int> waveform,
    String? fileName,
  ) async {
    // #Pangea
    stopMediaStream.add(null);
    if (PlatformInfos.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt < 19) {
        showOkAlertDialog(
          context: context,
          title: L10n.of(context).unsupportedAndroidVersion,
          message: L10n.of(context).unsupportedAndroidVersionLong,
          okLabel: L10n.of(context).close,
        );
        return;
      }
    }
    // Pangea#
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final audioFile = XFile(path);

    final bytesResult = await showFutureLoadingDialog(
      context: context,
      future: audioFile.readAsBytes,
    );
    final bytes = bytesResult.result;
    if (bytes == null) return;

    final file = MatrixAudioFile(
      bytes: bytes,
      name: fileName ?? audioFile.path,
    );

    // #Pangea
    final reply = replyEvent.value;
    replyEvent.value = null;

    // Get transcript first so we can embed it in the audio event,
    // allowing the bot (and other clients) to read it immediately
    // without waiting for a separate representation event.
    final transcriptResult = await _getVoiceMessageTranscript(file);
    final stt = transcriptResult.result;
    // Pangea#

    // #Pangea
    // room
    final eventId = await room
        // Pangea#
        .sendFileEvent(
          file,
          // #Pangea
          // inReplyTo: replyEvent,
          inReplyTo: reply,
          // Pangea#
          threadRootEventId: activeThreadId,
          extraContent: {
            'info': {...file.info, 'duration': duration},
            'org.matrix.msc3245.voice': {},
            'org.matrix.msc1767.audio': {
              'duration': duration,
              'waveform': waveform,
            },
            // #Pangea
            'speaker_l1': pangeaController.userController.userL1Code,
            'speaker_l2': pangeaController.userController.userL2Code,
            if (stt != null) ModelKey.userStt: stt.toJson(),
            // Pangea#
          },
        )
        // #Pangea
        // .catchError((e) {
        .catchError((e, s) {
          ErrorHandler.logError(
            e: e,
            s: s,
            data: {'roomId': roomId, 'file': file.name},
          );
          // Pangea#
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text((e as Object).toLocalizedString(context))),
          );
          return null;
        });
    // #Pangea
    // setState(() {
    //   replyEvent = null;
    // });
    if (eventId == null) {
      ErrorHandler.logError(
        e: Exception('eventID null in voiceMessageAction'),
        s: StackTrace.current,
        data: {'roomId': roomId},
      );
      return;
    }

    if (stt != null) {
      _sendVoiceMessageAnalytics(eventId, stt);
    }
    // Pangea#
    return;
  }

  void hideEmojiPicker() {
    setState(() => showEmojiPicker = false);
  }

  void emojiPickerAction() {
    if (showEmojiPicker) {
      inputFocus.requestFocus();
    } else {
      inputFocus.unfocus();
    }
    setState(() => showEmojiPicker = !showEmojiPicker);
  }

  // #Pangea
  // void _inputFocusListener() {
  //   if (showEmojiPicker && inputFocus.hasFocus) {
  //     setState(() => showEmojiPicker = false);
  //   }
  // }
  // Pangea#

  void sendLocationAction() async {
    await showAdaptiveDialog(
      context: context,
      builder: (c) => SendLocationDialog(room: room),
    );
  }

  String _getSelectedEventString() {
    var copyString = '';
    if (selectedEvents.length == 1) {
      return selectedEvents.first
          .getDisplayEvent(timeline!)
          .calcLocalizedBodyFallback(MatrixLocals(L10n.of(context)));
    }
    for (final event in selectedEvents) {
      if (copyString.isNotEmpty) copyString += '\n\n';
      copyString += event
          .getDisplayEvent(timeline!)
          .calcLocalizedBodyFallback(
            MatrixLocals(L10n.of(context)),
            withSenderNamePrefix: true,
          );
    }
    return copyString;
  }

  void copyEventsAction() {
    Clipboard.setData(ClipboardData(text: _getSelectedEventString()));
    // #Pangea
    // setState(() {
    //   showEmojiPicker = false;
    //   selectedEvents.clear();
    // });
    clearSelectedEvents();
    // Pangea#
  }

  void reportEventAction() async {
    final event = selectedEvents.single;
    final score = await showModalActionPopup<int>(
      context: context,
      title: L10n.of(context).reportMessage,
      message: L10n.of(context).howOffensiveIsThisContent,
      cancelLabel: L10n.of(context).cancel,
      actions: [
        AdaptiveModalAction(
          value: -100,
          label: L10n.of(context).extremeOffensive,
        ),
        AdaptiveModalAction(value: -50, label: L10n.of(context).offensive),
        AdaptiveModalAction(value: 0, label: L10n.of(context).inoffensive),
      ],
    );
    if (score == null) return;
    final reason = await showTextInputDialog(
      context: context,
      title: L10n.of(context).whyDoYouWantToReportThis,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      hintText: L10n.of(context).reason,
    );
    if (reason == null || reason.isEmpty) return;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.reportEvent(
        event.roomId!,
        event.eventId,
        reason: reason,
        score: score,
      ),
    );
    if (result.error != null) return;
    // #Pangea
    // setState(() {
    //   showEmojiPicker = false;
    //   selectedEvents.clear();
    // });
    clearSelectedEvents();
    // Pangea#
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L10n.of(context).contentHasBeenReported)),
    );
  }

  void deleteErrorEventsAction() async {
    try {
      if (selectedEvents.any((event) => event.status != EventStatus.error)) {
        throw Exception(
          'Tried to delete failed to send events but one event is not failed to sent',
        );
      }
      for (final event in selectedEvents) {
        await event.cancelSend();
      }
      // #Pangea
      // setState(selectedEvents.clear);
      clearSelectedEvents();
      // Pangea#
    } catch (e, s) {
      ErrorReporter(
        context,
        'Error while delete error events action',
      ).onErrorCallback(e, s);
    }
  }

  void redactEventsAction() async {
    final reasonInput = selectedEvents.any((event) => event.status.isSent)
        ? await showTextInputDialog(
            context: context,
            title: L10n.of(context).redactMessage,
            message: L10n.of(context).redactMessageDescription,
            isDestructive: true,
            hintText: L10n.of(context).optionalRedactReason,
            maxLength: 255,
            maxLines: 3,
            minLines: 1,
            okLabel: L10n.of(context).remove,
            cancelLabel: L10n.of(context).cancel,
            // #Pangea
            autoSubmit: true,
            // Pangea#
          )
        : null;
    // #Pangea
    // if (reasonInput == null) return;
    if (reasonInput == null) {
      clearSelectedEvents();
      return;
    }
    // Pangea#
    final reason = reasonInput.isEmpty ? null : reasonInput;
    await showFutureLoadingDialog(
      context: context,
      futureWithProgress: (onProgress) async {
        final count = selectedEvents.length;
        for (final (i, event) in selectedEvents.indexed) {
          onProgress(i / count);
          if (event.status.isSent) {
            if (event.canRedact) {
              await event.redactEvent(reason: reason);
            } else {
              final client = currentRoomBundle.firstWhere(
                (cl) => selectedEvents.first.senderId == cl!.userID,
                orElse: () => null,
              );
              if (client == null) {
                return;
              }
              final room = client.getRoomById(roomId)!;
              await Event.fromJson(
                event.toJson(),
                room,
              ).redactEvent(reason: reason);
            }
          } else {
            await event.cancelSend();
          }
        }
      },
    );
    // #Pangea
    // setState(() {
    //   showEmojiPicker = false;
    //   selectedEvents.clear();
    // });
    clearSelectedEvents();
    // Pangea#
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
      if (!event.status.isSent) return false;
      if (event.canRedact == false &&
          !(clients!.any((cl) => event.senderId == cl!.userID))) {
        return false;
      }
    }
    return true;
  }

  bool get canPinSelectedEvents {
    if (isArchived ||
        !room.canChangeStateEvent(EventTypes.RoomPinnedEvents) ||
        selectedEvents.length != 1 ||
        !selectedEvents.single.status.isSent ||
        activeThreadId != null) {
      return false;
    }
    return true;
  }

  bool get canEditSelectedEvents {
    if (isArchived ||
        selectedEvents.length != 1 ||
        !selectedEvents.first.status.isSent) {
      return false;
    }
    return currentRoomBundle.any(
      (cl) => selectedEvents.first.senderId == cl!.userID,
    );
  }

  void forwardEventsAction() async {
    if (selectedEvents.isEmpty) return;
    final timeline = this.timeline;
    if (timeline == null) return;

    final forwardEvents = List<Event>.from(
      selectedEvents,
    ).map((event) => event.getDisplayEvent(timeline)).toList();

    await showScaffoldDialog(
      context: context,
      builder: (context) => ShareScaffoldDialog(
        items: forwardEvents
            // #Pangea
            // .map((event) => ContentShareItem(event.content))
            // .toList(),
            .map((event) {
              final content = Map<String, dynamic>.from(event.content);
              content.remove("m.relates_to");
              return ContentShareItem(content);
            })
            .toList(),
        // Pangea#
      ),
    );
    if (!mounted) return;
    // #Pangea
    // see https://github.com/pangeachat/client/issues/2536
    // setState(() => selectedEvents.clear());
    // Pangea#
  }

  void sendAgainAction() {
    // #Pangea
    if (selectedEvents.isEmpty) {
      ErrorHandler.logError(
        e: "No selected events in send again action",
        s: StackTrace.current,
        data: {"roomId": roomId},
      );
      clearSelectedEvents();
      return;
    }
    // Pangea#
    final event = selectedEvents.first;
    // #Pangea
    clearSelectedEvents();
    // Pangea#
    if (event.status.isError) {
      event.sendAgain();
    }
    final allEditEvents = event
        .aggregatedEvents(timeline!, RelationshipTypes.edit)
        .where((e) => e.status.isError);
    for (final e in allEditEvents) {
      e.sendAgain();
    }
    // #Pangea
    // setState(() => selectedEvents.clear());
    // Pangea#
  }

  void replyAction({Event? replyTo}) {
    // #Pangea
    replyEvent.value = replyTo ?? selectedEvents.first;
    clearSelectedEvents();
    // setState(() {
    //   replyEvent = replyTo ?? selectedEvents.first;
    //   selectedEvents.clear();
    // });
    // Pangea#
    inputFocus.requestFocus();
  }

  void scrollToEventId(String eventId, {bool highlightEvent = true}) async {
    final foundEvent = timeline!.events.firstWhereOrNull(
      (event) => event.eventId == eventId,
    );

    final eventIndex = foundEvent == null
        ? -1
        : timeline!.events
              .filterByVisibleInGui(
                exceptionEventId: eventId,
                threadId: activeThreadId,
              )
              .indexOf(foundEvent);

    if (eventIndex == -1) {
      setState(() {
        timeline = null;
        _scrolledUp = false;
        loadTimelineFuture = _getTimeline(eventContextId: eventId).onError(
          ErrorReporter(
            context,
            'Unable to load timeline after scroll to ID',
          ).onErrorCallback,
        );
      });
      await loadTimelineFuture;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollToEventId(eventId);
      });
      return;
    }
    if (highlightEvent) {
      setState(() {
        scrollToEventIdMarker = eventId;
      });
    }
    await scrollController.scrollToIndex(
      eventIndex + 1,
      duration: FluffyThemes.animationDuration,
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
          ErrorReporter(
            context,
            'Unable to load timeline after scroll down',
          ).onErrorCallback,
        );
      });
      await loadTimelineFuture;
    }
    scrollController.jumpTo(0);
  }

  void onEmojiSelected(dynamic _, Emoji? emoji) {
    typeEmoji(emoji);
    onInputBarChanged(sendController.text);
  }

  void typeEmoji(Emoji? emoji) {
    if (emoji == null) return;
    final text = sendController.text;

    // #Pangea
    if (!sendController.selection.isValid) {
      sendController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    // Pangea#
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

  void emojiPickerBackspace() {
    sendController
      ..text = sendController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: sendController.text.length),
      );
  }

  // #Pangea
  // void clearSelectedEvents() => setState(() {
  //   selectedEvents.clear();
  //   showEmojiPicker = false;
  // });

  // void clearSingleSelectedEvent() {
  //   if (selectedEvents.length <= 1) {
  //     clearSelectedEvents();
  //   }
  // }
  void clearSelectedEvents() {
    if (!mounted) return;
    if (!_isToolbarOpen && selectedEvents.isEmpty) return;
    MatrixState.pAnyState.closeAllOverlays();
    depressMessageButton.value = false;

    setState(() {
      selectedEvents.clear();
      showEmojiPicker = false;
    });
  }

  void setSelectedEvent(Event event) {
    setState(() {
      selectedEvents.clear();
      selectedEvents.add(event);
    });
  }
  // Pangea#

  void editSelectedEventAction() {
    // #Pangea
    // final client = currentRoomBundle.firstWhere(
    //   (cl) => selectedEvents.first.senderId == cl!.userID,
    //   orElse: () => null,
    // );
    // if (client == null) {
    //   return;
    // }
    // setSendingClient(client);
    // setState(() {
    //   pendingText = sendController.text;
    //   editEvent = selectedEvents.first;
    //   sendController.text = editEvent
    //       .getDisplayEvent(timeline!)
    //       .calcLocalizedBodyFallback(
    //         MatrixLocals(L10n.of(context)),
    //         withSenderNamePrefix: false,
    //         hideReply: true,
    //       );
    //   selectedEvents.clear();
    // });
    pendingText = sendController.text;
    editEvent.value = selectedEvents.first;
    sendController.text = editEvent.value!
        .getDisplayEvent(timeline!)
        .calcLocalizedBodyFallback(
          MatrixLocals(L10n.of(context)),
          withSenderNamePrefix: false,
          hideReply: true,
        );
    clearSelectedEvents();
    // Pangea#
    inputFocus.requestFocus();
  }

  void goToNewRoomAction() async {
    final result = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final users = await room.requestParticipants(
          [Membership.join, Membership.leave],
          true,
          false,
        );
        users.sort((a, b) => a.powerLevel.compareTo(b.powerLevel));
        final via = users
            .map((user) => user.id.domain)
            .whereType<String>()
            .toSet()
            .take(10)
            .toList();
        return room.client.joinRoom(
          room
              .getState(EventTypes.RoomTombstone)!
              .parsedTombstoneContent
              .replacementRoom,
          via: via,
        );
      },
    );
    if (result.error != null) return;
    if (!mounted) return;
    context.go('/rooms/${result.result!}');

    await showFutureLoadingDialog(context: context, future: room.leave);
  }

  // #Pangea
  // void onSelectMessage(Event event) {
  //   if (!event.redacted) {
  //     if (selectedEvents.contains(event)) {
  //       setState(() => selectedEvents.remove(event));
  //     } else {
  //       setState(() => selectedEvents.add(event));
  //     }
  //     selectedEvents.sort(
  //       (a, b) => a.originServerTs.compareTo(b.originServerTs),
  //     );
  //   }
  // }
  // Pangea#

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

  // #Pangea
  // void onInputBarSubmitted(String _) {
  //   send();
  //   FocusScope.of(context).requestFocus(inputFocus);
  // }
  Future<void> onInputBarSubmitted() async {
    if (MatrixState.pangeaController.subscriptionController.shouldShowPaywall) {
      PaywallCard.show(context, ChoreoConstants.inputTransformTargetKey);
      return;
    }
    await _onRequestWritingAssistance(manual: false, autosend: true);
  }
  // Pangea#

  void onAddPopupMenuButtonSelected(AddPopupMenuActions choice) {
    room.client.getConfig();

    switch (choice) {
      case AddPopupMenuActions.image:
        sendFileAction(type: FileType.image);
        return;
      case AddPopupMenuActions.video:
        sendFileAction(type: FileType.video);
        return;
      case AddPopupMenuActions.file:
        sendFileAction();
        return;
      case AddPopupMenuActions.poll:
        showAdaptiveBottomSheet(
          context: context,
          builder: (context) => StartPollBottomSheet(room: room),
        );
        return;
      case AddPopupMenuActions.photoCamera:
        openCameraAction();
        return;
      case AddPopupMenuActions.videoCamera:
        openVideoCameraAction();
        return;
      case AddPopupMenuActions.location:
        sendLocationAction();
        return;
    }
  }

  void unpinEvent(String eventId) async {
    final response = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).unpin,
      // #Pangea
      // message: L10n.of(context).confirmEventUnpin,
      message: L10n.of(context).confirmMessageUnpin,
      // Pangea#
      okLabel: L10n.of(context).unpin,
      cancelLabel: L10n.of(context).cancel,
    );
    if (response == OkCancelResult.ok) {
      final events = room.pinnedEventIds
        ..removeWhere((oldEvent) => oldEvent == eventId);
      // #Pangea
      if (scrollToEventIdMarker == eventId) {
        scrollToEventIdMarker = null;
      }
      // Pangea#
      showFutureLoadingDialog(
        context: context,
        future: () => room.setPinnedEvents(events),
      );
    }
  }

  // #Pangea
  // void pinEvent() {
  Future<void> pinEvent() async {
    // Pangea#
    final pinnedEventIds = room.pinnedEventIds;
    final selectedEventIds = selectedEvents.map((e) => e.eventId).toSet();
    final unpin =
        selectedEventIds.length == 1 &&
        pinnedEventIds.contains(selectedEventIds.single);
    if (unpin) {
      // #Pangea
      //pinnedEventIds.removeWhere(selectedEventIds.contains);
      unpinEvent(selectedEventIds.single);
      // Pangea#
    } else {
      pinnedEventIds.addAll(selectedEventIds);
    }
    // #Pangea
    // showFutureLoadingDialog(
    //   context: context,
    //   future: () => room.setPinnedEvents(pinnedEventIds),
    // );
    await showFutureLoadingDialog(
      context: context,
      future: () => room.setPinnedEvents(pinnedEventIds),
    );
    clearSelectedEvents();
    // Pangea#
  }

  Timer? _storeInputTimeoutTimer;
  static const Duration _storeInputTimeout = Duration(milliseconds: 500);

  void onInputBarChanged(String text) {
    // #Pangea
    // if (_inputTextIsEmpty != text.isEmpty) {
    //   setState(() {
    //     _inputTextIsEmpty = text.isEmpty;
    //   });
    // }
    // Pangea#
    _storeInputTimeoutTimer?.cancel();
    _storeInputTimeoutTimer = Timer(_storeInputTimeout, () async {
      final prefs = Matrix.of(context).store;
      await prefs.setString('draft_$roomId', text);
    });
    // #Pangea
    // if (text.endsWith(' ') && Matrix.of(context).hasComplexBundles) {
    //   final clients = currentRoomBundle;
    //   for (final client in clients) {
    //     final prefix = client!.sendPrefix;
    //     if ((prefix.isNotEmpty) &&
    //         text.toLowerCase() == '${prefix.toLowerCase()} ') {
    //       setSendingClient(client);
    //       setState(() {
    //         sendController.clear();
    //       });
    //       return;
    //     }
    //   }
    // }
    // Pangea#
    if (AppSettings.sendTypingNotifications.value) {
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
        room.setTyping(
          true,
          timeout: const Duration(seconds: 30).inMilliseconds,
        );
      }
    }
  }

  // #Pangea
  // bool _inputTextIsEmpty = true;
  // Pangea#

  bool get isArchived =>
      {Membership.leave, Membership.ban}.contains(room.membership);

  // #Pangea
  // void showEventInfo([Event? event]) =>
  //     (event ?? selectedEvents.single).showInfoDialog(context);
  void showEventInfo([Event? event]) {
    (event ?? selectedEvents.single).showInfoDialog(context);
    clearSelectedEvents();
  }
  // Pangea#

  void onPhoneButtonTap() async {
    // VoIP required Android SDK 21
    if (PlatformInfos.isAndroid) {
      DeviceInfoPlugin().androidInfo.then((value) {
        if (value.version.sdkInt < 21) {
          Navigator.pop(context);
          showOkAlertDialog(
            context: context,
            title: L10n.of(context).unsupportedAndroidVersion,
            message: L10n.of(context).unsupportedAndroidVersionLong,
            okLabel: L10n.of(context).close,
          );
        }
      });
    }
    final callType = await showModalActionPopup<CallType>(
      context: context,
      title: L10n.of(context).warning,
      message: L10n.of(context).videoCallsBetaWarning,
      cancelLabel: L10n.of(context).cancel,
      actions: [
        AdaptiveModalAction(
          label: L10n.of(context).voiceCall,
          icon: const Icon(Icons.phone_outlined),
          value: CallType.kVoice,
        ),
        AdaptiveModalAction(
          label: L10n.of(context).videoCall,
          icon: const Icon(Icons.video_call_outlined),
          value: CallType.kVideo,
        ),
      ],
    );
    if (callType == null) return;

    final voipPlugin = Matrix.of(context).voipPlugin;
    try {
      await voipPlugin!.voip.inviteToCall(room, callType);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
    }
  }

  void cancelReplyEventAction() => setState(() {
    // #Pangea
    // sendController.text = pendingText;
    sendController.setSystemText(pendingText, EditTypeEnum.other);
    // Pangea#
    pendingText = '';
    // #Pangea
    // replyEvent = null;
    // editEvent = null;
    replyEvent.value = null;
    editEvent.value = null;
    // Pangea#
  });
  // #Pangea
  ValueNotifier<bool> depressMessageButton = ValueNotifier(false);

  String? get buttonEventID => timeline!.events
      .firstWhereOrNull(
        (event) =>
            event.isVisibleInGui &&
            event.senderId != room.client.userID &&
            !event.redacted,
      )
      ?.eventId;

  String? get refreshEventID {
    final candidate = timeline!.events.firstWhereOrNull(
      (event) =>
          event.isVisibleInGui &&
          event.senderId != room.client.userID &&
          event.senderId == BotName.byEnvironment &&
          !event.redacted,
    );
    if (candidate?.hasAggregatedEvents(timeline!, RelationshipTypes.edit) ==
        true) {
      return null;
    }
    return candidate?.eventId;
  }

  final StreamController<void> stopMediaStream = StreamController.broadcast();

  bool get _isToolbarOpen => MatrixState.pAnyState.isOverlayOpen(
    overlayKey: "message_toolbar_overlay",
  );

  void showToolbar(
    Event event, {
    PangeaMessageEvent? pangeaMessageEvent,
    PangeaToken? selectedToken,
    MessagePracticeMode? mode,
    Event? nextEvent,
    Event? prevEvent,
  }) async {
    if (event.redacted || event.status == EventStatus.sending) return;

    // Close emoji picker, if open
    if (showEmojiPicker) {
      hideEmojiPicker();
      return;
    }

    // Check if the user has set their languages. If not, prompt them to do so.
    if (!MatrixState.pangeaController.userController.languagesSet) {
      pLanguageDialog(context, () {});
      return;
    }

    final overlayEntry = MessageSelectionOverlay(
      chatController: this,
      event: event,
      timeline: timeline!,
      initialSelectedToken: selectedToken,
      nextEvent: nextEvent,
      prevEvent: prevEvent,
    );

    // you've clicked a message so lets turn this off
    if (!InstructionsEnum.clickMessage.isToggledOff) {
      InstructionsEnum.clickMessage.setToggledOff(true);
    }

    if (!kIsWeb) {
      HapticFeedback.mediumImpact();
    }
    stopMediaStream.add(null);

    final isButton = buttonEventID == event.eventId;
    final keyboardOpen = inputFocus.hasFocus && PlatformInfos.isMobile;

    final delay = keyboardOpen
        ? const Duration(milliseconds: 500)
        : isButton
        ? const Duration(milliseconds: 200)
        : null;

    if (isButton) {
      depressMessageButton.value = true;
    }

    if (keyboardOpen) {
      inputFocus.unfocus();
    }

    if (delay != null) {
      OverlayUtil.showOverlay(
        context: context,
        child: TransparentBackdrop(
          backgroundColor: Colors.black,
          onDismiss: clearSelectedEvents,
          blurBackground: true,
          animateBackground: true,
          backgroundAnimationDuration: delay,
        ),
        position: OverlayPositionEnum.centered,
        overlayKey: "button_message_backdrop",
      );

      await Future.delayed(delay);

      if (_router.state.path != ':roomid') {
        // The user has navigated away from the chat,
        // so we don't want to show the overlay.
        return;
      }
      OverlayUtil.showOverlay(
        context: context,
        child: overlayEntry,
        position: OverlayPositionEnum.centered,
        onDismiss: clearSelectedEvents,
        blurBackground: true,
        backgroundColor: Colors.black,
        overlayKey: "message_toolbar_overlay",
      );
    } else {
      OverlayUtil.showOverlay(
        context: context,
        child: overlayEntry,
        position: OverlayPositionEnum.centered,
        onDismiss: clearSelectedEvents,
        blurBackground: true,
        backgroundColor: Colors.black,
        overlayKey: "message_toolbar_overlay",
      );
    }
  }

  bool get displayChatDetailsColumn {
    try {
      return _displayChatDetailsColumn.value;
    } catch (e) {
      // if not set, default to false
      return false;
    }
  }

  void _sendMessageAnalytics(
    String? eventId, {
    PangeaRepresentation? originalSent,
    PangeaMessageTokens? tokensSent,
    ChoreoRecordModel? choreo,
  }) {
    // There's a listen in my_analytics_controller that decides when to auto-update
    // analytics based on when / how many messages the logged in user send. This
    // stream sends the data for newly sent messages.
    if (originalSent?.langCodeMatchesL2 != true) {
      return;
    }

    final metadata = ConstructUseMetaData(
      roomId: roomId,
      timeStamp: DateTime.now(),
      eventId: eventId,
    );

    if (eventId != null && originalSent != null && tokensSent != null) {
      final List<OneConstructUse> constructs = [
        ...originalSent.vocabAndMorphUses(
          choreo: choreo,
          tokens: tokensSent.tokens,
          metadata: metadata,
        ),
      ];

      final langCode = originalSent.langCode.split('-').first;
      _showAnalyticsFeedback(constructs, eventId, langCode);
      addAnalytics(constructs, eventId, langCode);
    }
  }

  Future<void> _sendVoiceMessageAnalytics(
    String eventId,
    SpeechToTextResponseModel stt,
  ) async {
    try {
      if (stt.transcript.sttTokens.isEmpty) return;
      final constructs = stt.constructs(roomId, eventId);
      if (constructs.isEmpty) return;

      final langCode = stt.langCode.split('-').first;
      _showAnalyticsFeedback(constructs, eventId, langCode);
      Matrix.of(context).analyticsDataService.updateService.addAnalytics(
        eventId,
        constructs,
        langCode,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {'roomId': roomId, 'eventId': eventId},
      );
    }
  }

  Future<async.Result<SpeechToTextResponseModel>> _getVoiceMessageTranscript(
    MatrixAudioFile file,
  ) async {
    return SpeechToTextRepo.get(
      MatrixState.pangeaController.userController.accessToken,
      SpeechToTextRequestModel(
        audioContent: file.bytes,
        config: SpeechToTextAudioConfigModel(
          encoding: mimeTypeToAudioEncoding(file.mimeType),
          sampleRateHertz: 22050,
          userL1:
              MatrixState
                  .pangeaController
                  .userController
                  .userL1
                  ?.langCodeShort ??
              LanguageKeys.unknownLanguage,
          userL2:
              MatrixState
                  .pangeaController
                  .userController
                  .userL2
                  ?.langCodeShort ??
              LanguageKeys.unknownLanguage,
        ),
      ),
    );
  }

  void showNextMatch({PangeaMatchState? match}) {
    final matchToShow =
        match ?? choreographer.igcController.openMatches.firstOrNull;

    if (matchToShow == null) {
      inputFocus.requestFocus();
      return;
    }

    if (matchToShow.updatedMatch.isITStart) {
      choreographer.itController.openIT(sendController.text);
      return;
    }

    final isSpanCardOpen = MatrixState.pAnyState.isOverlayOpen(
      overlayKey: 'span-card-overlay',
    );

    try {
      choreographer.igcController.setActiveMatch(match: matchToShow);
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s, data: {'match': matchToShow.toJson()});
      return;
    }

    if (!isSpanCardOpen) {
      OverlayUtil.showIGCMatch(
        matchToShow,
        choreographer,
        context,
        onWritingAssistanceFeedback,
      );
    }
  }

  Future<void> onManualWritingAssistance() =>
      _onRequestWritingAssistance(manual: true);

  Future<void> onWritingAssistanceFeedback(String feedback) =>
      _onRequestWritingAssistance(feedback: feedback);

  Future<void> _onRequestWritingAssistance({
    bool manual = false,
    bool autosend = false,
    String? feedback,
  }) async {
    if (shouldShowLanguageMismatchPopupByActivity) {
      return showLanguageMismatchPopup(manual: manual, autosend: autosend);
    }

    // If this request should send on a success, and is not a manual request, and assistance
    // has already been requested, then just send the message instead of requesting assistance again.
    if (autosend &&
        !manual &&
        choreographer.assistanceState != AssistanceStateEnum.notFetched) {
      await send();
      return;
    }

    feedback == null
        ? await choreographer.requestWritingAssistance(manual: manual)
        : await choreographer.rerunWithFeedback(feedback);

    if (choreographer.assistanceState == AssistanceStateEnum.fetched) {
      showNextMatch();
    } else if (autosend) {
      await send();
    } else {
      inputFocus.requestFocus();
    }
  }

  void showLanguageMismatchPopup({bool manual = false, bool autosend = false}) {
    if (!shouldShowLanguageMismatchPopupByActivity) {
      return;
    }

    final targetLanguage = room.activityPlan!.req.targetLanguage;
    LanguageMismatchRepo.setRoom(roomId);
    OverlayUtil.showLanguageMismatchPopup(
      context: context,
      targetId: ChoreoConstants.inputTransformTargetKey,
      message: L10n.of(context).languageMismatchDesc,
      targetLanguage: targetLanguage,
      onConfirm: () => WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onRequestWritingAssistance(manual: manual, autosend: autosend),
      ),
    );
  }

  Future<void> updateLanguageOnMismatch(String target) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    final resp = await showFutureLoadingDialog(
      context: context,
      future: () async {
        clearSelectedEvents();
        await MatrixState.pangeaController.userController.updateProfile((
          profile,
        ) {
          profile.userSettings.targetLanguage = target;
          return profile;
        }, waitForDataInSync: true);
      },
    );
    if (resp.isError) return;
    if (mounted) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            L10n.of(context).languageUpdated,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void _onCloseIT() {
    if (choreographer.timesDismissedIT.value >= 3) {
      showDisableLanguageToolsPopup();
    }
  }

  void showDisableLanguageToolsPopup() {
    if (InstructionsEnum.disableLanguageTools.isToggledOff) {
      return;
    }

    InstructionsEnum.disableLanguageTools.setToggledOff(true);
    OverlayUtil.showPositionedCard(
      context: context,
      cardToShow: const DisableLanguageToolsPopup(
        overlayId: 'disable_language_tools_popup',
      ),
      maxHeight: 325,
      maxWidth: 325,
      transformTargetId: ChoreoConstants.inputTransformTargetKey,
      overlayKey: 'disable_language_tools_popup',
    );
  }

  Future<void> _showAnalyticsFeedback(
    List<OneConstructUse> constructs,
    String eventId,
    String language,
  ) async {
    final analyticsService = Matrix.of(context).analyticsDataService;
    final newGrammarConstructs = await analyticsService.getNewConstructCount(
      constructs,
      ConstructTypeEnum.morph,
      language,
    );

    final newVocabConstructs = await analyticsService.getNewConstructCount(
      constructs,
      ConstructTypeEnum.vocab,
      language,
    );

    OverlayUtil.showOverlay(
      overlayKey: "msg_analytics_feedback_$eventId",
      followerAnchor: Alignment.bottomRight,
      targetAnchor: Alignment.topRight,
      context: context,
      child: MessageAnalyticsFeedback(
        newGrammarConstructs: newGrammarConstructs,
        newVocabConstructs: newVocabConstructs,
        close: () => MatrixState.pAnyState.closeOverlay(
          "msg_analytics_feedback_$eventId",
        ),
      ),
      transformTargetId: eventId,
      ignorePointer: true,
      closePrevOverlay: false,
    );
  }

  Future<void> showTokenFeedbackDialog(
    TokenInfoFeedbackRequestData requestData,
    String langCode,
    PangeaMessageEvent event,
  ) async {
    clearSelectedEvents();
    await TokenFeedbackUtil.showTokenFeedbackDialog(
      context,
      requestData: requestData,
      langCode: langCode,
      event: event,
    );
  }

  void toggleShowDropdown() {
    inputFocus.unfocus();
    activityController.toggleShowDropdown();

    if (!InstructionsEnum.showedActivityMenu.isToggledOff) {
      InstructionsEnum.showedActivityMenu.setToggledOff(true);
    }
  }

  Future<void> onLeave() async {
    final confirmed = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).areYouSure,
      message: L10n.of(context).leaveRoomDescription,
      okLabel: L10n.of(context).leave,
      cancelLabel: L10n.of(context).cancel,
      isDestructive: true,
    );
    if (confirmed != OkCancelResult.ok) return;
    final result = await showFutureLoadingDialog(
      context: context,
      future: widget.room.leave,
    );

    if (result.isError) return;
    final r = Matrix.of(context).client.getRoomById(widget.room.id);
    if (r != null && r.membership != Membership.leave) {
      await Matrix.of(
        context,
      ).client.waitForRoomInSync(widget.room.id, leave: true);
    }

    NavigationUtil.goToSpaceRoute(null, [], context);
  }

  Future<void> requestRegeneration(String eventId) async {
    final reason = await showTextInputDialog(
      context: context,
      title: L10n.of(context).requestRegeneration,
      hintText: L10n.of(context).optionalRegenerateReason,
      autoSubmit: true,
      maxLines: 5,
    );

    if (reason == null) return;

    clearSelectedEvents();
    await showFutureLoadingDialog(
      context: context,
      future: () => room.sendEvent({
        "m.relates_to": {
          "rel_type": PangeaEventTypes.regenerationRequest,
          "event_id": eventId,
        },
        PangeaEventTypes.regenerationRequest: {"reason": reason},
      }, type: PangeaEventTypes.regenerationRequest),
    );
  }
  // Pangea#

  late final ValueNotifier<bool> _displayChatDetailsColumn;

  void toggleDisplayChatDetailsColumn() async {
    await AppSettings.displayChatDetailsColumn.setItem(
      !_displayChatDetailsColumn.value,
    );
    _displayChatDetailsColumn.value = !_displayChatDetailsColumn.value;
  }

  @override
  Widget build(BuildContext context) {
    // #Pangea
    return LoadParticipantsBuilder(
      room: room,
      builder: (context, participants) {
        if (!room.participantListComplete && participants.loading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        // Pangea#
        final theme = Theme.of(context);
        return Row(
          children: [
            Expanded(child: ChatView(this)),
            ValueListenableBuilder(
              valueListenable: _displayChatDetailsColumn,
              builder: (context, displayChatDetailsColumn, _) =>
                  !FluffyThemes.isThreeColumnMode(context) ||
                      room.membership != Membership.join ||
                      !displayChatDetailsColumn
                  ? const SizedBox(height: double.infinity, width: 0)
                  : Container(
                      width: FluffyThemes.columnWidth,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 1, color: theme.dividerColor),
                        ),
                      ),
                      child: ChatDetails(
                        roomId: roomId,
                        embeddedCloseButton: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: toggleDisplayChatDetailsColumn,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

enum AddPopupMenuActions {
  image,
  video,
  file,
  poll,
  photoCamera,
  videoCamera,
  location,
}
