import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/dialogs/bootstrap_dialog.dart';
import 'package:fluffychat/components/sentry_switch_list_tile.dart';
import 'package:fluffychat/components/settings_switch_list_tile.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';

import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/content_banner.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../components/matrix.dart';
import '../app_config.dart';
import '../config/setting_keys.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<dynamic> profileFuture;
  dynamic profile;
  Future<bool> crossSigningCachedFuture;
  bool crossSigningCached;
  Future<bool> megolmBackupCachedFuture;
  bool megolmBackupCached;

  void logoutAction(BuildContext context) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSureYouWantToLogout,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    var matrix = Matrix.of(context);
    await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.logout(),
    );
  }

  void _changePasswordAccountAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).changePassword,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).pleaseEnterYourPassword,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
        DialogTextField(
          hintText: L10n.of(context).chooseAStrongPassword,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
      ],
    );
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context)
          .client
          .changePassword(input.last, oldPassword: input.first),
    );
    await FlushbarHelper.createSuccess(
            message: L10n.of(context).passwordHasBeenChanged)
        .show(context);
  }

  void _deleteAccountAction(BuildContext context) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).warning,
          message: L10n.of(context).deactivateAccountWarning,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    if (await showOkCancelAlertDialog(
            context: context, title: L10n.of(context).areYouSure) ==
        OkCancelResult.cancel) {
      return;
    }
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).pleaseEnterYourPassword,
      textFields: [
        DialogTextField(
          obscureText: true,
          hintText: '******',
          minLines: 1,
          maxLines: 1,
        )
      ],
    );
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.deactivateAccount(
            auth: AuthenticationPassword(
              password: input.single,
              user: Matrix.of(context).client.userID,
              identifier: AuthenticationUserIdentifier(
                  user: Matrix.of(context).client.userID),
            ),
          ),
    );
  }

  void setJitsiInstanceAction(BuildContext context) async {
    const prefix = 'https://';
    var input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).editJitsiInstance,
      textFields: [
        DialogTextField(
          initialText: AppConfig.jitsiInstance.replaceFirst(prefix, ''),
          prefixText: prefix,
        ),
      ],
    );
    if (input == null) return;
    var jitsi = prefix + input.single;
    if (!jitsi.endsWith('/')) {
      jitsi += '/';
    }
    final matrix = Matrix.of(context);
    await matrix.store.setItem(SettingKeys.jitsiInstance, jitsi);
    AppConfig.jitsiInstance = jitsi;
  }

  void setDisplaynameAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).editDisplayname,
      textFields: [
        DialogTextField(
          initialText: profile?.displayname ??
              Matrix.of(context).client.userID.localpart,
        )
      ],
    );
    if (input == null) return;
    final matrix = Matrix.of(context);
    final success = await showFutureLoadingDialog(
      context: context,
      future: () =>
          matrix.client.setDisplayname(matrix.client.userID, input.single),
    );
    if (success.error == null) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  void setAvatarAction(BuildContext context) async {
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
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
    final matrix = Matrix.of(context);
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.setAvatar(file),
    );
    if (success.error == null) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  Future<void> requestSSSSCache(BuildContext context) async {
    final handle = Matrix.of(context).client.encryption.ssss.open();
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).askSSSSCache,
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
            await Future.delayed(Duration(milliseconds: 100));
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
          context: context,
          message: L10n.of(context).cachedKeys,
        );
        setState(() {
          crossSigningCachedFuture = null;
          crossSigningCached = null;
          megolmBackupCachedFuture = null;
          megolmBackupCached = null;
        });
      } else {
        await showOkAlertDialog(
          context: context,
          message: L10n.of(context).incorrectPassphraseOrKey,
        );
      }
    }
  }

  void _setAppLockAction(BuildContext context) async {
    final currentLock =
        await FlutterSecureStorage().read(key: SettingKeys.appLockKey);
    if (currentLock?.isNotEmpty ?? false) {
      var unlocked = false;
      await showLockScreen(
        context: context,
        correctString: currentLock,
        onUnlocked: () => unlocked = true,
        canBiometric: true,
      );
      if (unlocked != true) return;
    }
    final newLock = await showTextInputDialog(
      context: context,
      title: L10n.of(context).pleaseChooseAPasscode,
      message: L10n.of(context).pleaseEnter4Digits,
      textFields: [
        DialogTextField(
          validator: (text) {
            if (int.tryParse(text) == null || int.tryParse(text) < 0) {
              return L10n.of(context).pleaseEnter4Digits;
            }
            if (text.length != 4 && text.isNotEmpty) {
              return L10n.of(context).pleaseEnter4Digits;
            }
            return null;
          },
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLines: 1,
          minLines: 1,
        )
      ],
    );
    if (newLock != null) {
      await FlutterSecureStorage()
          .write(key: SettingKeys.appLockKey, value: newLock.single);
      if (newLock.single.isEmpty) {
        AppLock.of(context).disable();
      } else {
        AppLock.of(context).enable();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    profileFuture ??= client.ownProfile.then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });
    if (client.encryption != null) {
      crossSigningCachedFuture ??=
          client.encryption.crossSigning.isCached().then((c) {
        if (mounted) setState(() => crossSigningCached = c);
        return c;
      });
      megolmBackupCachedFuture ??=
          client.encryption.keyManager.isCached().then((c) {
        if (mounted) setState(() => megolmBackupCached = c);
        return c;
      });
    }
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            elevation: Theme.of(context).appBarTheme.elevation,
            leading: BackButton(),
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            title: Text(L10n.of(context).settings,
                style: TextStyle(
                    color: Theme.of(context)
                        .appBarTheme
                        .textTheme
                        .headline6
                        .color)),
            backgroundColor: Theme.of(context).appBarTheme.color,
            flexibleSpace: FlexibleSpaceBar(
              background: ContentBanner(profile?.avatarUrl,
                  onEdit: () => setAvatarAction(context)),
            ),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                L10n.of(context).notifications,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.notifications_outlined),
              title: Text(L10n.of(context).notifications),
              onTap: () => AdaptivePageLayout.of(context)
                  .pushNamed('/settings/notifications'),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).chat,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).changeTheme),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/style'),
              trailing: Icon(Icons.style_outlined),
            ),
            SettingsSwitchListTile(
              title: L10n.of(context).renderRichContent,
              onChanged: (b) => AppConfig.renderHtml = b,
              storeKey: SettingKeys.renderHtml,
              defaultValue: AppConfig.renderHtml,
            ),
            SettingsSwitchListTile(
              title: L10n.of(context).hideRedactedEvents,
              onChanged: (b) => AppConfig.hideRedactedEvents = b,
              storeKey: SettingKeys.hideRedactedEvents,
              defaultValue: AppConfig.hideRedactedEvents,
            ),
            SettingsSwitchListTile(
              title: L10n.of(context).hideUnknownEvents,
              onChanged: (b) => AppConfig.hideUnknownEvents = b,
              storeKey: SettingKeys.hideUnknownEvents,
              defaultValue: AppConfig.hideUnknownEvents,
            ),
            ListTile(
              title: Text(L10n.of(context).emoteSettings),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/emotes'),
              trailing: Icon(Icons.insert_emoticon_outlined),
            ),
            ListTile(
              title: Text(L10n.of(context).archive),
              onTap: () => AdaptivePageLayout.of(context).pushNamed('/archive'),
              trailing: Icon(Icons.archive_outlined),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).account,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.edit_outlined),
              title: Text(L10n.of(context).editDisplayname),
              subtitle: Text(profile?.displayname ?? client.userID.localpart),
              onTap: () => setDisplaynameAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.phone_outlined),
              title: Text(L10n.of(context).editJitsiInstance),
              subtitle: Text(AppConfig.jitsiInstance),
              onTap: () => setJitsiInstanceAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.devices_other_outlined),
              title: Text(L10n.of(context).devices),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/devices'),
            ),
            ListTile(
              trailing: Icon(Icons.block_outlined),
              title: Text(L10n.of(context).ignoredUsers),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/ignore'),
            ),
            SentrySwitchListTile(),
            Divider(thickness: 1),
            ListTile(
              trailing: Icon(Icons.security_outlined),
              title: Text(
                L10n.of(context).changePassword,
              ),
              onTap: () => _changePasswordAccountAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.email_outlined),
              title: Text(L10n.of(context).passwordRecovery),
              onTap: () =>
                  AdaptivePageLayout.of(context).pushNamed('/settings/3pid'),
            ),
            ListTile(
              trailing: Icon(Icons.exit_to_app_outlined),
              title: Text(L10n.of(context).logout),
              onTap: () => logoutAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.delete_forever_outlined),
              title: Text(
                L10n.of(context).deleteAccount,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _deleteAccountAction(context),
            ),
            if (client.encryption != null) ...{
              Divider(thickness: 1),
              ListTile(
                title: Text(
                  L10n.of(context).security,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (PlatformInfos.isMobile)
                ListTile(
                  trailing: Icon(Icons.lock_outlined),
                  title: Text(L10n.of(context).appLock),
                  onTap: () => _setAppLockAction(context),
                ),
              ListTile(
                title: Text(L10n.of(context).yourPublicKey),
                onTap: () => showOkAlertDialog(
                  context: context,
                  title: L10n.of(context).yourPublicKey,
                  message: client.fingerprintKey.beautified,
                ),
                trailing: Icon(Icons.vpn_key_outlined),
              ),
              ListTile(
                title: Text(L10n.of(context).cachedKeys),
                trailing: Icon(Icons.wb_cloudy_outlined),
                subtitle: Text(
                    '${client.encryption.keyManager.enabled ? L10n.of(context).onlineKeyBackupEnabled : L10n.of(context).onlineKeyBackupDisabled}\n${client.encryption.crossSigning.enabled ? L10n.of(context).crossSigningEnabled : L10n.of(context).crossSigningDisabled}'),
                onTap: () => BootstrapDialog(
                  l10n: L10n.of(context),
                  client: Matrix.of(context).client,
                ).show(context),
              ),
            },
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).about,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => AdaptivePageLayout.of(context).pushNamed('/logs'),
            ),
            ListTile(
              trailing: Icon(Icons.help_outlined),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              trailing: Icon(Icons.privacy_tip_outlined),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              trailing: Icon(Icons.link_outlined),
              title: Text(L10n.of(context).about),
              onTap: () => PlatformInfos.showDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
