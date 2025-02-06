import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/user/models/profile_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PublicLevelIndicator extends StatelessWidget {
  final String userId;
  const PublicLevelIndicator({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profileFuture =
        MatrixState.pangeaController.userController.getPublicProfile(userId);

    return FutureBuilder<PublicProfileModel>(
      future: profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.surfaceBright,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    size: 14,
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    weight: 1000,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    L10n.of(context).oopsSomethingWentWrong,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData &&
            snapshot.data!.targetLanguage == null &&
            snapshot.data!.level == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (snapshot.data?.targetLanguage != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.surfaceBright,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        size: 14,
                        Icons.language,
                        color: Theme.of(context).colorScheme.primary,
                        weight: 1000,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        snapshot.data!.targetLanguage!.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 12),
              if (snapshot.data?.level != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.surfaceBright,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppConfig.gold,
                        radius: 8,
                        child: Icon(
                          size: 12,
                          Icons.star,
                          color: Theme.of(context).colorScheme.surfaceBright,
                          weight: 1000,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        L10n.of(context).levelShort(snapshot.data!.level!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
