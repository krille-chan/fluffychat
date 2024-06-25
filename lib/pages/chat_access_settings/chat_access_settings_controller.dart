import 'package:flutter/material.dart' hide Visibility;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_access_settings/chat_access_settings_page.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChatAccessSettings extends StatefulWidget {
  final String roomId;
  const ChatAccessSettings({required this.roomId, super.key});

  @override
  State<ChatAccessSettings> createState() => ChatAccessSettingsController();
}

class ChatAccessSettingsController extends State<ChatAccessSettings> {
  bool joinRulesLoading = false;
  bool visibilityLoading = false;
  bool historyVisibilityLoading = false;
  bool guestAccessLoading = false;
  Room get room => Matrix.of(context).client.getRoomById(widget.roomId)!;

  void setJoinRule(JoinRules? newJoinRules) async {
    if (newJoinRules == null) return;
    setState(() {
      joinRulesLoading = true;
    });

    try {
      await room.setJoinRules(newJoinRules);
    } catch (e, s) {
      Logs().w('Unable to change join rules', e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toLocalizedString(context),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          joinRulesLoading = false;
        });
      }
    }
  }

  void setHistoryVisibility(HistoryVisibility? historyVisibility) async {
    if (historyVisibility == null) return;
    setState(() {
      historyVisibilityLoading = true;
    });

    try {
      await room.setHistoryVisibility(historyVisibility);
    } catch (e, s) {
      Logs().w('Unable to change history visibility', e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toLocalizedString(context),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          historyVisibilityLoading = false;
        });
      }
    }
  }

  void setGuestAccess(GuestAccess? guestAccess) async {
    if (guestAccess == null) return;
    setState(() {
      guestAccessLoading = true;
    });

    try {
      await room.setGuestAccess(guestAccess);
    } catch (e, s) {
      Logs().w('Unable to change guest access', e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toLocalizedString(context),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          guestAccessLoading = false;
        });
      }
    }
  }

  void updateRoomAction() async {
    final roomVersion = room
        .getState(EventTypes.RoomCreate)!
        .content
        .tryGet<String>('room_version');
    final capabilitiesResult = await showFutureLoadingDialog(
      context: context,
      future: () => room.client.getCapabilities(),
    );
    final capabilities = capabilitiesResult.result;
    if (capabilities == null) return;
    final newVersion = await showConfirmationDialog<String>(
      context: context,
      title: L10n.of(context)!.replaceRoomWithNewerVersion,
      actions: capabilities.mRoomVersions!.available.entries
          .where((r) => r.key != roomVersion)
          .map(
            (version) => AlertDialogAction(
              key: version.key,
              label:
                  '${version.key} (${version.value.toString().split('.').last})',
            ),
          )
          .toList(),
    );
    if (newVersion == null ||
        OkCancelResult.cancel ==
            await showOkCancelAlertDialog(
              useRootNavigator: false,
              context: context,
              okLabel: L10n.of(context)!.yes,
              cancelLabel: L10n.of(context)!.cancel,
              title: L10n.of(context)!.areYouSure,
              message: L10n.of(context)!.roomUpgradeDescription,
              isDestructiveAction: true,
            )) {
      return;
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room.client.upgradeRoom(room.id, newVersion),
    );
  }

  Future<void> addAlias() async {
    final domain = room.client.userID?.domain;
    if (domain == null) {
      throw Exception('userID or domain is null! This should never happen.');
    }

    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.editRoomAliases,
      textFields: [
        DialogTextField(
          prefixText: '#',
          suffixText: domain,
          hintText: L10n.of(context)!.alias,
        ),
      ],
    );
    final aliasLocalpart = input?.singleOrNull?.trim();
    if (aliasLocalpart == null || aliasLocalpart.isEmpty) return;
    final alias = '#$aliasLocalpart:$domain';

    final result = await showFutureLoadingDialog(
      context: context,
      future: () => room.client.setRoomAlias(alias, room.id),
    );
    if (result.error != null) return;
    setState(() {});

    if (!room.canChangeStateEvent(EventTypes.RoomCanonicalAlias)) return;

    final canonicalAliasConsent = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.setAsCanonicalAlias,
      message: alias,
      okLabel: L10n.of(context)!.yes,
      cancelLabel: L10n.of(context)!.no,
    );

    final altAliases = room
            .getState(EventTypes.RoomCanonicalAlias)
            ?.content
            .tryGetList<String>('alt_aliases')
            ?.toSet() ??
        {};
    if (room.canonicalAlias.isNotEmpty) altAliases.add(room.canonicalAlias);
    altAliases.add(alias);
    if (canonicalAliasConsent == OkCancelResult.ok) {
      altAliases.remove(alias);
    } else {
      altAliases.remove(room.canonicalAlias);
    }

    await showFutureLoadingDialog(
      context: context,
      future: () => room.client.setRoomStateWithKey(
        room.id,
        EventTypes.RoomCanonicalAlias,
        '',
        {
          'alias': canonicalAliasConsent == OkCancelResult.ok
              ? alias
              : room.canonicalAlias,
          if (altAliases.isNotEmpty) 'alt_aliases': altAliases.toList(),
        },
      ),
    );
  }

  void deleteAlias(String alias) async {
    await showFutureLoadingDialog(
      context: context,
      future: () => room.client.deleteRoomAlias(alias),
    );
    setState(() {});
  }

  void setChatVisibilityOnDirectory(bool? visibility) async {
    if (visibility == null) return;
    setState(() {
      visibilityLoading = true;
    });

    try {
      await room.client.setRoomVisibilityOnDirectory(
        room.id,
        visibility: visibility == true ? Visibility.public : Visibility.private,
      );
      setState(() {});
    } catch (e, s) {
      Logs().w('Unable to change visibility', e, s);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toLocalizedString(context),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          visibilityLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatAccessSettingsPageView(this);
  }
}
