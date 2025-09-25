import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';

class AvatarPageHeader extends StatelessWidget {
  final Widget avatar;
  final void Function()? onAvatarEdit;
  final Widget? textButtonLeft, textButtonRight;
  final List<Widget> iconButtons;

  const AvatarPageHeader({
    super.key,
    required this.avatar,
    this.onAvatarEdit,
    this.iconButtons = const [],
    this.textButtonLeft,
    this.textButtonRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onAvatarEdit = this.onAvatarEdit;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: FluffyThemes.columnWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8.0,
          children: [
            Stack(
              children: [
                avatar,
                if (onAvatarEdit != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton.small(
                      elevation: 2,
                      onPressed: onAvatarEdit,
                      heroTag: null,
                      child: const Icon(Icons.camera_alt_outlined),
                    ),
                  ),
              ],
            ),
            TextButtonTheme(
              data: TextButtonThemeData(
                style: TextButton.styleFrom(
                  disabledForegroundColor: theme.colorScheme.onSurface,
                  foregroundColor: theme.colorScheme.onSurface,
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth / 2,
                          ),
                          child: textButtonLeft,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth / 2,
                          ),
                          child: textButtonRight,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            IconButtonTheme(
              data: IconButtonThemeData(
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainer,
                  iconSize: 24,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconButtons,
              ),
            ),
            const SizedBox(height: 0.0),
          ],
        ),
      ),
    );
  }
}
