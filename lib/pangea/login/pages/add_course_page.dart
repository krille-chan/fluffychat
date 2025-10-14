import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';

class AddCoursePage extends StatelessWidget {
  final String route;
  const AddCoursePage({
    required this.route,
    super.key,
  });

  static String mapStartFileName = "start_trip.svg";
  static String mapUnlockFileName = "unlock_trip.svg";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined),
            Text(L10n.of(context).addCourse),
          ],
        ),
        automaticallyImplyLeading: route == 'registration',
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            constraints: const BoxConstraints(
              maxWidth: 350,
              maxHeight: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PangeaLogoSvg(
                  width: 100.0,
                  forceColor: theme.colorScheme.onSurface,
                ),
                Column(
                  spacing: 16.0,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go(
                        '/$route/course/private',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Row(
                        spacing: 4.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(
                            "${AppConfig.assetsBaseURL}/$mapUnlockFileName",
                            width: 24.0,
                            height: 24.0,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.onPrimaryContainer,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(L10n.of(context).joinCourseWithCode),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go(
                        '/$route/course/public',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Row(
                        spacing: 4.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.map_search,
                            size: 24.0,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          Text(L10n.of(context).joinPublicCourse),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go(
                        '/$route/course/own',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Row(
                        spacing: 4.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(
                            "${AppConfig.assetsBaseURL}/$mapStartFileName",
                            width: 24.0,
                            height: 24.0,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.onPrimaryContainer,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(L10n.of(context).startOwn),
                        ],
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: const Icon(Icons.school),
                      title: Text(
                        L10n.of(context).joinCourseDesc,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
