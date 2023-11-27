// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import '../constants/pangea_event_types.dart';
import 'choreo_record.dart';

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
      if (kDebugMode) rethrow;
      ErrorHandler.logError(e: err, s: s);
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
