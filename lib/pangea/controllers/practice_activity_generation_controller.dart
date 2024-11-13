import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/network/requests.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

/// Represents an item in the completion cache.
class _RequestCacheItem {
  MessageActivityRequest req;
  PracticeActivityModelResponse? practiceActivity;

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

  PracticeGenerationController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 2);
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => _clearCache());
  }

  void _clearCache() {
    _cache.clear();
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

  Future<MessageActivityResponse> _fetch({
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

      // workaround for the server not returning the tgtConstructs
      // if (response.activity != null &&
      //     response.activity!.tgtConstructs.isEmpty) {
      //   response.activity?.tgtConstructs.addAll(
      //     requestModel.clientTokenRequest.constructIDs,
      //   );
      // }
      return response;
    } else {
      debugger(when: kDebugMode);
      throw Exception('Failed to convert speech to text');
    }
  }

  //TODO - allow return of activity content before sending the event
  // this requires some downstream changes to the way the event is handled
  Future<PracticeActivityModelResponse?> getPracticeActivity(
    MessageActivityRequest req,
    PangeaMessageEvent event,
  ) async {
    final int cacheKey = req.hashCode;

    // debugger(when: kDebugMode);

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.practiceActivity;
    }

    final MessageActivityResponse res = await _fetch(
      accessToken: _pangeaController.userController.accessToken,
      requestModel: req,
    );

    if (res.finished) {
      debugPrint('Activity generation finished');
      return null;
    }

    final eventCompleter = Completer<PracticeActivityEvent?>();

    // if the server points to an existing event, return that event
    if (res.existingActivityEventId != null) {
      final Event? existingEvent =
          await event.room.getEventById(res.existingActivityEventId!);

      debugPrint(
        'Existing activity event found: ${existingEvent?.content}',
      );
      debugPrint(
        "eventID: ${existingEvent?.eventId}, event is redacted: ${existingEvent?.redacted}",
      );
      if (existingEvent != null && !existingEvent.redacted) {
        final activityEvent = PracticeActivityEvent(
          event: existingEvent,
          timeline: event.timeline,
        );
        eventCompleter.complete(activityEvent);
        return PracticeActivityModelResponse(
          activity: activityEvent.practiceActivity,
          eventCompleter: eventCompleter,
        );
      }
    }

    if (res.activity == null) {
      debugPrint('No activity generated');
      return null;
    }

    debugPrint('Activity generated: ${res.activity!.toJson()}');
    _sendAndPackageEvent(res.activity!, event).then((event) {
      eventCompleter.complete(event);
    });

    final responseModel = PracticeActivityModelResponse(
      activity: res.activity!,
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
