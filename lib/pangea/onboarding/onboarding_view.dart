import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/onboarding/onboarding.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_complete.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_constants.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_step.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_steps_enum.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class OnboardingView extends StatelessWidget {
  final OnboardingController controller;

  const OnboardingView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final screenheight = MediaQuery.of(context).size.height;

    return Material(
      child: StreamBuilder(
        key: ValueKey(
          client.userID.toString(),
        ),
        stream: client.onSync.stream
            .where((s) => s.hasRoomUpdate)
            .rateLimit(const Duration(seconds: 1)),
        builder: (context, _) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              if (isColumnMode && !OnboardingController.isClosed)
                Positioned(
                  bottom: 0.0,
                  child: AnimatedOpacity(
                    duration: FluffyThemes.animationDuration,
                    opacity: OnboardingController.isComplete ? 1.0 : 0.3,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${AppConfig.assetsBaseURL}/${OnboardingConstants.onboardingImageFileName}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              AnimatedContainer(
                duration: FluffyThemes.animationDuration,
                height: OnboardingController.isClosed ? 0 : screenheight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: isColumnMode ? 20.0 : 8.0,
                  ),
                  child: MaxWidthBody(
                    showBorder: false,
                    maxWidth: 850.0,
                    child: Column(
                      children: [
                        Text(
                          L10n.of(context).getStarted,
                          style: TextStyle(
                            fontSize: isColumnMode ? 32.0 : 16.0,
                            height: isColumnMode ? 1.2 : 1.5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            isColumnMode ? 40.0 : 12.0,
                          ),
                          child: Row(
                            spacing: 8.0,
                            mainAxisSize: MainAxisSize.min,
                            children: OnboardingStepsEnum.values.map((step) {
                              final complete =
                                  OnboardingController.complete(step);
                              return CircleAvatar(
                                radius: 6.0,
                                backgroundColor: complete
                                    ? AppConfig.success
                                    : Theme.of(context).colorScheme.primary,
                                child: CircleAvatar(
                                  radius: 3.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        OnboardingController.isComplete
                            ? OnboardingComplete(
                                controller: controller,
                              )
                            : Column(
                                spacing: 12.0,
                                children: [
                                  for (final step in OnboardingStepsEnum.values)
                                    OnboardingStep(
                                      step: step,
                                      isComplete:
                                          OnboardingController.complete(step),
                                      onPressed: () =>
                                          controller.onPressed(step),
                                    ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
