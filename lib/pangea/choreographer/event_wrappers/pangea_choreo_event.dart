import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import '../../events/constants/pangea_event_types.dart';
import '../models/choreo_record.dart';

class ChoreoEvent {
  Event event;
  ChoreoRecord? _content;

  ChoreoEvent({required this.event}) {
    if (event.type != PangeaEventTypes.choreoRecord) {
      throw Exception(
        "${event.type} should not be used to make a ChoreoEvent",
      );
    }
  }

  ChoreoRecord? get content {
    try {
      _content ??= event.getPangeaContent<ChoreoRecord>();
      return _content;
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "event": event.toJson(),
        },
      );
      return null;
    }
  }

  // bool get hasAcceptedMatches =>
  //     content?.steps.any(
  //       (element) =>
  //           element.acceptedOrIgnoredMatch?.status ==
  //           PangeaMatchStatus.accepted,
  //     ) ??
  //     false;

  // bool get hasIgnoredMatches =>
  //     content?.steps.any(
  //       (element) =>
  //           element.acceptedOrIgnoredMatch?.status == PangeaMatchStatus.ignored,
  //     ) ??
  //     false;

  // bool get includedIT =>
  //     content?.steps.any((step) {
  //       return step.acceptedOrIgnoredMatch?.status ==
  //               PangeaMatchStatus.accepted &&
  //           (step.acceptedOrIgnoredMatch?.isITStart ?? false);
  //     }) ??
  //     false;
}
