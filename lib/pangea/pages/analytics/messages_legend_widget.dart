import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/enum/use_type.dart';

class MessagesLegendsListWidget extends StatelessWidget {
  const MessagesLegendsListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: UseType.values
          .map(
            // (e) => e.iconView(context, e.color(context), 20),
            (e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: e.color(context),
                  ),
                ),
                const SizedBox(width: 4),
                e.iconView(context, e.color(context), 20),
              ],
            ),
          )
          .toList(),
    );
  }
}
