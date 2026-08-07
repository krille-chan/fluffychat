import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/gif_api.dart';
import 'package:fluffychat/utils/gif_favorites.dart';

import 'events/message_content.dart';
import '../../widgets/matrix.dart';

class GifPickerDialog extends StatefulWidget {
  final void Function(GifItem) onSelected;
  final bool isSending;
  const GifPickerDialog({
    required this.onSelected,
    this.isSending = false,
    super.key,
  });

  @override
  GifPickerDialogState createState() => GifPickerDialogState();
}

class GifPickerDialogState extends State<GifPickerDialog> {
  String? searchFilter;
  List<GifItem> gifs = [];
  List<GifItem> favoriteGifs = [];
  bool isLoading = false;
  bool isLoadingFavorites = false;
  bool hasError = false;
  String? errorMessage;
  Timer? _debounceTimer;
  final ScrollController _scrollController = ScrollController();
  int _nextPos = 0;
  bool _hasMoreResults = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFeaturedGifs();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return;
    setState(() => isLoadingFavorites = true);
    try {
      final client = Matrix.of(context).client;
      final favorites = await GifFavorites.getFavorites(client: client);
      if (mounted) {
        setState(() {
          favoriteGifs = favorites;
          isLoadingFavorites = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => isLoadingFavorites = false);
      }
    }
  }

  Future<void> _toggleFavorite(GifItem gif) async {
    final client = Matrix.of(context).client;
    final updated = await GifFavorites.toggleFavorite(gif, client: client);
    if (mounted) {
      setState(() {
        favoriteGifs = updated;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        _hasMoreResults &&
        !isLoading) {
      _loadMoreGifs();
    }
  }

  Future<void> _loadFeaturedGifs() async {
    setState(() {
      isLoading = true;
      hasError = false;
      _nextPos = 0;
      _hasMoreResults = true;
    });

    try {
      final client = Matrix.of(context).client;
      if (!GifApi.hasApiKey(client)) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage =
              'API key required to fetch GIFs. Configure an API key in Settings or view your Favorite GIFs.';
        });
        return;
      }
      final response = await GifApi.getFeaturedGifs(client: client);
      setState(() {
        gifs = response.results;
        isLoading = false;
        _nextPos = response.results.length + _nextPos;
        _hasMoreResults = response.results.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _searchGifs(String query) async {
    setState(() {
      isLoading = true;
      hasError = false;
      _nextPos = 0;
      _hasMoreResults = true;
    });

    try {
      final client = Matrix.of(context).client;
      if (!GifApi.hasApiKey(client)) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage =
              'API key required to search GIFs. Configure an API key in Settings.';
        });
        return;
      }
      final response = await GifApi.searchGifs(query, client: client);
      setState(() {
        gifs = response.results;
        isLoading = false;
        _nextPos = response.results.length + _nextPos;
        _hasMoreResults = response.results.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadMoreGifs() async {
    if (_isLoadingMore || !_hasMoreResults || isLoading || _nextPos == 0) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final client = Matrix.of(context).client;
      final response = searchFilter?.isNotEmpty == true
          ? await GifApi.searchGifs(
              searchFilter!,
              pos: _nextPos,
              client: client,
            )
          : await GifApi.getFeaturedGifs(pos: _nextPos, client: client);

      setState(() {
        gifs.addAll(response.results);
        _nextPos = response.results.length + _nextPos;
        _hasMoreResults = response.results.isNotEmpty;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() => searchFilter = query);
      if (query.trim().isEmpty) {
        _loadFeaturedGifs();
      } else {
        _searchGifs(query);
      }
    });
  }

  Widget _buildGifTile(GifItem gif, ThemeData theme) {
    final isFav = GifFavorites.isFavorite(gif, favoriteGifs);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onSelected(gif),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                (gif.previewUrl.toLowerCase().endsWith('.mp4') ||
                        gif.previewUrl.toLowerCase().endsWith('.webm') ||
                        gif.previewUrl.toLowerCase().endsWith('.webmd'))
                    ? InlineMediaEmbedWidget(url: gif.previewUrl)
                    : Image.network(
                        gif.previewUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.broken_image,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),

                Positioned(
                  top: 4,
                  left: 4,
                  child: InkWell(
                    onTap: () => _toggleFavorite(gif),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.star : Icons.star_border,
                        color: isFav ? Colors.amber : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'GIF',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasApiKey = GifApi.hasApiKey(Matrix.of(context).client);

    return DefaultTabController(
      length: 2,
      initialIndex: hasApiKey ? 0 : 1,
      child: Scaffold(
        backgroundColor: theme.colorScheme.onInverseSurface,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Material(
            color: theme.colorScheme.surface,
            child: TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              tabs: [
                Tab(
                  icon: const Icon(Icons.grid_view_rounded, size: 20),
                  text: L10n.of(context).gifs,
                ),
                const Tab(
                  icon: Icon(Icons.star_rounded, size: 20),
                  text: 'Favorites',
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            AbsorbPointer(
              absorbing: widget.isSending,
              child: TabBarView(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        scrolledUnderElevation: 0,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        title: SizedBox(
                          height: 42,
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: L10n.of(context).search,
                              prefixIcon: const Icon(Icons.search_outlined),
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: _onSearchChanged,
                          ),
                        ),
                      ),
                      if (isLoading && gifs.isEmpty)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (hasError)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  L10n.of(context).oopsSomethingWentWrong,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  errorMessage ?? '',
                                  style: theme.textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    if (searchFilter?.isNotEmpty == true) {
                                      _searchGifs(searchFilter!);
                                    } else {
                                      _loadFeaturedGifs();
                                    }
                                  },
                                  child: Text(L10n.of(context).tryAgain),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (gifs.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.gif_box_outlined,
                                  size: 64,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  L10n.of(context).nothingFound,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width > 600
                                      ? 3
                                      : 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 1.0,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              if (index >= gifs.length) {
                                return const SizedBox.shrink();
                              }
                              return _buildGifTile(gifs[index], theme);
                            }, childCount: gifs.length),
                          ),
                        ),
                      if (_isLoadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ),

                  if (isLoadingFavorites)
                    const Center(child: CircularProgressIndicator())
                  else if (favoriteGifs.isEmpty)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_border_rounded,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorite GIFs yet',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Star GIFs in the search tab to save them here.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 600
                            ? 3
                            : 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: favoriteGifs.length,
                      itemBuilder: (context, index) {
                        return _buildGifTile(favoriteGifs[index], theme);
                      },
                    ),
                ],
              ),
            ),

            if (widget.isSending)
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
