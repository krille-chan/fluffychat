// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';

// Project imports:
import '../../enum/time_span.dart';

class TimeSpanMenuButton extends StatelessWidget {
  final TimeSpan value;
  final void Function(TimeSpan) onChange;
  const TimeSpanMenuButton(
      {Key? key, required this.value, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TimeSpan>(
      icon: const Icon(Icons.calendar_month_outlined),
      tooltip: L10n.of(context)!.changeDateRange,
      initialValue: value,
      onSelected: (TimeSpan? timeSpan) {
        if (timeSpan == null) {
          debugPrint("when is timeSpan null?");
          return;
        }
        onChange(timeSpan);
      },
      itemBuilder: (BuildContext context) =>
          TimeSpan.values.map<PopupMenuEntry<TimeSpan>>((TimeSpan timeSpan) {
        return PopupMenuItem<TimeSpan>(
          value: timeSpan,
          child: Text(timeSpan.string(context)),
        );
      }).toList(),
    );
  }
}
