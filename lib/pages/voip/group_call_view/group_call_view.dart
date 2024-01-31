import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import '../../../utils/voip/call_state_proxy.dart';
import '../widgets/stream_view.dart';
import 'widgets/grid_definitions.dart';
import 'widgets/no_tracks_published_tile.dart';

enum TileType { userMedia, screenShare }

class GroupCallView extends StatefulWidget {
  final CallStateProxy call;
  final Client client;

  const GroupCallView({
    super.key,
    required this.call,
    required this.client,
  });

  @override
  State<GroupCallView> createState() => GroupCallViewState();
}

class GroupCallViewState extends State<GroupCallView> {
  GroupCallSession get groupCall => widget.call.groupCall!;

  List<Participant> get participants => groupCall.participants;

  List<WrappedMediaStream>? userMediaStreams;
  List<WrappedMediaStream>? screenSharingStreams;

  List<WrappedMediaStream> getStreamOfTileType(TileType type) {
    return (type == TileType.userMedia
            ? userMediaStreams
            : screenSharingStreams) ??
        [];
  }

  List<SelectedLayout> selectedLayouts = [];
  int currentPage = 0;
  final pageViewController = PageController();

  /// called every build
  void createLayoutList(int pcount) {
    final layout = selectGridLayout(
      GRID_LAYOUTS,
      pcount,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );
    int pSet;
    final pLeft = pcount - layout.maxTiles;
    pSet = pLeft > 0 ? layout.maxTiles : pcount;
    selectedLayouts.add(SelectedLayout(layout: layout, tilesOnLayout: pSet));
    if (pLeft > 0) {
      createLayoutList(pLeft);
    }
  }

  /// keep in sync with getTiles
  int getTilesCount(TileType tileType) {
    int tiles = 0;
    for (final p in participants) {
      final tracksLength = getStreamOfTileType(tileType)
          .where((element) => element.participant == p)
          .length;
      if (tileType == TileType.userMedia) {
        tiles += tracksLength > 0 ? tracksLength : 1;
      }
    }
    return tiles;
  }

  /// keep in sync with getTilesCount
  List<Widget> getTiles({
    required TileType tileType,
    required double height,
    double? width,
  }) {
    final List<Widget> tiles = [];
    for (final p in participants) {
      final user = widget.call.room.unsafeGetUserFromMemoryOrFallback(p.userId);

      final List<Widget> ptiles = [];
      for (final stream in getStreamOfTileType(tileType)
          .where((element) => element.participant == p)) {
        final tile = InkWell(
          key: ValueKey(stream.id),
          onTap: () => togglePinned(stream),
          child: IgnorePointer(
            child: SizedBox(
              height: height,
              width: width,
              child: StreamView(
                highLight: false,
                wrappedStream: stream,
                showName: true,
                avatarSize: 80,
                avatarTextSize: 48,
                avatarBorderRadius: 16,
                showExtendedName: true,
              ),
            ),
          ),
        );
        ptiles.add(tile);
      }

      tiles.addAll(ptiles);
      Logs().d(
        'Found ${ptiles.length} tiles for ${user.displayName} of $tileType',
      );
      // add users who haven't published any tracks and hide missing screen share blanks
      if (tileType == TileType.userMedia && ptiles.isEmpty) {
        tiles.add(
          NoTracksPublishedTile(
            client: widget.client,
            user: user,
            height: height,
          ),
        );
        Logs().d(
          'Added blank tile for for ${user.displayName} of $tileType',
        );
      }
    }
    Logs().d(
      'Rendering ${tiles.length} tiles of $tileType',
    );
    return tiles;
  }

  WrappedMediaStream? pinnedStream;

  void togglePinned(WrappedMediaStream stream) {
    // ignore pinning when only one tile

    final totalTiles =
        getTilesCount(TileType.userMedia) + getTilesCount(TileType.screenShare);

    if (totalTiles <= 1) return;

    setState(() {
      pinnedStream = pinnedStream == stream ? null : stream;
    });
    Logs()
        .e('pinnsed stream set to: ${(pinnedStream?.displayName).toString()}');
  }

  @override
  Widget build(BuildContext context) {
    Logs().d('[GroupCallView] rebuilding callgrid children');

    // groupCall.encryptionKeysMap.forEach((key, value) {
    //   Logs().i(key.userId.toString());
    //   Logs().i(value.values.map((e) => base64Encode(e).toString()).toString());
    // });

    userMediaStreams = List.from(widget.call.userMediaStreams);
    screenSharingStreams = List.from(widget.call.screenSharingStreams);

    // reset the pinned stream
    if (!userMediaStreams!.contains(pinnedStream) &&
        !screenSharingStreams!.contains(pinnedStream)) pinnedStream = null;

    selectedLayouts.clear();
    createLayoutList(getTilesCount(TileType.userMedia));

    if (currentPage > selectedLayouts.length - 1) {
      currentPage = selectedLayouts.length - 1;
      Logs().d('[GroupCallView] currentPage set to $currentPage');
    }

    // use global context so no other widget in the tree can affect getting this
    final mediaQuery =
        MediaQuery.of(FluffyChatApp.appGlobalKey.currentContext!);
    final columnMode =
        FluffyThemes.isColumnMode(FluffyChatApp.appGlobalKey.currentContext!);

    final availableHeight = mediaQuery.size.height -
        (70 +
            mediaQuery.padding.top +
            mediaQuery.padding.bottom +
            56.0 +
            24 + // bottom and top padding of action buttons bar
            8.0 + // seperator padding
            // pagination buttons
            (columnMode ? 0 : 40));
    final availableWidth = mediaQuery.size.width -
        24; // acts as left right padding because centered

    if ((screenSharingStreams ?? []).isEmpty && pinnedStream == null) {
      return Column(
        children: [
          SizedBox(
            height: availableHeight,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedLayouts.length,
              controller: pageViewController,
              itemBuilder: (BuildContext context, int pageIndex) {
                // Logs().d('pageIndex: $pageIndex');
                // Logs().d('users: ${selectedLayouts[pageIndex].tilesOnLayout}');
                // Logs()
                //     .d('grid name: ${selectedLayouts[pageIndex].layout.name}');
                // Logs()
                //     .d('columns: ${selectedLayouts[pageIndex].layout.columns}');
                // Logs().d('rows: ${selectedLayouts[pageIndex].layout.rows}');
                // Logs().d(
                //   'maxTiles: ${selectedLayouts[pageIndex].layout.maxTiles}',
                // );

                int startIndex = 0;
                for (final page in selectedLayouts.sublist(0, pageIndex)) {
                  startIndex += page.tilesOnLayout;
                }
                Logs().d('startIndex: $startIndex');

                final tiles = getTiles(
                  tileType: TileType.userMedia,
                  height:
                      availableHeight / selectedLayouts[pageIndex].layout.rows,
                );

                final tilesForPage = tiles.sublist(
                  startIndex,
                  startIndex + selectedLayouts[pageIndex].tilesOnLayout,
                );

                Logs().d('tilesForPage length: ${tilesForPage.toString()}');

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AlignedGridView.count(
                      mainAxisSpacing: 3.0,
                      crossAxisSpacing: 4.0,
                      crossAxisCount: selectedLayouts[pageIndex].layout.columns,
                      itemCount: selectedLayouts[pageIndex].tilesOnLayout,
                      itemBuilder: (context, index) {
                        return tilesForPage[index];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: currentPage > 0
                    ? () {
                        setState(() {
                          currentPage--;
                          pageViewController.jumpToPage(currentPage);
                        });
                      }
                    : null,
              ),
              Text('${currentPage + 1}/${selectedLayouts.length}'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: currentPage < selectedLayouts.length - 1
                    ? () {
                        setState(() {
                          currentPage++;
                          pageViewController.jumpToPage(currentPage);
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      );
    } else {
      final focusedStream = pinnedStream ??
          screenSharingStreams!.firstWhere((element) => element.stream != null);

      final List<Widget> miniTiles = [
        ...getTiles(
          tileType: TileType.screenShare,
          height: 120.0,
          width: columnMode ? 220.0 - 8.0 : 120.0,
        ),
        ...getTiles(
          tileType: TileType.userMedia,
          height: 120.0,
          width: columnMode ? 220.0 - 8.0 : 120.0,
        ),
      ]
          .where(
            (element) => element.key != ValueKey(focusedStream.id),
          )
          .toList();

      final List<Widget> tilesWhileScreenSharing = [
        InkWell(
          key: ValueKey(focusedStream.id),
          onTap: () => togglePinned(focusedStream),
          child: IgnorePointer(
            child: SizedBox(
              height: columnMode ? availableHeight : availableHeight - 120.0,
              width: columnMode ? availableWidth - 220.0 : availableWidth,
              child: StreamView(
                highLight: false,
                showName: true,
                avatarSize: 80,
                avatarTextSize: 48,
                avatarBorderRadius: 16,
                showExtendedName: true,
                wrappedStream: focusedStream,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 2.0,
          width: 2.0,
        ),
        SizedBox(
          height: columnMode
              ? null
              : 120.0, // allow complete height to scroll in columnMode
          width: columnMode
              ? 220.0 - 8.0
              : null, // allow complete width to scroll in mobileMode
          child: ListView.separated(
            scrollDirection: columnMode ? Axis.vertical : Axis.horizontal,
            itemCount: miniTiles.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 2.0,
              width: 2.0,
            ),
            itemBuilder: (context, index) => miniTiles[index],
          ),
        ),
      ];
      return SizedBox(
        // height: availableHeight,
        width: availableWidth,
        child: columnMode
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: tilesWhileScreenSharing,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: tilesWhileScreenSharing.reversed.toList(),
              ),
      );
    }
  }
}

class SelectedLayout {
  GridLayoutDefinition layout;
  int tilesOnLayout;

  SelectedLayout({required this.layout, required this.tilesOnLayout});
}
