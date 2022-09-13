import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/space_view.dart';
import 'package:fluffychat/pages/chat_list/spaces_drawer.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpacesDrawerEntry extends StatefulWidget {
  final SpacesEntryMaybeChildren entry;
  final ChatListController controller;

  const SpacesDrawerEntry(
      {Key? key, required this.entry, required this.controller})
      : super(key: key);

  @override
  State<SpacesDrawerEntry> createState() => _SpacesDrawerEntryState();
}

class _SpacesDrawerEntryState extends State<SpacesDrawerEntry> {
  SpaceHierarchyCache? _cache;

  String? prevBatch;

  @override
  Widget build(BuildContext context) {
    _cache ??= SpaceHierarchyCache.instance ??=
        SpaceHierarchyCache(client: Matrix.of(context).client);
    return FutureBuilder<GetSpaceHierarchyResponse>(
        future: _cache!.getFuture(widget.entry.spacesEntry.id, prevBatch),
        builder: (context, snapshot) {
          final space = Matrix.of(context).client.rooms.singleWhereOrNull(
                  (element) =>
                      element.id == snapshot.data?.rooms.first.roomId) ??
              widget.entry.spacesEntry;
          final room = space;

          final canLoadMore = snapshot.data?.nextBatch != null;
          final active =
              widget.controller.activeSpaceId == widget.entry.spacesEntry.id;
          final leading = Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Avatar(
              mxContent: space.avatar,
              name: space.displayname,
              size: 32,
              fontSize: 12,
            ),
          );
          final title = Text(
            space.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
          void onTap() {
            widget.controller.setActiveSpace(space.id);
          }

          final trailing = SizedBox(
            width: 32,
            child: IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.edit_outlined),
              tooltip: L10n.of(context)!.edit,
              onPressed: () => widget.controller.editSpace(context, room.id),
            ),
          );

          if (widget.entry.children.isEmpty && !canLoadMore) {
            return ListTile(
              selected: active,
              leading: leading,
              title: title,
              onTap: onTap,
              trailing: trailing,
            );
          } else {
            final isSelected =
                widget.controller.activeFilter == ActiveFilter.spaces &&
                    space.id == widget.controller.activeSpaceId;
            return Stack(
              alignment: Alignment.topLeft,
              children: [
                ExpansionTile(
                  leading: leading,
                  initiallyExpanded: widget.entry.children.any((element) =>
                      widget.entry.isActiveOrChild(widget.controller)),
                  title: GestureDetector(
                    onTap: onTap,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: title),
                          const SizedBox(width: 8),
                          trailing
                        ]),
                  ),
                  children: [
                    ...widget.entry.children.map((e) => SpacesDrawerEntry(
                        entry: e, controller: widget.controller)),
                    if (canLoadMore)
                      ListTile(
                        title: TextButton.icon(
                          label: Text(L10n.of(context)!.loadMore),
                          icon: _cache?.isRefreshing(
                                    widget.entry.spacesEntry.id,
                                  ) ??
                                  false
                              ? const SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator(),
                                )
                              : const Icon(Icons.refresh),
                          onPressed: () {
                            prevBatch = snapshot.data!.nextBatch!;
                            setState(() {
                              _cache!.refresh(widget.entry.spacesEntry.id);
                            });
                          },
                        ),
                      ),
                  ],
                ),
                Container(
                  height: 56,
                  width: 4,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                        width: 4,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ],
            );
          }
        });
  }
}
