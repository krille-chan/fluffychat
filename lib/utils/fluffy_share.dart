import 'package:bot_toast/bot_toast.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

abstract class FluffyShare {
  static Future<void> share(String text, BuildContext context) async {
    if (PlatformInfos.isMobile) {
      return Share.share(text);
    }
    await Clipboard.setData(
      ClipboardData(text: text),
    );
    BotToast.showText(text: L10n.of(context).copiedToClipboard);
    return;
  }
}
