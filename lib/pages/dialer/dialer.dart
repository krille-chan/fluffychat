import 'dart:async';
import 'dart:math';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/voip/video_renderer.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' hide VideoRenderer;
import 'package:matrix/matrix.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'pip/pip_view.dart';

// ─────────────────────────────────────────────
// Stream View Widget
// ─────────────────────────────────────────────
class _StreamView extends StatelessWidget {
  const _StreamView(this.wrappedStream, {this.mainView = false, required this.matrixClient});

  final WrappedMediaStream wrappedStream;
  final Client matrixClient;
  final bool mainView;

  Uri? get avatarUrl => wrappedStream.getUser().avatarUrl;
  String? get displayName => wrappedStream.displayName;
  String get avatarName => wrappedStream.avatarName;
  bool get mirrored => wrappedStream.isLocal() && wrappedStream.purpose == SDPStreamMetadataPurpose.Usermedia;
  bool get audioMuted => wrappedStream.audioMuted;
  bool get videoMuted => wrappedStream.videoMuted;
  bool get isScreenSharing => wrappedStream.purpose == SDPStreamMetadataPurpose.Screenshare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoRenderer(wrappedStream, mirror: mirrored, fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain),
          if (videoMuted) ...[
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [colorScheme.surfaceContainerHigh, colorScheme.surface], radius: 1.2),
              ),
            ),
            Avatar(mxContent: avatarUrl, name: displayName, size: mainView ? 96 : 48, client: matrixClient),
          ],
          if (!isScreenSharing)
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      audioMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      color: audioMuted ? colorScheme.error : colorScheme.onSurface,
                      size: 14,
                    ),
                    if (displayName != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        displayName!,
                        style: TextStyle(color: colorScheme.onSurface, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Calling Widget
// ─────────────────────────────────────────────
class Calling extends StatefulWidget {
  final VoidCallback? onClear;
  final BuildContext context;
  final String callId;
  final CallSession call;
  final Client client;

  const Calling({required this.context, required this.call, required this.client, required this.callId, this.onClear, super.key});

  @override
  MyCallingPage createState() => MyCallingPage();
}

class MyCallingPage extends State<Calling> with TickerProviderStateMixin {
  bool _isOnHold = false;

  DateTime? _callStart;
  DateTime? _holdStart;
  Duration _totalPaused = Duration.zero;

  Timer? _uiTimer;
  CallState? _state;

  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  bool _showControls = true;
  Timer? _hideControlsTimer;

  Room? get room => call.room;
  CallSession get call => widget.call;

  String get displayName => call.room.getLocalizedDisplayname(MatrixLocals(L10n.of(widget.context)));

  bool get connected => call.state == CallState.kConnected;
  bool get voiceonly => call.type == CallType.kVoice;

  @override
  void initState() {
    super.initState();

    initialize();

    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300), value: 1);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeAnimation = _fadeController;

    _startHideControlsTimer();
  }

  void _handleCallState(CallState state) {
    if (state == CallState.kConnected) {
      _startCallIfNeeded();
    }

    if (state == CallState.kEnded) {
      cleanUp();
    }

    setState(() => _state = state);
  }

  // ─────────────────────────────
  // CALL START
  // ─────────────────────────────
  void _startCallIfNeeded() {
    _callStart ??= DateTime.now();

    _uiTimer?.cancel();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Duration get _callDuration {
    if (_callStart == null) return Duration.zero;

    final now = DateTime.now();

    final isOnHold = call.localHold || call.remoteOnHold;

    if (isOnHold && _holdStart == null) {
      _holdStart = now;
    }

    if (!isOnHold && _holdStart != null) {
      _totalPaused += now.difference(_holdStart!);
      _holdStart = null;
    }

    final paused = _totalPaused + (_holdStart != null ? now.difference(_holdStart!) : Duration.zero);

    return now.difference(_callStart!) - paused;
  }

  String get _formattedDuration {
    final d = _callDuration;

    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  // ─────────────────────────────
  // HOLD LOGIC (FIXED)
  // ─────────────────────────────
  void _toggleHold() {
    setState(() {
      _isOnHold = !_isOnHold;
      call.setRemoteOnHold(_isOnHold);
    });
  }

  // ─────────────────────────────
  // CLEANUP
  // ─────────────────────────────
  void cleanUp() {
    _uiTimer?.cancel();
    _hideControlsTimer?.cancel();

    _callStart = null;
    _holdStart = null;
    _totalPaused = Duration.zero;

    Timer(const Duration(seconds: 2), () {
      widget.onClear?.call();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _uiTimer?.cancel();
    _hideControlsTimer?.cancel();
    call.cleanUp.call();

    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();

    if (connected) {
      _hideControlsTimer = Timer(const Duration(seconds: 4), () {
        if (!mounted) return;
        _fadeController.reverse();
        setState(() => _showControls = false);
      });
    }
  }

  void _onTapScreen() {
    if (!connected) return;

    if (!_showControls) {
      _fadeController.forward();
      setState(() => _showControls = true);
    }

    _startHideControlsTimer();
  }

  String get callId => widget.callId;

  MediaStream? get localStream => call.localUserMediaStream?.stream;
  MediaStream? get remoteStream => call.getRemoteStreams.isNotEmpty ? call.getRemoteStreams.first.stream : null;

  bool get isMicrophoneMuted => call.isMicrophoneMuted;
  bool get isLocalVideoMuted => call.isLocalVideoMuted;
  bool get isScreensharingEnabled => call.screensharingEnabled;
  bool get isRemoteOnHold => call.remoteOnHold;
  bool get connecting => call.state == CallState.kConnecting;

  double? _localVideoHeight;
  double? _localVideoWidth;
  // EdgeInsetsGeometry? _localVideoMargin;

  void initialize() {
    call.onCallStateChanged.stream.listen(_handleCallState);
    call.onCallEventChanged.stream.listen((event) {
      if (event == CallStateChange.kFeedsChanged) {
        setState(call.tryRemoveStopedStreams);
      } else if (event == CallStateChange.kLocalHoldUnhold || event == CallStateChange.kRemoteHoldUnhold) {
        setState(() {});
      }
    });
    _state = call.state;

    if (call.type == CallType.kVideo) {
      unawaited(WakelockPlus.enable());
    }
  }

  void _resizeLocalVideo(Orientation orientation) {
    final shortSide = min(MediaQuery.sizeOf(widget.context).width, MediaQuery.sizeOf(widget.context).height);
    // _localVideoMargin = remoteStream != null ? const EdgeInsets.only(top: 20, right: 20) : EdgeInsets.zero;
    _localVideoWidth = remoteStream != null ? shortSide / 3 : MediaQuery.sizeOf(widget.context).width;
    _localVideoHeight = remoteStream != null ? shortSide / 4 : MediaQuery.sizeOf(widget.context).height;
  }

  void _answerCall() => setState(() => call.answer());

  void _hangUp() {
    setState(() {
      if (call.isRinging) {
        call.reject();
      } else {
        call.hangup(reason: CallErrorCode.userHangup);
      }
    });
  }

  void _muteMic() => setState(() => call.setMicrophoneMuted(!call.isMicrophoneMuted));
  void _muteCamera() => setState(() => call.setLocalVideoMuted(!call.isLocalVideoMuted));

  // void _screenSharing() {
  //   if (PlatformInfos.isAndroid) {
  //     if (!call.screensharingEnabled) {
  //       FlutterForegroundTask.init(
  //         androidNotificationOptions: AndroidNotificationOptions(
  //           channelId: 'notification_channel_id',
  //           channelName: 'Foreground Notification',
  //           channelDescription: L10n.of(widget.context).foregroundServiceRunning,
  //         ),
  //         iosNotificationOptions: const IOSNotificationOptions(),
  //         foregroundTaskOptions: ForegroundTaskOptions(eventAction: ForegroundTaskEventAction.nothing()),
  //       );
  //       FlutterForegroundTask.startService(
  //         notificationTitle: L10n.of(widget.context).screenSharingTitle,
  //         notificationText: L10n.of(widget.context).screenSharingDetail,
  //       );
  //     } else {
  //       FlutterForegroundTask.stopService();
  //     }
  //   }
  //   setState(() => call.setScreensharingEnabled(!call.screensharingEnabled));
  // }

  Future<void> _switchCamera() async {
    if (call.localUserMediaStream != null) {
      await Helper.switchCamera(call.localUserMediaStream!.stream!.getVideoTracks().first);
    }
    setState(() {});
  }

  // ─────────────────────────────────────────────
  // UI Builders
  // ─────────────────────────────────────────────

  Widget _buildBackground(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surface, colorScheme.surfaceContainerLow, colorScheme.surfaceContainerHigh],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [colorScheme.primary.withValues(alpha: 0.15), Colors.transparent]),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [colorScheme.secondary.withValues(alpha: 0.1), Colors.transparent]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallerInfo(ColorScheme colorScheme) {
    final isRinging = _state == CallState.kRinging || _state == CallState.kInviteSent || _state == CallState.kFledgling;

    String statusText;
    if (_state == CallState.kEnded) {
      statusText = 'Call ended';
    } else if (connected) {
      statusText = _formattedDuration;
    } else if (_state == CallState.kConnecting || _state == CallState.kCreateAnswer) {
      statusText = 'Connecting...';
    } else if (call.isOutgoing) {
      statusText = 'Calling...';
    } else {
      statusText = voiceonly ? 'Voice call' : 'Video call';
    }

    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (_, child) => Transform.scale(scale: isRinging ? _pulseAnimation.value : 1.0, child: child),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
              boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5)],
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: Avatar(mxContent: room?.avatar, name: displayName, size: 94, client: widget.client),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          displayName,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            statusText,
            key: ValueKey(statusText),
            style: TextStyle(
              color: connected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),
        ),
        if (call.localHold || call.remoteOnHold) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Text(
              'On Hold',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    bool isActive = false,
    bool isDanger = false,
    bool isAnswer = false,
    double size = 56,
    String? label,
  }) {
    final Color bgColor;
    final Color iconColor;

    if (isDanger) {
      bgColor = colorScheme.error;
      iconColor = colorScheme.onError;
    } else if (isAnswer) {
      bgColor = colorScheme.primary;
      iconColor = colorScheme.onPrimary;
    } else if (isActive) {
      bgColor = colorScheme.onSurface;
      iconColor = colorScheme.surface;
    } else {
      bgColor = colorScheme.surfaceContainerHigh;
      iconColor = colorScheme.onSurface;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: (isDanger || isAnswer)
                  ? [BoxShadow(color: bgColor.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2)]
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: size * 0.42),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w400),
          ),
        ],
      ],
    );
  }

  Widget _buildIncomingCallActions(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            icon: Icons.call_end_rounded,
            onPressed: _hangUp,
            colorScheme: colorScheme,
            isDanger: true,
            size: 68,
            label: 'Decline',
          ),
          _buildControlButton(
            icon: Icons.call_rounded,
            onPressed: _answerCall,
            colorScheme: colorScheme,
            isAnswer: true,
            size: 68,
            label: 'Accept',
          ),
        ],
      ),
    );
  }

  Widget _buildOutgoingCallActions(ColorScheme colorScheme) {
    return _buildControlButton(
      icon: Icons.call_end_rounded,
      onPressed: _hangUp,
      colorScheme: colorScheme,
      isDanger: true,
      size: 68,
      label: 'Cancel',
    );
  }

  Widget _buildConnectedControls(ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!voiceonly)
                _buildControlButton(
                  icon: isLocalVideoMuted ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                  onPressed: _muteCamera,
                  colorScheme: colorScheme,
                  isActive: isLocalVideoMuted,
                  label: 'Camera',
                ),
              _buildControlButton(
                icon: isMicrophoneMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                onPressed: _muteMic,
                colorScheme: colorScheme,
                isActive: isMicrophoneMuted,
                label: 'Mute',
              ),
              _buildControlButton(
                icon: isRemoteOnHold ? Icons.play_arrow_rounded : Icons.pause_rounded,
                onPressed: _toggleHold,
                colorScheme: colorScheme,
                isActive: isRemoteOnHold,
                label: isRemoteOnHold ? 'Resume' : 'Hold',
              ),
              if (!voiceonly && !kIsWeb)
                _buildControlButton(
                  icon: Icons.flip_camera_ios_rounded,
                  onPressed: _switchCamera,
                  colorScheme: colorScheme,
                  label: 'Flip',
                ),
              // if (PlatformInfos.isMobile || PlatformInfos.isWeb)
              //   _buildControlButton(
              //     icon: Icons.screen_share_rounded,
              //     onPressed: _screenSharing,
              //     colorScheme: colorScheme,
              //     isActive: isScreensharingEnabled,
              //     label: 'Share',
              //   ),
            ],
          ),
          const SizedBox(height: 28),
          _buildControlButton(
            icon: Icons.call_end_rounded,
            onPressed: _hangUp,
            colorScheme: colorScheme,
            isDanger: true,
            size: 64,
            label: 'End call',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ColorScheme colorScheme) {
    switch (_state) {
      case CallState.kRinging:
      case CallState.kFledgling:
        if (!call.isOutgoing) return _buildIncomingCallActions(colorScheme);
        return Center(child: _buildOutgoingCallActions(colorScheme));

      case CallState.kInviteSent:
      case CallState.kCreateAnswer:
      case CallState.kConnecting:
        return Center(child: _buildOutgoingCallActions(colorScheme));

      case CallState.kConnected:
        return _buildConnectedControls(colorScheme);

      case CallState.kEnded:
        return Center(
          child: _buildControlButton(
            icon: Icons.call_end_rounded,
            onPressed: _hangUp,
            colorScheme: colorScheme,
            isDanger: true,
            size: 64,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PIPView(
      builder: (context, isFloating) {
        return GestureDetector(
          onTap: _onTapScreen,
          child: Scaffold(
            backgroundColor: colorScheme.surface,
            body: OrientationBuilder(
              builder: (context, orientation) {
                // ── PIP mode ──
                if (isFloating) {
                  final primaryStream = call.remoteUserMediaStream ?? call.localUserMediaStream;
                  return Stack(
                    children: [
                      if (primaryStream != null)
                        _StreamView(primaryStream, mainView: true, matrixClient: widget.client)
                      else
                        ColoredBox(
                          color: colorScheme.surfaceContainerHigh,
                          child: Center(
                            child: Avatar(mxContent: room?.avatar, name: displayName, size: 48, client: widget.client),
                          ),
                        ),
                      if (connected)
                        Positioned(
                          top: 6,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorScheme.surface.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _formattedDuration,
                                style: TextStyle(color: colorScheme.primary, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }

                // ── Full screen ──
                final stackWidgets = <Widget>[];

                // Background
                if (voiceonly || call.getRemoteStreams.isEmpty) {
                  stackWidgets.add(Positioned.fill(child: _buildBackground(colorScheme)));
                }

                // Video / hold
                if (!call.callHasEnded) {
                  final primaryStream =
                      call.remoteScreenSharingStream ??
                      call.localScreenSharingStream ??
                      call.remoteUserMediaStream ??
                      call.localUserMediaStream;

                  final displayStream = connected ? primaryStream : call.localUserMediaStream;

                  if (displayStream != null && !voiceonly) {
                    stackWidgets.add(
                      Positioned.fill(child: _StreamView(displayStream, mainView: true, matrixClient: widget.client)),
                    );
                  }

                  // Local video thumbnail
                  if (connected && !voiceonly && call.getRemoteStreams.isNotEmpty) {
                    _resizeLocalVideo(orientation);
                    final localStream = call.localUserMediaStream ?? call.localScreenSharingStream;
                    if (localStream != null) {
                      stackWidgets.add(
                        Positioned(
                          right: 16,
                          top: MediaQuery.paddingOf(context).top + 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: _localVideoWidth,
                              height: _localVideoHeight,
                              child: _StreamView(localStream, matrixClient: widget.client),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }

                // Top bar
                stackWidgets.add(
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 8, left: 16, right: 16, bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [colorScheme.surface.withValues(alpha: 0.7), Colors.transparent],
                        ),
                      ),
                      child: Row(
                        children: [
                          _CallingIconButton(
                            icon: Icons.keyboard_arrow_down_rounded,
                            onTap: () => PIPView.of(context)?.setFloating(true),
                            colorScheme: colorScheme,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  voiceonly ? Icons.call_rounded : Icons.videocam_rounded,
                                  color: colorScheme.onSurface,
                                  size: 14,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  voiceonly ? 'Voice' : 'Video',
                                  style: TextStyle(color: colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                // Caller info (voice or pre-connect)
                if (voiceonly || !connected) {
                  stackWidgets.add(
                    Positioned.fill(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [_buildCallerInfo(colorScheme)]),
                    ),
                  );
                }

                // Bottom actions
                stackWidgets.add(
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 32, top: 24, left: 24, right: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [colorScheme.surface.withValues(alpha: 0.85), Colors.transparent],
                        ),
                      ),
                      child: _buildBottomActions(colorScheme),
                    ),
                  ),
                );

                return Stack(children: stackWidgets);
              },
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Helper widget
// ─────────────────────────────────────────────
class _CallingIconButton extends StatelessWidget {
  const _CallingIconButton({required this.icon, required this.onTap, required this.colorScheme});

  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.8), shape: BoxShape.circle),
        child: Icon(icon, color: colorScheme.onSurface, size: 22),
      ),
    );
  }
}
