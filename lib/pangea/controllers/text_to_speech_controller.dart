import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:http/http.dart';

import '../network/requests.dart';

class TextToSpeechRequest {
  String text;
  String langCode;

  TextToSpeechRequest({required this.text, required this.langCode});

  Map<String, dynamic> toJson() => {
        ModelKey.text: text,
        ModelKey.langCode: langCode,
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

  TextToSpeechResponse({
    required this.audioContent,
    required this.mimeType,
    required this.durationMillis,
    required this.waveform,
    required this.fileExtension,
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
      );
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
