---
applyTo: "lib/pangea/languages/**,lib/pangea/learning_settings/**,lib/pangea/login/pages/language_selection_page.dart"
---

# Language List — Client

For the cross-service language list architecture, L1/L2 definitions, and CMS schema, see [language-list.instructions.md](../../../.github/.github/instructions/language-list.instructions.md).

## Data Flow

1. [`LanguageRepo._fetch()`](../../lib/pangea/languages/language_repo.dart) fetches all languages from CMS REST API (`/api/languages?limit=500&sort=language_name`) — public, no auth
2. [`PLanguageStore`](../../lib/pangea/languages/p_language_store.dart) caches the list in `SharedPreferences` and re-fetches roughly daily
3. Hardcoded fallback in [`LanguageConstants.languageList`](../../lib/pangea/languages/language_constants.dart) if CMS is unreachable and cache is empty

## L1/L2 Filtering

[`PLanguageStore`](../../lib/pangea/languages/p_language_store.dart) exposes three getters:

| Getter | Filter | Used for |
|---|---|---|
| `baseOptions` | All languages (no filter) | L1 / source / native language selection |
| `targetOptions` | `element.l2` (i.e., `l2Support != L2SupportEnum.na`) | L2 / target / learning language selection |
| `unlocalizedTargetOptions` | L2 filter + excludes regional variants (e.g., keeps "Portuguese" but not "Portuguese (Brazil)") | Course creation language filter |

The `l2` getter on [`LanguageModel`](../../lib/pangea/languages/language_model.dart) returns `l2Support != L2SupportEnum.na`.

## Key Usage Sites

- **Login language selection**: [`language_selection_page.dart`](../../lib/pangea/login/pages/language_selection_page.dart) — uses `targetOptions` for L2 chips, defaults L1 to system language
- **Learning settings dialog**: [`p_language_dialog.dart`](../../lib/pangea/learning_settings/p_language_dialog.dart) — `baseOptions` for L1, `targetOptions` for L2
- **Learning settings view**: [`settings_learning_view.dart`](../../lib/pangea/learning_settings/settings_learning_view.dart) — same pattern
- **Bot chat settings**: [`bot_chat_settings_dialog.dart`](../../lib/pangea/bot/widgets/bot_chat_settings_dialog.dart) — `targetOptions` for room target language
- **Course creation**: [`course_language_filter.dart`](../../lib/pangea/course_creation/course_language_filter.dart) — `unlocalizedTargetOptions`

## Models

- [`LanguageModel`](../../lib/pangea/languages/language_model.dart) — core model with `langCode`, `displayName`, `l2Support`, `script`, `localeEmoji`, `voices`
- [`L2SupportEnum`](../../lib/pangea/languages/l2_support_enum.dart) — `na`, `alpha`, `beta`, `full` with localized display strings and badge rendering
- [`LanguageArc`](../../lib/pangea/languages/language_arc_model.dart) — L1→L2 pair, constructed from user settings

## Conventions

- Display names are localized via `getDisplayName(context)` using l10n keys, with fallback to CMS `language_name`
- Regional variants show `localeEmoji` in place of parenthesized region: "Portuguese 🇧🇷" instead of "Portuguese (Brazil)"
- `langCodeShort` strips the territory: `en-US` → `en`
- RTL detection uses a hardcoded list in `LanguageConstants.rtlLanguageCodes`

## Future Work

_(No linked issues yet.)_
