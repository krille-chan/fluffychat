//TODO move baseAPI addition to request function

import 'package:fluffychat/pangea/common/config/environment.dart';

/// autodocs
/// https://api.staging.pangea.chat/choreo/docs
/// username: admin
/// password: admin
///
/// https://api.staging.pangea.chat/api/v1/
class PApiUrls {
  static const String _choreoPrefix = "/choreo";
  static const String _subscriptionPrefix = "/subscription";

  static String get _choreoEndpoint =>
      "${Environment.choreoApi}${PApiUrls._choreoPrefix}";
  static String get _subscriptionEndpoint =>
      "${Environment.choreoApi}${PApiUrls._subscriptionPrefix}";

  ///  ---------------------- Util --------------------------------------
  static String appVersion = "${PApiUrls._choreoEndpoint}/version";

  ///   ---------------------- Languages --------------------------------------
  /// CMS REST API endpoint for languages (public, no auth required)
  static String cmsLanguages = "${Environment.cmsApi}/cms/api/languages";

  ///   ---------------------- Users --------------------------------------
  static String paymentLink = "${PApiUrls._subscriptionEndpoint}/payment_link";

  static String languageDetection =
      "${PApiUrls._choreoEndpoint}/language_detection";

  static String igcLite = "${PApiUrls._choreoEndpoint}/grammar_v2";

  static String simpleTranslation =
      "${PApiUrls._choreoEndpoint}/translation/direct";
  static String tokenize = "${PApiUrls._choreoEndpoint}/tokenize";

  static String textToSpeech = "${PApiUrls._choreoEndpoint}/text_to_speech";
  static String speechToText = "${PApiUrls._choreoEndpoint}/speech_to_text";
  static String phoneticTranscriptionV2 =
      "${PApiUrls._choreoEndpoint}/phonetic_transcription_v2";

  static String messageActivityGeneration =
      "${PApiUrls._choreoEndpoint}/practice";

  static String lemmaDictionary =
      "${PApiUrls._choreoEndpoint}/lemma_definition";
  static String morphDictionary = "${PApiUrls._choreoEndpoint}/morph_meaning";

  static String activitySummary =
      "${PApiUrls._choreoEndpoint}/activity_summary";

  static String activityFeedback =
      "${PApiUrls._choreoEndpoint}/activity_plan/feedback";

  static String tokenFeedback = "${PApiUrls._choreoEndpoint}/token/feedback";
  static String tokenFeedbackV2 =
      "${PApiUrls._choreoEndpoint}/token/feedback_v2";

  static String morphFeaturesAndTags = "${PApiUrls._choreoEndpoint}/morphs";

  ///--------------------------- course translations ---------------------------
  static String getLocalizedCourse =
      "${PApiUrls._choreoEndpoint}/course_plans/localize";
  static String getLocalizedTopic =
      "${PApiUrls._choreoEndpoint}/topics/localize";
  static String getLocalizedActivity =
      "${PApiUrls._choreoEndpoint}/activity_plan/localize";

  ///-------------------------------- revenue cat --------------------------
  static String rcAppsChoreo = "${PApiUrls._subscriptionEndpoint}/app_ids";
  static String rcProductsChoreo =
      "${PApiUrls._subscriptionEndpoint}/all_products";
  static String rcProductsTrial =
      "${PApiUrls._subscriptionEndpoint}/free_trial";

  static String rcSubscription = PApiUrls._subscriptionEndpoint;
}
