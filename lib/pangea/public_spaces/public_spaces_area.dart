// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/public_spaces/public_space_card.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PublicSpacesArea extends StatefulWidget {
  const PublicSpacesArea({super.key});

  @override
  PublicSpacesAreaState createState() => PublicSpacesAreaState();
}

class PublicSpacesAreaState extends State<PublicSpacesArea> {
  @override
  void initState() {
    super.initState();
    _setSpaceItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _coolDown?.cancel();
    super.dispose();
  }

  bool _loading = true;
  bool _isSearching = false;

  final List<PublicRoomsChunk> _spaceItems = [];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _coolDown;

  final double cardHeight = 150.0;
  final double cardWidth = 325.0;

  Future<void> _setSpaceItems() async {
    _spaceItems.clear();
    setState(() => _loading = true);
    try {
      final resp = await Matrix.of(context).client.queryPublicRooms(
            filter: PublicRoomQueryFilter(
              roomTypes: ['m.space'],
              genericSearchTerm: _searchController.text,
            ),
            limit: 100,
          );
      _spaceItems.addAll(resp.chunk);
      _spaceItems.sort((a, b) {
        int getPriority(item) {
          final bool hasTopic = item.topic != null && item.topic!.isNotEmpty;
          final bool hasAvatar = item.avatarUrl != null;

          if (hasTopic && hasAvatar) return 0; // Highest priority
          if (hasAvatar) return 1; // Second priority
          if (hasTopic) return 2; // Third priority
          return 3; // Lowest priority
        }

        return getPriority(a).compareTo(getPriority(b));
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchEnter(String text, {bool globalSearch = true}) {
    if (text.isEmpty) {
      _setSpaceItems();
      return;
    }

    _coolDown?.cancel();
    _coolDown = Timer(const Duration(milliseconds: 500), _setSpaceItems);
  }

  void _toggleSearching() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      _setSpaceItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final List<Widget> cards = _loading && _spaceItems.isEmpty
        ? List.generate(5, (i) {
            return Shimmer.fromColors(
              baseColor: theme.colorScheme.primary.withAlpha(20),
              highlightColor: theme.colorScheme.primary.withAlpha(50),
              child: Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            );
          })
        : _spaceItems
            .map((space) {
              return PublicSpaceCard(
                space: space,
                width: cardWidth,
                height: cardHeight,
              );
            })
            .cast<Widget>()
            .toList();

    if (_loading && _spaceItems.isNotEmpty) {
      cards.add(
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: _isSearching
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  key: const ValueKey('search'),
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: _searchController,
                        onChanged: _onSearchEnter,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 12.0,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _toggleSearching,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  key: const ValueKey('title'),
                  children: [
                    Text(
                      L10n.of(context).publicSpacesTitle,
                      style: isColumnMode
                          ? theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)
                          : theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _toggleSearching,
                    ),
                  ],
                ),
        ),
        Container(
          decoration: const BoxDecoration(),
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8.0,
                  children: cards,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
