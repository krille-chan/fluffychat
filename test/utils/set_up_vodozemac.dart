// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:vodozemac/vodozemac.dart' as vod;

Future<void> setUpVodozemac() async {
  if (vod.isInitialized()) return;
  if (!await Directory('./test/rust').exists()) {
    await Process.run('./scripts/prepare_vodozemac.sh', []);
  }
  await vod.init(wasmPath: './pkg/', libraryPath: 'test/rust/target/debug/');
}
