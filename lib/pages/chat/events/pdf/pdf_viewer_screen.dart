// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final Event event;

  const PdfViewerScreen({
    required this.filePath,
    required this.event,
    super.key,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late final PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
      document: PdfDocument.openFile(widget.filePath),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _filename {
    final name =
        widget.event.content.tryGet<String>('filename') ?? widget.event.body;
    return name.endsWith('.pdf') ? name : '$name.pdf';
  }

  Future<void> _save() async {
    final l10n = L10n.of(context);
    final bytes = await File(widget.filePath).readAsBytes();
    if (!mounted) return;
    final savedPath = await FilePicker.saveFile(
      dialogTitle: l10n.saveFile,
      fileName: _filename,
      bytes: bytes,
    );
    if (savedPath == null) return;
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.fileHasBeenSavedAt(savedPath))));
  }

  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(widget.filePath, name: _filename, mimeType: 'application/pdf'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: Navigator.of(context).pop),
        title: Text(_filename, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: l10n.share,
            onPressed: _share,
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: l10n.saveFile,
            onPressed: _save,
          ),
        ],
      ),
      body: PdfViewPinch(
        controller: _controller,
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator.adaptive()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
