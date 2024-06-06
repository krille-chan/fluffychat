import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:matrix/matrix.dart';

import '../constants/pangea_event_types.dart';

class PracticeActivityEvent {
  Event event;
  PracticeActivityModel? _content;

  PracticeActivityEvent({required this.event}) {
    if (event.type != PangeaEventTypes.activityResponse) {
      throw Exception(
        "${event.type} should not be used to make a PracticeActivityEvent",
      );
    }
  }

  PracticeActivityModel? get practiceActivity {
    try {
      _content ??= event.getPangeaContent<PracticeActivityModel>();
      return _content!;
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s);
      return null;
    }
  }
}
