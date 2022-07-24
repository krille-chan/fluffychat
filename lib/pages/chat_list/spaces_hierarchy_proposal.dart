import 'dart:async';

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:async/async.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'recommended_room_list_item.dart';

class SpacesHierarchyProposals extends StatefulWidget {
  static final Map<String, AsyncCache<GetSpaceHierarchyResponse?>> _cache = {};

  final String? space;
  final String? query;

  const SpacesHierarchyProposals({
    Key? key,
    required this.space,
    this.query,
  }) : super(key: key);

  @override
  State<SpacesHierarchyProposals> createState() =>
      _SpacesHierarchyProposalsState();
}

class _SpacesHierarchyProposalsState extends State<SpacesHierarchyProposals> {
  @override
  void didUpdateWidget(covariant SpacesHierarchyProposals oldWidget) {
    if (oldWidget.space != widget.space || oldWidget.query != widget.query) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // check for recommended rooms in case the active space is a [SpaceSpacesEntry]
    if (widget.space != null) {
      final client = Matrix.of(context).client;

      final cache = SpacesHierarchyProposals._cache[widget.space!] ??=
          AsyncCache<GetSpaceHierarchyResponse?>(const Duration(minutes: 15));

      /// additionally saving the future's state in the completer in order to
      /// display the loading indicator when refreshing as a [FutureBuilder] is
      /// a [StatefulWidget].
      final completer = Completer();
      final future = cache.fetch(() => client.getSpaceHierarchy(
            widget.space!,
            suggestedOnly: true,
            maxDepth: 1,
          ));
      future.then(completer.complete);

      return FutureBuilder<GetSpaceHierarchyResponse?>(
        future: future,
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            final rooms = snapshot.data!.rooms.where(
              (element) =>
                  element.roomId != widget.space &&
                  // filtering in case a query is given
                  (widget.query != null
                      ? (element.name?.contains(widget.query!) ?? false) ||
                          (element.topic?.contains(widget.query!) ?? false)
                      // in case not, just leave it...
                      : true) &&
                  client.rooms
                      .any((knownRoom) => element.roomId != knownRoom.id),
            );
            if (rooms.isEmpty) child = const ListTile(key: ValueKey(false));
            child = Column(
              key: ValueKey(widget.space),
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchTitle(
                  title: L10n.of(context)!.suggestedRooms,
                  icon: const Icon(Icons.auto_awesome_outlined),
                  trailing: completer.isCompleted
                      ? const Icon(
                          Icons.refresh_outlined,
                          size: 16,
                        )
                      : const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 1,
                          ),
                        ),
                  onTap: _refreshRooms,
                ),
                ...rooms.map(
                  (e) => RecommendedRoomListItem(
                    room: e,
                    onRoomJoined: _refreshRooms,
                  ),
                ),
              ],
            );
          } else {
            child = Column(
              key: const ValueKey(null),
              children: [
                if (!snapshot.hasError) const LinearProgressIndicator(),
                const ListTile(),
              ],
            );
          }
          return PageTransitionSwitcher(
            // prevent the animation from re-building on dependency change
            key: ValueKey(widget.space),
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.scaled,
                child: child,
                fillColor: Colors.transparent,
              );
            },
            layoutBuilder: (children) => Stack(
              alignment: Alignment.topCenter,
              children: children,
            ),
            child: child,
          );
        },
      );
    } else {
      return Container();
    }
  }

  void _refreshRooms() => setState(
        () => SpacesHierarchyProposals._cache[widget.space!]!.invalidate(),
      );
}
