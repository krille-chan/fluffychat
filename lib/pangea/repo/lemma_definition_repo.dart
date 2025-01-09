import 'dart:convert';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/models/lemma.dart';
import 'package:fluffychat/pangea/network/requests.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:http/http.dart';

class LemmaDefinitionRequest {
  final Lemma _lemma;
  final String partOfSpeech;
  final String lemmaLang;
  final String userL1;

  LemmaDefinitionRequest({
    required this.partOfSpeech,
    required this.lemmaLang,
    required this.userL1,
    required Lemma lemma,
  }) : _lemma = lemma;

  String get lemma {
    if (_lemma.text.isNotEmpty) {
      return _lemma.text;
    }
    ErrorHandler.logError(
      e: "Found lemma with empty text",
      data: {
        'lemma': _lemma,
        'part_of_speech': partOfSpeech,
        'lemma_lang': lemmaLang,
        'user_l1': userL1,
      },
    );
    return _lemma.form;
  }

  Map<String, dynamic> toJson() {
    return {
      'lemma': lemma,
      'part_of_speech': partOfSpeech,
      'lemma_lang': lemmaLang,
      'user_l1': userL1,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LemmaDefinitionRequest &&
          runtimeType == other.runtimeType &&
          lemma == other.lemma &&
          partOfSpeech == other.partOfSpeech &&
          lemmaLang == other.lemmaLang &&
          userL1 == other.userL1;

  @override
  int get hashCode =>
      lemma.hashCode ^
      partOfSpeech.hashCode ^
      lemmaLang.hashCode ^
      userL1.hashCode;
}

class LemmaDefinitionResponse {
  final List<String> emoji;
  final String meaning;

  LemmaDefinitionResponse({
    required this.emoji,
    required this.meaning,
  });

  factory LemmaDefinitionResponse.fromJson(Map<String, dynamic> json) {
    return LemmaDefinitionResponse(
      emoji: (json['emoji'] as List<dynamic>).map((e) => e as String).toList(),
      meaning: json['meaning'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'meaning': meaning,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LemmaDefinitionResponse &&
          runtimeType == other.runtimeType &&
          emoji.length == other.emoji.length &&
          emoji.every((element) => other.emoji.contains(element)) &&
          meaning == other.meaning;

  @override
  int get hashCode =>
      emoji.fold(0, (prev, element) => prev ^ element.hashCode) ^
      meaning.hashCode;
}

class LemmaDictionaryRepo {
  // In-memory cache with timestamps
  static final Map<LemmaDefinitionRequest, LemmaDefinitionResponse> _cache = {};
  static final Map<LemmaDefinitionRequest, DateTime> _cacheTimestamps = {};

  static const Duration _cacheDuration = Duration(days: 2);

  static Future<LemmaDefinitionResponse> get(
    LemmaDefinitionRequest request,
  ) async {
    _clearExpiredEntries();

    // Check the cache first
    if (_cache.containsKey(request)) {
      return _cache[request]!;
    }

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final requestBody = request.toJson();
    final Response res = await req.post(
      url: PApiUrls.lemmaDictionary,
      body: requestBody,
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = LemmaDefinitionResponse.fromJson(decodedBody);

    // Store the response and timestamp in the cache
    _cache[request] = response;
    _cacheTimestamps[request] = DateTime.now();

    return response;
  }

  /// From the cache, get a random set of cached definitions that are not for a specific lemma
  static List<String> getDistractorDefinitions(
    String lemma,
    int count,
  ) {
    _clearExpiredEntries();

    final List<String> definitions = [];
    for (final entry in _cache.entries) {
      if (entry.key.lemma != lemma) {
        definitions.add(entry.value.meaning);
      }
    }

    definitions.shuffle();

    return definitions.take(count).toList();
  }

  static void _clearExpiredEntries() {
    final now = DateTime.now();
    final expiredKeys = _cacheTimestamps.entries
        .where((entry) => now.difference(entry.value) > _cacheDuration)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }
}
