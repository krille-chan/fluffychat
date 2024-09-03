//TODO move baseAPI addition to request function

import 'package:fluffychat/pangea/config/environment.dart';

/// autodocs
/// https://api.staging.pangea.chat/choreo/docs
/// username: admin
/// password: admin
///
/// https://api.staging.pangea.chat/api/v1/
class PApiUrls {
  static String baseAPI = Environment.baseAPI;

  ///   ---------------------- Languages --------------------------------------
  static String getLanguages = "${Environment.choreoApi}/choreo/languages";

  ///   ---------------------- Users --------------------------------------
  static String createUser = "/account/create";
  static String userDetails = "/account/get_user_access_token?pangea_user_id=";
  static String updateUserProfile = "/account/update";
  static String paymentLink = "/account/payment_link";
  static String subscriptionExpiration = "/account/premium_expires_date";

  ///   ---------------------- Conversation Partner -------------------------
  static String searchUserProfiles = "/account/search";

  ///-------------------------------- choreo --------------------------
  static String igc = "${Environment.choreoApi}/grammar";

  static String languageDetection =
      "${Environment.choreoApi}/language_detection";

  static String igcLite = "${Environment.choreoApi}/grammar_lite";
  static String spanDetails = "${Environment.choreoApi}/span_details";

  static String wordNet = "${Environment.choreoApi}/wordnet";
  static String contextualizedTranslation =
      "${Environment.choreoApi}/translation/contextual";
  static String simpleTranslation =
      "${Environment.choreoApi}/translation/direct";
  static String tokenize = "${Environment.choreoApi}/tokenize";
  static String contextualDefinition =
      "${Environment.choreoApi}/contextual_definition";
  static String similarity = "${Environment.choreoApi}/similarity";
  static String topicInfo = "${Environment.choreoApi}/vocab_list";

  static String itFeedback = "${Environment.choreoApi}/translation/feedback";

  static String firstStep = "/it_initialstep";
  static String subseqStep = "/it_step";

  static String textToSpeech = "${Environment.choreoApi}/text_to_speech";
  static String speechToText = "${Environment.choreoApi}/speech_to_text";

  static String messageActivityGeneration =
      "${Environment.choreoApi}/practice/message";

  ///-------------------------------- revenue cat --------------------------

  static String rcAppsChoreo = "${Environment.choreoApi}/revenue/app_ids";
  static String rcProductsChoreo =
      "${Environment.choreoApi}/revenue/all_products";
  static String rcSubscriptionChoreo =
      "${Environment.choreoApi}/revenue/subscription";