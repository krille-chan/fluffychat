// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'dart:typed_data';

/// Rewrites the Ogg container of an Ogg Opus file without re-encoding the
/// audio. Android's `MediaMuxer` writes Ogg files with wrong granule
/// positions and without an end-of-stream page, which some players (e.g.
/// Firefox and WhatsApp) refuse to play. This produces a RFC 7845 compliant
/// file from the same Opus packets.
///
/// Returns the original bytes if the input can not be parsed.
Uint8List remuxOggOpus(Uint8List input, {String vendor = 'FluffyChat'}) {
  try {
    final packets = _readOggPackets(input);
    if (packets.isEmpty || !_startsWith(packets.first, 'OpusHead')) {
      return input;
    }
    final opusHead = packets.first;
    final audioPackets = packets
        .skip(1)
        .where(
          (p) =>
              p.isNotEmpty &&
              !_startsWith(p, 'OpusTags') &&
              !_startsWith(p, 'OpusHead'),
        )
        .toList();
    if (audioPackets.isEmpty) return input;

    final writer = _OggWriter(serial: _serialFromHead(input));
    writer.writePage([opusHead], granulePosition: 0, bos: true);
    writer.writePage([_opusTags(vendor)], granulePosition: 0);

    var granulePosition = 0;
    final pagePackets = <Uint8List>[];
    var pageSegments = 0;
    var pageBytes = 0;

    for (var i = 0; i < audioPackets.length; i++) {
      final packet = audioPackets[i];
      final segments = packet.length ~/ 255 + 1;
      if (pagePackets.isNotEmpty &&
          (pageSegments + segments > 255 ||
              pageBytes + packet.length > _maxPageBodySize)) {
        writer.writePage(pagePackets, granulePosition: granulePosition);
        pagePackets.clear();
        pageSegments = 0;
        pageBytes = 0;
      }
      pagePackets.add(packet);
      pageSegments += segments;
      pageBytes += packet.length;
      granulePosition += _opusPacketSamples(packet);
    }
    writer.writePage(pagePackets, granulePosition: granulePosition, eos: true);

    return writer.takeBytes();
  } catch (_) {
    return input;
  }
}

const _maxPageBodySize = 4096;

/// Reads all packets of the first logical bitstream.
List<Uint8List> _readOggPackets(Uint8List data) {
  final view = ByteData.sublistView(data);
  final packets = <Uint8List>[];
  final current = BytesBuilder(copy: false);
  int? serial;
  var offset = 0;

  while (offset + 27 <= data.length) {
    if (!_startsWith(data, 'OggS', offset)) {
      throw const FormatException('Missing Ogg capture pattern');
    }
    final pageSerial = view.getUint32(offset + 14, Endian.little);
    final segmentCount = data[offset + 26];
    final segmentTableStart = offset + 27;
    var bodyOffset = segmentTableStart + segmentCount;
    if (bodyOffset > data.length) {
      throw const FormatException('Truncated Ogg page');
    }
    serial ??= pageSerial;

    for (var i = 0; i < segmentCount; i++) {
      final length = data[segmentTableStart + i];
      if (bodyOffset + length > data.length) {
        throw const FormatException('Truncated Ogg page');
      }
      if (pageSerial == serial) {
        current.add(
          Uint8List.sublistView(data, bodyOffset, bodyOffset + length),
        );
        if (length < 255) packets.add(current.takeBytes());
      }
      bodyOffset += length;
    }
    offset = bodyOffset;
  }
  return packets;
}

int _serialFromHead(Uint8List data) =>
    ByteData.sublistView(data).getUint32(14, Endian.little);

/// Number of 48 kHz samples in an Opus packet, see RFC 6716 section 3.1.
int _opusPacketSamples(Uint8List packet) {
  final toc = packet[0];
  final config = toc >> 3;
  final int frameSize;
  if (config < 12) {
    // SILK-only: 10, 20, 40, 60 ms
    frameSize = const [480, 960, 1920, 2880][config & 3];
  } else if (config < 16) {
    // Hybrid: 10, 20 ms
    frameSize = (config & 1) == 0 ? 480 : 960;
  } else {
    // CELT-only: 2.5, 5, 10, 20 ms
    frameSize = const [120, 240, 480, 960][config & 3];
  }
  final int frameCount;
  switch (toc & 3) {
    case 0:
      frameCount = 1;
    case 1:
    case 2:
      frameCount = 2;
    default:
      if (packet.length < 2) throw const FormatException('Invalid Opus packet');
      frameCount = packet[1] & 0x3F;
  }
  return frameSize * frameCount;
}

Uint8List _opusTags(String vendor) {
  final vendorBytes = utf8.encode(vendor);
  final bytes = BytesBuilder()
    ..add(ascii.encode('OpusTags'))
    ..add(_uint32(vendorBytes.length))
    ..add(vendorBytes)
    ..add(_uint32(0));
  return bytes.takeBytes();
}

Uint8List _uint32(int value) =>
    (ByteData(4)..setUint32(0, value, Endian.little)).buffer.asUint8List();

bool _startsWith(Uint8List data, String magic, [int offset = 0]) {
  if (data.length < offset + magic.length) return false;
  for (var i = 0; i < magic.length; i++) {
    if (data[offset + i] != magic.codeUnitAt(i)) return false;
  }
  return true;
}

class _OggWriter {
  final int serial;
  final BytesBuilder _output = BytesBuilder(copy: false);
  int _sequence = 0;

  _OggWriter({required this.serial});

  /// Writes complete packets into a single page.
  void writePage(
    List<Uint8List> packets, {
    required int granulePosition,
    bool bos = false,
    bool eos = false,
  }) {
    final segmentTable = <int>[];
    for (final packet in packets) {
      segmentTable.addAll(List.filled(packet.length ~/ 255, 255));
      segmentTable.add(packet.length % 255);
    }
    if (segmentTable.length > 255) {
      throw const FormatException('Too many segments for one Ogg page');
    }

    final header = ByteData(27 + segmentTable.length);
    for (var i = 0; i < 4; i++) {
      header.setUint8(i, 'OggS'.codeUnitAt(i));
    }
    header.setUint8(4, 0); // version
    header.setUint8(5, (bos ? 0x02 : 0) | (eos ? 0x04 : 0));
    // Split into two 32 bit values as setInt64 is not supported on web.
    header.setUint32(6, granulePosition & 0xFFFFFFFF, Endian.little);
    header.setUint32(10, granulePosition ~/ 0x100000000, Endian.little);
    header.setUint32(14, serial, Endian.little);
    header.setUint32(18, _sequence++, Endian.little);
    header.setUint32(22, 0, Endian.little); // CRC, filled in below
    header.setUint8(26, segmentTable.length);
    for (var i = 0; i < segmentTable.length; i++) {
      header.setUint8(27 + i, segmentTable[i]);
    }

    final page =
        (BytesBuilder(copy: false)
              ..add(header.buffer.asUint8List())
              ..add(packets.expand((p) => p).toList()))
            .takeBytes();
    ByteData.sublistView(page).setUint32(22, _crc32(page), Endian.little);
    _output.add(page);
  }

  Uint8List takeBytes() => _output.takeBytes();
}

/// CRC-32 as used by Ogg: polynomial 0x04c11db7, no reflection, init 0.
int _crc32(Uint8List data) {
  var crc = 0;
  for (final byte in data) {
    crc = ((crc << 8) & 0xFFFFFFFF) ^ _crcTable[((crc >> 24) ^ byte) & 0xFF];
  }
  return crc;
}

final _crcTable = List<int>.generate(256, (i) {
  var r = i << 24;
  for (var j = 0; j < 8; j++) {
    r = (r & 0x80000000) != 0 ? ((r << 1) ^ 0x04C11DB7) : (r << 1);
    r &= 0xFFFFFFFF;
  }
  return r;
});
