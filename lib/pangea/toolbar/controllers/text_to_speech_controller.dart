import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';

class PangeaAudioEventData {
  final String text;
  final String langCode;
  final List<TTSToken> tokens;

  PangeaAudioEventData({
    required this.text,
    required this.langCode,
    required this.tokens,
  });

  factory PangeaAudioEventData.fromJson(dynamic json) => PangeaAudioEventData(
        text: json[ModelKey.text] as String,
        langCode: json[ModelKey.langCode] as String,
        tokens: List<TTSToken>.from(
          (json[ModelKey.tokens] as Iterable)
              .map((x) => TTSToken.fromJson(x))
              .toList(),
        ),
      );

  Map<String, dynamic> toJson() => {
        ModelKey.text: text,
        ModelKey.langCode: langCode,
        ModelKey.tokens:
            List<Map<String, dynamic>>.from(tokens.map((x) => x.toJson())),
      };
}

class TTSToken {
  final int startMS;
  final int endMS;
  final PangeaTokenText text;

  TTSToken({
    required this.startMS,
    required this.endMS,
    required this.text,
  });

  factory TTSToken.fromJson(Map<String, dynamic> json) => TTSToken(
        startMS: json["start_ms"],
        endMS: json["end_ms"],
        text: PangeaTokenText.fromJson(json["text"]),
      );

  Map<String, dynamic> toJson() => {
        "start_ms": startMS,
        "end_ms": endMS,
        "text": text.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TTSToken &&
        other.startMS == startMS &&
        other.endMS == endMS &&
        other.text == text;
  }

  @override
  int get hashCode => startMS.hashCode ^ endMS.hashCode ^ text.hashCode;
}

class TextToSpeechRequest {
  String text;
  String langCode;
  String userL1;
  String userL2;
  List<PangeaTokenText> tokens;

  TextToSpeechRequest({
    required this.text,
    required this.langCode,
    required this.userL1,
    required this.userL2,
    required this.tokens,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.text: text,
        ModelKey.langCode: langCode,
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        ModelKey.tokens: tokens.map((token) => token.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TextToSpeechRequest &&
        other.text == text &&
        other.langCode == langCode;
  }

  @override
  int get hashCode => text.hashCode ^ langCode.hashCode;
}

class TextToSpeechResponse {
  String audioContent;
  String mimeType;
  int durationMillis;
  List<int> waveform;
  String fileExtension;
  List<TTSToken> ttsTokens;

  TextToSpeechResponse({
    required this.audioContent,
    required this.mimeType,
    required this.durationMillis,
    required this.waveform,
    required this.fileExtension,
    required this.ttsTokens,
  });

  factory TextToSpeechResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      TextToSpeechResponse(
        audioContent: json["audio_content"],
        mimeType: json["mime_type"],
        durationMillis: json["duration_millis"],
        waveform: List<int>.from(json["wave_form"]),
        fileExtension: json["file_extension"],
        ttsTokens: List<TTSToken>.from(
          json["tts_tokens"].map((x) => TTSToken.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "audio_content": audioContent,
        "mime_type": mimeType,
        "duration_millis": durationMillis,
        "wave_form": List<dynamic>.from(waveform.map((x) => x)),
        "file_extension": fileExtension,
        "tts_tokens": List<dynamic>.from(ttsTokens.map((x) => x.toJson())),
      };

  PangeaAudioEventData toPangeaAudioEventData(String text, String langCode) {
    return PangeaAudioEventData(
      text: text,
      langCode: langCode,
      tokens: ttsTokens,
    );
  }
}

class _TextToSpeechCacheItem {
  Future<TextToSpeechResponse> data;

  _TextToSpeechCacheItem({
    required this.data,
  });
}

class TextToSpeechController {
  static final Map<TextToSpeechRequest, _TextToSpeechCacheItem> _cache = {};
  late final PangeaController _pangeaController;

  Timer? _cacheClearTimer;

  TextToSpeechController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 15); // Adjust the duration as needed
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => _clearCache());
  }

  void _clearCache() {
    _cache.clear();
  }

  void dispose() {
    _cacheClearTimer?.cancel();
  }

  Future<TextToSpeechResponse> get(
    TextToSpeechRequest params,
  ) async {
    if (_cache.containsKey(params)) {
      return _cache[params]!.data;
    } else {
      final Future<TextToSpeechResponse> response = _fetchResponse(
        _pangeaController.userController.accessToken,
        params,
      );
      _cache[params] = _TextToSpeechCacheItem(data: response);
      return response;
    }
  }

  static Future<TextToSpeechResponse> _fetchResponse(
    String accessToken,
    TextToSpeechRequest params,
  ) async {
    final Requests request = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await request.post(
      url: PApiUrls.textToSpeech,
      body: params.toJson(),
    );

    final Map<String, dynamic> json = jsonDecode(res.body);

    return TextToSpeechResponse.fromJson(json);
  }

  static bool isOggFile(Uint8List bytes) {
    // Check if the file has enough bytes for the header
    if (bytes.length < 4) {
      return false;
    }

    // Check the magic number for OGG file
    return bytes[0] == 0x4F &&
        bytes[1] == 0x67 &&
        bytes[2] == 0x67 &&
        bytes[3] == 0x53;
  }
}
