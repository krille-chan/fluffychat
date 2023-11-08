import 'lemma.dart';

class ChatTopic {
  String name;
  String description;
  String langCode;
  String languageLevel;
  List<DiscussionPrompt> discussionPrompts;
  List<Lemma> vocab;

  ChatTopic({
    this.name = "",
    this.description = "",
    required this.langCode,
    this.languageLevel = "Pre-A1",
    this.discussionPrompts = const [],
    this.vocab = const [],
  });

  factory ChatTopic.fromJson(Map<String, dynamic> json) {
    return ChatTopic(
      name: json['name'],
      description: json['description'],
      langCode: json['lang_code'],
      languageLevel: json['language_level'],
      discussionPrompts: (json['discussion_prompts'] as Iterable)
          .map<DiscussionPrompt>((e) => DiscussionPrompt.fromJson(e))
          .toList(),
      vocab: (json['vocab'] as Iterable)
          .map<Lemma>((e) => Lemma.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'lang_code': langCode,
      'language_level': languageLevel,
      'discussion_prompts': discussionPrompts,
      'vocab': vocab,
    };
  }

  static ChatTopic get empty => ChatTopic(
        name: '',
        description: '',
        langCode: '',
        languageLevel: '',
        discussionPrompts: [],
        vocab: [],
      );

  /// set equals operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatTopic &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          langCode == other.langCode &&
          languageLevel == other.languageLevel &&
          discussionPrompts == other.discussionPrompts &&
          vocab == other.vocab;

  /// set hashcode
  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      langCode.hashCode ^
      languageLevel.hashCode ^
      discussionPrompts.hashCode ^
      vocab.hashCode;

  /// mock data
  static ChatTopic get mockTopic => ChatTopic(
        name: 'Mock Topic',
        description: 'Mock Description',
        langCode: 'en',
        languageLevel: 'A1',
        discussionPrompts: [
          DiscussionPrompt(text: 'Mock Prompt 1'),
          DiscussionPrompt(text: 'Mock Prompt 2'),
        ],
        vocab: [
          Lemma(text: 'Mock Lemma 1', saveVocab: true, form: 'Mock Form 1'),
          Lemma(text: 'Mock Lemma 2', saveVocab: true, form: 'Mock Form 2'),
        ],
      );
}

/// just one parameter, text
class DiscussionPrompt {
  final String text;

  DiscussionPrompt({required this.text});

  factory DiscussionPrompt.fromJson(Map<String, dynamic> json) {
    return DiscussionPrompt(
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }

  /// set equals operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscussionPrompt &&
          runtimeType == other.runtimeType &&
          text == other.text;

  /// set hashcode
  @override
  int get hashCode => text.hashCode;
}
