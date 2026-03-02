---
applyTo: "lib/pangea/toolbar/**"
---

# Toolbar & Reading Assistance

The toolbar is the primary learning surface for received messages. When a user taps any message in a chat, an overlay appears that transforms that message into an interactive language exercise. The design philosophy: **every message is a lesson**, and the toolbar is how you access it.

## Design Goals

1. **Think in your target language**: The toolbar emphasizes word-level interaction over full-sentence translation. The goal is to encourage users to engage with the text and discover meanings themselves, rather than relying on passive translation. Translation is available but intentionally one step removed. Further, messages can be viewed in 'emoji mode' where known words show their emoji associations above the text.
2. **Encourage exploration**: Word cards are simple and feature playful emoji associations and encourage exploration via the vocab collection mechanic and rewarding of the first tap with XP and visual feedback. The experience should feel like discovering hidden treasures in the text.
3. **Opportunities for hearing the language**: On each click of a word, its audio is played. The audio mode with word-by-word highlighting provides a karaoke-like experience that helps users connect written and spoken forms.

## The User Experience

### Reading Assistance (Select Mode)

User taps a message → the message appears in an overlay with each word individually tappable:

```
┌──────────────────────────────┐
│  [Word card for selected     │  ← appears above message when a word is tapped
│   token: meaning, phonetic,  │
│   emoji, feedback button]    │
├──────────────────────────────┤
│  The cat sat on the mat      │  ← message with underlined/interactive tokens
│  ~~~     ~~~        ~~~      │     new words shimmer to attract attention
├──────────────────────────────┤
│ audio translate practice emoji ...│  ← standard message actions
└──────────────────────────────┘
```

**When the user taps a word:**

- The word card appears above with the lemma (dictionary form), meaning, phonetic transcription, and emojis.
- TTS speaks the word aloud (unless the user is already in audio mode)
- If this is the **first time** the user has ever tapped this word, it silently earns a small amount of XP — the word has been "planted" as a seed in their vocabulary garden
- A green underline effect on new words draws the eye to words worth exploring.

### Toolbar Modes

The toolbar offers several assistance modes. Which ones appear depends on the message:

| Mode                   | What the user sees                                                               | When it appears                          |
| ---------------------- | -------------------------------------------------------------------------------- | ---------------------------------------- |
| **Audio**              | Full sentence TTS with word-by-word highlighting (like a karaoke bar)            | Text messages in user's L2               |
| **Translate**          | Full L1 translation appears below the message                                    | Text messages in L2 or unknown languages |
| **Practice**           | Transitions to practice mode (see conversation-activities doc)                           | Text messages in user's L2               |
| **Emoji**              | Emoji picker appears for each word — user can assign personal emoji associations | Text messages in user's L2               |
| **Speech Translation** | Shows STT transcript + translation for audio messages                            | Audio messages not in user's L1          |
| **Regenerate**         | Re-tokenizes the message (for when tokenization looks wrong)                     | Optional, when enabled                   |

**Mode availability logic:**

- Messages in the user's **L2** (target language) → all modes available
- Messages in the user's **L1** (native language) → no modes (nothing to learn)
- Messages in an **unknown language** → only translate
- **Audio messages** → speech transcription and translation modes instead of text modes

### Practice Mode Transition

When the user taps the practice button:

1. The overlay message **animates to the center** of the screen and enlarges
2. Practice buttons appear on each eligible word
3. The user cycles through four practice types (listening, meaning, emoji, grammar)
4. Completed modes turn gold; when all four are gold for all words, the message is "fully practiced"

This transition is a deliberate "mode shift" — the user is choosing to go deeper. The animation signals that something different is happening.

## Word Card

The word card is the detailed view for a single token. It appears above the message when a word is tapped and contains:

- **Lemma** — the dictionary form (e.g., "laufen" for "lief")
- **Meaning** — either user-set or auto-generated L1 translation
- **Phonetic transcription** — IPA or simplified pronunciation guide
- **Emoji** — the user's personal emoji association (if set), or a picker to set one
- **Feedback button** — lets the user flag incorrect token data (POS, meaning, phonetics, language). See §User Feedback below.

The word card is intentionally compact — it should be glanceable, not a full dictionary entry. The goal is quick recognition, not exhaustive reference.

## Collection Mechanic

The toolbar visually distinguishes words the user has never interacted with. New words get a green underline effect that draws attention without being disruptive. The first time a user taps a new word:

1. The underline disappears (globally — once you've tapped that word, you understand how it works)
2. The word earns a small "click" XP bonus
3. The word is now tracked as a seed in the user's vocabulary garden

The design insiration is from Zelda's spin slash of grass to uncover rupees.

## Audio Playback & Highlighting

In audio mode, the toolbar plays the full sentence with word-by-word highlighting:

- Each word highlights as it's being spoken (driven by TTS timing data)
- The user can tap individual words to hear them in isolation
- Highlighted tokens follow the TTS playback position in real time

For audio messages (voice notes), the toolbar provides transcription with the same word-level interaction — tap any word in the transcript to hear it, see its meaning, or practice it.

## Emoji Associations

Users can assign a personal emoji to any word. This serves two purposes:

1. **Memory aid** — visual associations help with retention
2. **Personalization** — the emoji appears on the word's token in future encounters, making familiar words instantly recognizable

Emoji associations persist via the Matrix analytics room and sync across devices.

## Layout Constraints

The toolbar must work within chat layout constraints:

- The overlay positions itself relative to the original message bubble
- On small screens, it scrolls if the message + word card + buttons exceed available space
- The overlay must survive screen rotation and keyboard appearance without losing state
- On width changes (e.g., split-screen), the overlay dismisses rather than attempting to reposition (avoids jarring layout jumps)

## User Feedback

AI-generated content in the toolbar — word card info and translations — can be wrong. Users need a lightweight way to say "this is incorrect" without leaving the toolbar flow. The pattern is the same everywhere: a small **flag icon** beside the content opens a dialog where the user describes the problem in free text. The server re-generates the content with the feedback in context and returns an improved result.

### Design Principles

- **Low friction**: One tap to flag, one text field, done. The user shouldn't need to know *what* is wrong technically — just describe it in their own words.
- **Immediate improvement**: After flagging, the UI replaces the old content with the regenerated version so the user sees the fix right away.
- **Same interaction everywhere**: Word card flagging and translation flagging look and feel identical to the user. Same icon, same dialog, same flow.
- **Auditable**: Every flag is recorded on the server with the user's identity, building a quality signal that improves future results for all users.

### Word Card Feedback (exists)

The word card already has a flag button. When tapped, the user can report issues with tokenization, meaning, phonetics, or language detection. The server figures out which fields need correction and returns updates. See [token-info-feedback-v2.instructions.md](token-info-feedback-v2.instructions.md).

### Translation Feedback (planned)

The full-text translation shown in Translate mode currently has no flag button. Add one — same icon, same dialog, same UX as word card feedback. When the user flags a bad translation, the server regenerates it with a stronger model and the user's feedback as context.

This is especially important for mixed-language and polysemous inputs where the default model gets it wrong (see [#1311](https://github.com/pangeachat/2-step-choreographer/issues/1311), [#1477](https://github.com/pangeachat/2-step-choreographer/issues/1477)). No new server endpoint is needed — the existing translation endpoint already supports feedback. See [direct-translate.instructions.md](../../2-step-choreographer/.github/instructions/direct-translate.instructions.md).

## Key Contracts

- **Overlay, not navigation.** The toolbar never pushes a route. It's a composited overlay that lives on top of the chat. Dismissal returns to the exact same chat state.
- **Lazy loading.** Translation, TTS, and transcription are fetched only when the user activates the corresponding mode. Nothing is prefetched on message tap.
- **Token-centric.** All assistance features require the message to have a tokenized representation. If tokens aren't available (message still loading, unsupported language), the toolbar shows limited functionality.
- **First-click-only analytics.** Tapping the same word repeatedly doesn't keep earning XP. Only the first interaction with a word per session counts, preventing XP gaming.
- **Deferred setState.** Because the overlay lives in the compositing layer alongside the chat, setState calls must be phase-aware to avoid "setState during build" errors. All state updates check the scheduler phase and defer if necessary.

## Future Work

_Last updated: 2026-02-15_

### Overlay & Layout

- [pangeachat/client#3348](https://github.com/pangeachat/client/discussions/3348) — Issues with message overlay / toolbar updates
- [pangeachat/client#3344](https://github.com/pangeachat/client/discussions/3344) — Mixed message text directionality (RTL overlay layout)
- [pangeachat/client#2237](https://github.com/pangeachat/client/discussions/2237) — Soft cap on message length (overlay sizing)
- [pangeachat/client#5609](https://github.com/pangeachat/client/issues/5609) — Copy/paste single words or letters from overlay

### Word Card

- [pangeachat/client#4731](https://github.com/pangeachat/client/discussions/4731) — Word card emotes are confusing
- [pangeachat/client#4481](https://github.com/pangeachat/client/discussions/4481) — Give definitions by form in word cards (not lemma)
- [pangeachat/client#2356](https://github.com/pangeachat/client/discussions/2356) — Simplify lemma_definition user report flow when initial definition is wrong
- [pangeachat/client#5610](https://github.com/pangeachat/client/issues/5610) — Fix wording on the word-card emoji selection popup
- [pangeachat/2-step-choreographer#1475](https://github.com/pangeachat/2-step-choreographer/issues/1475) — Lemma definition improvements (contractions, context, forms)
- [pangeachat/2-step-choreographer#1505](https://github.com/pangeachat/2-step-choreographer/issues/1505) — Consume message info for lemma info endpoint
- [pangeachat/cms#49](https://github.com/pangeachat/cms/issues/49) — Improve lemma definition flow (CMS localization + batching)

### Phonetic Transcription

- [pangeachat/client#5600](https://github.com/pangeachat/client/discussions/5600) — How should pronunciations be displayed for different learners?
- [pangeachat/2-step-choreographer#1611](https://github.com/pangeachat/2-step-choreographer/issues/1611) — Phonetic transcription: heteronyms and TTS consistency
- [pangeachat/2-step-choreographer#1610](https://github.com/pangeachat/2-step-choreographer/issues/1610) — Test pinyin transcription library accuracy
- [pangeachat/2-step-choreographer#831](https://github.com/pangeachat/2-step-choreographer/issues/831) — English-Vietnamese phonetic transcription is not good

### Audio & TTS

- [pangeachat/client#5654](https://github.com/pangeachat/client/issues/5654) — Are there more places where it makes sense to use word audio?
- [pangeachat/client#3175](https://github.com/pangeachat/client/discussions/3175) — Speaking practice for voice/audio messages
- [pangeachat/client#2678](https://github.com/pangeachat/client/discussions/2678) — Listening exercises
- [pangeachat/client#5656](https://github.com/pangeachat/client/issues/5656) — Voice practice ideas

### Translation & IT

- [pangeachat/client#5437](https://github.com/pangeachat/client/discussions/5437) — Audio, translation, and emoji tools, toggable
- [pangeachat/client#5612](https://github.com/pangeachat/client/issues/5612) — Make IT popup feel less like an error
- [pangeachat/client#1896](https://github.com/pangeachat/client/discussions/1896) — Interactive Translator needs refresh and probably skip
- [pangeachat/client#3302](https://github.com/pangeachat/client/discussions/3302) — Changing IT
- [pangeachat/client#4649](https://github.com/pangeachat/client/discussions/4649) — Should other users' messages in DMs be automatically translated to L2?
- [pangeachat/2-step-choreographer#1477](https://github.com/pangeachat/2-step-choreographer/issues/1477) — Direct translation improvements (ambiguous words)
- [pangeachat/2-step-choreographer#1311](https://github.com/pangeachat/2-step-choreographer/issues/1311) — Mixed languages carry over into translation

### Collection Mechanic

- [pangeachat/client#4387](https://github.com/pangeachat/client/discussions/4387) — Max on underlined new words in a sentence feels like a bug
- [pangeachat/client#1754](https://github.com/pangeachat/client/discussions/1754) — Render pangea representation of user L1
