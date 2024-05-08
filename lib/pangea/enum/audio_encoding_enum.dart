AudioEncodingEnum mimeTypeToAudioEncoding(String mimeType) {
  switch (mimeType) {
    case 'audio/mpeg':
      return AudioEncodingEnum.mp3;
    case 'audio/mp4':
      return AudioEncodingEnum.mp4;
    case 'audio/ogg':
      return AudioEncodingEnum.oggOpus;
    case 'audio/x-flac':
      return AudioEncodingEnum.flac;
    case 'audio/x-wav':
      return AudioEncodingEnum.linear16;
    default:
      return AudioEncodingEnum.encodingUnspecified;
  }
}

enum AudioEncodingEnum {
  encodingUnspecified,
  linear16,
  flac,
  mulaw,
  amr,
  amrWb,
  oggOpus,
  speexWithHeaderByte,
  mp3,
  mp4,
  webmOpus,
}

// Utility extension to map enum values to their corresponding string value as used by the API
extension AudioEncodingExtension on AudioEncodingEnum {
  String get value {
    switch (this) {
      case AudioEncodingEnum.linear16:
        return 'LINEAR16';
      case AudioEncodingEnum.flac:
        return 'FLAC';
      case AudioEncodingEnum.mulaw:
        return 'MULAW';
      case AudioEncodingEnum.amr:
        return 'AMR';
      case AudioEncodingEnum.amrWb:
        return 'AMR_WB';
      case AudioEncodingEnum.oggOpus:
        return 'OGG_OPUS';
      case AudioEncodingEnum.speexWithHeaderByte:
        return 'SPEEX_WITH_HEADER_BYTE';
      case AudioEncodingEnum.mp3:
        return 'MP3';
      case AudioEncodingEnum.mp4:
        return 'MP4';
      case AudioEncodingEnum.webmOpus:
        return 'WEBM_OPUS';
      default:
        return 'ENCODING_UNSPECIFIED';
    }
  }
}
