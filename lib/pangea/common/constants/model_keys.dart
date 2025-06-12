class ModelKey {
  ///user model keys
  static const String userAccess = 'access';
  static const String userRefresh = 'refresh';
  static const String userProfile = 'profile';
  static const String userFullName = 'full_name';
  static const String userCreatedAt = 'created_at';
  static const String userPangeaUserId = 'pangea_user_id';
  static const String userDateOfBirth = 'date_of_birth';
  static const String userTargetLanguage = 'target_language';
  static const String userSourceLanguage = 'source_language';
  static const String userSpeaks = 'speaks';
  static const String userCountry = 'country';
  static const String hasJoinedHelpSpace = 'has_joined_help_space';
  static const String userInterests = 'interests';
  static const String l2LanguageKey = 'target_language';
  static const String l1LanguageKey = 'source_language';
  static const String publicProfile = 'public_profile';
  static const String userId = 'user_id';
  static const String toolSettings = 'tool_settings';
  static const String userSettings = 'user_settings';
  static const String instructionsSettings = 'instructions_settings';
  static const String cefrLevel = 'user_cefr';

  static const String autoPlayMessages = 'autoPlayMessages';
  static const String itAutoPlay = 'autoPlayIT';

  static const String clientClassCity = "city";
  static const String clientClassCountry = "country";
  static const String clientClassDominantLanguage = "dominantLanguage";
  static const String clientClassTargetLanguage = "targetLanguage";
  static const String clientClassDescription = "description";
  static const String clientLanguageLevel = "languageLevel";
  static const String clientSchool = "schoolName";

  static const String clientIsPublic = "isPublic";
  static const String clientIsOpenEnrollment = 'isOpenEnrollment';
  static const String clientIsOneToOneChatClass = 'oneToOneChatClass';
  static const String clientIsCreateRooms = 'isCreateRooms';
  static const String clientIsShareVideo = 'isShareVideo';
  static const String clientIsSharePhoto = 'isSharePhoto';
  static const String clientIsShareFiles = 'isShareFiles';
  static const String clientIsShareLocation = 'isShareLocation';
  static const String clientIsCreateStories = 'isCreateStories';
  static const String clientIsVoiceNotes = 'isVoiceNotes';
  static const String clientIsInviteOnlyStudents = 'isInviteOnlyStudents';

  static const String userL1 = "user_l1";
  static const String userL2 = "user_l2";
  static const String fullText = "full_text";
  static const String fullTextLang = "full_text_lang";
  static const String tokens = "tokens";
  static const String allDetections = "all_detections";
  static const String srcLang = "src_lang";
  static const String tgtLang = "tgt_lang";
  static const String word = "word";
  static const String lang = "lang";
  static const String deepL = "deepl";
  static const String offset = "offset";
  static const String length = "length";
  static const String langCode = 'lang_code';
  static const String confidence = 'confidence';
  // some old analytics rooms have langCode instead of lang_code in the room creation content
  static const String oldLangCode = 'langCode';
  static const String wordLang = "word_lang";
  static const String lemma = "lemma";
  static const String saveVocab = "save_vocab";
  static const String text = "text";
  static const String permissions = "permissions";
  static const String enableIGC = "enable_igc";
  static const String enableIT = "enable_it";
  static const String prevMessages = "prev_messages";
  static const String prevContent = "prev_content";
  static const String prevSender = "prev_sender";
  static const String prevTimestamp = "prev_timestamp";

  static const String originalSent = "original_sent";
  static const String originalWritten = "original_written";
  static const String tokensSent = "tokens_sent";
  static const String tokensWritten = "tokens_written";
  static const String choreoRecord = "choreo_record";

  /// This is strictly for use in message content jsons
  /// in order to flag that the message edit was done in order
  /// to edit some message data such as tokens, morph tags, etc.
  /// This will help us know to omit the message from notifications,
  /// bot responses, etc. It will also help use find the message if
  /// we want to gather user edits for LLM fine-tuning.
  static const String messageTags = "p.tag";
  static const String messageTagMorphEdit = "morph_edit";
  static const String messageTagLemmaEdit = "lemma_edit";
  static const String messageTagActivityPlan = "activity_plan";
  static const String tempEventId = "temporary_event_id";

  static const String baseDefinition = "base_definition";
  static const String targetDefinition = "target_definition";
  static const String basePartOfSpeech = "base_part_of_speech";
  static const String targetPartOfSpeech = "target_part_of_speech";
  static const String partOfSpeech = "part_of_speech";
  static const String baseWord = "base_word";
  static const String targetWord = "target_word";
  static const String baseExampleSentence = "base_example_sentence";
  static const String targetExampleSentence = "target_example_sentence";

  //add goldTranslation, goldContinuance, chosenContinuance
  static const String goldTranslation = "gold_translation";
  static const String goldContinuance = "gold_continuance";
  static const String chosenContinuance = "chosen_continuance";

  // sourceText, currentText, bestContinuance, feedback_lang
  static const String sourceText = "src";
  static const String currentText = "current";
  static const String bestContinuance = "best_continuance";
  static const String feedbackLang = "feedback_lang";

  static const String transcription = "transcription";
  static const String botTranscription = 'bot_transcription';

  // bot options
  static const String languageLevel = "difficulty";
  static const String safetyModeration = "safety_moderation";
  static const String mode = "mode";
  static const String discussionTopic = "discussion_topic";
  static const String discussionKeywords = "discussion_keywords";
  static const String discussionTriggerReactionEnabled =
      "discussion_trigger_reaction_enabled";
  static const String discussionTriggerReactionKey =
      "discussion_trigger_reaction_key";
  static const String customSystemPrompt = "custom_system_prompt";
  static const String customTriggerReactionEnabled =
      "custom_trigger_reaction_enabled";
  static const String customTriggerReactionKey = "custom_trigger_reaction_key";

  static const String textAdventureGameMasterInstructions =
      "text_adventure_game_master_instructions";

  static const String targetLanguage = "target_language";
  static const String targetVoice = "target_voice";

  static const String prevEventId = "prev_event_id";
  static const String prevLastUpdated = "prev_last_updated";

  // room code
  static const String joinRule = "join_rule";
  static const String accessCode = "access_code";

  // app version
  static const String latestVersion = "latest_version";
  static const String latestBuildNumber = "latest_build_number";
  static const String mandatoryUpdate = "mandatory_update";
  static const String emoji = "emoji";
  static const String emojiList = "emoji_list";

  static const String analytics = "analytics";
  static const String level = "level";
  static const String xpOffset = "xp_offset";

  // activity plan
  static const String activityPlanRequest = "req";
  static const String activityPlanTitle = "title";
  static const String activityPlanLearningObjective = "learning_objective";
  static const String activityPlanInstructions = "instructions";
  static const String activityPlanVocab = "vocab";
  static const String activityPlanImageURL = "image_url";
  static const String activityPlanBookmarkId = "bookmark_id";

  static const String activityRequestTopic = "topic";
  static const String activityRequestMode = "mode";
  static const String activityRequestObjective = "objective";
  static const String activityRequestMedia = "media";
  static const String activityRequestCefrLevel = "activity_cefr_level";
  static const String activityRequestLanguageOfInstructions =
      "language_of_instructions";
  static const String activityRequestTargetLanguage = "target_language";
  static const String activityRequestCount = "count";
  static const String activityRequestNumberOfParticipants =
      "number_of_participants";
}
