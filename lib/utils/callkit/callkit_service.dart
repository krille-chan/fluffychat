import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart' as callkit;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/avatar.dart';
import 'call_state_persistence.dart';
import 'call_store.dart';

const _uuid = Uuid();

/// Singleton managing CallKit integration
class CallKitService {
  static CallKitService? _instance;
  static CallKitService get instance {
    _instance ??= CallKitService._();
    return _instance!;
  }

  CallKitService._();

  bool _initialized = false;
  final Map<String, String> _callUuidToRoomId = {}; // callUuid -> roomId
  final Map<String, String> _roomIdToCallUuid = {}; // roomId -> callUuid

  StreamSubscription? _callEventSubscription;

  // Callback for when call is accepted
  Future<void> Function(String roomId, String callUuid)? onCallAccepted;

  /// Initialize CallKit service
  Future<void> initialize() async {
    if (_initialized) return;

    Logs().i('[CallKitService] Initializing CallKit service');

    // Restore persisted calls
    await _restorePersistedCalls();

    // Setup event handlers
    await _setupCallKitHandlers();

    _initialized = true;
    Logs().i('[CallKitService] CallKit service initialized');
  }

  /// Show incoming call UI
  Future<void> showIncomingCall({
    required Room room,
    String? callerName,
    Uri? callerAvatar,
  }) async {
    if (!_initialized) {
      Logs().w('[CallKitService] Not initialized, skipping showIncomingCall');
      return;
    }

    // Check if already showing call for this room
    if (_roomIdToCallUuid.containsKey(room.id)) {
      Logs().w(
        '[CallKitService] Already showing call for roomId=${room.id}',
      );
      return;
    }

    final callUuid = _uuid.v4();
    Logs().i(
      '[CallKitService] showIncomingCall: roomId=${room.id}, callUuid=$callUuid',
    );

    // Track mapping
    _callUuidToRoomId[callUuid] = room.id;
    _roomIdToCallUuid[room.id] = callUuid;

    // Get caller details
    final displayName = callerName ?? room.getLocalizedDisplayname();
    final avatarPath = await _generateAvatarImage(
      room: room,
      name: displayName,
      mxContent: callerAvatar ?? room.avatar,
    );

    // Configure CallKit parameters
    final params = callkit.CallKitParams(
      id: callUuid,
      nameCaller: displayName,
      appName: 'FluffyChat',
      avatar: avatarPath,
      handle: room.id,
      type: 1, // Video call
      textAccept: 'Accept',
      textDecline: 'Decline',
      duration: 30000, // 30 seconds timeout
      extra: {
        'roomId': room.id,
      },
      headers: <String, dynamic>{'platform': 'flutter'},
      android: const callkit.AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'assets/sounds/phone.ogg',
        backgroundColor: '#0175c9',
        backgroundUrl: '',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
      ),
      ios: const callkit.IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'videoChat',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'phone.ogg',
      ),
    );

    // Show call
    await FlutterCallkitIncoming.showCallkitIncoming(params);

    // Persist call state
    await CallStatePersistence.instance.saveCall(
      callUuid: callUuid,
      roomId: room.id,
      state: 'ringing',
    );

    Logs().d('[CallKitService] showIncomingCall: CallKit UI displayed');
  }

  /// Show outgoing call UI
  Future<void> showOutgoingCall({
    required Room room,
  }) async {
    if (!_initialized) {
      Logs().w('[CallKitService] Not initialized, skipping showOutgoingCall');
      return;
    }

    // Check if already showing call for this room
    if (_roomIdToCallUuid.containsKey(room.id)) {
      Logs().w(
        '[CallKitService] Already showing call for roomId=${room.id}',
      );
      return;
    }

    final callUuid = _uuid.v4();
    Logs().i(
      '[CallKitService] showOutgoingCall: roomId=${room.id}, callUuid=$callUuid',
    );

    // Track mapping
    _callUuidToRoomId[callUuid] = room.id;
    _roomIdToCallUuid[room.id] = callUuid;

    // Get room details
    final displayName = room.getLocalizedDisplayname();
    final avatarPath = await _generateAvatarImage(
      room: room,
      name: displayName,
      mxContent: room.avatar,
    );

    // Configure CallKit parameters
    final params = callkit.CallKitParams(
      id: callUuid,
      nameCaller: displayName,
      appName: 'FluffyChat',
      avatar: avatarPath,
      handle: room.id,
      type: 1, // Video call
      extra: {
        'roomId': room.id,
        'outgoing': true,
      },
      headers: <String, dynamic>{'platform': 'flutter'},
      android: const callkit.AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'assets/sounds/phone.ogg',
        backgroundColor: '#0175c9',
        backgroundUrl: '',
        actionColor: '#4CAF50',
      ),
      ios: const callkit.IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'videoChat',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'phone.ogg',
      ),
    );

    // Start outgoing call
    await FlutterCallkitIncoming.startCall(params);

    // Persist call state
    await CallStatePersistence.instance.saveCall(
      callUuid: callUuid,
      roomId: room.id,
      state: 'outgoing',
    );

    Logs().d('[CallKitService] showOutgoingCall: CallKit UI displayed');
  }

  /// End call by UUID
  Future<void> endCall(String callUuid) async {
    Logs().i('[CallKitService] endCall: callUuid=$callUuid');

    await FlutterCallkitIncoming.endCall(callUuid);

    // Clean up mappings
    final roomId = _callUuidToRoomId.remove(callUuid);
    if (roomId != null) {
      _roomIdToCallUuid.remove(roomId);
    }

    // Remove from persistence
    await CallStatePersistence.instance.removeCall(callUuid);

    Logs().d('[CallKitService] endCall: completed');
  }

  /// End call by room ID
  Future<void> endCallByRoomId(String roomId) async {
    final callUuid = _roomIdToCallUuid[roomId];
    if (callUuid == null) {
      Logs().w(
        '[CallKitService] endCallByRoomId: no active call for roomId=$roomId',
      );
      return;
    }

    await endCall(callUuid);
  }

  /// Update call state
  Future<void> updateCallState({
    required String callUuid,
    required String state,
  }) async {
    Logs().d(
      '[CallKitService] updateCallState: callUuid=$callUuid, state=$state',
    );

    final roomId = _callUuidToRoomId[callUuid];
    if (roomId == null) {
      Logs().w('[CallKitService] updateCallState: unknown callUuid');
      return;
    }

    // Update persistence
    await CallStatePersistence.instance.updateCallState(
      callUuid: callUuid,
      state: state,
    );
  }

  /// Get room ID for call UUID
  String? getRoomIdForCall(String callUuid) {
    return _callUuidToRoomId[callUuid];
  }

  /// Get call UUID for room ID
  String? getCallUuidForRoom(String roomId) {
    return _roomIdToCallUuid[roomId];
  }

  /// Setup CallKit event handlers
  Future<void> _setupCallKitHandlers() async {
    Logs().i('[CallKitService] Setting up CallKit event handlers');

    _callEventSubscription =
        FlutterCallkitIncoming.onEvent.listen((callkit.CallEvent? event) async {
      if (event == null) return;

      Logs().d(
        '[CallKitService] CallKit event: ${event.event}, body=${event.body}',
      );

      switch (event.event) {
        case callkit.Event.actionCallIncoming:
          // Incoming call displayed
          Logs().i('[CallKitService] Incoming call displayed');
          break;

        case callkit.Event.actionCallStart:
          // Outgoing call started
          Logs().i('[CallKitService] Outgoing call started');
          break;

        case callkit.Event.actionCallAccept:
          // Call accepted
          await _handleCallAccepted(event.body);
          break;

        case callkit.Event.actionCallDecline:
          // Call declined
          await _handleCallDeclined(event.body);
          break;

        case callkit.Event.actionCallEnded:
          // Call ended
          await _handleCallEnded(event.body);
          break;

        case callkit.Event.actionCallTimeout:
          // Call timeout
          await _handleCallTimeout(event.body);
          break;

        case callkit.Event.actionCallCallback:
          // Callback action (missed call)
          Logs().i('[CallKitService] Callback action');
          break;

        case callkit.Event.actionCallToggleHold:
          // Hold toggled
          Logs().i('[CallKitService] Hold toggled');
          break;

        case callkit.Event.actionCallToggleMute:
          // Mute toggled
          Logs().i('[CallKitService] Mute toggled');
          break;

        case callkit.Event.actionCallToggleDmtf:
          // DTMF toggled
          Logs().i('[CallKitService] DTMF toggled');
          break;

        case callkit.Event.actionCallToggleGroup:
          // Group toggled
          Logs().i('[CallKitService] Group toggled');
          break;

        case callkit.Event.actionCallToggleAudioSession:
          // Audio session toggled
          Logs().i('[CallKitService] Audio session toggled');
          break;

        case callkit.Event.actionDidUpdateDevicePushTokenVoip:
          // VoIP push token updated
          Logs().i('[CallKitService] VoIP push token updated');
          break;

        default:
          Logs().w('[CallKitService] Unknown event: ${event.event}');
      }
    });

    Logs().d('[CallKitService] CallKit event handlers registered');
  }

  Future<void> _handleCallAccepted(dynamic body) async {
    final callUuid = body['id'] as String?;
    if (callUuid == null) return;

    Logs().i('[CallKitService] Call accepted: callUuid=$callUuid');

    final roomId = _callUuidToRoomId[callUuid];
    if (roomId == null) {
      Logs().w('[CallKitService] Unknown call accepted: $callUuid');
      return;
    }

    // Update state
    await updateCallState(callUuid: callUuid, state: 'accepted');

    // Trigger callback to navigate to call screen
    if (onCallAccepted != null) {
      try {
        await onCallAccepted!(roomId, callUuid);
      } catch (e, s) {
        Logs().e('[CallKitService] Error in onCallAccepted callback', e, s);
      }
    } else {
      Logs().w('[CallKitService] No onCallAccepted callback registered');
    }
  }

  Future<void> _handleCallDeclined(dynamic body) async {
    final callUuid = body['id'] as String?;
    if (callUuid == null) return;

    Logs().i('[CallKitService] Call declined: callUuid=$callUuid');

    final roomId = _callUuidToRoomId[callUuid];
    if (roomId == null) {
      Logs().w('[CallKitService] Unknown call declined: $callUuid');
      return;
    }

    // Get GroupCall and hang up to send call.member leave event
    final call = CallStore.instance.getCall(roomId);
    if (call != null) {
      try {
        await call.hangup();
        Logs().i(
          '[CallKitService] Successfully hung up call for declined callUuid=$callUuid',
        );
      } catch (e, s) {
        Logs().e('[CallKitService] Failed to hang up declined call', e, s);
      }
    }

    // Clean up
    await endCall(callUuid);
  }

  Future<void> _handleCallEnded(dynamic body) async {
    final callUuid = body['id'] as String?;
    if (callUuid == null) return;

    Logs().i('[CallKitService] Call ended: callUuid=$callUuid');

    final roomId = _callUuidToRoomId[callUuid];
    if (roomId == null) {
      Logs().w('[CallKitService] Unknown call ended: $callUuid');
      return;
    }

    // Get GroupCall and hang up
    final call = CallStore.instance.getCall(roomId);
    if (call != null) {
      try {
        await call.hangup();
      } catch (e, s) {
        Logs().e(
          '[CallKitService] Error during hangup - continuing cleanup',
          e,
          s,
        );
      }
    }

    // Clean up
    await endCall(callUuid);
  }

  Future<void> _handleCallTimeout(dynamic body) async {
    final callUuid = body['id'] as String?;
    if (callUuid == null) return;

    Logs().i('[CallKitService] Call timeout: callUuid=$callUuid');

    // Clean up
    await endCall(callUuid);
  }

  /// Generate avatar image from Avatar widget
  Future<String?> _generateAvatarImage({
    required Room room,
    required String name,
    Uri? mxContent,
  }) async {
    try {
      const size = 200.0;

      // Create a RepaintBoundary with GlobalKey to capture the widget
      final key = GlobalKey();
      final avatar = RepaintBoundary(
        key: key,
        child: SizedBox(
          width: size,
          height: size,
          child: Avatar(
            mxContent: mxContent,
            name: name,
            size: size,
          ),
        ),
      );

      // Create offscreen widget tree for rendering
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      final pipelineOwner = PipelineOwner();
      final buildOwner = BuildOwner(focusManager: FocusManager());

      final renderView = RenderView(
        view: view,
        configuration: ViewConfiguration.fromView(view),
      );

      final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: renderView,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: avatar,
        ),
      ).attachToRenderTree(buildOwner);

      // Build and layout
      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();

      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();

      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      // Wait for next frame to ensure rendering is complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture image from RepaintBoundary
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        Logs().w('[CallKitService] Could not find RepaintBoundary');
        return null;
      }

      final image = await boundary.toImage(pixelRatio: 1.0);

      // Convert to PNG bytes
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        Logs().w('[CallKitService] Failed to convert image to bytes');
        return null;
      }

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final fileName = 'avatar_${_uuid.v4()}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      Logs().i('[CallKitService] Avatar saved to: ${file.path}');
      return file.path;
    } catch (e, s) {
      Logs().e('[CallKitService] Failed to generate avatar', e, s);
      return null;
    }
  }

  /// Restore persisted calls on app start
  Future<void> _restorePersistedCalls() async {
    Logs().i('[CallKitService] Restoring persisted calls');

    final calls = await CallStatePersistence.instance.getAllCalls();

    for (final call in calls) {
      final callUuid = call['callUuid'] as String;
      final roomId = call['roomId'] as String;
      final timestamp = call['timestamp'] as int;

      // Check if call is stale (>5 hours)
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (age > 5 * 60 * 60 * 1000) {
        Logs().d(
          '[CallKitService] Removing stale call: callUuid=$callUuid, age=${age}ms',
        );
        await CallStatePersistence.instance.removeCall(callUuid);
        await FlutterCallkitIncoming.endCall(callUuid);
        continue;
      }

      // Restore mapping
      _callUuidToRoomId[callUuid] = roomId;
      _roomIdToCallUuid[roomId] = callUuid;

      Logs().d(
        '[CallKitService] Restored call: callUuid=$callUuid, roomId=$roomId',
      );
    }

    Logs().i(
      '[CallKitService] Restored ${calls.length} persisted calls',
    );
  }

  /// Dispose service
  Future<void> dispose() async {
    Logs().i('[CallKitService] Disposing CallKit service');
    await _callEventSubscription?.cancel();
    _callEventSubscription = null;
    _callUuidToRoomId.clear();
    _roomIdToCallUuid.clear();
    _initialized = false;
  }
}
