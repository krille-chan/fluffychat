import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:intl/intl.dart';

class FormatTimeHelper {
  static String formatHHMMSS(int seconds) {
    if (seconds != 0) {
      final int hours = (seconds / 3600).truncate();
      seconds = (seconds % 3600).truncate();
      final int minutes = (seconds / 60).truncate();

      final String hoursStr = (hours).toString().padLeft(2, '0');
      final String minutesStr = (minutes).toString().padLeft(2, '0');
      final String secondsStr = (seconds % 60).toString().padLeft(2, '0');
      if (hours == 0) {
        return "$minutesStr:$secondsStr";
      }
      return "$hoursStr:$minutesStr:$secondsStr";
    } else {
      return " ";
    }
  }

  /// returns seconds in a prettier format supporting localizations
  /// Use l10n.localeName to pass localeName
  static String prettierTime(int seconds, String localeName) {
    return prettyDuration(
      Duration(seconds: seconds),
      locale: DurationLocale.fromLanguageCode(
            Intl.getCurrentLocale(),
          ) ??
          DurationLocale.fromLanguageCode(localeName)!,
    );
  }
}
