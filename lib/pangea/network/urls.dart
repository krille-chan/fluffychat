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
  static String choreoBaseApi = Environment.choreoApi;

  ///   ---------------------- Languages --------------------------------------
  static String getLanguages = "/language/list";

  ///   ---------------------- Users --------------------------------------
  static String createUser = "/account/create";
  static String userDetails = "/account/get_user_access_token?pangea_user_id=";
  static String updateUserProfile = "/account/update";
  static String paymentLink = "/account/payment_link";
  static String subscriptionExpiration = "/account/premium_expires_date";

  ///   ---------------------- Conversation Partner -------------------------
  static String searchUserProfiles = "/account/search";

  ///   ---------------------- Deprecated Class API -------------------------
  static String classListBySpaceIds = "/class/listbyspaceids";
  static String getClassByClassCode = "/class/class_by_code?class_code=";

  ///   ---------------------- Exchange -----------------------------------
  static String exchangeClassValidate = "/class/validate_exchange";
  static String exchangeClass = "/class/class_exchange";
  static String isExchange = "/class/get_exchange?exchange_pangea_id=";
  static String exchangeParticipantsStore = "/class/exchange/participant";
  static String exchangeInfoStore = "/class/exchange/create";
  static String fetchExchangeInfo = "/class/exchange/data?exchange_pangea_id=";
  static String exchangeAcceptRequest = "/class/exchange/accept";
  static String makeAdminInExchange = "/class/exchange/admin/create";

  ///-------------------------------- Deprecated analytics --------------------
  static String classAnalytics = "${Environment.choreoApi}/class_analytics";
  static String messageService = "/message_service";

  ///-------------------------------- choreo --------------------------
  static String igc = "${Environment.choreoApi}/grammar";

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

  ///-------------------------------- revenue cat --------------------------
  static String rcApiV1 = "https://api.revenuecat.com/v1";
  static String rcApiV2 =
      "https://api.revenuecat.com/v2/projects/${Environment.rcProjectId}";

  static String rcApps = "$rcApiV2/apps";
  static String rcProducts = "$rcApiV2/offerings?expand=items.package.product";
  static String rcSubscribers = "$rcApiV1/subscribers";
}
