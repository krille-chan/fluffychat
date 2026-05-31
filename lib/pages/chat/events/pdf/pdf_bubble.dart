// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:fluffychat/attachment/attachment_style.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/events/pdf/pdf_cache.dart';
import 'package:fluffychat/pages/chat/events/pdf/pdf_viewer_screen.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:pdfx/pdfx.dart';

class PdfBubble extends StatefulWidget {
  final Event event;
  final AttachmentStyle style;

  const PdfBubble({required this.event, required this.style, super.key});

  @override
  State<PdfBubble> createState() => _PdfBubbleState();
}

enum _Status { idle, ready, error }

class _PdfBubbleState extends State<PdfBubble>
    with AutomaticKeepAliveClientMixin {
  _Status _status = _Status.idle;
  PdfController? _controller;
  String? _cachedPath;
  String? _thumbnailPath;
  bool _isLoading = false;

  // Keep the loaded PDF alive when it scrolls off-screen.
  // AutomaticKeepAliveClientMixin + wantKeepAlive replaces any need for a
  // static controller cache — the controller stays alive in memory for the
  // lifetime of the ListView's scroll view.
  @override
  bool get wantKeepAlive => _status == _Status.ready;

  @override
  void initState() {
    super.initState();
    _loadThumbnailIfCached();
  }

  @override
  void didUpdateWidget(PdfBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.eventId != widget.event.eventId) {
      _controller?.dispose();
      _controller = null;
      _cachedPath = null;
      _thumbnailPath = null;
      _isLoading = false;
      _status = _Status.idle;
      updateKeepAlive();
      _loadThumbnailIfCached();
    }
  }

  // Check for a previously generated thumbnail (survives app restarts).
  Future<void> _loadThumbnailIfCached() async {
    final thumbFile = await PdfCache.thumbnailFile(widget.event.eventId);
    if (!mounted) return;
    if (thumbFile.existsSync()) {
      setState(() => _thumbnailPath = thumbFile.path);
    }
  }

  // Render the first PDF page to a small JPEG and cache it to disk.
  // Called fire-and-forget — failures are swallowed so they never affect
  // the main load flow.
  Future<void> _generateThumbnail(String pdfPath, String eventId) async {
    try {
      final thumbFile = await PdfCache.thumbnailFile(eventId);

      // If the thumbnail already exists from a previous run, surface it.
      if (thumbFile.existsSync()) {
        if (mounted && _thumbnailPath == null) {
          setState(() => _thumbnailPath = thumbFile.path);
        }
        return;
      }

      final doc = await PdfDocument.openFile(pdfPath);
      try {
        final page = await doc.getPage(1);
        try {
          if (page.width <= 0) return;

          const thumbWidth = 200.0;
          final thumbHeight = page.height * thumbWidth / page.width;

          final image = await page.render(
            width: thumbWidth,
            height: thumbHeight,
            format: PdfPageImageFormat.jpeg,
            backgroundColor: '#ffffff',
          );

          if (image != null) {
            await thumbFile.writeAsBytes(image.bytes);
            if (mounted) setState(() => _thumbnailPath = thumbFile.path);
          }
        } finally {
          await page.close();
        }
      } finally {
        await doc.close();
      }
    } catch (_) {
      // Thumbnail is best-effort. Never surface this error.
    }
  }

  Future<void> _load() async {
    if (_isLoading || _status == _Status.ready) return;
    _isLoading = true;

    final event = widget.event;
    final fileSize = event.infoMap['size'] as int?;

    if (fileSize != null && fileSize > PdfCache.maxFileSizeForInlinePreview) {
      _isLoading = false;
      if (context.mounted) await event.saveFile(context);
      return;
    }

    try {
      // Compute path once — avoids TOCTOU between an isCached check and use.
      final file = await PdfCache.cacheFile(event.eventId);
      if (!mounted) return;

      if (!file.existsSync()) {
        final result = await showFutureLoadingDialog<MatrixFile>(
          context: context,
          futureWithProgress: (onProgress) =>
              event.downloadAndDecryptAttachment(
                onDownloadProgress: fileSize == null
                    ? null
                    : (bytes) => onProgress(bytes / fileSize),
              ),
        );
        if (!context.mounted) return;
        final matrixFile = result.result;
        if (matrixFile == null) {
          setState(() => _isLoading = false);
          return;
        }
        await file.writeAsBytes(matrixFile.bytes);
      }

      if (!mounted) return;

      // Generate thumbnail in background — does not block opening the viewer.
      _generateThumbnail(file.path, event.eventId).ignore();

      final document = await PdfDocument.openFile(file.path);
      if (!mounted) return;
      final controller = PdfController(document: Future.value(document));
      setState(() {
        _cachedPath = file.path;
        _controller = controller;
        _status = _Status.ready;
        _isLoading = false;
      });
      updateKeepAlive();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = _Status.error;
        _isLoading = false;
      });
    }
  }

  void _openFullscreen() {
    final path = _cachedPath;
    if (path == null) return;
    showDialog(
      context: context,
      builder: (_) => PdfViewerScreen(filePath: path, event: widget.event),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    return switch (_status) {
      _Status.idle => _PdfIdleView(
        event: widget.event,
        style: widget.style,
        onTap: _isLoading ? null : _load,
        thumbnailPath: _thumbnailPath,
      ),
      _Status.ready => RepaintBoundary(
        child: _PdfReadyView(
          controller: _controller!,
          style: widget.style,
          onTap: _openFullscreen,
        ),
      ),
      _Status.error => _PdfIdleView(
        event: widget.event,
        style: widget.style,
        onTap: () => widget.event.saveFile(context),
        isError: true,
      ),
    };
  }
}

class _PdfIdleView extends StatelessWidget {
  final Event event;
  final AttachmentStyle style;
  final VoidCallback? onTap;
  final bool isError;
  final String? thumbnailPath;

  const _PdfIdleView({
    required this.event,
    required this.style,
    required this.onTap,
    this.isError = false,
    this.thumbnailPath,
  });

  @override
  Widget build(BuildContext context) {
    final filename = event.content.tryGet<String>('filename') ?? event.body;
    final sizeString = event.sizeString ?? '?MB';
    final textColor = style.textColor;
    final thumb = thumbnailPath;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
        onTap: onTap,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              // Thumbnail when cached; generic icon otherwise.
              if (thumb != null && !isError)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.file(
                    File(thumb),
                    width: 40,
                    height: 56,
                    fit: BoxFit.cover,
                    // Decode at display size to avoid holding a 200 px bitmap
                    // in memory for a 40 px slot.
                    cacheWidth: 40,
                    // Fall back to icon if the thumbnail file is corrupted.
                    errorBuilder: (_, e, s) =>
                        _PdfIcon(textColor: textColor, isError: isError),
                  ),
                )
              else
                _PdfIcon(textColor: textColor, isError: isError),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filename,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$sizeString | PDF',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: textColor, fontSize: 10),
                    ),
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

class _PdfIcon extends StatelessWidget {
  final Color textColor;
  final bool isError;

  const _PdfIcon({required this.textColor, required this.isError});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: textColor.withAlpha(32),
      child: Icon(
        isError ? Icons.file_download_outlined : Icons.picture_as_pdf_outlined,
        color: textColor,
      ),
    );
  }
}

class _PdfReadyView extends StatelessWidget {
  final PdfController controller;
  final AttachmentStyle style;
  final VoidCallback onTap;

  const _PdfReadyView({
    required this.controller,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // opaque ensures taps register even if pdfx internals absorb pointer
      // events from the frozen-physics PdfView.
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: style.borderRadius,
        child: SizedBox(
          width: 300,
          height: 300,
          // NeverScrollableScrollPhysics prevents the inline PDF from
          // consuming vertical scroll events and fighting the chat ListView.
          child: PdfView(
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
