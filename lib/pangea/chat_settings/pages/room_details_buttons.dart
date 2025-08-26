import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/chat_settings/pages/space_details_content.dart';
import 'package:fluffychat/widgets/hover_builder.dart';

class ButtonDetails {
  final String title;
  final String? description;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool visible;
  final bool enabled;
  final bool showInMainView;
  final SpaceSettingsTabs? tab;

  const ButtonDetails({
    required this.title,
    this.description,
    required this.icon,
    this.visible = true,
    this.enabled = true,
    this.onPressed,
    this.showInMainView = true,
    this.tab,
  });
}

class RoomDetailsButton extends StatelessWidget {
  final bool mini;
  final double height;
  final ButtonDetails buttonDetails;

  final bool selected;

  const RoomDetailsButton({
    super.key,
    required this.buttonDetails,
    required this.mini,
    required this.height,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!buttonDetails.visible) {
      return const SizedBox();
    }

    return TooltipVisibility(
      visible: mini,
      child: Tooltip(
        message: buttonDetails.title,
        child: AbsorbPointer(
          absorbing: !buttonDetails.enabled,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: HoverBuilder(
              builder: (context, hovered) {
                return GestureDetector(
                  onTap: buttonDetails.onPressed,
                  child: Opacity(
                    opacity: buttonDetails.enabled ? 1.0 : 0.5,
                    child: Container(
                      alignment: Alignment.center,
                      height: height,
                      decoration: BoxDecoration(
                        color: hovered || selected
                            ? Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withAlpha(200)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(mini ? 6 : 12.0),
                      child: mini
                          ? buttonDetails.icon
                          : Column(
                              spacing: 12.0,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buttonDetails.icon,
                                Text(
                                  buttonDetails.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
