import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/tenor_api.dart';

class GifPickerDialog extends StatefulWidget {
  final void Function(TenorGif) onSelected;

  const GifPickerDialog({
    required this.onSelected,
    super.key,
  });

  @override
  GifPickerDialogState createState() => GifPickerDialogState();
}

class GifPickerDialogState extends State<GifPickerDialog> {
  String? searchFilter;
  List<TenorGif> gifs = [];
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;
  Timer? _debounceTimer;
  final ScrollController _scrollController = ScrollController();
  String _nextPos = '0';
  bool _hasMoreResults = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFeaturedGifs();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
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
      _nextPos = '0';
      _hasMoreResults = true;
    });

    try {
      final response = await TenorApi.getFeaturedGifs();
      setState(() {
        gifs = response.results;
        isLoading = false;
        _nextPos = response.next;
        _hasMoreResults = response.next != '0' && response.results.isNotEmpty;
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
      _nextPos = '0';
      _hasMoreResults = true;
    });

    try {
      final response = await TenorApi.searchGifs(query);
      setState(() {
        gifs = response.results;
        isLoading = false;
        _nextPos = response.next;
        _hasMoreResults = response.next != '0' && response.results.isNotEmpty;
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
    if (_isLoadingMore || !_hasMoreResults || isLoading || _nextPos == '0')
      return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = searchFilter?.isNotEmpty == true
          ? await TenorApi.searchGifs(searchFilter!, pos: _nextPos)
          : await TenorApi.getFeaturedGifs(pos: _nextPos);

      setState(() {
        gifs.addAll(response.results);
        _nextPos = response.next;
        _hasMoreResults = response.next != '0' && response.results.isNotEmpty;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        // Don't disable _hasMoreResults on error, allow retry
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.onInverseSurface,
      body: SizedBox(
        width: double.maxFinite,
        child: CustomScrollView(
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
                child: Center(
                  child: CircularProgressIndicator(),
                ),
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
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= gifs.length) {
                        return const SizedBox.shrink();
                      }

                      final gif = gifs[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => widget.onSelected(gif),
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    gif.previewUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: theme.colorScheme
                                            .surfaceContainerHighest,
                                        child: Icon(
                                          Icons.broken_image,
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      );
                                    },
                                  ),
                                  // GIF indicator
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 2.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.7),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        'GIF',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (gif.title.isNotEmpty)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black
                                                  .withValues(alpha: 0.7),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          gif.title,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: gifs.length,
                  ),
                ),
              ),
            if (_isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
