// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/call/call_tile.dart';
import 'package:fluffychat/pages/call/call_view_model.dart';
import 'package:fluffychat/pages/call/start_time.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:material_ui/material_ui.dart';

class CallPage extends StatelessWidget {
  final String roomId;
  const CallPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final room = Matrix.of(context).client.getRoomById(roomId)!;
    return ViewModelBuilder(
      create: () => CallViewModel(room: room),
      builder: (context, viewModel, _) {
        final liveKitRoom = viewModel.value.room;
        final localVideoTrack = viewModel.value.localVideoTrack;
        final localAudioTrack = viewModel.value.localAudioTrack;
        final localParticipant = liveKitRoom?.localParticipant;

        final activeMembers = room.getActiveMatrixRtcMembers().length;
        final ownUser = room.unsafeGetUserFromMemoryOrFallback(
          room.client.userID!,
        );

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: viewModel.startTime == null
                ? null
                : StartTime(startTime: viewModel.startTime!),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            actions: [
              if (localVideoTrack == null)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => viewModel.selectCamera(context),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          const Icon(Icons.camera_outlined),
                          const SizedBox(width: 12),
                          Text('Select camera'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => viewModel.selectMicrophone(context),
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          const Icon(Icons.mic_outlined),
                          const SizedBox(width: 12),
                          Text('Select microphone'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
            title: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  room.getLocalizedDisplayname(),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                Text(
                  L10n.of(context).countActiveCallMembers(activeMembers),
                  maxLines: 1,
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          body: liveKitRoom == null
              ? Center(child: CircularProgressIndicator())
              : localVideoTrack != null
              ? localVideoTrack.muted
                    ? Center(
                        child: Avatar(
                          mxContent: ownUser.avatarUrl,
                          name: ownUser.calcDisplayname(),
                          size: 128,
                        ),
                      )
                    : VideoTrackRenderer(localVideoTrack, fit: .cover)
              : SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final axis = constraints.maxWidth < constraints.maxHeight
                          ? Axis.vertical
                          : Axis.horizontal;

                      final tiles = liveKitRoom.getCallTiles(room);

                      final focused =
                          (viewModel.value.focusedTrack == null
                              ? null
                              : tiles.firstWhereOrNull(
                                  (tile) =>
                                      tile.id == viewModel.value.focusedTrack,
                                )) ??
                          tiles.firstWhereOrNull(
                            (tile) => tile.video?.isScreenShare == true,
                          ) ??
                          tiles.firstOrNull ??
                          (
                            id: '${ownUser.id}_fallback_none',
                            user: ownUser,
                            video: null,
                            audio: null,
                          );
                      tiles.remove(focused);

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 84.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Flex(
                          direction: axis,
                          crossAxisAlignment: .stretch,
                          children: [
                            Expanded(
                              child: CallTile(
                                key: ValueKey(focused.id),
                                user: focused.user,
                                video: focused.video,
                                audio: focused.audio,
                                onTap: focused.video == null
                                    ? null
                                    : () =>
                                          viewModel.setFocusedTrack(focused.id),
                              ),
                            ),
                            if (tiles.isNotEmpty) ...[
                              SizedBox(width: 16, height: 16),
                              SizedBox(
                                height: axis == .horizontal ? null : 128,
                                width: axis == .vertical ? null : 128,
                                child: ListView.builder(
                                  scrollDirection: axis == .horizontal
                                      ? .vertical
                                      : .horizontal,
                                  itemCount: tiles.length,
                                  itemBuilder: (context, i) => CallTile(
                                    key: ValueKey(tiles[i].id),
                                    user: tiles[i].user,
                                    video: tiles[i].video,
                                    audio: tiles[i].audio,
                                    onTap: tiles[i].video == null
                                        ? null
                                        : () => viewModel.setFocusedTrack(
                                            tiles[i].id,
                                          ),
                                    margin: EdgeInsets.only(
                                      right: axis == .vertical ? 16 : 0,
                                      bottom: axis == .horizontal ? 16 : 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
          floatingActionButtonLocation: .centerFloat,
          floatingActionButton: Wrap(
            alignment: .center,
            spacing: 16,
            children: [
              if (localParticipant != null) ...[
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () => localParticipant.setMicrophoneEnabled(
                    !localParticipant.isMicrophoneEnabled(),
                  ),
                  child: Icon(
                    localParticipant.isMicrophoneEnabled()
                        ? Icons.mic_outlined
                        : Icons.mic_off_outlined,
                  ),
                ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: () => localParticipant.setCameraEnabled(
                    !localParticipant.isCameraEnabled(),
                  ),
                  child: Icon(
                    localParticipant.isCameraEnabled()
                        ? Icons.videocam_outlined
                        : Icons.videocam_off_outlined,
                  ),
                ),
                if (!PlatformInfos.isIOS) // TODO: Fix on iOS?
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => localParticipant.setScreenShareEnabled(
                      !localParticipant.isScreenShareEnabled(),
                    ),
                    child: Icon(
                      localParticipant.isScreenShareEnabled()
                          ? Icons.stop_screen_share_outlined
                          : Icons.screen_share_outlined,
                    ),
                  ),
                FloatingActionButton(
                  heroTag: null,
                  onPressed: null,
                  child: Icon(Icons.emoji_emotions_outlined),
                ),
              ] else ...[
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withAlpha(230),
                      borderRadius: BorderRadius.circular(
                        AppConfig.borderRadius,
                      ),
                    ),
                    margin: EdgeInsets.all(16.0),
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      L10n.of(context).videoCallsBetaWarning,
                      textAlign: .center,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 200,
                      child: FloatingActionButton.extended(
                        onPressed: () => showFutureLoadingDialog(
                          context: context,
                          future: viewModel.connect,
                        ),
                        foregroundColor: theme.colorScheme.onPrimary,
                        backgroundColor: theme.colorScheme.primary,
                        icon: Icon(Icons.call_outlined),
                        label: Text(L10n.of(context).enterCall),
                      ),
                    ),
                  ),
                ),
                if (localAudioTrack != null)
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: viewModel.togglePreviewMic,
                    child: Icon(
                      !localAudioTrack.muted
                          ? Icons.mic_outlined
                          : Icons.mic_off_outlined,
                    ),
                  ),
                if (localVideoTrack != null)
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: viewModel.togglePreviewCamera,
                    child: Icon(
                      !localVideoTrack.muted
                          ? Icons.videocam_outlined
                          : Icons.videocam_off_outlined,
                    ),
                  ),
              ],
              FloatingActionButton(
                heroTag: null,
                onPressed: () => viewModel.close(context),
                foregroundColor: theme.colorScheme.onErrorContainer,
                backgroundColor: theme.colorScheme.errorContainer,
                child: Icon(Icons.call_end_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
