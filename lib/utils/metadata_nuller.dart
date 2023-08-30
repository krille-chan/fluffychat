import 'dart:typed_data';

const uint32Size = 4;
// 32bits unsigned integers representing mp4 atoms
const ftypAtom = 0x66747970; // 'ftyp'
const metaAtom = 0x6d657461; // 'meta'
const freeAtom = 0x66726565; // 'free'

void metadataNuller(Uint8List file) {
  final blob = ByteData.sublistView(file);
  final bool isMp4Container =
      blob.getUint32(uint32Size, Endian.big) == ftypAtom;
  if (!isMp4Container) {
    return;
  }

  var i = 0;
  while (i < (blob.lengthInBytes - uint32Size) &&
      blob.getUint32(i, Endian.big) != freeAtom) {
    if (blob.getUint32(i, Endian.big) == metaAtom) {
      final size = blob.getUint32(i - uint32Size, Endian.big);
      final offset = i + uint32Size;
      file.fillRange(offset, offset + size, 0);
      break;
    }
    i += 1;
  }
}
