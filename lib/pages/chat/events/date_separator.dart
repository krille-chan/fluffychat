import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/date_time_extension.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;
  const DateSeparator({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              date.localizedTimeShort(context, dateOnly: true),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 13 * AppConfig.fontSizeFactor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
