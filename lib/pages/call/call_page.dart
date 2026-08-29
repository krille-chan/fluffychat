// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/call/call_tile.dart';
import 'package:fluffychat/pages/call/call_view_model.dart';
import 'package:fluffychat/pages/call/start_time.dart';
import 'package:fluffychat/pages/call/utils/get_call_tiles.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
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
    final mini = Matrix.of(context).callPosition.value != .fullScreen;
    final tileSize = FluffyThemes.isColumnMode(context) ? 256.0 : 128.0;
    return ViewModelBuilder(
      create: () => CallViewModel(room: room),
      builder: (context, viewModel, _) {
        final liveKitRoom = viewModel.value.room;
        final localVideoTrack = viewModel.value.localVideoTrack;
        final localParticipant = liveKitRoom?.localParticipant;

        final activeMembers = room.getActiveMatrixRtcMembers().length;
        final ownUser = room.unsafeGetUserFromMemoryOrFallback(
          room.client.userID!,
        );
        final ownHandRaised = viewModel.participantRaisedHand(ownUser.id);
        final userIsScreensharing =
            localParticipant?.isScreenShareEnabled() == true;
        final iconButtonStyle = IconButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceBright.withAlpha(230),
          disabledBackgroundColor: theme.colorScheme.surfaceBright.withAlpha(
            230,
          ),
          iconSize: mini ? null : 28,
          padding: EdgeInsets.all(mini ? 8.0 : 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
            side: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
          ),
        );
        final iconButtonStyleActive = IconButton.styleFrom(
          backgroundColor: theme.colorScheme.inverseSurface,
          disabledBackgroundColor: theme.colorScheme.inverseSurface,
          foregroundColor: theme.colorScheme.onInverseSurface,
          disabledForegroundColor: theme.colorScheme.onInverseSurface,
        ).merge(iconButtonStyle);

        return MediaQuery.removePadding(
          context: context,
          removeBottom: mini,
          removeTop: mini,
          child: ScaffoldMessenger(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: viewModel.startTime == null
                    ? null
                    : StartTime(startTime: viewModel.startTime!),
                backgroundColor: theme.colorScheme.surface.withAlpha(64),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.fullscreen_outlined),
                    onPressed: () {
                      Matrix.of(context).callPosition.value = mini
                          ? .fullScreen
                          : .top;
                    },
                  ),
                  if (localVideoTrack == null)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => viewModel.selectCamera(context),
                          child: Row(
                            mainAxisSize: .min,
                            spacing: 12,
                            children: [
                              const Icon(Icons.camera_outlined),
                              Text(L10n.of(context).selectCamera),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => viewModel.selectMicrophone(context),
                          child: Row(
                            mainAxisSize: .min,
                            spacing: 12,
                            children: [
                              const Icon(Icons.mic_outlined),
                              Text(L10n.of(context).selectMicrophone),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () => viewModel.selectSpeaker(context),
                          child: Row(
                            mainAxisSize: .min,
                            spacing: 12,
                            children: [
                              const Icon(Icons.speaker_phone_outlined),
                              Text(L10n.of(context).selectSpeaker),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
                titleSpacing: mini ? 0 : null,
                title: Column(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      room.getLocalizedDisplayname(),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: mini
                          ? TextStyle(fontSize: 11, fontWeight: .bold)
                          : null,
                    ),
                    if (activeMembers > 0)
                      Text(
                        viewModel.waitForOtherSide
                            ? L10n.of(context).waitingForParticipant
                            : L10n.of(
                                context,
                              ).countActiveCallMembers(activeMembers),
                        maxLines: 1,
                        style: TextStyle(fontSize: 11),
                      ),
                  ],
                ),
              ),
              body: liveKitRoom == null
                  ? Center(child: CircularProgressIndicator())
                  : localVideoTrack != null
                  ? Stack(
                      children: [
                        localVideoTrack.muted
                            ? Center(
                                child: Avatar(
                                  mxContent: ownUser.avatarUrl,
                                  name: ownUser.calcDisplayname(),
                                  size: 128,
                                ),
                              )
                            : VideoTrackRenderer(localVideoTrack, fit: .cover),

                        Align(
                          alignment: .topCenter,
                          child: SafeArea(
                            child: Container(
                              decoration: BoxDecoration(
                                color: viewModel.value.error == null
                                    ? theme.colorScheme.errorContainer
                                          .withAlpha(230)
                                    : theme.colorScheme.error.withAlpha(230),
                                borderRadius: BorderRadius.circular(
                                  AppConfig.borderRadius,
                                ),
                              ),
                              margin: EdgeInsets.all(16.0),
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                viewModel.value.error?.toLocalizedString(
                                      context,
                                    ) ??
                                    L10n.of(context).videoCallsBetaWarning,
                                textAlign: .center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: viewModel.value.error == null
                                      ? theme.colorScheme.onErrorContainer
                                      : theme.colorScheme.onError,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SafeArea(
                      top: !mini,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final axis =
                              constraints.maxWidth < constraints.maxHeight
                              ? Axis.vertical
                              : Axis.horizontal;

                          final tiles = liveKitRoom.getCallTiles(room);

                          final focused =
                              (viewModel.value.focusedTrack == null
                                  ? null
                                  : tiles.firstWhereOrNull(
                                      (tile) =>
                                          tile.id ==
                                          viewModel.value.focusedTrack,
                                    )) ??
                              tiles.firstWhereOrNull(
                                (tile) => tile.video?.isScreenShare == true,
                              ) ??
                              (tiles.length < 3 ? tiles.first : null);

                          if (mini) {
                            final miniFocused =
                                focused ??
                                tiles.firstOrNull ??
                                (
                                  id: '${ownUser.id}_fallback_none',
                                  user: ownUser,
                                  video: null,
                                  audio: null,
                                  connected: false,
                                  isSpeaking: false,
                                );
                            return SizedBox.expand(
                              child: CallTile(
                                key: ValueKey(miniFocused.id),
                                user: miniFocused.user,
                                video: miniFocused.video,
                                audio: miniFocused.audio,
                                connected: miniFocused.connected,
                                margin: EdgeInsets.zero,
                                handRaised: viewModel.participantRaisedHand(
                                  miniFocused.user.id,
                                ),
                                isSpeaking: miniFocused.isSpeaking,
                                onTap: null,
                              ),
                            );
                          }
                          tiles.remove(focused);

                          return focused == null
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 84.0,
                                    left: 16.0,
                                    right: 16.0,
                                    top: 16.0,
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final rows = sqrt(tiles.length).ceil();
                                      final columns = (tiles.length / rows)
                                          .ceil();

                                      final width =
                                          (constraints.maxWidth / rows) -
                                          (rows * 8);
                                      final height =
                                          (constraints.maxHeight / columns) -
                                          (columns * 8);
                                      return Center(
                                        child: Wrap(
                                          spacing: 16.0,
                                          runSpacing: 16.0,
                                          alignment: .center,
                                          runAlignment: .center,
                                          crossAxisAlignment: .center,
                                          children: tiles
                                              .map(
                                                (tile) => CallTile(
                                                  key: ValueKey(tile.id),
                                                  user: tile.user,
                                                  video: tile.video,
                                                  audio: tile.audio,
                                                  connected: tile.connected,
                                                  width: width,
                                                  height: height,
                                                  isSpeaking: tile.isSpeaking,
                                                  handRaised: viewModel
                                                      .participantRaisedHand(
                                                        tile.user.id,
                                                      ),
                                                  onTap: () => viewModel
                                                      .setFocusedTrack(tile.id),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 96.0,
                                    left: 16.0,
                                    right: 16.0,
                                    top: 16.0,
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
                                          connected: focused.connected,
                                          fit: .contain,
                                          isSpeaking: focused.isSpeaking,
                                          handRaised: viewModel
                                              .participantRaisedHand(
                                                focused.user.id,
                                              ),
                                          onTap: () => viewModel
                                              .setFocusedTrack(focused.id),
                                        ),
                                      ),
                                      if (tiles.isNotEmpty) ...[
                                        SizedBox(width: 16, height: 16),
                                        SizedBox(
                                          height: axis == .horizontal
                                              ? null
                                              : tileSize,
                                          width: axis == .vertical
                                              ? null
                                              : tileSize,
                                          child: ListView.builder(
                                            scrollDirection: axis == .horizontal
                                                ? .vertical
                                                : .horizontal,
                                            itemCount: tiles.length,
                                            itemBuilder: (context, i) =>
                                                CallTile(
                                                  key: ValueKey(tiles[i].id),
                                                  user: tiles[i].user,
                                                  video: tiles[i].video,
                                                  audio: tiles[i].audio,
                                                  connected: tiles[i].connected,
                                                  width: tileSize,
                                                  height: tileSize,
                                                  isSpeaking:
                                                      tiles[i].isSpeaking,
                                                  handRaised: viewModel
                                                      .participantRaisedHand(
                                                        tiles[i].user.id,
                                                      ),
                                                  onTap: () =>
                                                      viewModel.setFocusedTrack(
                                                        tiles[i].id,
                                                      ),
                                                  margin: EdgeInsets.only(
                                                    right: axis == .vertical
                                                        ? 16
                                                        : 0,
                                                    bottom: axis == .horizontal
                                                        ? 16
                                                        : 0,
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
                spacing: mini ? 8 : 16,
                children: [
                  if (localParticipant != null) ...[
                    IconButton(
                      tooltip: L10n.of(context).toggleMicrophone,
                      style: iconButtonStyle,
                      onPressed: () => localParticipant.setMicrophoneEnabled(
                        !localParticipant.isMicrophoneEnabled(),
                      ),
                      icon: Icon(
                        localParticipant.isMicrophoneEnabled()
                            ? Icons.mic_outlined
                            : Icons.mic_off_outlined,
                      ),
                    ),
                    IconButton(
                      tooltip: L10n.of(context).toggleCamera,
                      style: iconButtonStyle,
                      onPressed: () => localParticipant.setCameraEnabled(
                        !localParticipant.isCameraEnabled(),
                      ),
                      icon: Icon(
                        localParticipant.isCameraEnabled()
                            ? Icons.videocam_outlined
                            : Icons.videocam_off_outlined,
                      ),
                    ),
                    if (!PlatformInfos.isMobile) // TODO: Fix on mobile?
                      IconButton(
                        tooltip: userIsScreensharing
                            ? L10n.of(context).stopScreensharing
                            : L10n.of(context).startScreensharing,
                        style: userIsScreensharing
                            ? iconButtonStyleActive
                            : iconButtonStyle,
                        onPressed: () => localParticipant.setScreenShareEnabled(
                          !userIsScreensharing,
                        ),
                        icon: Icon(
                          userIsScreensharing
                              ? Icons.stop_screen_share
                              : Icons.screen_share_outlined,
                        ),
                      ),
                    IconButton(
                      tooltip: ownHandRaised
                          ? L10n.of(context).stopRaiseHand
                          : L10n.of(context).raiseHand,
                      style: ownHandRaised
                          ? iconButtonStyleActive
                          : iconButtonStyle,
                      onPressed: () => showFutureLoadingDialog(
                        context: context,
                        future: () => ownHandRaised
                            ? room.lowerHandInMatrixRtcCall(viewModel.timeline!)
                            : room.raiseHandInMatrixRtcCall(),
                      ),
                      icon: Icon(
                        ownHandRaised
                            ? Icons.front_hand
                            : Icons.front_hand_outlined,
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 212,
                          child: TextButton.icon(
                            onPressed: viewModel.value.isLoading
                                ? null
                                : viewModel.connect,
                            style: ButtonStyle(
                              padding: iconButtonStyleActive.padding,
                              foregroundColor:
                                  iconButtonStyleActive.foregroundColor,
                              backgroundColor:
                                  iconButtonStyleActive.backgroundColor,
                            ),
                            icon: viewModel.value.isLoading
                                ? SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                      color: theme.colorScheme.onInverseSurface,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(Icons.call_outlined),
                            label: Text(
                              viewModel.value.isLoading
                                  ? L10n.of(context).loadingPleaseWait
                                  : room.hasActiveMatrixRtcCall
                                  ? L10n.of(context).enterCall
                                  : L10n.of(context).startCall,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: L10n.of(context).toggleMicrophone,
                      style: iconButtonStyle,
                      onPressed: viewModel.value.isLoading
                          ? null
                          : viewModel.togglePreviewMic,
                      icon: Icon(
                        (viewModel.value.startWithAudio)
                            ? Icons.mic_outlined
                            : Icons.mic_off_outlined,
                      ),
                    ),
                    IconButton(
                      tooltip: L10n.of(context).toggleCamera,
                      style: iconButtonStyle,
                      onPressed: viewModel.value.isLoading
                          ? null
                          : localVideoTrack != null
                          ? viewModel.togglePreviewCamera
                          : null,
                      icon: Icon(
                        !(localVideoTrack?.muted ?? true)
                            ? Icons.videocam_outlined
                            : Icons.videocam_off_outlined,
                      ),
                    ),
                  ],
                  IconButton(
                    tooltip: L10n.of(context).hangUp,
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.errorContainer,
                      foregroundColor: theme.colorScheme.onErrorContainer,
                    ).merge(iconButtonStyle),

                    onPressed: () => viewModel.close(context),
                    icon: Icon(Icons.call_end_outlined),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
