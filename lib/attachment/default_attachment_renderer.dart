// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/pages/chat/events/message_download_content.dart';
import 'package:fluffychat/pages/chat/events/pdf/pdf_bubble.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'attachment_renderer.dart';
import 'attachment_style.dart';

class DefaultAttachmentRenderer extends AttachmentRenderer {
  const DefaultAttachmentRenderer();

  // pdfx native renderers: Android (PdfRenderer), iOS/macOS (PDFKit),
  // Windows (pdfium). Linux has no bundled pdfium. Web requires a CDN
  // pdf.js that is unreliable in air-gapped / encrypted-content flows.
  static bool get _pdfxSupported =>
      !PlatformInfos.isLinux && !PlatformInfos.isWeb;

  @override
  Widget build(BuildContext context, Event event, AttachmentStyle style) {
    final mimetype = event.content
        .tryGetMap<String, Object?>('info')
        ?.tryGet<String>('mimetype');

    if (mimetype == 'application/pdf' && _pdfxSupported) {
      return PdfBubble(event: event, style: style);
    }

    return MessageDownloadContent(
      event,
      textColor: style.textColor,
      linkColor: style.linkColor,
    );
  }
}
