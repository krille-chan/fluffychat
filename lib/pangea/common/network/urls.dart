//TODO move baseAPI addition to request function

import 'package:fluffychat/pangea/common/config/environment.dart';

/// autodocs
/// https://api.staging.pangea.chat/choreo/docs
/// username: admin
/// password: admin
///
/// https://api.staging.pangea.chat/api/v1/
class PApiUrls {
  static String choreoPrefix = "/choreo";
  static String subscriptionPrefix = "/subscription";
  static String accountPrefix = "/account";

  static String choreoEndpoint =
      "${Environment.choreoApi}${PApiUrls.choreoPrefix}";
  static String subscriptionEndpoint =
      "${Environment.choreoApi}${PApiUrls.subscriptionPrefix}";
  static String accountEndpoint =
      "${Environment.choreoApi}${PApiUrls.accountPrefix}";

  ///  ---------------------- Util --------------------------------------
  static String appVersion = "${PApiUrls.choreoEndpoint}/version";

  ///   ---------------------- Languages --------------------------------------
  static String getLanguages = "${PApiUrls.choreoEndpoint}/languages_v2";

  ///   ---------------------- Users --------------------------------------
  static String paymentLink = "${PApiUrls.subscriptionEndpoint}/payment_link";

  ///   ---------------------- Conversation Partner -------------------------
  /// PTODO: Migrate or remove
  static String searchUserProfiles = "${PApiUrls.accountEndpoint}/search";

  ///-------------------------------- choreo --------------------------
  static String igc = "${PApiUrls.choreoEndpoint}/grammar";

  static String languageDetection =
      "${PApiUrls.choreoEndpoint}/language_detection";

  static String igcLite = "${PApiUrls.choreoEndpoint}/grammar_lite";
  static String spanDetails = "${PApiUrls.choreoEndpoint}/span_details";

  static String wordNet = "${PApiUrls.choreoEndpoint}/wordnet";
  static String contextualizedTranslation =
      "${PApiUrls.choreoEndpoint}/translation/contextual";
  static String simpleTranslation =
      "${PApiUrls.choreoEndpoint}/translation/direct";
  static String tokenize = "${PApiUrls.choreoEndpoint}/tokenize";
  static String contextualDefinition =
      "${PApiUrls.choreoEndpoint}/contextual_definition";
  static String similarity = "${PApiUrls.choreoEndpoint}/similarity";
  static String topicInfo = "${PApiUrls.choreoEndpoint}/vocab_list";

  static String itFeedback = "${PApiUrls.choreoEndpoint}/translation/feedback";

  static String firstStep = "${PApiUrls.choreoEndpoint}/it_initialstep";
  static String subseqStep = "${PApiUrls.choreoEndpoint}/it_step";

  static String textToSpeech = "${PApiUrls.choreoEndpoint}/text_to_speech";
  static String speechToText = "${PApiUrls.choreoEndpoint}/speech_to_text";

  static String messageActivityGeneration =
      "${PApiUrls.choreoEndpoint}/practice";

  static String lemmaDictionary = "${PApiUrls.choreoEndpoint}/lemma_definition";
  static String morphDictionary = "${PApiUrls.choreoEndpoint}/morph_meaning";

  static String activityPlanGeneration =
      "${PApiUrls.choreoEndpoint}/activity_plan";
  static String activityModeList = "${PApiUrls.choreoEndpoint}/modes";
  static String objectiveList = "${PApiUrls.choreoEndpoint}/objectives";
  static String topicList = "${PApiUrls.choreoEndpoint}/topics";
  static String activityPlanSearch =
      "${PApiUrls.choreoEndpoint}/activity_plan/search";

  static String morphFeaturesAndTags = "${PApiUrls.choreoEndpoint}/morphs";

  ///-------------------------------- revenue cat --------------------------
  static String rcAppsChoreo = "${PApiUrls.subscriptionEndpoint}/app_ids";
  static String rcProductsChoreo =
      "${PApiUrls.subscriptionEndpoint}/all_products";

  static String rcSubscription = PApiUrls.subscriptionEndpoint;
}
