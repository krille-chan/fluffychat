// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat_view.dart';
import 'package:fluffychat/pages/chat/event_info_dialog.dart';
import 'package:fluffychat/pages/chat/recording_dialog.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/gain_points_animation.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/chat/utils/unlocked_morphs_snackbar.dart';
import 'package:fluffychat/pangea/chat/widgets/event_too_large_dialog.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/enums/edit_type.dart';
import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/message_analytics_feedback.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/pangea_text_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dialog.dart';
import 'package:fluffychat/pangea/spaces/pages/pangea_space_page.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
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
import '../../utils/account_bundles.dart';
import '../../utils/localized_exception_extension.dart';
import 'send_file_dialog.dart';
import 'send_location_dialog.dart';

class ChatPage extends StatelessWidget {
  final String roomId;
  final List<ShareItem>? shareItems;
  final String? eventId;

  const ChatPage({
    super.key,
    required this.roomId,
    this.eventId,
    this.shareItems,
  });

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(roomId);
    // #Pangea
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

    // #Pangea
    if (room.isSpace) {
      return PangeaSpacePage(space: room);
    }
    // Pangea#

    return ChatPageWithRoom(
      key: Key('chat_page_${roomId}_$eventId'),
      room: room,
      shareItems: shareItems,
      eventId: eventId,
    );
  }
}

class ChatPageWithRoom extends StatefulWidget {
  final Room room;
  final List<ShareItem>? shareItems;
  final String? eventId;

  const ChatPageWithRoom({
    super.key,
    required this.room,
    this.shareItems,
    this.eventId,
  });

  @override
  ChatController createState() => ChatController();
}

class ChatController extends State<ChatPageWithRoom>
    with WidgetsBindingObserver {
  // #Pangea
  final PangeaController pangeaController = MatrixState.pangeaController;
  late Choreographer choreographer = Choreographer(pangeaController, this);
  late GoRouter _router;

  StreamSubscription? _levelSubscription;
  StreamSubscription? _analyticsSubscription;
  // Pangea#
  Room get room => sendingClient.getRoomById(roomId) ?? widget.room;

  late Client sendingClient;

  Timeline? timeline;

  late final String readMarkerEventId;

  String get roomId => widget.room.id;

  final AutoScrollController scrollController = AutoScrollController();

  late final FocusNode inputFocus;
  StreamSubscription<html.Event>? onFocusSub;

  Timer? typingCoolDown;
  Timer? typingTimeout;
  bool currentlyTyping = false;
  // #Pangea
  // bool dragging = false;

  // void onDragEntered(_) => setState(() => dragging = true);

  // void onDragExited(_) => setState(() => dragging = false);

  // void onDragDone(DropDoneDetails details) async {
  //   setState(() => dragging = false);
  //   if (details.files.isEmpty) return;

  //   await showAdaptiveDialog(
  //     context: context,
  //     builder: (c) => SendFileDialog(
  //       files: details.files,
  //       room: room,
  //       outerContext: context,
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
    context.go('/rooms');
  }

  EmojiPickerType emojiPickerType = EmojiPickerType.keyboard;

  // #Pangea
  // void requestHistory([_]) async {
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
    final mostRecentEventId = timeline.events.first.eventId;
    await timeline.requestFuture(historyCount: _loadHistoryCount);
    setReadMarker(eventId: mostRecentEventId);
  }

  void _updateScrollController() {
    if (!mounted) {
      return;
    }
    if (!scrollController.hasClients) return;
    if (timeline?.allowNewEvent == false ||
        scrollController.position.pixels > 0 && _scrolledUp == false) {
      setState(() => _scrolledUp = true);
    } else if (scrollController.position.pixels <= 0 && _scrolledUp == true) {
      setState(() => _scrolledUp = false);
      setReadMarker();
    }

    if (scrollController.position.pixels == 0 ||
        scrollController.position.pixels == 64) {
      requestFuture();
    }
  }

  void _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = prefs.getString('draft_$roomId');
    if (draft != null && draft.isNotEmpty) {
      // #Pangea
      // sendController.text = draft;
      sendController.setSystemText(draft, EditType.other);
      // Pangea#
    }
  }

  void _shareItems([_]) {
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
            style: TextStyle(
              color: theme.colorScheme.onErrorContainer,
            ),
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
      ),
    );
  }

  KeyEventResult _shiftEnterKeyHandling(FocusNode node, KeyEvent evt) {
    if (!HardwareKeyboard.instance.isShiftPressed &&
        evt.logicalKey.keyLabel == 'Enter') {
      if (evt is KeyDownEvent) {
        // #Pangea
        // send();
        choreographer.send(context);
        // Pangea#
      }
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  @override
  void initState() {
    inputFocus = FocusNode(
      onKeyEvent: (AppConfig.sendOnEnter ?? !PlatformInfos.isMobile)
          ? _shiftEnterKeyHandling
          : null,
    );

    scrollController.addListener(_updateScrollController);
    inputFocus.addListener(_inputFocusListener);

    _loadDraft();
    WidgetsBinding.instance.addPostFrameCallback(_shareItems);
    super.initState();
    _displayChatDetailsColumn = ValueNotifier(
      AppSettings.displayChatDetailsColumn.getItem(Matrix.of(context).store),
    );

    sendingClient = Matrix.of(context).client;
    readMarkerEventId = room.hasNewMessages ? room.fullyRead : '';
    WidgetsBinding.instance.addObserver(this);
    // #Pangea
    if (!mounted) return;
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      debugPrint(
        "chat.dart l1 ${pangeaController.languageController.userL1?.langCode}",
      );
      debugPrint(
        "chat.dart l2 ${pangeaController.languageController.userL2?.langCode}",
      );
      if (mounted) {
        pangeaController.languageController.showDialogOnEmptyLanguage(
          context,
          () => Future.delayed(
            Duration.zero,
            () => setState(() {}),
          ),
        );
      }
    });

    _levelSubscription = pangeaController.getAnalytics.stateStream
        .where(
      (update) =>
          update is Map<String, dynamic> &&
          (update['level_up'] != null || update['unlocked_constructs'] != null),
    )
        // .listen(
        //   (update) => Future.delayed(
        //     const Duration(milliseconds: 500),
        //     () => LevelUpUtil.showLevelUpDialog(
        //       update['level_up'],
        //       context,
        //     ),
        //   ),
        // )
        .listen(
      // remove delay now that GetAnalyticsController._onLevelUp
      // is async is should take roughly 500ms to make requests anyway
      (update) {
        if (update['level_up'] != null) {
          LevelUpUtil.showLevelUpDialog(
            update['upper_level'],
            update['lower_level'],
            context,
          );
        } else if (update['unlocked_constructs'] != null) {
          ConstructNotificationUtil.addUnlockedConstruct(
            List.from(update['unlocked_constructs']),
            context,
          );
        }
      },
    );

    _analyticsSubscription =
        pangeaController.getAnalytics.analyticsStream.stream.listen((update) {
      if (update.targetID == null) return;
      OverlayUtil.showOverlay(
        overlayKey: "${update.targetID ?? ""}_points",
        followerAnchor: Alignment.bottomCenter,
        targetAnchor: Alignment.bottomCenter,
        context: context,
        child: PointsGainedAnimation(
          points: update.points,
          targetID: update.targetID!,
        ),
        transformTargetId: update.targetID ?? "",
        closePrevOverlay: false,
        backDropToDismiss: false,
        ignorePointer: true,
      );
    });
    // Pangea#
    _tryLoadTimeline();
    if (kIsWeb) {
      onFocusSub = html.window.onFocus.listen((_) => setReadMarker());
    }
  }

  void _tryLoadTimeline() async {
    final initialEventId = widget.eventId;
    loadTimelineFuture = _getTimeline();
    try {
      await loadTimelineFuture;
      if (initialEventId != null) scrollToEventId(initialEventId);

      var readMarkerEventIndex = readMarkerEventId.isEmpty
          ? -1
          : timeline!.events
              .filterByVisibleInGui(exceptionEventId: readMarkerEventId)
              .indexWhere((e) => e.eventId == readMarkerEventId);

      // Read marker is existing but not found in first events. Try a single
      // requestHistory call before opening timeline on event context:
      if (readMarkerEventId.isNotEmpty && readMarkerEventIndex == -1) {
        await timeline?.requestHistory(historyCount: _loadHistoryCount);
        readMarkerEventIndex = timeline!.events
            .filterByVisibleInGui(exceptionEventId: readMarkerEventId)
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
    setState(() {});
  }

  Future<void>? loadTimelineFuture;

  int? animateInEventIndex;

  void onInsert(int i) {
    // setState will be called by updateView() anyway
    // #Pangea
    // If fake event was sent, don't animate in the next event.
    // It makes the replacement of the fake event jumpy.
    if (_fakeEventID != null) {
      animateInEventIndex = null;
      return;
    }
    // Pangea#
    animateInEventIndex = i;
  }

  // #Pangea
  List<Event> get visibleEvents =>
      timeline?.events
          .where(
            (x) => x.isVisibleInGui,
          )
          .toList() ??
      <Event>[];
  // Pangea#

  Future<void> _getTimeline({
    String? eventContextId,
  }) async {
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
    if (_setReadMarkerFuture != null) return;
    if (_scrolledUp) return;
    if (scrollUpBannerEventId != null) return;

    if (eventId == null &&
        !room.hasNewMessages &&
        room.notificationCount == 0) {
      return;
    }

    // Do not send read markers when app is not in foreground
    // #Pangea
    try {
      // Pangea#
      if (kIsWeb && !Matrix.of(context).webHasFocus) return;
      // #Pangea
    } catch (err) {
      return;
    }
    // Pangea#
    if (!kIsWeb &&
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }

    final timeline = this.timeline;
    if (timeline == null || timeline.events.isEmpty) return;

    Logs().d('Set read marker...', eventId);
    // ignore: unawaited_futures
    _setReadMarkerFuture = timeline
        .setReadMarker(
      eventId: eventId,
      public: AppConfig.sendPublicReadReceipts,
    )
        .then((_) {
      _setReadMarkerFuture = null;
    })
        // #Pangea
        .catchError((e, s) {
      ErrorHandler.logError(
        e: PangeaWarningError("Failed to set read marker: $e"),
        s: s,
        data: {
          'eventId': eventId,
          'roomId': roomId,
        },
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
    inputFocus.removeListener(_inputFocusListener);
    onFocusSub?.cancel();
    //#Pangea
    choreographer.stateStream.close();
    choreographer.dispose();
    MatrixState.pAnyState.closeAllOverlays(force: true);
    showToolbarStream.close();
    stopMediaStream.close();
    hideTextController.dispose();
    _levelSubscription?.cancel();
    _analyticsSubscription?.cancel();
    _router.routeInformationProvider.removeListener(_onRouteChanged);
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
      context.go("/rooms");
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

  /// used to obscure text in text field after sending fake message without
  /// changing the actual text in the sendController
  final TextEditingController hideTextController = TextEditingController();
  // #Pangea

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

  // #Pangea
  Event? pangeaEditingEvent;
  void clearEditingEvent() {
    pangeaEditingEvent = null;
  }

  String? _fakeEventID;
  bool get obscureText => _fakeEventID != null;

  /// Add a fake event to the timeline to visually indicate that a message is being sent.
  /// Used when tokenizing after message send, specifically because tokenization for some
  /// languages takes some time.
  void sendFakeMessage() {
    final eventID = room.sendFakeMessage(
      text: sendController.text,
      inReplyTo: replyEvent,
      editEventId: editEvent?.eventId,
    );
    setState(() => _fakeEventID = eventID);
  }

  void clearFakeEvent() {
    if (_fakeEventID == null) return;
    timeline?.events.removeWhere((e) => e.eventId == _fakeEventID);
    setState(() {
      _fakeEventID = null;
    });
  }

  // Future<void> send() async {
  // Original send function gets the tx id within the matrix lib,
  // but for choero, the tx id is generated before the message send.
  // Also, adding PangeaMessageData
  Future<void> send({
    PangeaRepresentation? originalSent,
    PangeaRepresentation? originalWritten,
    PangeaMessageTokens? tokensSent,
    PangeaMessageTokens? tokensWritten,
    ChoreoRecord? choreo,
  }) async {
    // Pangea#
    if (sendController.text.trim().isEmpty) return;
    _storeInputTimeoutTimer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('draft_$roomId');
    var parseCommands = true;

    final commandMatch = RegExp(r'^\/(\w+)').firstMatch(sendController.text);
    if (commandMatch != null &&
        !sendingClient.commands.keys.contains(commandMatch[1]!.toLowerCase())) {
      final l10n = L10n.of(context);
      final dialogResult = await showOkCancelAlertDialog(
        context: context,
        title: l10n.commandInvalid,
        message: l10n.commandMissing(commandMatch[0]!),
        okLabel: l10n.sendAsText,
        cancelLabel: l10n.cancel,
      );
      if (dialogResult == OkCancelResult.cancel) return;
      parseCommands = false;
    }

    // ignore: unawaited_futures
    // #Pangea
    // room.sendTextEvent(
    //   sendController.text,
    //   inReplyTo: replyEvent,
    //   editEventId: editEvent?.eventId,
    //   parseCommands: parseCommands,
    // );
    final previousEdit = editEvent;

    // wait for the next event to come through before clearing any fake event,
    // to make the replacement look smooth
    room.client.onTimelineEvent.stream.first.then((_) => clearFakeEvent());

    room
        .pangeaSendTextEvent(
      sendController.text,
      inReplyTo: replyEvent,
      editEventId: editEvent?.eventId,
      parseCommands: parseCommands,
      originalSent: originalSent,
      originalWritten: originalWritten,
      tokensSent: tokensSent,
      tokensWritten: tokensWritten,
      choreo: choreo,
    )
        .then(
      (String? msgEventId) async {
        // #Pangea
        // There's a listen in my_analytics_controller that decides when to auto-update
        // analytics based on when / how many messages the logged in user send. This
        // stream sends the data for newly sent messages.
        final metadata = ConstructUseMetaData(
          roomId: roomId,
          timeStamp: DateTime.now(),
          eventId: msgEventId,
        );

        if (msgEventId != null && originalSent != null && tokensSent != null) {
          final List<OneConstructUse> constructs = [
            ...originalSent.vocabAndMorphUses(
              choreo: choreo,
              tokens: tokensSent.tokens,
              metadata: metadata,
            ),
          ];

          final newGrammarConstructs =
              pangeaController.getAnalytics.newConstructCount(
            constructs,
            ConstructTypeEnum.morph,
          );

          final newVocabConstructs =
              pangeaController.getAnalytics.newConstructCount(
            constructs,
            ConstructTypeEnum.vocab,
          );

          OverlayUtil.showOverlay(
            overlayKey: "msg_analytics_feedback_$msgEventId",
            followerAnchor: Alignment.bottomRight,
            targetAnchor: Alignment.topRight,
            context: context,
            child: MessageAnalyticsFeedback(
              overlayId: "msg_analytics_feedback_$msgEventId",
              newGrammarConstructs: newGrammarConstructs,
              newVocabConstructs: newVocabConstructs,
            ),
            transformTargetId: msgEventId,
            ignorePointer: true,
          );

          pangeaController.putAnalytics.setState(
            AnalyticsStream(
              eventId: msgEventId,
              targetID: msgEventId,
              roomId: room.id,
              constructs: constructs,
            ),
          );
        }

        if (previousEdit != null) {
          pangeaEditingEvent = previousEdit;
        }

        final spaceCode = room.classCode(context);
        if (spaceCode != null) {
          GoogleAnalytics.sendMessage(
            room.id,
            spaceCode,
          );
        }

        if (msgEventId == null) {
          ErrorHandler.logError(
            e: Exception('msgEventId is null'),
            s: StackTrace.current,
            data: {
              'roomId': roomId,
              'text': sendController.text,
              'inReplyTo': replyEvent?.eventId,
              'editEventId': editEvent?.eventId,
            },
          );
          return;
        }
      },
    ).catchError((err, s) {
      clearFakeEvent();
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
          'text': sendController.text,
          'inReplyTo': replyEvent?.eventId,
          'editEventId': editEvent?.eventId,
        },
      );
    });
    // Pangea#
    sendController.value = TextEditingValue(
      text: pendingText,
      selection: const TextSelection.collapsed(offset: 0),
    );

    setState(() {
      // #Pangea
      // sendController.text = pendingText;
      sendController.setSystemText(pendingText, EditType.other);
      // Pangea#
      _inputTextIsEmpty = pendingText.isEmpty;
      replyEvent = null;
      editEvent = null;
      pendingText = '';
    });
  }

  void sendFileAction({FileSelectorType type = FileSelectorType.any}) async {
    final files = await selectFiles(
      context,
      allowMultiple: true,
      type: type,
    );
    if (files.isEmpty) return;
    await showAdaptiveDialog(
      context: context,
      builder: (c) => SendFileDialog(
        files: files,
        room: room,
        outerContext: context,
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
      ),
    );
  }

  void voiceMessageAction() async {
    // #Pangea
    stopMediaStream.add(null);
    // Pangea#
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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

    // #Pangea
    // if (await AudioRecorder().hasPermission() == false) return;
    // Pangea#
    final result = await showDialog<RecordingResult>(
      context: context,
      barrierDismissible: false,
      builder: (c) => const RecordingDialog(),
    );
    if (result == null) return;
    final audioFile = XFile(result.path);
    final file = MatrixAudioFile(
      bytes: await audioFile.readAsBytes(),
      name: result.fileName ?? audioFile.path,
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
      // #Pangea
      // ).catchError((e) {
    ).catchError((e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'roomId': roomId,
          'file': file.name,
          'duration': result.duration,
          'waveform': result.waveform,
        },
      );
      // Pangea#
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            (e as Object).toLocalizedString(context),
          ),
        ),
      );
      return null;
    });
    // #Pangea
    // setState(() {
    //   replyEvent = null;
    // });
    if (mounted) setState(() => replyEvent = null);
    // Pangea#
  }

  void hideEmojiPicker() {
    // #Pangea
    clearSelectedEvents();
    // Pangea#
    setState(() => showEmojiPicker = false);
  }

  // #Pangea
  void hideOverlayEmojiPicker() {
    MatrixState.pAnyState.closeOverlay();
    setState(() => showEmojiPicker = false);
  }
  // Pangea

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
      copyString += event.getDisplayEvent(timeline!).calcLocalizedBodyFallback(
            MatrixLocals(L10n.of(context)),
            withSenderNamePrefix: true,
          );
    }
    return copyString;
  }

  void copyEventsAction() {
    Clipboard.setData(ClipboardData(text: _getSelectedEventString()));
    setState(() {
      showEmojiPicker = false;
      // #Pangea
      // selectedEvents.clear();
      clearSelectedEvents();
      // Pangea#
    });
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
        AdaptiveModalAction(
          value: -50,
          label: L10n.of(context).offensive,
        ),
        AdaptiveModalAction(
          value: 0,
          label: L10n.of(context).inoffensive,
        ),
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
    setState(() {
      showEmojiPicker = false;
      selectedEvents.clear();
    });
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
    for (final event in selectedEvents) {
      await showFutureLoadingDialog(
        context: context,
        future: () async {
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
              await Event.fromJson(event.toJson(), room).redactEvent(
                reason: reason,
              );
            }
          } else {
            await event.cancelSend();
          }
        },
      );
    }
    // #Pangea
    clearSelectedEvents();
    // Pangea#
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
        !selectedEvents.single.status.isSent) {
      return false;
    }
    return true;
  }

  bool get canEditSelectedEvents {
    if (isArchived ||
        selectedEvents.length != 1 ||
        // #Pangea
        selectedEvents.single.messageType != MessageTypes.Text ||
        // Pangea#
        !selectedEvents.first.status.isSent) {
      return false;
    }
    return currentRoomBundle
        .any((cl) => selectedEvents.first.senderId == cl!.userID);
  }

  void forwardEventsAction() async {
    if (selectedEvents.isEmpty) return;
    await showScaffoldDialog(
      context: context,
      builder: (context) => ShareScaffoldDialog(
        items: selectedEvents
            .map((event) => ContentShareItem(event.content))
            .toList(),
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
    setState(() => selectedEvents.clear());
  }

  void replyAction({Event? replyTo}) {
    setState(() {
      replyEvent = replyTo ?? selectedEvents.first;
      selectedEvents.clear();
    });
    // #Pangea
    clearSelectedEvents();
    // Pangea
    inputFocus.requestFocus();
  }

  void scrollToEventId(
    String eventId, {
    bool highlightEvent = true,
  }) async {
    final foundEvent =
        timeline!.events.firstWhereOrNull((event) => event.eventId == eventId);

    final eventIndex = foundEvent == null
        ? -1
        : timeline!.events
            .filterByVisibleInGui(exceptionEventId: eventId)
            .indexOf(foundEvent);

    if (eventIndex == -1) {
      setState(() {
        timeline = null;
        _scrolledUp = false;
        loadTimelineFuture = _getTimeline(eventContextId: eventId).onError(
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
          ErrorReporter(context, 'Unable to load timeline after scroll down')
              .onErrorCallback,
        );
      });
      await loadTimelineFuture;
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
    if (_allReactionEvents.any(
      (e) => e.content.tryGetMap('m.relates_to')?['key'] == emoji.emoji,
    )) {
      return;
    }
    // #Pangea
    // return sendEmojiAction(emoji.emoji);
    sendEmojiAction(emoji.emoji);

    // don't need to clear these when sending while in select mode,
    // but do need to clear these when reacting from the large emoji picker
    setState(() => selectedEvents.clear());
    // Pangea#
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
    // #Pangea
    closeSelectionOverlay();
    // Pangea#
    _allReactionEvents = allReactionEvents;
    emojiPickerType = EmojiPickerType.reaction;
    setState(() => showEmojiPicker = true);
  }

  void sendEmojiAction(String? emoji) async {
    final events = List<Event>.from(selectedEvents);
    // #Pangea
    // keep this event selected in case the user wants to send another emoji
    // setState(() => selectedEvents.clear());
    // Pangea#
    for (final event in events) {
      await room.sendReaction(
        event.eventId,
        emoji!,
      );
    }
  }

  // #Pangea
  /// Close the combined selection view overlay and clear the message
  /// text and selection stored for the text in that overlay
  void closeSelectionOverlay() {
    MatrixState.pAnyState.closeAllOverlays();
    // selectedTokenIndicies.clear();
  }
  // Pangea#

  // #Pangea
  // void clearSelectedEvents() => setState(() {
  //       selectedEvents.clear();
  //       showEmojiPicker = false;
  //     });
  void clearSelectedEvents() {
    if (!mounted) return;
    setState(() {
      closeSelectionOverlay();
      selectedEvents.clear();
      showEmojiPicker = false;
    });
  }
  // Pangea#

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
      sendController.text =
          editEvent!.getDisplayEvent(timeline!).calcLocalizedBodyFallback(
                MatrixLocals(L10n.of(context)),
                withSenderNamePrefix: false,
                hideReply: true,
              );
      selectedEvents.clear();
    });
    inputFocus.requestFocus();
  }

  void goToNewRoomAction() async {
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => room.client.joinRoomById(
        room
            .getState(EventTypes.RoomTombstone)!
            .parsedTombstoneContent
            .replacementRoom,
      ),
    );
    if (result.error != null) return;
    if (!mounted) return;
    context.go('/rooms/${result.result!}');

    await showFutureLoadingDialog(
      context: context,
      future: room.leave,
    );
  }

  void onSelectMessage(Event event) {
    // #Pangea
    if (choreographer.itController.willOpen) {
      return;
    }
    // Pangea#
    if (!event.redacted) {
      // #Pangea
      // if (selectedEvents.contains(event)) {
      //   setState(
      //     () => selectedEvents.remove(event),
      //   );
      // }

      // If delete first selected event with the selected eventID
      final matches = selectedEvents.where((e) => e.eventId == event.eventId);
      if (matches.isNotEmpty) {
        setState(() => selectedEvents.remove(matches.first));
      }
      // Pangea#
      else {
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

  // #Pangea
  void onInputBarSubmitted(String _, BuildContext context) {
    // void onInputBarSubmitted(_) {
    //   send();
    choreographer.send(context);
    // Pangea#
    FocusScope.of(context).requestFocus(inputFocus);
  }

  //#Pangea
  void onAddPopupMenuButtonSelected(String? choice) {
    // void onAddPopupMenuButtonSelected(String choice) {
    debugger(when: kDebugMode && choice == null);

    //Pangea#
    if (choice == 'file') {
      sendFileAction();
    }
    if (choice == 'image') {
      sendFileAction(type: FileSelectorType.images);
    }
    if (choice == 'video') {
      sendFileAction(type: FileSelectorType.videos);
    }
    if (choice == 'camera') {
      openCameraAction();
    }
    if (choice == 'camera-video') {
      openVideoCameraAction();
    }
    if (choice == 'location') {
      sendLocationAction();
    }
  }

  unpinEvent(String eventId) async {
    final response = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).unpin,
      message: L10n.of(context).confirmEventUnpin,
      okLabel: L10n.of(context).unpin,
      cancelLabel: L10n.of(context).cancel,
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
  Duration storeInputTimeout = const Duration(milliseconds: 500);

  void onInputBarChanged(String text) {
    if (_inputTextIsEmpty != text.isEmpty) {
      setState(() {
        _inputTextIsEmpty = text.isEmpty;
      });
    }

    _storeInputTimeoutTimer?.cancel();
    _storeInputTimeoutTimer = Timer(storeInputTimeout, () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('draft_$roomId', text);
    });
    if (text.endsWith(' ') && Matrix.of(context).hasComplexBundles) {
      final clients = currentRoomBundle;
      for (final client in clients) {
        final prefix = client!.sendPrefix;
        if ((prefix.isNotEmpty) &&
            text.toLowerCase() == '${prefix.toLowerCase()} ') {
          setSendingClient(client);
          setState(() {
            sendController.clear();
          });
          return;
        }
      }
    }
    if (AppConfig.sendTypingNotifications) {
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

  bool _inputTextIsEmpty = true;

  bool get isArchived =>
      {Membership.leave, Membership.ban}.contains(room.membership);

  void showEventInfo([Event? event]) {
    (event ?? selectedEvents.single).showInfoDialog(context);
    // #Pangea
    clearSelectedEvents();
    // Pangea#
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toLocalizedString(context))),
      );
    }
  }

  void cancelReplyEventAction() => setState(() {
        if (editEvent != null) {
          // #Pangea
          // sendController.text = pendingText;
          sendController.setSystemText(pendingText, EditType.other);
          // Pangea#
          pendingText = '';
        }
        replyEvent = null;
        editEvent = null;
      });

  // #Pangea
  String? get buttonEventID => timeline!.events
      .firstWhereOrNull(
        (event) =>
            event.isVisibleInGui &&
            event.senderId != room.client.userID &&
            !event.redacted,
      )
      ?.eventId;

  final StreamController<String> showToolbarStream =
      StreamController.broadcast();

  final StreamController<void> stopMediaStream = StreamController.broadcast();

  void showToolbar(
    Event event, {
    PangeaMessageEvent? pangeaMessageEvent,
    PangeaToken? selectedToken,
    MessageMode? mode,
    Event? nextEvent,
    Event? prevEvent,
  }) {
    if (event.redacted || event.status == EventStatus.sending) return;

    // Close keyboard, if open
    if (inputFocus.hasFocus && PlatformInfos.isMobile) {
      inputFocus.unfocus();
      return;
    }
    // Close emoji picker, if open
    showEmojiPicker = false;

    // Check if the user has set their languages. If not, prompt them to do so.
    if (!MatrixState.pangeaController.languageController.languagesSet) {
      pLanguageDialog(context, () {});
      return;
    }

    Widget? overlayEntry;
    try {
      overlayEntry = MessageSelectionOverlay(
        chatController: this,
        event: event,
        timeline: timeline!,
        initialSelectedToken: selectedToken,
        nextEvent: nextEvent,
        prevEvent: prevEvent,
      );
    } catch (err) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: StackTrace.current,
        data: {
          'roomId': roomId,
          'event': event.toJson(),
          'selectedToken': selectedToken?.toJson(),
          'nextEvent': nextEvent?.toJson(),
          'prevEvent': prevEvent?.toJson(),
        },
      );
      return;
    }

    // you've clicked a message so lets turn this off
    InstructionsEnum.clickMessage.setToggledOff(true);

    showToolbarStream.add(event.eventId);
    if (!kIsWeb) {
      HapticFeedback.mediumImpact();
    }

    stopMediaStream.add(null);

    Future.delayed(
        Duration(milliseconds: buttonEventID == event.eventId ? 200 : 0), () {
      if (_router.state.path != ':roomid') {
        // The user has navigated away from the chat,
        // so we don't want to show the overlay.
        return;
      }

      OverlayUtil.showOverlay(
        context: context,
        child: overlayEntry!,
        transformTargetId: "",
        position: OverlayPositionEnum.centered,
        onDismiss: clearSelectedEvents,
        blurBackground: true,
      );

      // select the message
      onSelectMessage(event);
    });
  }

  double inputBarHeight = 64;
  void updateInputBarHeight(double height) {
    if (mounted && height != inputBarHeight) {
      setState(() => inputBarHeight = height);
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
  // Pangea#

  late final ValueNotifier<bool> _displayChatDetailsColumn;

  void toggleDisplayChatDetailsColumn() async {
    await AppSettings.displayChatDetailsColumn.setItem(
      Matrix.of(context).store,
      !_displayChatDetailsColumn.value,
    );
    _displayChatDetailsColumn.value = !_displayChatDetailsColumn.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: ChatView(this),
        ),
        AnimatedSize(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          child: ValueListenableBuilder(
            valueListenable: _displayChatDetailsColumn,
            builder: (context, displayChatDetailsColumn, _) {
              if (!FluffyThemes.isThreeColumnMode(context) ||
                  room.membership != Membership.join ||
                  !displayChatDetailsColumn) {
                return const SizedBox(
                  height: double.infinity,
                  width: 0,
                );
              }
              return Container(
                width: FluffyThemes.columnWidth,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: theme.dividerColor,
                    ),
                  ),
                ),
                child: ChatDetails(
                  roomId: roomId,
                  embeddedCloseButton: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: toggleDisplayChatDetailsColumn,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

enum EmojiPickerType { reaction, keyboard }
