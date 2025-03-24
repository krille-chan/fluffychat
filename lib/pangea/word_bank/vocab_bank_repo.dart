import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/word_bank/vocab_request.dart';
import 'package:fluffychat/pangea/word_bank/vocab_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class VocabRepo {
  static final GetStorage _lemmaStorage = GetStorage('vocab_storage');

  static void set(VocabRequest request, VocabResponse response) {
    // set expireAt if not set
    response.expireAt ??= DateTime.now().add(const Duration(days: 100));
    _lemmaStorage.write(request.storageKey, response.toJson());
  }

  static Future<VocabResponse> get(
    VocabRequest request, [
    bool useExpireAt = false,
  ]) async {
    try {
      debugger(when: kDebugMode);
      final cachedJson = _lemmaStorage.read(request.storageKey);

      final cached =
          cachedJson == null ? null : VocabResponse.fromJson(cachedJson);

      if (cached != null) {
        // at this point we have a cache without feedback
        if (!useExpireAt) {
          // return cache as is if we're not using expireAt
          return cached;
        } else if (cached.expireAt != null) {
          if (DateTime.now().isBefore(cached.expireAt!)) {
            // return cache as is if we're using expireAt and it's set but not expired
            return cached;
          }
        }
      }

      final Requests req = Requests(
        choreoApiKey: Environment.choreoApiKey,
        accessToken: MatrixState.pangeaController.userController.accessToken,
      );

      final Response res = await req.post(
        url: PApiUrls.lemmaDictionary,
        body: request.toJson(),
      );

      final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
      final response = VocabResponse.fromJson(decodedBody);

      set(request, response);

      return response;
    } catch (err, stack) {
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "request": request.toJson(),
        },
      );

      return VocabRepo.placeholderData();
    }
  }

  /// Preference previously used words if list is non-empty
  /// Otherwise, pull from a set of starter words for each language
  static Future<VocabResponse> getAllCandidateVocab(
    VocabRequest request,
  ) async {
    final List<ConstructIdentifier> myVocab = MatrixState
        .pangeaController.getAnalytics.constructListModel
        .constructList(type: ConstructTypeEnum.vocab)
        .map((use) => use.id)
        .toList();

    final List<ConstructIdentifier> vocabBank =
        (await VocabRepo.get(request)).vocab;

    final List<ConstructIdentifier> all = [...myVocab, ...vocabBank];

    final deduped = all.toSet().toList();

    return VocabResponse(vocab: deduped);
  }

  static Future<VocabResponse> getSemanticallySimilarWords(
    VocabRequest request,
  ) async {
    // Pull from a list of semantically similar words
    // Either from
    final candidates = (await VocabRepo.getAllCandidateVocab(request)).vocab;

    // we filter out words that do not share the same part of speech as the token
    // TODO: semantic similarity is not implemented yet
    final sharingPos = candidates
        .where(
          (element) =>
              (element.category.toLowerCase() == request.pos?.toLowerCase() &&
                  element.lemma.toLowerCase() != request.lemma?.toLowerCase()),
        )
        .toList();

    // we prefer to return words that share the same part of speech as the token
    // but if there are no words that share the same part of speech, we return all words
    final similarWords = sharingPos.isEmpty ? candidates : sharingPos;

    return VocabResponse(vocab: similarWords);
  }

  Future<VocabResponse> getSementicallyDisimiliarWords(
    VocabRequest request,
  ) async {
    // Pull from previously used words if list is non-empty
    // Otherwise, pull from a set of starter words for each language
    final candidates = (await VocabRepo.getAllCandidateVocab(request)).vocab;

    final sharingPos = candidates
        .where(
          (element) =>
              element.category.toLowerCase() != request.pos?.toLowerCase() &&
              element.lemma.toLowerCase() != request.lemma?.toLowerCase(),
        )
        .toList();

    final disSimilarWords = sharingPos.isEmpty ? candidates : sharingPos;

    return VocabResponse(vocab: disSimilarWords);
  }

  VocabResponse getWordPredictor(VocabRequest request) {
    // Pull from previously used words if list is non-empty
    // Otherwise, pull from a set of starter words for each language

    // Can we locally narrow down the candidate words to a smaller set based some simple rules?
    // For example, if the user is learning a language with a different script, we can filter out words that are not in the target script
    // we might be able to narrow it down based on a model that predicts the next morphological features/tags of a word, independent of language or context.
    // This kind of model could be shared across languages, and could be used to predict the next word in a sentence, or the next morphological feature of a word.
    // We could use this to go from the user's vocabularly list to a list of candidate words that are likely to be useful to the user.

    // we then use a server-side service, likely LLM but could be a simpler model, to rank the words based on the context, the previous words as well as previous two messages
    // in the conversation
    return VocabResponse();
  }

  static VocabResponse placeholderData([LanguageModel? language]) {
    language ??= MatrixState.pangeaController.languageController.userL2 == null
        ? PLanguageStore.byLangCode(LanguageKeys.defaultLanguage)
        : MatrixState.pangeaController.languageController.userL2!;

    //TODO - move this to the server and fill out all our languages
    final Map<String, VocabResponse> placeholder = {
      "es": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hola",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "adios",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "tarde",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "noche",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dia",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "bueno",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "zh": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "你好",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "再见",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "下午",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "晚上",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "天",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "好",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "fr": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "bonjour",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "au revoir",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "après-midi",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "soir",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "jour",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "bon",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "de": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hallo",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "auf wiedersehen",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "nachmittag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "abend",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "tag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "gut",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "en": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hello",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "goodbye",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "afternoon",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "evening",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "day",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "good",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "it": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "ciao",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "arrivederci",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "pomeriggio",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "sera",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "giorno",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "buono",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "pt": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "oi",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "tchau",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "tarde",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "noite",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dia",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "bom",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "ru": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "привет",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "до свидания",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "день",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "вечер",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ночь",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "хороший",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "ja": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "こんにちは",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "さようなら",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "午後",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "夜",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "日",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "良い",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "ko": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "안녕하세요",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "안녕히 가세요",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "오후",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "밤",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "낮",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "좋은",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "ar": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "مرحبا",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "وداعا",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "مساء",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ليل",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "يوم",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "جيد",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "hi": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "नमस्ते",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "अलविदा",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "दोपहर",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "रात",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "दिन",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "अच्छा",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "tr": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "merhaba",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "hoşça kal",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "öğleden sonra",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "akşam",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "gün",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "iyi",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "nl": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hallo",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "tot ziens",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "middag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "avond",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "goed",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "pl": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "cześć",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "do widzenia",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "popołudnie",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "wieczór",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dzień",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dobry",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "sv": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hej",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "hej då",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "eftermiddag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "kväll",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "bra",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "da": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hej",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "farvel",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "eftermiddag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "aften",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "god",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "no": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hei",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ha det",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ettermiddag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "kveld",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dag",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "god",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "fi": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "hei",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "hei hei",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "iltapäivä",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ilta",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "päivä",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "hyvä",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "cs": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "ahoj",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "na shledanou",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "odpoledne",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "večer",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "den",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dobrý",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "hu": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "szia",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "viszontlátásra",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "délután",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "este",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "nap",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "jó",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "ro": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "salut",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "la revedere",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "după-amiază",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "seară",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "zi",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "bun",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "el": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "γεια",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "αντίο",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "απόγευμα",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "βράδυ",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ημέρα",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "καλό",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "bg": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "здравей",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "довиждане",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "следобед",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "вечер",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ден",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "добър",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "uk": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "привіт",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "до побачення",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "після обіду",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "вечір",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "день",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "добрий",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "hr": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "zdravo",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "doviđenja",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "popodne",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "večer",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dan",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dobar",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "sr": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "здраво",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "довиђења",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "поподне",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "вече",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "дан",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "добар",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "bs": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "zdravo",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "doviđenja",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "popodne",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "veče",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dan",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "dobar",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
      "vi": VocabResponse(
        vocab: [
          ConstructIdentifier(
            lemma: "xin chào",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "tạm biệt",
            category: "INTJ",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "buổi chiều",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "buổi tối",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "ngày",
            category: "NOUN",
            type: ConstructTypeEnum.vocab,
          ),
          ConstructIdentifier(
            lemma: "tốt",
            category: "ADJ",
            type: ConstructTypeEnum.vocab,
          ),
        ],
      ),
    };

    return placeholder[language!.langCodeShort]!;
  }
}
