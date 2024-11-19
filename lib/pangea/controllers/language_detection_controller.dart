import 'dart:async';
import 'dart:convert';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/language_detection_model.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:http/http.dart' as http;

import '../network/requests.dart';

class LanguageDetectionRequest {
  /// The full text from which to detect the language.
  String fullText;

  /// The base language of the user that sent the meessage, if known. Including this is much preferred
  /// and should return better results; however, it is not absolutely necessary.
  /// This property is nullable to allow for situations where the languages are not set
  /// at the time of the request.
  String? senderL1;

  /// The target language of the user that sent the message. This is expected to be set for the request
  /// but is nullable to handle edge cases where it might not be.
  String? senderL2;

  LanguageDetectionRequest({
    required this.fullText,
    required this.senderL1,
    required this.senderL2,
  });

  Map<String, dynamic> toJson() => {
        'full_text': fullText,
        'sender_l1': senderL1,
        'sender_l2': senderL2,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageDetectionRequest &&
        other.fullText == fullText &&
        other.senderL1 == senderL1 &&
        other.senderL2 == senderL2;
  }

  @override
  int get hashCode => fullText.hashCode ^ senderL1.hashCode ^ senderL2.hashCode;
}

class LanguageDetectionResponse {
  List<LanguageDetection> detections;
  String fullText;

  LanguageDetectionResponse({
    required this.detections,
    required this.fullText,
  });

  factory LanguageDetectionResponse.fromJson(Map<String, dynamic> json) {
    return LanguageDetectionResponse(
      detections: List<LanguageDetection>.from(
        (json['detections'] as Iterable).map(
          (e) => LanguageDetection.fromJson(e),
        ),
      ),
      fullText: json['full_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detections': detections.map((e) => e.toJson()).toList(),
      'full_text': fullText,
    };
  }

  /// Return the highest confidence detection.
  /// If there are no detections, the unknown language detection is returned.
  LanguageDetection get highestConfidenceDetection {
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    return detections.firstOrNull ?? unknownLanguageDetection;
  }

  static const double languageDetectionConfidenceThreshold = 0.95;

  /// Returns the highest validated detection based on the confidence threshold.
  /// If the highest confidence detection is below the threshold, the unknown language
  /// detection is returned.
  LanguageDetection highestValidatedDetection({double? threshold}) =>
      highestConfidenceDetection.confidence >=
              (threshold ?? languageDetectionConfidenceThreshold)
          ? highestConfidenceDetection
          : unknownLanguageDetection;
}

class _LanguageDetectionCacheItem {
  Future<LanguageDetectionResponse> data;

  _LanguageDetectionCacheItem({
    required this.data,
  });
}

class LanguageDetectionController {
  static final Map<LanguageDetectionRequest, _LanguageDetectionCacheItem>
      _cache = {};
  late final PangeaController _pangeaController;
  Timer? _cacheClearTimer;

  LanguageDetectionController(PangeaController pangeaController) {
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

  Future<LanguageDetectionResponse> get(
    LanguageDetectionRequest params,
  ) async {
    if (_cache.containsKey(params)) {
      return _cache[params]!.data;
    } else {
      final Future<LanguageDetectionResponse> response = _fetchResponse(
        _pangeaController.userController.accessToken,
        params,
      );
      _cache[params] = _LanguageDetectionCacheItem(data: response);
      return response;
    }
  }

  static Future<LanguageDetectionResponse> _fetchResponse(
    String accessToken,
    LanguageDetectionRequest params,
  ) async {
    final Requests request = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final http.Response res = await request.post(
      url: PApiUrls.languageDetection,
      body: params.toJson(),
    );

    final Map<String, dynamic> json = jsonDecode(res.body);
    return LanguageDetectionResponse.fromJson(json);
  }
}
