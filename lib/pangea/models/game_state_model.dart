import 'dart:developer';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';

class GameModel {
  DateTime? currentRoundStartTime;
  DateTime? previousRoundEndTime;

  GameModel({
    this.currentRoundStartTime,
    this.previousRoundEndTime,
  });

  factory GameModel.fromJson(json) {
    return GameModel(
      currentRoundStartTime: json[ModelKey.currentRoundStartTime] != null
          ? DateTime.parse(json[ModelKey.currentRoundStartTime])
          : null,
      previousRoundEndTime: json[ModelKey.previousRoundEndTime] != null
          ? DateTime.parse(json[ModelKey.previousRoundEndTime])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    try {
      data[ModelKey.currentRoundStartTime] =
          currentRoundStartTime?.toIso8601String();
      data[ModelKey.previousRoundEndTime] =
          previousRoundEndTime?.toIso8601String();
      return data;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
      return data;
    }
  }

  StateEvent get toStateEvent => StateEvent(
        content: toJson(),
        type: PangeaEventTypes.storyGame,
      );
}
