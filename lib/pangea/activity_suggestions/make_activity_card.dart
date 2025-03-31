import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/common/widgets/customized_svg.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';

class MakeActivityCard extends StatelessWidget {
  final double width;
  final double height;
  final double padding;
  final String? roomID;

  const MakeActivityCard({
    required this.width,
    required this.height,
    required this.padding,
    this.roomID,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(padding),
      child: PressableButton(
        onPressed: () {
          roomID == null
              ? context.go('/rooms/planner')
              : context.go('/rooms/${roomID!}/planner/generator');
        },
        borderRadius: BorderRadius.circular(24.0),
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        colorFactor: theme.brightness == Brightness.dark ? 0.6 : 0.2,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24.0),
          ),
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CustomizedSvg(
                  svgUrl:
                      "${AppConfig.assetsBaseURL}/${ActivitySuggestionsConstants.crayonIconPath}",
                  colorReplacements: {
                    "#CDBEF9":
                        colorToHex(Theme.of(context).colorScheme.secondary),
                  },
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  L10n.of(context).makeYourOwnActivity,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.secondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
