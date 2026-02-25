---
applyTo: "lib/pangea/morphs/**, lib/pangea/constructs/**, lib/pangea/analytics_details_popup/morph_*"
---

# Grammar Analytics — Design & Intent

The grammar analytics section surfaces which morphological grammar concepts a learner has used (and which they haven't) based on the [Universal Dependencies](https://universaldependencies.org/) (UD) framework. In the UI it is labeled "Grammar" but internally the data model calls these **morph constructs** (`ConstructTypeEnum.morph`).

## Design Goals

### 1. Motivational progress tracker, not a textbook

The grammar page is **not** a grammar reference. It exists to let students see at a glance which grammar concepts they've already produced in real messages and which remain unused — promoting more varied, adventurous language use. The framing is "look what you've done / here's what you could try" rather than "here are 30 categories you need to learn."

### 2. Language-specific relevance

The full UD feature/tag inventory is large and language-agnostic. Only a subset matters for any given L2. The server maintains an **exclusion-based list** per language (`morphs_exclusions_by_language.json` in 2-step-choreographer) that trims the master UD inventory down to what's relevant. The client fetches this trimmed list via `GET /choreo/morphs/{language_code}` (see `morph_repo.dart`).

> **Known gap:** These per-language exclusion lists have only been audited for a handful of languages. Many languages still show tags that don't apply or are missing tags that do. Cleaning these up is ongoing work — contributions from linguists and language teachers are needed.

### 3. Tokenized dataset contribution

A secondary intent is to build up tokenized message datasets annotated with UD morphological information. This data helps improve NLP quality for low-resource languages where training data is scarce. Surfacing grammar analytics to users is partly a mechanism for generating and validating this annotation at scale.

## Data Architecture

### Construct model

Every grammar data point is a **construct** identified by a `ConstructIdentifier`:

| Field | Meaning | Example |
|---|---|---|
| `type` | Always `ConstructTypeEnum.morph` | `morph` |
| `category` | The UD feature name (maps to `MorphFeaturesEnum`) | `Tense` |
| `lemma` | The UD tag value within that feature | `Pres` |

A user's usage of each construct is tracked as `ConstructUses`, which accumulates XP and a proficiency level (`ConstructLevelEnum`).

### Morph feature inventory

The canonical tag list lives server-side in `ud_constants.py`. The client carries a `defaultMorphMapping` fallback (`default_morph_mapping.dart`) and fetches the L2-specific version from the API. Features are sorted by `morphFeatureSortOrder` — roughly by pedagogical importance (POS → tense → aspect → mood → …).

### Human-readable descriptions

The **morph meaning** system (server: `morph_meaning/`, client: `morph_meaning/`) provides LLM-generated titles and descriptions for each feature/tag pair, keyed by user's L1 display language. These are stored in the CMS and generated on-demand for missing entries. See the server-side `morph-meaning_v1.instructions.md` for the full data model and request flow.

## UI Structure

### Grammar list view (`morph_analytics_list_view.dart`)

Top-level page showing all relevant UD features as expandable boxes. Each box lists the tags within that feature (e.g., Tense → Past, Present, Future). Tags are color-coded by the user's proficiency level. Tags the user hasn't encountered yet are visible but dimmed — this is intentional to motivate exploration.

### Grammar detail view (`morph_details_view.dart`)

Drill-down for a single tag showing:
- Tag display name and icon (`morph_tag_display.dart`, `morph_icon.dart`)
- Feature category label (`morph_feature_display.dart`)
- Human-readable meaning (`morph_meaning_widget.dart`)
- XP progress bar
- Usage examples from the user's actual messages

### Grammar practice (`grammar_error_practice_generator.dart`, `morph_category_activity_generator.dart`)

Recent addition: users can practice grammar concepts they've struggled with. `GrammarErrorPracticeGenerator` creates activities from past IGC grammar corrections. `MorphCategoryActivityGenerator` creates practice targeting specific morph categories.

## Recent Improvements

- **Grammar practice section** on the analytics page allowing rehearsal of past grammar mistakes via generated multiple-choice activities.

## Future Work

- **In-app feedback on grammar info**: Allow users to flag incorrect or confusing grammar tags/descriptions (similar to the feedback mechanism on other features) to trigger internal review. This covers both the per-L2 tag list (exclusions) and the morph meaning descriptions.
- **Pre-made examples per tag**: Add curated example sentences for each grammar concept so users can see the construct in context without needing to have encountered it themselves.
- **Target grammar in activities**: Allow course creators and activity generators to specify grammar concepts as learning targets (e.g., "practice the subjunctive"), connecting the grammar inventory to the activity system.

## Key Files

| Area | Files |
|---|---|
| **Data model** | `constructs/construct_identifier.dart`, `analytics_misc/construct_type_enum.dart`, `analytics_misc/construct_use_model.dart` |
| **UD features** | `morphs/morph_features_enum.dart`, `morphs/morph_models.dart`, `morphs/default_morph_mapping.dart`, `morphs/parts_of_speech_enum.dart` |
| **Display copy** | `morphs/get_grammar_copy.dart`, `morphs/morph_meaning/` |
| **API** | `morphs/morph_repo.dart` (fetches L2-specific feature/tag list) |
| **UI — list** | `analytics_details_popup/morph_analytics_list_view.dart`, `analytics_details_popup/analytics_details_popup.dart` |
| **UI — detail** | `analytics_details_popup/morph_details_view.dart`, `morphs/morph_tag_display.dart`, `morphs/morph_feature_display.dart`, `morphs/morph_icon.dart` |
| **Practice** | `analytics_practice/grammar_error_practice_generator.dart`, `analytics_practice/morph_category_activity_generator.dart` |
| **Server — tag lists** | `2-step-choreographer: app/handlers/universal_dependencies/` |
| **Server — descriptions** | `2-step-choreographer: app/handlers/morph_meaning/` |
