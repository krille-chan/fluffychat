import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/themes.dart';
import 'package:tawkie/pages/chat/chat.dart';
import 'package:tawkie/utils/date_time_extension.dart';
import 'package:tawkie/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:tawkie/widgets/avatar.dart';
import 'package:tawkie/widgets/presence_builder.dart';

class ChatAppBarTitle extends StatelessWidget {
  final ChatController controller;

  const ChatAppBarTitle(this.controller, {super.key});

  bool containsFacebook(List<String> participantsIds) {
    return participantsIds.any((id) => id.contains('@messenger2'));
  }

  bool containsInstagram(List<String> participantsIds) {
    return participantsIds.any((id) => id.contains('@instagram2_'));
  }

  bool containsWhatsApp(List<String> participantsIds) {
    return participantsIds.any((id) => id.contains('@whatsapp'));
  }

  bool containsLinkedin(List<String> participantsIds) {
    return participantsIds.any((id) => id.contains('@linkedin'));
  }

  bool containsDiscord(List<String> participantsIds) {
    return participantsIds.any((id) => id.contains('@discord'));
  }

  bool containsSignal(List<String> participantsIds) {
    return participantsIds.any((id) => id.contains('@signal'));
  }

  String removeFacebookTag(String displayname) {
    if (displayname.contains('(FB)')) {
      displayname = displayname.replaceAll('(FB)', ''); // Delete (FB)
    }
    return displayname;
  }

  String removeInstagramTag(String displayname) {
    if (displayname.contains('(IG)')) {
      displayname = displayname.replaceAll('(IG)', ''); // Delete (Instagram)
    }
    return displayname;
  }

  String removeWhatsAppTag(String displayname) {
    if (displayname.contains('(WA)')) {
      displayname = displayname.replaceAll('(WA)', ''); // Delete (WA)
    }
    return displayname;
  }

  String removeLinkedinTag(String displayname) {
    if (displayname.contains('(LinkedIn)')) {
      displayname =
          displayname.replaceAll('(LinkedIn)', ''); // Delete (LinkedIn)
    }
    return displayname;
  }

  String removeDiscordTag(String displayname) {
    if (displayname.contains('(Discord)')) {
      displayname = displayname.replaceAll('(Discord)', ''); // Delete (Discord)
    }
    return displayname;
  }

  String removeSignalTag(String displayname) {
    if (displayname.contains('(Signal)')) {
      displayname = displayname.replaceAll('(Signal)', ''); // Delete (Signal)
    }
    return displayname;
  }

  Future<List<dynamic>> loadRoomInfo(BuildContext context, Room room) async {
    List<User> participants = room.getParticipants();
    Color? networkColor;
    Image? networkImage;
    final participantsIds = participants.map((member) => member.id).toList();
    String displayname =
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));

    if (containsFacebook(participantsIds)) {
      networkColor = FluffyThemes.facebookColor;
      networkImage = Image.asset(
        'assets/facebook-messenger.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeFacebookTag(displayname);
    } else if (containsInstagram(participantsIds)) {
      networkColor = FluffyThemes.instagramColor;
      networkImage = Image.asset(
        'assets/instagram.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeInstagramTag(displayname);
    } else if (containsWhatsApp(participantsIds)) {
      networkColor = FluffyThemes.whatsAppColor;
      networkImage = Image.asset(
        'assets/whatsapp.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeWhatsAppTag(displayname);
    } else if (containsLinkedin(participantsIds)) {
      networkColor = FluffyThemes.linkedinColor;
      networkImage = Image.asset(
        'assets/linkedin.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeLinkedinTag(displayname);
    } else if (containsDiscord(participantsIds)) {
      networkColor = FluffyThemes.dicordColor;
      networkImage = Image.asset(
        'assets/discord.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeDiscordTag(displayname);
    } else if (containsSignal(participantsIds)) {
      networkColor = FluffyThemes.signalColor;
      networkImage = Image.asset(
        'assets/signal.png',
        color: networkColor,
        filterQuality: FilterQuality.high,
      );
      displayname = removeSignalTag(displayname);
    }

    return [networkColor, networkImage, displayname];
  }

  @override
  Widget build(BuildContext context) {
    final room = controller.room;
    if (controller.selectedEvents.isNotEmpty) {
      return Text(controller.selectedEvents.length.toString());
    }

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: controller.isArchived
          ? null
          : () => FluffyThemes.isThreeColumnMode(context)
              ? controller.toggleDisplayChatDetailsColumn()
              : context.go('/rooms/${room.id}/details'),
      child: FutureBuilder<List<dynamic>>(
        future: loadRoomInfo(context, room),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Row(
              children: [
                Hero(
                  tag: 'content_banner',
                  child: Avatar(
                    mxContent: room.avatar,
                    name: room.getLocalizedDisplayname(
                        MatrixLocals(L10n.of(context)!)),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    room.getLocalizedDisplayname(
                        MatrixLocals(L10n.of(context)!)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          }

          final networkColor = snapshot.data![0] as Color?;
          final networkImage = snapshot.data![1] as Image?;
          final displayname = snapshot.data![2] as String;

          return Row(
            children: [
              Hero(
                tag: 'content_banner',
                child: Avatar(
                  mxContent: room.avatar,
                  name: displayname,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              if (networkImage != null)
                SizedBox(
                  height: 16.0, // to adjust height
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: networkImage,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.light
                            ? null
                            : networkColor,
                      ),
                    ),
                    AnimatedSize(
                      duration: FluffyThemes.animationDuration,
                      child: PresenceBuilder(
                        userId: room.directChatMatrixID,
                        builder: (context, presence) {
                          final lastActiveTimestamp =
                              presence?.lastActiveTimestamp;
                          final style = Theme.of(context).textTheme.bodySmall;
                          if (presence?.currentlyActive == true) {
                            return Text(
                              L10n.of(context)!.currentlyActive,
                              style: style,
                            );
                          }
                          if (lastActiveTimestamp != null) {
                            return Text(
                              L10n.of(context)!.lastActiveAgo(
                                lastActiveTimestamp.localizedTimeShort(context),
                              ),
                              style: style,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
