import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:fluffychat/utils/url_launcher.dart';

class ChatAppBarListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;

  static const double fixedHeight = 40.0;

  const ChatAppBarListTile({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leading = this.leading;
    final trailing = this.trailing;
    return SizedBox(
      height: fixedHeight,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (leading != null) leading,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Linkify(
                  text: title,
                  textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
                  options: const LinkifyOptions(humanize: false),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                  ),
                  linkStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: theme.colorScheme.onSurfaceVariant,
                  ),
                  onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
