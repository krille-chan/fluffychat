import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/models/choreo_record.dart';
import 'package:fluffychat/pangea/models/representation_content_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

extension PangeaEvent on Event {
  V getPangeaContent<V>() {
    final Map<String, dynamic>? json = content[type] as Map<String, dynamic>?;

    if (json == null) {
      debugger(when: kDebugMode);
      throw Exception("$type event with null content $eventId");
    }

    //PTODO - how does this work? abstract class?
    // return V.fromJson(json);

    switch (type) {
      case PangeaEventTypes.tokens:
        return PangeaMessageTokens.fromJson(json) as V;
      case PangeaEventTypes.representation:
        return PangeaRepresentation.fromJson(json) as V;
      case PangeaEventTypes.choreoRecord:
        return ChoreoRecord.fromJson(json) as V;
      case PangeaEventTypes.activityResponse:
        return PangeaMessageTokens.fromJson(json) as V;
      default:
        throw Exception("$type events do not have pangea content");
    }
  }
}
