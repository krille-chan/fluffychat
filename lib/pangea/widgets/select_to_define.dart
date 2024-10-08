import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SelectToDefine extends StatelessWidget {
  const SelectToDefine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(minHeight: minCardHeight),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            L10n.of(context)!.selectToDefine,
            style: BotStyle.text(context),
          ),
        ),
      ),
    );
  }
}
