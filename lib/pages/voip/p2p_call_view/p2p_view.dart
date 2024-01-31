import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import '../../../utils/voip/call_session_state.dart';
import '../../../widgets/avatar.dart';
import '../widgets/call_timer.dart';
import '../widgets/stream_view.dart';

/// stack of remote view and user view
class P2PCallView extends StatefulWidget {
  final CallSessionState call;
  final VoipPlugin voipPlugin;
  const P2PCallView({
    super.key,
    required this.call,
    required this.voipPlugin,
  });

  @override
  State<P2PCallView> createState() => _P2PCallViewState();
}

class _P2PCallViewState extends State<P2PCallView> {
  CallSessionState get call => widget.call;
  VoipPlugin get voipPlugin => widget.voipPlugin;

  WrappedMediaStream? get primaryStream => call.primaryStream;
  List<WrappedMediaStream> get remoteStreams =>
      call.userMediaStreams.where((element) => !element.isLocal()).toList();
  List<WrappedMediaStream> get screenSharingStreams =>
      call.screenSharingStreams;

  List<Widget> secondaryViews() {
    final views = <Widget>[];

    final List<WrappedMediaStream> userMediaStreamsCopy =
        List.from(call.userMediaStreams);

    if (call.connected && call.voiceonly) {
      userMediaStreamsCopy.removeWhere(
        (element) => element.participant == voipPlugin.voip.localParticipant,
      );
    }
    userMediaStreamsCopy.removeWhere(
      (element) => element.stream!.id == primaryStream!.stream!.id,
    );

    for (final stream in userMediaStreamsCopy) {
      views.add(
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              color: Colors.black,
            ),
            child: SizedBox(
              width: 96,
              height: 128,
              child: stream.participant == voipPlugin.voip.localParticipant &&
                      stream.videoMuted
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_off,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 11),
                          Text(
                            'Camera turned off',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : StreamView(
                      wrappedStream: stream,
                      isVoiceOnly: call.voiceonly,
                    ),
            ),
          ),
        ),
      );
      views.add(const SizedBox(height: 8));
    }

    return views;
  }

  bool get expandedMainView =>
      primaryStream != null && !call.voiceonly && call.connected;

  @override
  Widget build(BuildContext context) {
    // use global context so no other widget in the tree can affect getting this
    final mediaQuery =
        MediaQuery.of(FluffyChatApp.appGlobalKey.currentContext!);
    final availableHeight = mediaQuery.size.height -
        (70 +
            mediaQuery.padding.top +
            mediaQuery.padding.bottom +
            56.0 +
            24 // bottom and top padding of action buttons bar
        );

    return call.callOnHold
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pause,
                size: 48.0,
                color: Colors.white,
              ),
              Text(
                call.localHold
                    ? L10n.of(context)!.userHeldTheCall(
                        call.displayName ?? L10n.of(context)!.unknownUser,
                      )
                    : L10n.of(context)!.youHeldTheCall,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!call.connected)
                Text(
                  !call.isOutgoing && !call.connecting
                      ? call.type == VoipType.kVoice
                          ? L10n.of(context)!.audioCall
                          : L10n.of(context)!.videoCall
                      : call.isOutgoing && !call.connecting
                          ? L10n.of(context)!.youAreCalling
                          : L10n.of(context)!.connecting,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white.withOpacity(0.8)),
                ),
              if (call.connected && call.voiceonly)
                CallTimer(
                  voipPlugin: voipPlugin,
                  appBar: false,
                  proxy: call,
                ),
              SizedBox(height: !expandedMainView ? 32 : 0),
              if (!call.connected)
                // outgoing calls initial page
                Avatar(
                  mxContent: call.call.remoteUser!.avatarUrl,
                  name: call.call.remoteUser!.displayName.toString(),
                  size: min(MediaQuery.of(context).size.height * 0.2, 160),
                  fontSize: 64,
                  client: call.room.client,
                )
              else
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: expandedMainView ? availableHeight : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Center(
                            child: StreamView(
                              wrappedStream: primaryStream!,
                              avatarSize: min(
                                MediaQuery.of(context).size.height * 0.2,
                                160,
                              ),
                              avatarTextSize: 64,
                              avatarBorderRadius: 24,
                              isVoiceOnly: call.voiceonly,
                            ),
                          ),
                        ),
                      ),
                    ),
                    call.userMediaStreams.isEmpty ||
                            (call.voiceonly && primaryStream!.videoMuted)
                        ? Container()
                        : Positioned(
                            right: 8,
                            bottom: 0,
                            child: Column(children: secondaryViews()),
                          ),
                  ],
                ),
              SizedBox(height: expandedMainView ? 0 : 32),
              if (screenSharingStreams.isEmpty &&
                  (call.voiceonly || !call.connected)) ...[
                // show name and org only if voice only and no screen sharing
                Text(
                  !call.connected
                      ? call.call.remoteUser!.displayName.toString()
                      : primaryStream!.displayName.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  !call.connected
                      ? call.call.remoteUser!.id.domain.toString()
                      : primaryStream!.participant.userId.domain.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ],
            ],
          );
  }
}
