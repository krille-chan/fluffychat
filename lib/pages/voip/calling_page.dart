/*
 *   Famedly
 *   Copyright (C) 2019, 2020, 2021 Famedly GmbH
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/app_state.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import '../../utils/voip/call_session_state.dart';
import '../../utils/voip/call_state_proxy.dart';
import '../../utils/voip/group_call_session_state.dart';
import '../../utils/voip/livekit_group_call_session_state.dart';
import 'group_call_view/group_call_view.dart';
import 'p2p_call_view/p2p_view.dart';
import 'widgets/call_buttons.dart';
import 'widgets/call_timer.dart';
import 'widgets/more_options_listtile.dart';

enum ChangeAudioMode { input, output }

class Calling extends StatefulWidget {
  final VoipPlugin voipPlugin;
  final CallStateProxy proxy;

  /// when a call is not connected we don't have the remote user, so pass this
  /// to show the remote user
  final User? remoteUserInCall;
  const Calling({
    super.key,
    required this.voipPlugin,
    required this.proxy,
    this.remoteUserInCall,
  });

  @override
  MyCallingPage createState() => MyCallingPage();
}

class MyCallingPage extends State<Calling> {
  CallStateProxy get proxy => widget.proxy;
  Room get room => proxy.room;

  String get displayName => proxy.displayName ?? '';

  MediaStream? get localStream {
    if (proxy.localUserMediaStream != null) {
      return proxy.localUserMediaStream!.stream!;
    }
    return null;
  }

  bool get isMicrophoneMuted => proxy.isMicrophoneMuted;
  bool get isLocalVideoMuted => proxy.isLocalVideoMuted;
  bool get isScreensharingEnabled => proxy.isScreensharingEnabled;
  bool get isRemoteOnHold => proxy.remoteOnHold;
  bool get isLocalOnHold => proxy.localHold;
  bool get voiceonly => proxy.voiceonly;
  bool get answering => proxy.answering;
  bool get connecting => proxy.connecting;
  bool get connected => proxy.connected;
  bool get ended => proxy.ended;
  bool get callOnHold => proxy.callOnHold;
  bool get isGroupCall =>
      (proxy is GroupCallSessionState || proxy is LiveKitGroupCallSessionState);
  bool get showMicMuteButton => connected;
  bool get showScreenSharingButton => connected;
  bool get showHoldButton => connected && !isGroupCall;
  bool get showEstablishingConnection => connecting;
  WrappedMediaStream get screenSharing => screenSharingStreams.elementAt(0);
  WrappedMediaStream? get primaryStream => proxy.primaryStream;

  // TODO(td): remove this when ios gets callkeepv3
  bool get showAnswerButton =>
      (!connected && !connecting && !ended) &&
      !proxy.isOutgoing &&
      !isGroupCall &&
      (kIsWeb || !Platform.isAndroid);

  bool get showVideoMuteButton => connected;
  bool get showFlipCameraButton =>
      !kIsWeb &&
      PlatformInfos.isMobile &&
      proxy.localUserMediaStream?.videoMuted == false;

  List<WrappedMediaStream> get screenSharingStreams =>
      (proxy.screenSharingStreams);

  List<WrappedMediaStream> get userMediaStreams {
    if (isGroupCall) {
      return (proxy.userMediaStreams);
    }
    final streams = <WrappedMediaStream>[
      ...proxy.screenSharingStreams,
      ...proxy.userMediaStreams,
    ];
    streams.removeWhere((s) => s.stream?.id == proxy.primaryStream?.stream?.id);
    return streams;
  }

  String get title {
    if (isGroupCall) {
      return 'Group call';
    }
    return '${voiceonly ? L10n.of(context)!.audioCall : L10n.of(context)!.videoCall} (${proxy.callState})';
  }

  String get heldTitle {
    var heldTitle = '';
    if (proxy.localHold) {
      heldTitle = '${proxy.displayName ?? ''} ${L10n.of(context)!.heldTheCall}';
    } else if (proxy.remoteOnHold) {
      heldTitle = '${L10n.of(context)!.you} ${L10n.of(context)!.heldTheCall}';
    }
    return heldTitle;
  }

  VoipPlugin get voipPlugin => widget.voipPlugin;

  @override
  void initState() {
    super.initState();
    // Do not rely on this initState to be called only once, user can close this
    // page and reopen from call banner anytime.
    ServicesBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppState>(context, listen: false)
          .removeGlobalBanner(); // ideally was a call banner
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    proxy.onUpdateViewCallback(_handleCallState);
  }

  StreamSubscription? proximitySubscription;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  void _handleCallState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> handleAnswerButtonClick() async {
    try {
      await proxy.answer();
    } catch (e) {
      Logs().e('answer failed?', e);
    }
  }

  Future<void> handleHangupButtonClick() async {
    try {
      await proxy.hangup();
    } catch (e) {
      Logs().e('hangup failed?', e);
    }
  }

  Future<void> handleMicMuteButtonClick() async {
    await proxy.setMicrophoneMuted(!isMicrophoneMuted);
  }

  Future<void> handleScreenSharingButtonClick() async {
    if (!kIsWeb && Platform.isAndroid) {
      if (!proxy.isScreensharingEnabled) {
        FlutterForegroundTask.init(
          androidNotificationOptions: AndroidNotificationOptions(
            channelId: 'notification_channel_id',
            channelName: 'Foreground Notification',
            channelDescription:
                'This notification appears when the foreground service is running.',
          ),
          iosNotificationOptions: const IOSNotificationOptions(),
          foregroundTaskOptions: const ForegroundTaskOptions(),
        );
        await FlutterForegroundTask.startService(
          notificationTitle: 'Screen sharing',
          notificationText: 'You are sharing your screen in famedly',
        );
      } else {
        await FlutterForegroundTask.stopService();
      }
    }

    await proxy.setScreensharingEnabled(!isScreensharingEnabled);
  }

  Future<void> handleHoldButtonClick() async {
    await proxy.setRemoteOnHold(!isRemoteOnHold);
  }

  Future<void> handleVideoMuteButtonClick() async {
    await proxy.setLocalVideoMuted(!isLocalVideoMuted);
  }

  Future<void> handleFlipCameraButtonClick() async {
    if (proxy.localUserMediaStream != null) {
      await Helper.switchCamera(
        proxy.localUserMediaStream!.stream!.getVideoTracks()[0],
      );
    }
    setState(() {});
  }

  bool speakerPhoneTurnedOn = false;
  void handleturnOnSpeakerPhoneClicked() async {
    if (proxy.localUserMediaStream != null) {
      await Helper.setSpeakerphoneOn(!speakerPhoneTurnedOn);
      setState(() {
        speakerPhoneTurnedOn = !speakerPhoneTurnedOn;
      });
    }
  }

  void changeAudioStuff(ChangeAudioMode mode) async {
    if (proxy.localUserMediaStream != null) {
      final devices = mode == ChangeAudioMode.input
          ? await Helper.enumerateDevices('audioinput')
          : await Helper.audiooutputs;
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: devices
                  .map(
                    (device) => ListTile(
                      title: Text(
                        device.label,
                        style: Theme.of(context).textTheme.bodyLarge!,
                      ),
                      onTap: () async {
                        Logs().d('setting audio $mode to ${device.label}');
                        if (mode == ChangeAudioMode.input) {
                          await Helper.selectAudioInput(device.deviceId);
                        } else {
                          await Helper.selectAudioOutput(device.deviceId);
                        }

                        GoRouter.of(context).pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
    }
    setState(() {});
  }

  void handleMoreButtonClicked() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showScreenSharingButton &&
                  !FluffyThemes.isColumnMode(context))
                MoreOptionsListTile(
                  icon: Icons.screen_share,
                  title: isScreensharingEnabled
                      ? L10n.of(context)!.stopScreenShare
                      : L10n.of(context)!.startScreenShare,
                  onPressed: handleScreenSharingButtonClick,
                  shouldPopOnPress: true,
                ),
              if (proxy is CallSessionState)
                MoreOptionsListTile(
                  icon: Icons.pause,
                  title: isRemoteOnHold
                      ? L10n.of(context)!.unholdCall
                      : L10n.of(context)!.holdCall,
                  onPressed: handleHoldButtonClick,
                  shouldPopOnPress: true,
                ),
              if (showFlipCameraButton &&
                  MediaQuery.of(context).size.width < 400)
                MoreOptionsListTile(
                  icon: Icons.flip_camera_android,
                  title: L10n.of(context)!.flipCamera,
                  onPressed: handleFlipCameraButtonClick,
                ),
              if (!kIsWeb)
                MoreOptionsListTile(
                  icon: Icons.speaker,
                  title: L10n.of(context)!.audioOutput,
                  onPressed: () async =>
                      changeAudioStuff(ChangeAudioMode.output),
                ),
              if (!kIsWeb)
                MoreOptionsListTile(
                  icon: Icons.mic,
                  title: L10n.of(context)!.audioInput,
                  onPressed: () async =>
                      changeAudioStuff(ChangeAudioMode.input),
                ),
            ],
          ),
        );
      },
    );
  }

  bool miniHangupButtonLoading = false;

  /// PIP buttons
  /// New buttons will also need to go to more list manually for now if no space available.
  List<Widget> _buildActionButtons() {
    return [
      if (connected &&
          voiceonly &&
          !kIsWeb &&
          PlatformInfos.isMobile &&
          !FluffyThemes.isColumnMode(context))
        CallButton(
          onPressed: handleturnOnSpeakerPhoneClicked,
          selected: speakerPhoneTurnedOn,
          selectedIcon: Icons.speaker,
          unSelectedIcon: Icons.speaker,
          extendedView: expandedMainView,
        ),
      if (showMicMuteButton)
        CallButton(
          onPressed: handleMicMuteButtonClick,
          selected: isMicrophoneMuted,
          selectedIcon: Icons.mic_off,
          unSelectedIcon: Icons.mic,
          extendedView: expandedMainView,
        ),
      if (showFlipCameraButton && MediaQuery.of(context).size.width > 400)
        CallButton(
          onPressed: handleFlipCameraButtonClick,
          selected: false,
          selectedIcon: Icons.flip_camera_android,
          unSelectedIcon: Icons.flip_camera_android,
          extendedView: expandedMainView,
        ),
      if (showVideoMuteButton)
        CallButton(
          onPressed: handleVideoMuteButtonClick,
          selected: isLocalVideoMuted,
          selectedIcon: Icons.videocam_off,
          unSelectedIcon: Icons.videocam,
          extendedView: expandedMainView,
        ),
      if (showScreenSharingButton && FluffyThemes.isColumnMode(context))
        CallButton(
          onPressed: handleScreenSharingButtonClick,
          selected: isScreensharingEnabled,
          selectedIcon: Icons.stop_screen_share,
          unSelectedIcon: Icons.screen_share,
          extendedView: expandedMainView,
        ),
      if (connected &&
          (!FluffyThemes.isColumnMode(context) ||
              !isGroupCall)) // show for p2p calls because hold, audio change buttons
        CallButton(
          onPressed: handleMoreButtonClicked,
          selected: false,
          selectedIcon: Icons.more_vert,
          unSelectedIcon: Icons.more_vert,
          extendedView: expandedMainView,
          doLoadingAnimation: false,
        ),
      if (expandedMainView)
        InkWell(
          onTap: () async {
            if (miniHangupButtonLoading) return;
            setState(() {
              miniHangupButtonLoading = true;
            });
            await handleHangupButtonClick();
            if (mounted) {
              setState(() {
                miniHangupButtonLoading = false;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              color: Colors.red,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: miniHangupButtonLoading
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : isGroupCall
                      ? Center(
                          child: Text(
                            L10n.of(context)!.leave,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                        ),
            ),
          ),
        ),
    ];
  }

  bool get expandedMainView =>
      FluffyThemes.isColumnMode(context) ||
      isGroupCall ||
      primaryStream != null && !voiceonly && connected;
  bool membersEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: !FluffyThemes.isColumnMode(context)
          ? AppBar(
              automaticallyImplyLeading: false,
              title: expandedMainView
                  ? CallerId(
                      proxy: proxy,
                      voipPlugin: voipPlugin,
                    )
                  : Container(),
              toolbarHeight: 70,
              backgroundColor: Colors.black.withOpacity(0.9),
              actions: [
                CallActionButtons(
                  proxy: proxy,
                  voipPlugin: voipPlugin,
                  toggleMembers: () {
                    setState(() {
                      membersEnabled = !membersEnabled;
                    });
                  },
                ),
                const SizedBox(width: 12),
              ],
            )
          : const PreferredSize(
              preferredSize: Size.fromHeight(24.0),
              child: SizedBox(height: 24.0),
            ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarColor: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isGroupCall)
              Expanded(
                child: Center(
                  child: GroupCallView(
                    call: proxy,
                    client: voipPlugin.client,
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: P2PCallView(
                    call: proxy as CallSessionState,
                    remoteUserInCall: widget.remoteUserInCall,
                    voipPlugin: voipPlugin,
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: expandedMainView ? 12.0 : 40,
                ),
                if (connected)
                  SizedBox(
                    height: 56.0,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (FluffyThemes.isColumnMode(context))
                              Flexible(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CallerId(
                                    proxy: proxy,
                                    voipPlugin: voipPlugin,
                                  ),
                                ),
                              ),
                            Flexible(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.center,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      _buildActionButtons().toList()[index],
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 12),
                                  itemCount: _buildActionButtons().length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                            if (FluffyThemes.isColumnMode(context))
                              Flexible(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: CallActionButtons(
                                    proxy: proxy,
                                    voipPlugin: voipPlugin,
                                    toggleMembers: () {
                                      setState(() {
                                        membersEnabled = !membersEnabled;
                                      });
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: expandedMainView ? 0 : 16.0,
                ),
                if (!expandedMainView || (!connected && !isGroupCall))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CallBigButton(
                        onPressed: handleHangupButtonClick,
                        iconData: Icons.call_end,
                        proxy: proxy,
                        text: proxy.isOutgoing || proxy.connected
                            ? L10n.of(context)!.hangup
                            : L10n.of(context)!.reject,
                        backgroundColor: Colors.red,
                      ),
                      const SizedBox(width: 12),
                      if (showAnswerButton)
                        CallBigButton(
                          onPressed: handleAnswerButtonClick,
                          iconData: Icons.call,
                          proxy: proxy,
                          text: L10n.of(context)!.accept,
                          backgroundColor: Colors.green,
                        ),
                    ],
                  ),
                SizedBox(
                  height: expandedMainView
                      ? 12.0
                      : connected
                          ? MediaQuery.of(context).size.height * 0.05
                          : MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CallBigButton extends StatefulWidget {
  final Function onPressed;
  final CallStateProxy proxy;
  final Color backgroundColor;
  final IconData iconData;
  final String text;
  const CallBigButton({
    super.key,
    required this.onPressed,
    required this.proxy,
    required this.backgroundColor,
    required this.iconData,
    required this.text,
  });

  @override
  State<CallBigButton> createState() => _CallBigButtonState();
}

class _CallBigButtonState extends State<CallBigButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (loading) return;
        setState(() {
          loading = true;
        });
        await widget.onPressed();
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0 + 4,
          ),
          child: loading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.iconData, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      widget.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CallerId extends StatelessWidget {
  final CallStateProxy proxy;
  final VoipPlugin voipPlugin;
  const CallerId({super.key, required this.proxy, required this.voipPlugin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: FluffyThemes.isColumnMode(context) ? 0 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            proxy.room.getLocalizedDisplayname(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
          CallTimer(
            voipPlugin: voipPlugin,
            appBar: true,
            proxy: proxy,
          ),
        ],
      ),
    );
  }
}

class CallActionButtons extends StatelessWidget {
  final CallStateProxy proxy;
  final VoipPlugin voipPlugin;
  final Function toggleMembers;
  const CallActionButtons({
    super.key,
    required this.proxy,
    required this.voipPlugin,
    required this.toggleMembers,
  });

  @override
  Widget build(BuildContext context) {
    final toRoomPath = '/rooms/${proxy.room.id}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            GoRouter.of(context).go(toRoomPath);
            voipPlugin.createMinimizer(proxy);
          },
          icon: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
        if ((proxy.screenSharingStreams.isNotEmpty &&
                proxy is GroupCallSessionState) ||
            proxy.userMediaStreams.length > 4)
          IconButton(
            onPressed: () => toggleMembers(),
            icon: const Icon(
              Icons.people,
              color: Colors.white,
            ),
          ),
        IconButton(
          onPressed: () {
            GoRouter.of(context).go(
              Provider.of<AppState>(context, listen: false)
                      .bannerClickedOnPath ??
                  toRoomPath,
            );
            voipPlugin.createMinimizer(proxy);
          },
          icon: const Icon(
            Icons.minimize,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
