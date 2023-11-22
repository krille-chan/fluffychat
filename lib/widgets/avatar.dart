import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class Avatar extends StatelessWidget {
  final Uri? mxContent;
  final String? name;
  final double size;
  final void Function()? onTap;
  static const double defaultSize = 44;
  final Client? client;
  final double fontSize;
  final String? presenceUserId;
  final Color? presenceBackgroundColor;
  //#Pangea
  final IconData? littleIcon;
  // Pangea#

  const Avatar({
    this.mxContent,
    this.name,
    this.size = defaultSize,
    this.onTap,
    this.client,
    this.fontSize = 18,
    this.presenceUserId,
    this.presenceBackgroundColor,
    //#Pangea
    this.littleIcon,
    // Pangea#
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
          fontSize: fontSize,
        ),
      ),
    );
    final borderRadius = BorderRadius.circular(size / 2);
    // #Pangea
    // final presenceUserId = this.presenceUserId;
    // final color =
    //     noPic ? name?.lightColorAvatar : Theme.of(context).secondaryHeaderColor;
    // Pangea#
    final container = Stack(
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            width: size,
            height: size,
            color: noPic
                ? name?.lightColorAvatar
                : Theme.of(context).secondaryHeaderColor,
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
        // #Pangea
        if (littleIcon != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                height: 16,
                width: 16,
                color: Colors.white,
                child: Icon(
                  littleIcon,
                  color: noPic
                      ? name?.lightColorAvatar
                      : Theme.of(context).secondaryHeaderColor,
                  size: 14,
                ),
              ),
            ),
          ),
        // PresenceBuilder(
        //   client: client,
        //   userId: presenceUserId,
        //   builder: (context, presence) {
        //     if (presence == null ||
        //         (presence.presence == PresenceType.offline &&
        //             presence.lastActiveTimestamp == null)) {
        //       return const SizedBox.shrink();
        //     }
        //     final dotColor = presence.presence.isOnline
        //         ? Colors.green
        //         : presence.presence.isUnavailable
        //             ? Colors.red
        //             : Colors.grey;
        //     return Positioned(
        //       bottom: -4,
        //       right: -4,
        //       child: Container(
        //         width: 16,
        //         height: 16,
        //         decoration: BoxDecoration(
        //           color: presenceBackgroundColor ??
        //               Theme.of(context).colorScheme.background,
        //           borderRadius: BorderRadius.circular(32),
        //         ),
        //         alignment: Alignment.center,
        //         child: Container(
        //           width: 8,
        //           height: 8,
        //           decoration: BoxDecoration(
        //             color: dotColor,
        //             borderRadius: BorderRadius.circular(16),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        // Pangea#
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
