// import 'package:fluffychat/l10n/l10n.dart';

// /// 200: All activities successfully retrieved
// /// 202: Waiting for activities to load
// /// 504: Timeout
// /// Other: Error
// enum ActivitySearchEnum {
//   complete,
//   waiting,
//   timeout,
//   error,
// }

// extension ActivitySearchExtension on ActivitySearchEnum {
//   ActivitySearchEnum fromCode(int statusCode) {
//     switch (statusCode) {
//       case 200:
//         return ActivitySearchEnum.complete;
//       case 202:
//         return ActivitySearchEnum.waiting;
//       case 504:
//         return ActivitySearchEnum.timeout;
//       default:
//         return ActivitySearchEnum.error;
//     }
//   }

//   bool get hideCards {
//     switch (this) {
//       case ActivitySearchEnum.complete:
//       case ActivitySearchEnum.waiting:
//         return false;
//       case ActivitySearchEnum.timeout:
//       case ActivitySearchEnum.error:
//         return true;
//     }
//   }

//   String message(L10n l10n) {
//     switch (this) {
//       case ActivitySearchEnum.waiting:
//         return l10n.activitySuggestionTimeoutMessage;
//       case ActivitySearchEnum.timeout:
//         return l10n.generatingNewActivities;
//       case ActivitySearchEnum.error:
//         return l10n.errorFetchingActivitiesMessage;
//       default:
//         return '';
//     }
//   }
// }
