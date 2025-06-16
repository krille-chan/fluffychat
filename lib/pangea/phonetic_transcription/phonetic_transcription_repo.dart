import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_request.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PhoneticTranscriptionRepo {
  static final GetStorage _storage =
      GetStorage('phonetic_transcription_storage');

  static void set(
    PhoneticTranscriptionRequest request,
    PhoneticTranscriptionResponse response,
  ) {
    response.expireAt ??= DateTime.now().add(const Duration(days: 100));
    _storage.write(request.storageKey, response.toJson());
  }

  static Future<PhoneticTranscriptionResponse> _fetch(
    PhoneticTranscriptionRequest request,
  ) async {
    final cachedJson = _storage.read(request.storageKey);
    final cached = cachedJson == null
        ? null
        : PhoneticTranscriptionResponse.fromJson(cachedJson);

    if (cached != null) {
      if (DateTime.now().isBefore(cached.expireAt!)) {
        return cached;
      } else {
        _storage.remove(request.storageKey);
      }
    }

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.phoneticTranscription,
      body: request.toJson(),
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = PhoneticTranscriptionResponse.fromJson(decodedBody);
    set(request, response);
    return response;
  }

  static Future<PhoneticTranscriptionResponse> get(
    PhoneticTranscriptionRequest request,
  ) async {
    try {
      return await _fetch(request);
    } catch (e) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, data: request.toJson());
      rethrow;
    }
  }
}
