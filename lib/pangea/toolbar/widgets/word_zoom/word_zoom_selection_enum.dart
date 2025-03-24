import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';

enum WordZoomSelection {
  meaning,
  emoji,
  lemma,
  morph,
}

extension WordZoomSelectionUtils on WordZoomSelection {
  ActivityTypeEnum get activityType {
    switch (this) {
      case WordZoomSelection.meaning:
        return ActivityTypeEnum.wordMeaning;
      case WordZoomSelection.emoji:
        return ActivityTypeEnum.emoji;
      case WordZoomSelection.lemma:
        return ActivityTypeEnum.lemmaId;
      case WordZoomSelection.morph:
        return ActivityTypeEnum.morphId;
    }
  }
}
