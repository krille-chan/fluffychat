import 'dart:async';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import '../../widgets/matrix.dart';
import 'settings_view.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  SettingsController createState() => SettingsController();
}

class SettingsController extends State<Settings> {
  Future<bool> crossSigningCachedFuture;
  bool crossSigningCached;
  Future<bool> megolmBackupCachedFuture;
  bool megolmBackupCached;
  Future<dynamic> profileFuture;
  Profile profile;
  bool profileUpdated = false;

  void updateProfile() => setState(() {
        profileUpdated = true;
        profile = profileFuture = null;
      });

  void setAvatarAction() async {
    final action = profile?.avatarUrl == null
        ? AvatarAction.change
        : await showConfirmationDialog<AvatarAction>(
            context: context,
            title: L10n.of(context).pleaseChoose,
            actions: [
              AlertDialogAction(
                key: AvatarAction.change,
                label: L10n.of(context).changeYourAvatar,
                isDefaultAction: true,
              ),
              AlertDialogAction(
                key: AvatarAction.remove,
                label: L10n.of(context).removeYourAvatar,
                isDestructiveAction: true,
              ),
            ],
          );
    if (action == null) return;
    final matrix = Matrix.of(context);
    if (action == AvatarAction.remove) {
      final success = await showFutureLoadingDialog(
        context: context,
        future: () => matrix.client.setAvatarUrl(matrix.client.userID, null),
      );
      if (success.error == null) {
        updateProfile();
      }
      return;
    }
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName,
      );
    }
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.setAvatar(file),
    );
    if (success.error == null) {
      updateProfile();
    }
  }

  Future<void> requestSSSSCache() async {
    final handle = Matrix.of(context).client.encryption.ssss.open();
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).askSSSSCache,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).passphraseOrKey,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        )
      ],
    );
    if (input != null) {
      final valid = await showFutureLoadingDialog(
          context: context,
          future: () async {
            // make sure the loading spinner shows before we test the keys
            await Future.delayed(const Duration(milliseconds: 100));
            var valid = false;
            try {
              await handle.unlock(recoveryKey: input.single);
              valid = true;
            } catch (e, s) {
              SentryController.captureException(e, s);
            }
            return valid;
          });

      if (valid.result == true) {
        await handle.maybeCacheAll();
        await showOkAlertDialog(
          useRootNavigator: false,
          context: context,
          message: L10n.of(context).cachedKeys,
          okLabel: L10n.of(context).ok,
        );
        setState(() {
          crossSigningCachedFuture = null;
          crossSigningCached = null;
          megolmBackupCachedFuture = null;
          megolmBackupCached = null;
        });
      } else {
        await showOkAlertDialog(
          useRootNavigator: false,
          context: context,
          message: L10n.of(context).incorrectPassphraseOrKey,
          okLabel: L10n.of(context).ok,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    profileFuture ??= client
        .getProfileFromUserId(
      client.userID,
      cache: !profileUpdated,
      getFromRooms: !profileUpdated,
    )
        .then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });
    if (client.encryption != null) {
      crossSigningCachedFuture ??=
          client.encryption?.crossSigning?.isCached()?.then((c) {
        if (mounted) setState(() => crossSigningCached = c);
        return c;
      });
      megolmBackupCachedFuture ??=
          client.encryption?.keyManager?.isCached()?.then((c) {
        if (mounted) setState(() => megolmBackupCached = c);
        return c;
      });
    }
    return SettingsView(this);
  }
}

enum AvatarAction { change, remove }
