---
applyTo: "lib/pangea/token_info_feedback/**"
---

# Token Info Feedback — v2 Migration (Client)

Migrate the token info feedback flow to use the v2 endpoint and v2 phonetic transcription types. This is a client-side companion to the choreo instructions at `2-step-choreographer/.github/instructions/token-info-feedback-pt-v2.instructions.md`.

## Context

Token info feedback lets users flag incorrect token data (POS, language, phonetics, lemma). The server evaluates the feedback via LLM, conditionally calls sub-handlers, and returns updated fields. The client applies the updates to local caches and optionally edits the Matrix message.

**Why migrate**: The phonetics field currently sends a plain `String` and receives a `PhoneticTranscriptionResponse` (v1 nested types). The v2 endpoint expects `PTRequest` + `PTResponse` and returns `PTResponse` (flat v2 types). This aligns token feedback with the broader PT v2 migration.

**Staleness detection**: The server compares the client-sent phonetics against its CMS cache. If they differ and the LLM didn't request changes, the server returns the CMS version as `updatedPhonetics` so the client refreshes its local cache. This means `updatedPhonetics` may be non-null even when the user's feedback didn't trigger phonetic changes.

---

## 1. Endpoint URL

**v1**: `{choreoEndpoint}/token/feedback`
**v2**: `{choreoEndpoint}/token/feedback_v2`

Update `PApiUrls.tokenFeedback` (or add a new constant) in [urls.dart](lib/pangea/common/network/urls.dart).

---

## 2. Request Changes

### Replace `phonetics` with `ptRequest` + `ptResponse`

**v1**: `phonetics: String` — a rendered transcription like `"hái"`, extracted by `PhoneticTranscriptionBuilder.transcription` (the first token's `phoneticL1Transcription.content`).

**v2**: Two new fields replace `phonetics`:
- `ptRequest: PTRequest?` — the PT request used to fetch phonetics (surface, langCode, userL1, userL2). The server passes this directly to `pt_v2_handler.get()` when feedback triggers a phonetics re-evaluation.
- `ptResponse: PTResponse?` — the cached PT response containing `List<Pronunciation>`. The server uses `ptResponse.pronunciations` for the evaluation prompt and staleness detection.

This means `TokenInfoFeedbackRequestData` drops `phonetics: String` and adds `ptRequest: PTRequest?` + `ptResponse: PTResponse?`.

### What feeds into `ptRequest` / `ptResponse`

The data flows through this chain:

1. **`PhoneticTranscriptionBuilder`** resolves a `PhoneticTranscriptionResponse` (v1) → extracts a `String`.
2. **`TokenFeedbackButton`** receives the string via `onFlagTokenInfo(lemmaInfo, transcript)`.
3. **Call sites** (`reading_assistance_content.dart`, `analytics_details_popup.dart`) put the string into `TokenInfoFeedbackRequestData(phonetics: transcript)`.

After v2 migration, this chain must change:

1. **`PhoneticTranscriptionBuilder`** resolves a v2 response → exposes both the `PTRequest` it used and the `PTResponse` it received.
2. **`TokenFeedbackButton`** callback signature changes: `Function(LemmaInfoResponse, PTRequest, PTResponse)`.
3. **Call sites** pass both objects into the updated request data: `TokenInfoFeedbackRequestData(ptRequest: ptReq, ptResponse: ptRes)`.

### `toJson()` serialization

v1:
```json
{ "phonetics": "hái" }
```

v2:
```json
{
  "pt_request": {
    "surface": "还",
    "lang_code": "zh",
    "user_l1": "en",
    "user_l2": "zh"
  },
  "pt_response": {
    "pronunciations": [
      { "transcription": "hái", "ipa": "xaɪ̌", "ud_conditions": "Pos=ADV" },
      { "transcription": "huán", "ipa": "xwaň", "ud_conditions": "Pos=VERB" }
    ]
  }
}
```

All other request fields (`userId`, `roomId`, `fullText`, `detectedLanguage`, `tokens`, `selectedToken`, `lemmaInfo`, `wordCardL1`) are unchanged.

---

## 3. Response Changes

### `updatedPhonetics` field

**v1**: `PhoneticTranscriptionResponse?` — deeply nested v1 types with `phoneticTranscriptionResult.phoneticTranscription[0].phoneticL1Transcription.content`.

**v2**: The v2 response type (e.g., `PhoneticTranscriptionV2Response` with `pronunciations: List<Pronunciation>`). Deserialized via the v2 model's `fromJson()`.

**New behavior**: `updatedPhonetics` may be non-null in two cases:
1. The LLM evaluated user feedback and generated new phonetics (same as v1).
2. The server detected that the client's cached phonetics are stale compared to CMS. In this case, the server returns the current CMS version so the client can refresh.

Either way, the client should apply the update to its local cache (see §4).

All other response fields (`userFriendlyMessage`, `updatedToken`, `updatedLemmaInfo`, `updatedLanguage`) are unchanged.

---

## 4. Cache Side-Effects in `_submitFeedback`

The dialog applies server updates to local caches. The phonetic cache write must change:

### v1 (current)
```dart
Future<void> _updatePhoneticTranscription(
  PhoneticTranscriptionResponse response,
) async {
  final req = PhoneticTranscriptionRequest(
    arc: LanguageArc(l1: ..., l2: ...),
    content: response.content,
  );
  await PhoneticTranscriptionRepo.set(req, response);
}
```

This constructs a v1 `PhoneticTranscriptionRequest` to use as the cache key, then writes the v1 response.

### v2 (target)
Construct the v2 cache key (`surface + lang_code + user_l1`) and write the v2 response to the v2 PT cache. The exact implementation depends on how the PT v2 repo's `set()` method is designed during the broader PT migration. The key pieces are:

- **Cache key inputs**: `surface` = the token's surface text, `langCode` = `this.langCode` (from the dialog), `userL1` = `requestData.wordCardL1`.
- **Response type**: The v2 response containing `List<Pronunciation>`.
- **Cache target**: The v2 PT cache (not the v1 `phonetic_transcription_storage`).

---

## 5. Files to Modify

| File | Change |
|------|--------|
| `token_info_feedback_request.dart` | Drop `phonetics: String`. Add `ptRequest: PTRequest?` + `ptResponse: PTResponse?`. Update `toJson()`, `==`, `hashCode`. |
| `token_info_feedback_response.dart` | `updatedPhonetics: PhoneticTranscriptionResponse?` → v2 response type. Update `fromJson()`, `toJson()`, `==`, `hashCode`. Remove v1 `PhoneticTranscriptionResponse` import. |
| `token_info_feedback_dialog.dart` | Update `_updatePhoneticTranscription` to use v2 cache key/types. Remove v1 `PhoneticTranscriptionRequest`, `PhoneticTranscriptionResponse`, `LanguageArc`, `PLanguageStore` imports. |
| `token_info_feedback_repo.dart` | Update URL to `PApiUrls.tokenFeedbackV2` (or equivalent). |
| `token_feedback_button.dart` *(outside this folder)* | Change callback from `(LemmaInfoResponse, String)` to `(LemmaInfoResponse, PTRequest, PTResponse)`. Update how the PT objects are extracted from the builder. |
| Call sites *(outside this folder)* | `reading_assistance_content.dart`, `analytics_details_popup.dart` — update `onFlagTokenInfo` to pass `PTRequest` + `PTResponse` into `TokenInfoFeedbackRequestData`. |
| `urls.dart` *(outside this folder)* | Add `tokenFeedbackV2` URL constant. |

---

## 6. Dependency on PT v2 Migration

This migration **depends on** the core PT v2 models existing on the client:
- `Pronunciation` model (with `transcription`, `ipa`, `ud_conditions`)
- V2 response model (with `pronunciations: List<Pronunciation>`)
- V2 repo with a `set()` method that accepts the v2 cache key

These are created as part of the main PT v2 migration (see `phonetic-transcription-v2-design.instructions.md` §3). Implement the core PT v2 models first, then update token info feedback.

---

## 7. Checklist

- [ ] Replace `phonetics` field with `ptRequest` + `ptResponse` in request model
- [ ] Update `updatedPhonetics` field type in response model
- [ ] Update `_updatePhoneticTranscription` cache write in dialog
- [ ] Update `TokenFeedbackButton` callback signature to `(LemmaInfoResponse, PTRequest, PTResponse)`
- [ ] Update call sites to pass `PTRequest` + `PTResponse`
- [ ] Update URL to v2 endpoint
- [ ] Remove all v1 PT type imports from token_info_feedback files
