import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/toolbar/models/message_activity_request.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';
import 'package:fluffychat/pangea/toolbar/repo/emoji_activity_generator.dart';
import 'package:fluffychat/pangea/toolbar/repo/lemma_activity_generator.dart';
import 'package:fluffychat/pangea/toolbar/repo/lemma_meaning_activity_generator.dart';
import 'package:fluffychat/pangea/toolbar/repo/morph_activity_generator.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Represents an item in the completion cache.
class _RequestCacheItem {
  final MessageActivityRequest req;
  final PracticeActivityModelResponse practiceActivity;
  final DateTime createdAt = DateTime.now();

  _RequestCacheItem({
    required this.req,
    required this.practiceActivity,
  });
}

/// Controller for handling activity completions.
class PracticeGenerationController {
  static final Map<int, _RequestCacheItem> _cache = {};
  Timer? _cacheClearTimer;

  late PangeaController _pangeaController;

  final _morph = MorphActivityGenerator();
  final _emoji = EmojiActivityGenerator();
  final _lemma = LemmaActivityGenerator();
  final _wordMeaning = LemmaMeaningActivityGenerator();

  PracticeGenerationController() {
    _pangeaController = MatrixState.pangeaController;
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 10);
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => _clearCache());
  }

  void _clearCache() {
    final now = DateTime.now();
    final keys = _cache.keys.toList();
    for (final key in keys) {
      final item = _cache[key]!;
      if (now.difference(item.createdAt) > const Duration(minutes: 10)) {
        _cache.remove(key);
      }
    }
  }

  void dispose() {
    _cacheClearTimer?.cancel();
  }

  Future<PracticeActivityEvent?> _sendAndPackageEvent(
    PracticeActivityModel model,
    PangeaMessageEvent pangeaMessageEvent,
  ) async {
    final Event? activityEvent = await pangeaMessageEvent.room.sendPangeaEvent(
      content: model.toJson(),
      parentEventId: pangeaMessageEvent.eventId,
      type: PangeaEventTypes.pangeaActivity,
    );

    if (activityEvent == null) {
      return null;
    }

    return PracticeActivityEvent(
      event: activityEvent,
      timeline: pangeaMessageEvent.timeline,
    );
  }

  Future<MessageActivityResponse> _fetchFromServer({
    required String accessToken,
    required MessageActivityRequest requestModel,
  }) async {
    final Requests request = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );
    final Response res = await request.post(
      url: PApiUrls.messageActivityGeneration,
      body: requestModel.toJson(),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(utf8.decode(res.bodyBytes));

      final response = MessageActivityResponse.fromJson(json);

      return response;
    } else {
      debugger(when: kDebugMode);
      throw Exception('Failed to create activity');
    }
  }

  Future<MessageActivityResponse> _routePracticeActivity({
    required String accessToken,
    required MessageActivityRequest req,
    required BuildContext context,
  }) async {
    // some activities we'll get from the server and others we'll generate locally
    switch (req.targetType) {
      case ActivityTypeEnum.emoji:
        return _emoji.get(req, context);
      case ActivityTypeEnum.lemmaId:
        return _lemma.get(req, context);
      case ActivityTypeEnum.morphId:
        return _morph.get(req);
      case ActivityTypeEnum.wordMeaning:
        debugger(when: kDebugMode);
        return _wordMeaning.get(req);
      case ActivityTypeEnum.messageMeaning:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
        return _fetchFromServer(
          accessToken: accessToken,
          requestModel: req,
        );
    }
  }

  Future<PracticeActivityModelResponse> getPracticeActivity(
    MessageActivityRequest req,
    PangeaMessageEvent event,
    BuildContext context,
  ) async {
    final int cacheKey = req.hashCode;

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.practiceActivity;
    }

    final MessageActivityResponse res = await _routePracticeActivity(
      accessToken: _pangeaController.userController.accessToken,
      req: req,
      context: context,
    );
    res.activity.content.choices.sort((a, b) => a.length.compareTo(b.length));

    // TODO resolve some wierdness here whereby the activity can be null but then... it's not
    final eventCompleter = Completer<PracticeActivityEvent?>();

    debugPrint('Activity generated: ${res.activity.toJson()}');
    _sendAndPackageEvent(res.activity, event).then((event) {
      eventCompleter.complete(event);
    });

    final responseModel = PracticeActivityModelResponse(
      activity: res.activity,
      eventCompleter: eventCompleter,
    );

    _cache[cacheKey] = _RequestCacheItem(
      req: req,
      practiceActivity: responseModel,
    );

    return responseModel;
  }
}

class PracticeActivityModelResponse {
  final PracticeActivityModel? activity;
  final Completer<PracticeActivityEvent?> eventCompleter;

  PracticeActivityModelResponse({
    required this.activity,
    required this.eventCompleter,
  });
}
