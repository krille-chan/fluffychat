import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/url_launcher.dart';

class ChatAppBarListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;

  const ChatAppBarListTile({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    final trailing = this.trailing;
    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (leading != null) leading,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Linkify(
                text: title,
                options: const LinkifyOptions(humanize: false),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  overflow: TextOverflow.ellipsis,
                  fontSize: fontSize,
                ),
                linkStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: fontSize,
                  decoration: TextDecoration.underline,
                  decorationColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
