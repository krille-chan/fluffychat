import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:url_launcher/url_launcher.dart';

enum MoreLoginActions {
  store,
  course,
  news,
  podcasts,
  about,
}

class MoreLoginMenuButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const MoreLoginMenuButton({
    super.key,
    required this.padding,
  });

  Future<void> _handleAction(
      BuildContext context, MoreLoginActions action) async {
    switch (action) {
      case MoreLoginActions.about:
        PlatformInfos.showAboutInfo(context);
        break;

      case MoreLoginActions.store:
        await launchUrl(
          Uri.parse('https://www.radiohemp.com/store/'),
          mode: LaunchMode.externalApplication,
        );
        break;

      case MoreLoginActions.course:
        await launchUrl(
          Uri.parse(
            'https://www.radiohemp.com/produto/como-plantar-maconha-medicinal/',
          ),
          mode: LaunchMode.externalApplication,
        );
        break;

      case MoreLoginActions.news:
        await launchUrl(
          Uri.parse('https://www.radiohemp.com/blog/'),
          mode: LaunchMode.externalApplication,
        );
        break;

      case MoreLoginActions.podcasts:
        await launchUrl(
          Uri.parse('https://www.radiohemp.com/podcast/'),
          mode: LaunchMode.externalApplication,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: PopupMenuButton<MoreLoginActions>(
        onSelected: (action) => _handleAction(context, action),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: MoreLoginActions.store,
            child: Row(
              children: [
                const Icon(Icons.store_outlined),
                const SizedBox(width: 18),
                Text(L10n.of(context).menuStore),
              ],
            ),
          ),
          PopupMenuItem(
            value: MoreLoginActions.course,
            child: Row(
              children: [
                const Icon(Icons.grass_outlined),
                const SizedBox(width: 18),
                Text(L10n.of(context).menuCourse),
              ],
            ),
          ),
          PopupMenuItem(
            value: MoreLoginActions.news,
            child: Row(
              children: [
                const Icon(Icons.article_outlined),
                const SizedBox(width: 18),
                Text(L10n.of(context).menuNews),
              ],
            ),
          ),
          PopupMenuItem(
            value: MoreLoginActions.podcasts,
            child: Row(
              children: [
                const Icon(Icons.podcasts_outlined),
                const SizedBox(width: 18),
                Text(L10n.of(context).menuPodcasts),
              ],
            ),
          ),
          PopupMenuItem(
            value: MoreLoginActions.about,
            child: Row(
              children: [
                const Icon(Icons.info_outlined),
                const SizedBox(width: 12),
                Text(L10n.of(context).about),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
