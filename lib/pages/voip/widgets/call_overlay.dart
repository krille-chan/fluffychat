import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import 'package:fluffychat/utils/app_state.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import '../../../utils/voip/call_state_proxy.dart';
import '../../../utils/voip/group_call_session_state.dart';
import '../../../utils/voip/livekit_group_call_session_state.dart';
import '../../../widgets/avatar.dart';
import 'call_timer.dart';
import 'stream_view.dart';

class CallOverlay extends StatefulWidget {
  final CallStateProxy callStateProxy;
  final VoipPlugin voipPlugin;
  const CallOverlay({
    super.key,
    required this.callStateProxy,
    required this.voipPlugin,
  });

  @override
  State<CallOverlay> createState() => _CallOverlayState();
}

class _CallOverlayState extends State<CallOverlay> {
  List<WrappedMediaStream> screenSharingStreams = [];
  List<WrappedMediaStream> userMediaStreams = [];
  WrappedMediaStream? get primaryScreenShare => screenSharingStreams.first;

  late bool isGroupCall;

  BuildContext get globalContext => FluffyChatApp.appGlobalKey.currentContext!;
  void setupCall() {
    isGroupCall = widget.callStateProxy is GroupCallSessionState ||
        widget.callStateProxy is LiveKitGroupCallSessionState;

    p2pCallConnecting = !widget.callStateProxy.connected &&
        !widget.callStateProxy.ended &&
        !isGroupCall;

    userMediaStreams = List.from(widget.callStateProxy.userMediaStreams);

    screenSharingStreams =
        List.from(widget.callStateProxy.screenSharingStreams);

    widget.callStateProxy.onUpdateViewCallback(() {
      if (mounted) setState(() {});
    });
  }

  late bool p2pCallConnecting;
  bool hovering = false;
  late User? remoteUser;

  void toCallAndRemovePopup() {
    Provider.of<AppState>(globalContext, listen: false).bannerClickedOnPath =
        FluffyChatApp.router.routerDelegate.currentConfiguration.uri.toString();

    FluffyChatApp.router.go('/rooms/${widget.callStateProxy.room.id}/call');

    widget.voipPlugin.removeCallPopupOverlay();
  }

  Future<void> handleAnswerButtonClick() async {
    try {
      await widget.callStateProxy.answer();
    } catch (e) {
      Logs().e('answer failed?', e);
    }
    toCallAndRemovePopup();
  }

  Future<void> handleHangupButtonClick() async {
    try {
      await widget.callStateProxy.hangup();
    } catch (e) {
      Logs().e('hangup failed?', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// why call this per build and not initState? widget can close/open multiple
    /// times so initState is called multiple times, having it in the build to avoid confusion
    /// state is stored in a global variable
    setupCall();

    return SafeArea(
      child: p2pCallConnecting
          ? Align(
              heightFactor: 1.0,
              alignment: Alignment.center,
              child: SizedBox(
                height: 360,
                width: 360,
                child: Material(
                  color: Colors.black,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: remoteUser == null
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    if (widget.callStateProxy.type ==
                                        VoipType.kVoice)
                                      Icon(
                                        Icons.call,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 21,
                                      )
                                    else
                                      Icon(
                                        Icons.videocam,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 21,
                                      ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Text(
                                      widget.voipPlugin.getCallStateSuffix(
                                        widget.callStateProxy,
                                        context,
                                      ),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: toCallAndRemovePopup,
                                      icon: const Icon(
                                        Icons.maximize,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 32.0,
                              ),
                              Avatar(
                                mxContent: remoteUser!.avatarUrl,
                                name: remoteUser!.displayName.toString(),
                                size: 96,
                                fontSize: 16,
                                client: widget.callStateProxy.client,
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              Text(
                                remoteUser!.displayName.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                remoteUser!.id.domain.toString(),
                              ),
                              const SizedBox(
                                height: 24.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    onTap: handleHangupButtonClick,
                                    child: Container(
                                      height: 56,
                                      width: 64,
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        border: Border.all(),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.call_end,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  InkWell(
                                    onTap: handleAnswerButtonClick,
                                    child: Container(
                                      height: 56,
                                      width: 64,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        border: Border.all(),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Icon(
                                        widget.callStateProxy.type ==
                                                VoipType.kVoice
                                            ? Icons.call
                                            : Icons.videocam,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            )
          : Align(
              heightFactor: 1.0,
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 74.0,
                  right: 8.0,
                ),
                height: 300,
                width: 300,
                child: Material(
                  color: Colors.black,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: InkWell(
                      enableFeedback: false,
                      onTap: toCallAndRemovePopup,
                      onHover: (value) {
                        setState(() {
                          hovering = value;
                        });
                      },
                      child: screenSharingStreams.isEmpty &&
                              userMediaStreams.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : Stack(
                              children: [
                                StreamView(
                                  highLight: true,
                                  wrappedStream: screenSharingStreams.isNotEmpty
                                      ? screenSharingStreams.first
                                      : userMediaStreams.first,
                                  avatarSize: 80,
                                  avatarTextSize: 48,
                                  avatarBorderRadius: 16,
                                ),
                                if (hovering)
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 64,
                                      width: 300,
                                      margin: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        bottom: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.callStateProxy
                                                        .displayName ??
                                                    L10n.of(context)!.call,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(
                                                height: 4.0,
                                              ),
                                              CallTimer(
                                                appBar: false,
                                                proxy: widget.callStateProxy,
                                                voipPlugin: widget.voipPlugin,
                                                overrideTextStyle:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: toCallAndRemovePopup,
                                            icon: const Icon(
                                              Icons.maximize,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
