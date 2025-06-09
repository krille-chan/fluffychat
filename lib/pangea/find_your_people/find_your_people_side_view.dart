import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/find_your_people/find_your_people_constants.dart';
import 'package:fluffychat/widgets/navigation_rail.dart';

class FindYourPeopleSideView extends StatelessWidget {
  const FindYourPeopleSideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (FluffyThemes.isColumnMode(context) ||
            AppConfig.displayNavigationRail) ...[
          SpacesNavigationRail(
            activeSpaceId: null,
            onGoToChats: () => context.go('/rooms'),
            onGoToSpaceId: (spaceId) => context.go('/rooms?spaceId=$spaceId'),
          ),
          Container(
            color: Colors.transparent,
            width: 1,
          ),
        ],
        Expanded(
          child: Center(
            child: SizedBox(
              width: 250.0,
              child: CachedNetworkImage(
                imageUrl:
                    "${AppConfig.assetsBaseURL}/${FindYourPeopleConstants.sideBearFileName}",
                errorWidget: (context, url, error) => const SizedBox(),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
