import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StoryVisibility { all, contacts, selected, hiddenFrom }

extension StoryVisibilityX on StoryVisibility {
  String get value => switch (this) {
        StoryVisibility.all => 'all',
        StoryVisibility.contacts => 'contacts',
        StoryVisibility.selected => 'selected',
        StoryVisibility.hiddenFrom => 'hiddenFrom',
      };

  static StoryVisibility fromValue(String? value) => switch (value) {
        'contacts' => StoryVisibility.contacts,
        'selected' => StoryVisibility.selected,
        'hiddenFrom' => StoryVisibility.hiddenFrom,
        _ => StoryVisibility.all,
      };
}

enum StoryMediaType { image, video, text }

extension StoryMediaTypeX on StoryMediaType {
  String get value => switch (this) {
        StoryMediaType.image => 'image',
        StoryMediaType.video => 'video',
        StoryMediaType.text => 'text',
      };

  static StoryMediaType fromValue(String? value) => switch (value) {
        'video' => StoryMediaType.video,
        'text' => StoryMediaType.text,
        _ => StoryMediaType.image,
      };
}

class StoryReply {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String text;
  final DateTime createdAt;

  const StoryReply({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'text': text,
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  factory StoryReply.fromJson(Map<String, dynamic> json) => StoryReply(
        id: json['id'] as String? ?? '',
        fromUserId: json['fromUserId'] as String? ?? '',
        fromUserName: json['fromUserName'] as String? ?? 'User',
        text: json['text'] as String? ?? '',
        createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '')
                ?.toLocal() ??
            DateTime.now(),
      );
}

class StoryEntry {
  final String id;
  final String authorId;
  final String authorName;
  final String? mediaPath;
  final String? text;
  final StoryMediaType mediaType;
  final StoryVisibility visibility;
  final List<String> selectedUserIds;
  final List<String> hiddenUserIds;
  final List<String> viewedBy;
  final Map<String, int> reactions;
  final List<StoryReply> replies;
  final DateTime createdAt;

  const StoryEntry({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.mediaPath,
    this.text,
    required this.mediaType,
    required this.visibility,
    this.selectedUserIds = const [],
    this.hiddenUserIds = const [],
    this.viewedBy = const [],
    this.reactions = const {},
    this.replies = const [],
    required this.createdAt,
  });

  bool hasUnreadFor(String userId) => !viewedBy.contains(userId);

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorId': authorId,
        'authorName': authorName,
        'mediaPath': mediaPath,
        'text': text,
        'mediaType': mediaType.value,
        'visibility': visibility.value,
        'selectedUserIds': selectedUserIds,
        'hiddenUserIds': hiddenUserIds,
        'viewedBy': viewedBy,
        'reactions': reactions,
        'replies': replies.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  factory StoryEntry.fromJson(Map<String, dynamic> json) => StoryEntry(
        id: json['id'] as String? ?? '',
        authorId: json['authorId'] as String? ?? 'unknown',
        authorName: json['authorName'] as String? ?? 'User',
        mediaPath: json['mediaPath'] as String?,
        text: json['text'] as String?,
        mediaType: StoryMediaTypeX.fromValue(json['mediaType'] as String?),
        visibility: StoryVisibilityX.fromValue(json['visibility'] as String?),
        selectedUserIds: List<String>.from(
          (json['selectedUserIds'] as List<dynamic>? ?? const []).map(
            (e) => e.toString(),
          ),
        ),
        hiddenUserIds: List<String>.from(
          (json['hiddenUserIds'] as List<dynamic>? ?? const []).map(
            (e) => e.toString(),
          ),
        ),
        viewedBy: List<String>.from(
          (json['viewedBy'] as List<dynamic>? ?? const []).map(
            (e) => e.toString(),
          ),
        ),
        reactions: Map<String, int>.from(
          (json['reactions'] as Map<String, dynamic>? ?? const {})
              .map((key, value) => MapEntry(key, int.tryParse(value.toString()) ?? 0)),
        ),
        replies: List<StoryReply>.from(
          (json['replies'] as List<dynamic>? ?? const [])
              .map((e) => StoryReply.fromJson(Map<String, dynamic>.from(e as Map))),
        ),
        createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '')
                ?.toLocal() ??
            DateTime.now(),
      );
}

class StoryStore {
  static const String _key = 'aerogram_stories_v1';

  const StoryStore();

  Future<List<StoryEntry>> loadStories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];

    final stories = decoded
        .map((e) => StoryEntry.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return stories;
  }

  Future<void> saveStories(List<StoryEntry> stories) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(
      stories.map((story) => story.toJson()).toList(),
    );
    await prefs.setString(_key, payload);
  }

  Future<void> addStory(StoryEntry story) async {
    final stories = await loadStories();
    final updated = [story, ...stories.where((item) => item.id != story.id)];
    await saveStories(updated);
  }

  Future<void> deleteStory(String storyId, [String? authorId]) async {
    final stories = await loadStories();
    final filtered = stories.where((story) => story.id != storyId).toList();
    await saveStories(filtered);
  }

  Future<void> markViewed(String storyId, String userId, String userName) async {
    final stories = await loadStories();
    final i = stories.indexWhere((story) => story.id == storyId);
    if (i < 0) return;

    final story = stories[i];
    final viewed = story.viewedBy.toList();
    if (!viewed.contains(userId)) {
      viewed.add(userId);
    }

    stories[i] = StoryEntry(
      id: story.id,
      authorId: story.authorId,
      authorName: story.authorName,
      mediaPath: story.mediaPath,
      text: story.text,
      mediaType: story.mediaType,
      visibility: story.visibility,
      selectedUserIds: story.selectedUserIds,
      hiddenUserIds: story.hiddenUserIds,
      viewedBy: viewed,
      reactions: story.reactions,
      replies: story.replies,
      createdAt: story.createdAt,
    );
    await saveStories(stories);
  }

  Future<void> addReaction(
    String storyId,
    String userId,
    String userName,
    String reaction,
  ) async {
    final stories = await loadStories();
    final i = stories.indexWhere((story) => story.id == storyId);
    if (i < 0) return;

    final story = stories[i];
    final reactions = Map<String, int>.from(story.reactions);
    reactions[reaction] = (reactions[reaction] ?? 0) + 1;
    stories[i] = StoryEntry(
      id: story.id,
      authorId: story.authorId,
      authorName: story.authorName,
      mediaPath: story.mediaPath,
      text: story.text,
      mediaType: story.mediaType,
      visibility: story.visibility,
      selectedUserIds: story.selectedUserIds,
      hiddenUserIds: story.hiddenUserIds,
      viewedBy: story.viewedBy,
      reactions: reactions,
      replies: story.replies,
      createdAt: story.createdAt,
    );
    await saveStories(stories);
  }

  Future<void> addReply(
    String storyId,
    String userId,
    String userName,
    String text,
  ) async {
    if (text.trim().isEmpty) return;
    final stories = await loadStories();
    final i = stories.indexWhere((story) => story.id == storyId);
    if (i < 0) return;

    final story = stories[i];
    final replies = List<StoryReply>.from(story.replies);
    replies.insert(
      0,
      StoryReply(
        id: '${story.id}_reply_${DateTime.now().microsecondsSinceEpoch}',
        fromUserId: userId,
        fromUserName: userName,
        text: text.trim(),
        createdAt: DateTime.now(),
      ),
    );
    stories[i] = StoryEntry(
      id: story.id,
      authorId: story.authorId,
      authorName: story.authorName,
      mediaPath: story.mediaPath,
      text: story.text,
      mediaType: story.mediaType,
      visibility: story.visibility,
      selectedUserIds: story.selectedUserIds,
      hiddenUserIds: story.hiddenUserIds,
      viewedBy: story.viewedBy,
      reactions: story.reactions,
      replies: replies,
      createdAt: story.createdAt,
    );
    await saveStories(stories);
  }

  static bool canView(
    StoryEntry story,
    String currentUserId, {
    List<String> contacts = const [],
    List<String> selectedUsers = const [],
    List<String> hiddenUsers = const [],
  }) {
    if (currentUserId == story.authorId) return true;
    final hiddenSet = {...story.hiddenUserIds, ...hiddenUsers};
    if (hiddenSet.contains(currentUserId)) return false;

    switch (story.visibility) {
      case StoryVisibility.all:
        return true;
      case StoryVisibility.contacts:
        return contacts.contains(currentUserId);
      case StoryVisibility.selected:
        final allowed = {
          ...story.selectedUserIds,
          ...selectedUsers,
        };
        return allowed.contains(currentUserId);
      case StoryVisibility.hiddenFrom:
        return !hiddenSet.contains(currentUserId);
    }
  }

  static bool hasUnreadFor(String currentUserId, StoryEntry story) =>
      story.authorId != currentUserId && !story.viewedBy.contains(currentUserId);
}
