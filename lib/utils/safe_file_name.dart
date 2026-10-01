// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

/// Maximum length in UTF-8 bytes for a file name produced by
/// [safeCacheFileName].
///
/// Most file systems limit a single path component to 255 bytes; the margin
/// below that leaves room for suffixes callers may append (e.g. `.caf`).
const int maxCacheFileNameBytes = 200;

/// Builds a file name for caching a downloaded attachment in the temp
/// directory that is guaranteed to fit into [maxCacheFileNameBytes] UTF-8
/// bytes.
///
/// Both [encodedMxcId] (the URI-encoded last segment of the attachment's mxc
/// URL) and [attachmentName] can be arbitrarily long. Concatenating them
/// directly used to exceed the OS file name limit and crash with
/// `FileSystemException: File name too long (errno = 36)`.
/// See https://github.com/krille-chan/fluffychat/issues/874
String safeCacheFileName(String encodedMxcId, String attachmentName) {
  final name = '${encodedMxcId}_$attachmentName';
  if (utf8.encode(name).length <= maxCacheFileNameBytes) return name;

  // Preserve the attachment's file extension so the cached file keeps a
  // usable type.
  final dotIndex = attachmentName.lastIndexOf('.');
  final extension =
      dotIndex > 0 ? attachmentName.substring(dotIndex) : '';
  final budget = maxCacheFileNameBytes - utf8.encode(extension).length;
  if (budget <= 0) {
    // The extension alone does not fit; drop it and truncate the name.
    return _truncateUtf8(name, maxCacheFileNameBytes);
  }
  return '${_truncateUtf8(name, budget)}$extension';
}

/// Truncates [s] so that its UTF-8 encoding is at most [maxBytes] long,
/// without splitting a multi-byte character.
String _truncateUtf8(String s, int maxBytes) {
  final bytes = utf8.encode(s);
  if (bytes.length <= maxBytes) return s;
  var end = maxBytes;
  // Step back over UTF-8 continuation bytes (10xxxxxx) so no character is
  // split in half.
  while (end > 0 && (bytes[end] & 0xC0) == 0x80) {
    end--;
  }
  return utf8.decode(bytes.sublist(0, end));
}
