import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../enum/time_span.dart';

class TimeSpanMenuButton extends StatelessWidget {
  final TimeSpan value;
  final void Function(TimeSpan) onChange;
  const TimeSpanMenuButton({
    super.key,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: PopupMenuButton<TimeSpan>(
        tooltip: L10n.of(context).changeDateRange,
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
        child: TextButton.icon(
          label: Text(
            value.string(context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          icon: Icon(
            Icons.calendar_month_outlined,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: null,
        ),
      ),
    );
  }
}
