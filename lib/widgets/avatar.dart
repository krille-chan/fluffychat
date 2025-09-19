import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:fluffychat/widgets/presence_builder.dart';

class Avatar extends StatelessWidget {
  final Uri? mxContent;
  final String? name;
  final double size;
  final void Function()? onTap;
  static const double defaultSize = 44;
  final Client? client;
  final String? presenceUserId;
  final Color? presenceBackgroundColor;
  final BorderRadius? borderRadius;
  final IconData? icon;
  final BorderSide? border;
  // #Pangea
  final bool useRive;
  final bool showPresence;
  final String? userId;

  final double? presenceSize;
  final Offset? presenceOffset;
  // Pangea#

  const Avatar({
    this.mxContent,
    this.name,
    this.size = defaultSize,
    this.onTap,
    this.client,
    this.presenceUserId,
    this.presenceBackgroundColor,
    this.borderRadius,
    this.border,
    this.icon,
    // #Pangea
    this.useRive = false,
    this.showPresence = true,
    this.userId,
    this.presenceSize,
    this.presenceOffset,
    // Pangea#
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final name = this.name;
    final fallbackLetters =
        name == null || name.isEmpty ? '@' : name.substring(0, 1);

    final noPic = mxContent == null ||
        mxContent.toString().isEmpty ||
        mxContent.toString() == 'null';
    final borderRadius = this.borderRadius ?? BorderRadius.circular(size / 2);
    final presenceUserId = this.presenceUserId;
    final container = Stack(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Material(
            color: theme.brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: border ?? BorderSide.none,
            ),
            clipBehavior: Clip.antiAlias,
            // #Pangea
            // child: noPic
            child: (userId ?? presenceUserId) == BotName.byEnvironment
                ? BotFace(
                    width: size,
                    expression: BotExpression.idle,
                    useRive: useRive,
                  )
                : noPic
                    // Pangea#
                    ? Container(
                        decoration:
                            BoxDecoration(color: name?.lightColorAvatar),
                        alignment: Alignment.center,
                        child: Text(
                          fallbackLetters,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'RobotoMono',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: (size / 2.5).roundToDouble(),
                          ),
                        ),
                      )
                    // #Pangea
                    : !(mxContent.toString().startsWith('mxc://'))
                        ? ImageByUrl(
                            imageUrl: mxContent.toString(),
                            width: size,
                            replacement: Center(
                              child: Icon(
                                icon ?? Icons.person_2,
                                color: theme.colorScheme.tertiary,
                                size: size / 1.5,
                              ),
                            ),
                            borderRadius: borderRadius,
                          )
                        // Pangea#
                        : MxcImage(
                            client: client,
                            key: ValueKey(mxContent.toString()),
                            cacheKey: '${mxContent}_$size',
                            uri: mxContent,
                            fit: BoxFit.cover,
                            width: size,
                            height: size,
                            placeholder: (_) => Center(
                              child: Icon(
                                Icons.person_2,
                                color: theme.colorScheme.tertiary,
                                size: size / 1.5,
                              ),
                            ),
                          ),
          ),
        ),
        // #Pangea
        // if (presenceUserId != null)
        if (presenceUserId != null && size >= 32.0 && showPresence)
          // Pangea#
          PresenceBuilder(
            client: client,
            userId: presenceUserId,
            builder: (context, presence) {
              if (presence == null ||
                  (presence.presence == PresenceType.offline &&
                      presence.lastActiveTimestamp == null)) {
                return const SizedBox.shrink();
              }
              final dotColor = presence.presence.isOnline
                  ? Colors.green
                  : presence.presence.isUnavailable
                      ? Colors.orange
                      : Colors.grey;
              return Positioned(
                // #Pangea
                // bottom: -3,
                // right: -3,
                bottom: presenceOffset?.dy ?? -3,
                right: presenceOffset?.dx ?? -3,
                // Pangea#
                child: Container(
                  // #Pangea
                  // width: 16,
                  // height: 16,
                  width: (presenceSize ?? 10) + 6,
                  height: (presenceSize ?? 10) + 6,
                  // Pangea#
                  decoration: BoxDecoration(
                    color: presenceBackgroundColor ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    // #Pangea
                    // width: 10,
                    // height: 10,
                    width: (presenceSize ?? 10),
                    height: (presenceSize ?? 10),
                    // Pangea#
                    decoration: BoxDecoration(
                      color: dotColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1,
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
    if (onTap == null) return container;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: container,
      ),
    );
  }
}
