import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/toolbar/models/speech_to_text_models.dart';
import '../../common/config/environment.dart';
import '../../common/network/requests.dart';
import '../../common/network/urls.dart';

// Assuming SpeechToTextRequestModel, SpeechToTextModel and related models are already defined as in your provided code.

class _SpeechToTextCacheItem {
  Future<SpeechToTextModel> data;

  _SpeechToTextCacheItem({required this.data});
}

class SpeechToTextController {
  static final Map<int, _SpeechToTextCacheItem> _cache = {};
  late final PangeaController _pangeaController;
  Timer? _cacheClearTimer;

  SpeechToTextController(this._pangeaController) {
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

  Future<SpeechToTextModel> get(
    SpeechToTextRequestModel requestModel,
  ) async {
    final int cacheKey = requestModel.hashCode;

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.data;
    } else {
      final Future<SpeechToTextModel> response = _fetchResponse(
        accessToken: _pangeaController.userController.accessToken,
        requestModel: requestModel,
      );
      _cache[cacheKey] = _SpeechToTextCacheItem(data: response);

      return response;
    }
  }

  Future<void> saveSpeechToTextAsRepresentationEvent(
    SpeechToTextModel response,
    SpeechToTextRequestModel requestModel,
  ) {
    if (requestModel.audioEvent == null) {
      debugPrint(
        'Audio event is null, case of giving speech to text before message sent, currently not implemented',
      );
      return Future.value(null);
    }
    debugPrint('Saving transcript as matrix event');

    requestModel.audioEvent?.room
        .sendPangeaEvent(
          content: PangeaRepresentation(
            langCode: response.langCode,
            text: response.transcript.text,
            originalSent: false,
            originalWritten: false,
            speechToText: response,
          ).toJson(),
          parentEventId: requestModel.audioEvent!.eventId,
          type: PangeaEventTypes.representation,
        )
        .then(
          (_) => debugPrint('Transcript saved as matrix event'),
        );

    return Future.value(null);
  }

  Future<SpeechToTextModel> _fetchResponse({
    required String accessToken,
    required SpeechToTextRequestModel requestModel,
  }) async {
    final Requests request = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    final Response res = await request.post(
      url: PApiUrls.speechToText,
      body: requestModel.toJson(),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(utf8.decode(res.bodyBytes));

      final response = SpeechToTextModel.fromJson(json);

      saveSpeechToTextAsRepresentationEvent(response, requestModel).onError(
        (error, stackTrace) => ErrorHandler.logError(
          e: error,
          s: stackTrace,
          data: {
            "response": response.toJson(),
            "requestModel": requestModel.toJson(),
          },
        ),
      );

      return response;
    } else {
      debugPrint('Error converting speech to text: ${res.body}');
      throw Exception('Failed to convert speech to text');
    }
  }
}
