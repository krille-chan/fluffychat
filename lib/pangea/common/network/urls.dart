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
  static String getLanguages = "${PApiUrls._choreoEndpoint}/languages_v2";

  ///   ---------------------- Users --------------------------------------
  static String paymentLink = "${PApiUrls._subscriptionEndpoint}/payment_link";

  static String languageDetection =
      "${PApiUrls._choreoEndpoint}/language_detection";

  static String igcLite = "${PApiUrls._choreoEndpoint}/grammar_lite";
  static String spanDetails = "${PApiUrls._choreoEndpoint}/span_details";

  static String simpleTranslation =
      "${PApiUrls._choreoEndpoint}/translation/direct";
  static String tokenize = "${PApiUrls._choreoEndpoint}/tokenize";
  static String contextualDefinition =
      "${PApiUrls._choreoEndpoint}/contextual_definition";

  static String firstStep = "${PApiUrls._choreoEndpoint}/it_initialstep";

  static String textToSpeech = "${PApiUrls._choreoEndpoint}/text_to_speech";
  static String speechToText = "${PApiUrls._choreoEndpoint}/speech_to_text";
  static String phoneticTranscription =
      "${PApiUrls._choreoEndpoint}/phonetic_transcription";

  static String messageActivityGeneration =
      "${PApiUrls._choreoEndpoint}/practice";

  static String lemmaDictionary =
      "${PApiUrls._choreoEndpoint}/lemma_definition";
  static String morphDictionary = "${PApiUrls._choreoEndpoint}/morph_meaning";

  // static String activityPlan = "${PApiUrls._choreoEndpoint}/activity_plan";
  // static String activityPlanGeneration =
  //     "${PApiUrls._choreoEndpoint}/activity_plan/generate";
  // static String activityPlanSearch =
  //     "${PApiUrls._choreoEndpoint}/activity_plan/search";
  // static String activityModeList = "${PApiUrls._choreoEndpoint}/modes";
  // static String objectiveList = "${PApiUrls._choreoEndpoint}/objectives";
  // static String topicList = "${PApiUrls._choreoEndpoint}/topics";

  static String activitySummary =
      "${PApiUrls._choreoEndpoint}/activity_summary";

  static String activityFeedback =
      "${PApiUrls._choreoEndpoint}/activity_plan/feedback";

  static String tokenFeedback = "${PApiUrls._choreoEndpoint}/token/feedback";

  static String morphFeaturesAndTags = "${PApiUrls._choreoEndpoint}/morphs";
  static String constructSummary =
      "${PApiUrls._choreoEndpoint}/construct_summary";

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
