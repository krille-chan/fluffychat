import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_record_model.dart';
import '../../events/constants/pangea_event_types.dart';

class PracticeActivityRecordEvent {
  Event event;

  PracticeActivityRecordModel? _content;

  PracticeActivityRecordEvent({required this.event}) {
    if (event.type != PangeaEventTypes.activityRecord) {
      throw Exception(
        "${event.type} should not be used to make a PracticeActivityRecordEvent",
      );
    }
  }

  PracticeActivityRecordModel get record {
    _content ??= event.getPangeaContent<PracticeActivityRecordModel>();
    return _content!;
  }
}
