import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';

class LanguageDetectionRequest {
  List<LanguageDetection> detections;
  String fullText;

  LanguageDetectionRequest({
    required this.detections,
    required this.fullText,
  });

  factory LanguageDetectionRequest.fromJson(Map<String, dynamic> json) {
    return LanguageDetectionRequest(
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
