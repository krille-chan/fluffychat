// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:universal_html/universal_html.dart' as web;

Future<XFile> webToXFile(web.File file) async {
  final reader = web.FileReader();
  final completer = Completer<Uint8List>();

  reader.onLoad.listen((_) {
    completer.complete(reader.result as Uint8List);
  });
  reader.readAsArrayBuffer(file);

  final bytes = await completer.future;

  return XFile(
    file.relativePath ?? file.name,
    name: file.name,
    mimeType: file.type,
    bytes: bytes,
  );
}
