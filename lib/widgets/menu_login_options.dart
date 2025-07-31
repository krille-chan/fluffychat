import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                SvgPicture.asset(
                  'assets/icons/store.svg',
                  width: 30,
                ),
                const SizedBox(width: 18),
                Text(L10n.of(context).menuStore),
              ],
            ),
          ),
          PopupMenuItem(
            value: MoreLoginActions.course,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/course.svg',
                  width: 30,
                ),
                const SizedBox(width: 18),
                Text(L10n.of(context).menuCourse),
              ],
            ),
          ),
          PopupMenuItem(
            value: MoreLoginActions.podcasts,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/podcast.svg',
                  width: 30,
                ),
                const SizedBox(width: 18),
                Text(L10n.of(context).menuPodcasts),
              ],
            ),
          ),
          PopupMenuItem(
            value: MoreLoginActions.about,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    Icons.info_outlined,
                    color: Theme.of(context).colorScheme.primaryFixed,
                  ),
                ),
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

enum MoreLoginActions {
  store,
  course,
  podcasts,
  about,
}
