import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

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

  const Avatar({
    this.mxContent,
    this.name,
    this.size = defaultSize,
    this.onTap,
    this.client,
    this.presenceUserId,
    this.presenceBackgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var fallbackLetters = '@';
    final name = this.name;
    if (name != null) {
      if (name.runes.length >= 2) {
        fallbackLetters = String.fromCharCodes(name.runes, 0, 2);
      } else if (name.runes.length == 1) {
        fallbackLetters = name;
      }
    }
    final noPic = mxContent == null ||
        mxContent.toString().isEmpty ||
        mxContent.toString() == 'null';
    final textWidget = Center(
      child: Text(
        fallbackLetters,
        style: TextStyle(
          color: noPic ? Colors.white : null,
          fontSize: (size / 2.5).roundToDouble(),
        ),
      ),
    );
    final borderRadius = BorderRadius.circular(size / 2);
    final presenceUserId = this.presenceUserId;
    final color =
        noPic ? name?.lightColorAvatar : Theme.of(context).secondaryHeaderColor;
    final container = Stack(
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            width: size,
            height: size,
            color: color,
            child: noPic
                ? textWidget
                : MxcImage(
                    key: Key(mxContent.toString()),
                    uri: mxContent,
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                    placeholder: (_) => textWidget,
                    cacheKey: mxContent.toString(),
                  ),
          ),
        ),
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
              bottom: -3,
              right: -3,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: presenceBackgroundColor ??
                      Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(32),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dotColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.surface,
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
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: container,
    );
  }
}
