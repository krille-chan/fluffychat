---
applyTo: "lib/pangea/**"
---

# Pangea Feature Modules (`lib/pangea/`)

See also: [UX Priorities](../../../.github/instructions/ux-priorities.instructions.md) | [Design System](../../../.github/instructions/design-system.instructions.md)

Each subdirectory is a self-contained feature module. This doc provides the full map.

## Core Infrastructure

| Module | Purpose | Key Files |
|---|---|---|
| `common/controllers/` | Central controllers | `pangea_controller.dart` (owns UserController, SubscriptionController, PLanguageStore), `base_controller.dart` (stream-based generic controller) |
| `common/network/` | API communication | `urls.dart` (all choreo API URLs), `requests.dart` (HTTP client) |
| `common/config/` | Environment config | `environment.dart` (reads `.env` / `config.sample.json` for URLs, homeserver, etc.) |
| `common/constants/` | Shared constants | `local.key.dart` (storage keys), `model_keys.dart` |
| `common/models/` | Base models | `base_request_model.dart`, `llm_feedback_model.dart` |
| `common/utils/` | Shared utilities | `error_handler.dart`, `firebase_analytics.dart`, `overlay.dart`, `p_vguard.dart` (route guards) |
| `common/widgets/` | Shared widgets | `pressable_button.dart`, `overlay_container.dart`, `shimmer_background.dart`, ~20 others |
| `design_system/` | Design tokens | `tokens/` |
| `navigation/` | Navigation | `navigation_util.dart` |

## Writing Assistance (Choreographer)

| Module | Purpose | Key Files |
|---|---|---|
| `choreographer/` | Writing flow orchestrator | `choreographer.dart` (ChangeNotifier), `choreographer_state_extension.dart`, `assistance_state_enum.dart`, `choreo_record_model.dart`, `choreo_mode_enum.dart` |
| `choreographer/igc/` | Interactive Grammar Correction | `igc_controller.dart`, `igc_repo.dart`, `replacement_type_enum.dart`, `pangea_match_model.dart`, `span_card.dart`, `span_data_model.dart`, `autocorrect_popup.dart`, `autocorrect_span.dart`, `start_igc_button.dart`, `text_normalization_util.dart` |
| `choreographer/it/` | ⚠️ DEPRECATED — Interactive Translation | `it_controller.dart`, `it_repo.dart`, `it_step_model.dart`, `it_feedback_card.dart`, `word_data_card.dart` |
| `choreographer/text_editing/` | Text controller | `pangea_text_controller.dart`, `edit_type_enum.dart` |

## Message Toolbar (Reading Assistance)

| Module | Purpose | Key Files |
|---|---|---|
| `toolbar/layout/` | Overlay positioning | `message_selection_positioner.dart`, `over_message_overlay.dart`, `reading_assistance_mode_enum.dart` |
| `toolbar/reading_assistance/` | Token-level reading UX | `underline_text_widget.dart`, `token_rendering_util.dart`, `select_mode_controller.dart`, `new_word_overlay.dart` |
| `toolbar/word_card/` | Word detail card | `word_card_switcher.dart`, `reading_assistance_content.dart`, `lemma_meaning_display.dart`, `token_feedback_button.dart` |
| `toolbar/message_practice/` | In-message practice | `practice_controller.dart`, `practice_activity_card.dart`, `practice_match_card.dart`, `morph_selection.dart` |

## Events & Data Model

| Module | Purpose | Key Files |
|---|---|---|
| `events/constants/` | Event type strings | `pangea_event_types.dart` (~30 custom types) |
| `events/event_wrappers/` | Typed event wrappers | `pangea_message_event.dart`, `pangea_choreo_event.dart`, `pangea_representation_event.dart` |
| `events/models/` | Event content models | `pangea_token_model.dart`, `pangea_token_text_model.dart`, `tokens_event_content_model.dart`, `representation_content_model.dart` |
| `events/repo/` | Token/language API | `tokens_repo.dart`, `token_api_models.dart`, `language_detection_repo.dart` |
| `events/extensions/` | Event helpers | `pangea_event_extension.dart` |
| `extensions/` | Room extensions | `pangea_room_extension.dart`, `room_events_extension.dart`, `room_user_permissions_extension.dart`, etc. |

## Language & Linguistics

| Module | Purpose | Key Files |
|---|---|---|
| `languages/` | Language data | `language_model.dart`, `language_repo.dart`, `language_service.dart`, `p_language_store.dart`, `locale_provider.dart` |
| `lemmas/` | Lemma (dictionary form) | `lemma.dart`, `lemma_info_repo.dart`, `user_set_lemma_info.dart` |
| `morphs/` | Morphological analysis | `morph_models.dart`, `morph_repo.dart`, `parts_of_speech_enum.dart`, `morph_features_enum.dart` |
| `constructs/` | Grammar/vocab constructs | `construct_identifier.dart`, `construct_repo.dart`, `construct_form.dart` |
| `translation/` | Full-text translation | `full_text_translation_repo.dart` + request/response models |
| `phonetic_transcription/` | IPA transcriptions | repo + models |

## Practice & Activities

| Module | Purpose | Key Files |
|---|---|---|
| `practice_activities/` | Activity generation | `practice_activity_model.dart`, `practice_generation_repo.dart`, `multiple_choice_activity_model.dart`, type-specific generators |
| `activity_sessions/` | Session management | `activity_room_extension.dart`, `activity_session_chat/`, `activity_session_start/` |
| `activity_planner/` | Activity planning UI | `activity_plan_model.dart`, `activity_planner_page.dart` |
| `activity_generator/` | Activity creation | `activity_generator.dart`, `activity_plan_generation_repo.dart` |
| `activity_suggestions/` | Activity suggestions | `activity_suggestion_dialog.dart`, `activity_plan_search_repo.dart` |
| `activity_summary/` | Post-activity summary | `activity_summary_model.dart`, `activity_summary_repo.dart` |
| `activity_feedback/` | Activity feedback | `activity_feedback_repo.dart` + request/response |

## Analytics

| Module | Purpose | Key Files |
|---|---|---|
| `analytics_data/` | Local DB & sync | `analytics_data_service.dart`, `analytics_database.dart`, `analytics_sync_controller.dart` |
| `analytics_misc/` | Models & utilities | `construct_use_model.dart`, `constructs_model.dart`, `room_analytics_extension.dart`, `level_up/` |
| `analytics_page/` | Analytics UI | `activity_archive.dart` |
| `analytics_summary/` | Summary views | `level_analytics_details_content.dart` |
| `analytics_practice/` | Practice analytics | `analytics_practice_page.dart` |
| `analytics_details_popup/` | Detail popups | `analytics_details_popup.dart` |
| `analytics_settings/` | Analytics config | settings UI |
| `analytics_downloads/` | Analytics export | download utilities |
| `space_analytics/` | Course-level analytics | `space_analytics.dart` |

## User & Auth

| Module | Purpose | Key Files |
|---|---|---|
| `user/` | Profile & settings | `user_controller.dart`, `user_model.dart`, `analytics_profile_model.dart`, `style_settings_repo.dart` |
| `authentication/` | Login/logout | `p_login.dart`, `p_logout.dart` |
| `login/` | Signup flow pages | `pages/` — language selection, course code, signup, find course |
| `subscription/` | RevenueCat | `controllers/subscription_controller.dart`, `pages/`, `repo/` |

## Courses & Spaces

| Module | Purpose | Key Files |
|---|---|---|
| `spaces/` | Matrix Spaces extensions | `client_spaces_extension.dart`, `space_navigation_column.dart` |
| `course_creation/` | Browse/join courses | `public_course_preview.dart`, `selected_course_page.dart` |
| `course_plans/` | CMS course data | `courses/`, `course_topics/`, `course_activities/`, `course_locations/`, `course_media/` |
| `course_settings/` | Course config | `course_settings.dart`, `teacher_mode_model.dart` |
| `chat_settings/` | Room bot/language config | `models/bot_options_model.dart`, `utils/bot_client_extension.dart` |
| `chat_list/` | Chat list customization | custom chat list logic |
| `chat/` | In-chat customization | `constants/`, `extensions/`, `utils/`, `widgets/` |
| `join_codes/` | Room code invitations | `join_with_link_page.dart` |

## Media & I/O

| Module | Purpose | Key Files |
|---|---|---|
| `speech_to_text/` | STT | `speech_to_text_repo.dart` + models |
| `text_to_speech/` | TTS | `tts_controller.dart`, `text_to_speech_repo.dart` |
| `download/` | Room data export | `download_room_extension.dart`, `download_type_enum.dart` |
| `payload_client/` | CMS API client | `payload_client.dart`, `models/course_plan/` |

## Misc

| Module | Purpose | Key Files |
|---|---|---|
| `bot/` | Bot UI & utils | `utils/`, `widgets/` |
| `instructions/` | In-app tutorials | tutorial content |
| `token_info_feedback/` | Token feedback dialog | `token_info_feedback_dialog.dart`, `token_info_feedback_repo.dart` |
| `learning_settings/` | Learning preferences | `settings_learning.dart`, `tool_settings_enum.dart` |
