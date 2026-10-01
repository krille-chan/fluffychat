// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:fluffychat/utils/safe_file_name.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('safeCacheFileName', () {
    test('short names are returned unchanged', () {
      expect(
        safeCacheFileName('mxc123', 'video.mp4'),
        'mxc123_video.mp4',
      );
    });

    test('a long mxc id is truncated but keeps the extension', () {
      final result = safeCacheFileName('x' * 300, 'video.mp4');
      expect(utf8.encode(result).length, lessThanOrEqualTo(200));
      expect(result, endsWith('.mp4'));
      // Truncated from the front: the surviving prefix is all mxc id.
      expect(result, startsWith('x' * 100));
    });

    test('a long attachment name is truncated but keeps the extension', () {
      final result = safeCacheFileName('mxc123', '${'a' * 300}.ogg');
      expect(utf8.encode(result).length, lessThanOrEqualTo(200));
      expect(result, endsWith('.ogg'));
    });

    test('names without an extension are truncated plainly', () {
      final result = safeCacheFileName('x' * 150, 'y' * 150);
      expect(utf8.encode(result).length, lessThanOrEqualTo(200));
      // The full input would have been 301 chars; it must have shrunk.
      expect(result.length, lessThan(301));
    });

    test('multi-byte characters are never split', () {
      // '🎬' is 4 bytes in UTF-8; a naive byte cut could split it.
      final result = safeCacheFileName('🎬' * 100, 'namé🎉.mp4');
      final bytes = utf8.encode(result);
      expect(bytes.length, lessThanOrEqualTo(200));
      // Round-trips cleanly: no replacement characters from split surrogates.
      expect(utf8.decode(bytes), result);
      expect(result.contains('\uFFFD'), isFalse);
      expect(result, endsWith('.mp4'));
    });

    test('a very long extension is dropped instead of overflowing', () {
      final result = safeCacheFileName('mxc123', 'a.${'b' * 300}');
      expect(utf8.encode(result).length, lessThanOrEqualTo(200));
    });

    test('issue #874 scenario stays within the OS limit', () {
      // A URI-encoded mxc URL segment plus a long attachment name, like in
      // https://github.com/krille-chan/fluffychat/issues/874
      final fileName = Uri.encodeComponent('a' * 200);
      final result = safeCacheFileName(fileName, '${'b' * 200}.mp4');
      expect(utf8.encode(result).length, lessThanOrEqualTo(200));
      expect(result, endsWith('.mp4'));
    });
  });
}
