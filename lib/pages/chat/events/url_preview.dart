// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/gif_api.dart';
import 'package:fluffychat/utils/gif_favorites.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'message_content.dart';

class UrlPreviewWidget extends StatefulWidget {
  final String url;
  final Client client;

  const UrlPreviewWidget({required this.url, required this.client, super.key});

  @override
  State<UrlPreviewWidget> createState() => _UrlPreviewWidgetState();
}

class _UrlPreviewWidgetState extends State<UrlPreviewWidget>
    with AutomaticKeepAliveClientMixin {
  String? _title;
  String? _description;
  String? _imageUrl;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isFav = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    _fetchPreview();
  }

  Future<void> _checkFavorite() async {
    try {
      final favs = await GifFavorites.getFavorites(client: widget.client);
      final item = GifItem(
        id: widget.url,
        title: _title ?? widget.url,
        url: widget.url,
        embedUrl: widget.url,
        previewUrl: _imageUrl ?? widget.url,
        width: 0,
        height: 0,
      );
      final isFav = GifFavorites.isFavorite(item, favs);
      if (mounted) {
        setState(() => _isFav = isFav);
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    try {
      final item = GifItem(
        id: widget.url,
        title: _title ?? widget.url,
        url: widget.url,
        embedUrl: widget.url,
        previewUrl: _imageUrl ?? widget.url,
        width: 0,
        height: 0,
      );
      final updated = await GifFavorites.toggleFavorite(
        item,
        client: widget.client,
      );
      if (mounted) {
        setState(() {
          _isFav = GifFavorites.isFavorite(item, updated);
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchPreview() async {
    try {
      final uri = Uri.tryParse(widget.url);
      if (uri != null) {
        final previewData = await widget.client.getUrlPreview(uri);
        final json = previewData.toJson();
        final title = json['og:title']?.toString() ?? json['title']?.toString();
        final description =
            json['og:description']?.toString() ??
            json['description']?.toString();
        final imageStr =
            json['og:image']?.toString() ?? json['og:video']?.toString();

        String? imageResolved;
        if (imageStr != null && imageStr.isNotEmpty) {
          if (imageStr.startsWith('mxc://')) {
            final mxcUri = Uri.tryParse(imageStr);
            if (mxcUri != null) {
              imageResolved = mxcUri.getDownloadUri(widget.client).toString();
            }
          } else {
            imageResolved = imageStr;
          }
        }

        if (mounted && (title != null || imageResolved != null)) {
          setState(() {
            _title = title;
            _description = description;
            _imageUrl = imageResolved;
            _isLoading = false;
          });
          _checkFavorite();
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        height: 60,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading preview...', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    if (_hasError || (_title == null && _imageUrl == null)) {
      return const SizedBox.shrink();
    }

    final lowerUrl = widget.url.toLowerCase();
    final isMediaUrl =
        lowerUrl.contains('.gif') ||
        lowerUrl.contains('.mp4') ||
        lowerUrl.contains('.webm') ||
        lowerUrl.contains('.webmd') ||
        lowerUrl.contains('.png') ||
        lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.webp') ||
        lowerUrl.contains('giphy.com') ||
        lowerUrl.contains('klipy.co') ||
        lowerUrl.contains('tenor.com');

    if (isMediaUrl && _imageUrl != null && _imageUrl!.isNotEmpty) {
      final isVideo =
          _imageUrl!.toLowerCase().contains('.mp4') ||
          _imageUrl!.toLowerCase().contains('.webm') ||
          _imageUrl!.toLowerCase().contains('.webmd');

      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 250),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                isVideo
                    ? InlineMediaEmbedWidget(url: _imageUrl!)
                    : Image.network(
                        _imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150,
                            color: Colors.black12,
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        },
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: InkWell(
                    onTap: _toggleFavorite,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFav ? Icons.star : Icons.star_border,
                        color: _isFav ? Colors.amber : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => UrlLauncher(context, widget.url).launchUrl(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_imageUrl != null && _imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    width: double.infinity,
                    child: Image.network(
                      _imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_title != null && _title!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Text(
                          _title!,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (_description != null && _description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
