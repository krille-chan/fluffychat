import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:http/http.dart';

import '../config/environment.dart';
import '../models/chat_topic_model.dart';
import '../network/requests.dart';
import '../network/urls.dart';

/// accepts ChatTopic and calls an API for a list of Lemma
class TopicDataRepo {
  static Future<ChatTopic> generate(
    String? accessToken, {
    required TopicDataRequest request,
  }) async {
    final Requests req = Requests(
      accessToken: accessToken,
      choreoApiKey: Environment.choreoApiKey,
    );
    final Response res = await req.post(
      url: PApiUrls.topicInfo,
      body: request.toJson(),
    );

    return TopicDataResponse.fromJson(jsonDecode(res.body)).topicInfo;
  }

  /// gets list of ChatTopic from assets/chat_data.json
  static Future<List<ChatTopic>> getTopics(String langCode) async {
    final String data = await rootBundle.loadString("assets/chat_data.json");
    final jsonResult = json.decode(data);
    final List<ChatTopic> topics = [];
    for (final topic in jsonResult['chats']) {
      topics.add(ChatTopic.fromJson(topic));
    }
    return topics;
  }
}

class TopicDataResponse {
  final ChatTopic topicInfo;

  TopicDataResponse({required this.topicInfo});

  factory TopicDataResponse.fromJson(Map<String, dynamic> json) {
    return TopicDataResponse(
      topicInfo: ChatTopic.fromJson(json['topic_info']),
    );
  }
}

class TopicDataRequest {
  final ChatTopic topicInfo;
  final int numWords;
  final int numPrompts;

  TopicDataRequest({
    required this.topicInfo,
    required this.numWords,
    required this.numPrompts,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic_info': topicInfo.toJson(),
      'num_words': numWords,
      'num_prompts': numPrompts,
    };
  }
}
