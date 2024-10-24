import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SelectToDefine extends StatelessWidget {
  const SelectToDefine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Text(
        L10n.of(context)!.selectToDefine,
        style: BotStyle.text(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
