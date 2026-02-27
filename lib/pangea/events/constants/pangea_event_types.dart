class PangeaEventTypes {
  static const construct = "pangea.construct";
  static const userSetLemmaInfo = "p.user_lemma_info";
  static const userChosenEmoji = "p.emoji";

  static const tokens = "pangea.tokens";
  static const choreoRecord = "pangea.record";
  static const representation = "pangea.representation";
  static const sttTranslation = "pangea.stt_translation";
  static const textToSpeech = "pangea.text_to_speech";

  static const botOptions = "pangea.bot_options";
  static const capacity = "pangea.capacity";

  static const activityPlan = "pangea.activity_plan";
  static const activityRole = "pangea.activity_roles";
  static const activitySummary = "pangea.activity_summary";

  static const report = 'm.report';
  static const textToSpeechRule = "p.rule.text_to_speech";
  static const analyticsInviteRule = "p.rule.analytics_invite";
  static const analyticsInviteContent = "p.analytics_request";

  /// A practice activity that is related to a message
  static const pangeaActivity = "pangea.activity_res";

  /// Profile information related to a user's analytics
  static const profileAnalytics = "pangea.analytics_profile";
  static const activityRoomIds = "pangea.activity_room_ids";

  /// Relates to course plans
  static const coursePlan = "pangea.course_plan";
  static const teacherMode = "pangea.teacher_mode";
  static const courseChatList = "pangea.course_chat_list";

  static const analyticsSettings = "pangea.analytics_settings";

  static const regenerationRequest = "pangea.regeneration_request";

  static const knockedRooms = 'org.pangea.knocked_rooms';
}
