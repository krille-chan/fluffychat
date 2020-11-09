import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

import 'package:fluffychat/components/settings_themes.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/views/settings_devices.dart';
import 'package:fluffychat/views/settings_ignore_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/adaptive_page_layout.dart';
import '../components/content_banner.dart';
import '../components/dialogs/simple_dialogs.dart';
import '../components/matrix.dart';
import '../utils/app_route.dart';
import '../config/app_config.dart';
import '../config/setting_keys.dart';
import 'app_info.dart';
import 'chat_list.dart';
import 'settings_emotes.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: Settings(),
    );
  }
}

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
    if (await SimpleDialogs(context).askConfirmation() == false) {
      return;
    }
    var matrix = Matrix.of(context);
    await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(matrix.client.logout());
  }

  void _changePasswordAccountAction(BuildContext context) async {
    final oldPassword = await SimpleDialogs(context).enterText(
      password: true,
      titleText: L10n.of(context).pleaseEnterYourPassword,
    );
    if (oldPassword == null) return;
    final newPassword = await SimpleDialogs(context).enterText(
      password: true,
      titleText: L10n.of(context).chooseAStrongPassword,
    );
    if (newPassword == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context)
          .client
          .changePassword(newPassword, oldPassword: oldPassword),
    );
    BotToast.showText(text: L10n.of(context).passwordHasBeenChanged);
  }

  void _deleteAccountAction(BuildContext context) async {
    if (await SimpleDialogs(context).askConfirmation(
          titleText: L10n.of(context).warning,
          contentText: L10n.of(context).deactivateAccountWarning,
          dangerous: true,
        ) ==
        false) {
      return;
    }
    if (await SimpleDialogs(context).askConfirmation(dangerous: true) ==
        false) {
      return;
    }
    final password = await SimpleDialogs(context).enterText(
      password: true,
      titleText: L10n.of(context).pleaseEnterYourPassword,
    );
    if (password == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context).client.deactivateAccount(auth: {
        'type': 'm.login.password',
        'user': Matrix.of(context).client.userID,
        'password': password,
      }),
    );
  }

  void setJitsiInstanceAction(BuildContext context) async {
    var jitsi = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).editJitsiInstance,
      hintText: Matrix.of(context).jitsiInstance,
      labelText: L10n.of(context).editJitsiInstance,
    );
    if (jitsi == null) return;
    if (!jitsi.endsWith('/')) {
      jitsi += '/';
    }
    final matrix = Matrix.of(context);
    await matrix.store.setItem(SettingKeys.jitsiInstance, jitsi);
    matrix.jitsiInstance = jitsi;
  }

  void setDisplaynameAction(BuildContext context) async {
    final displayname = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).editDisplayname,
      hintText:
          profile?.displayname ?? Matrix.of(context).client.userID.localpart,
      labelText: L10n.of(context).enterAUsername,
    );
    if (displayname == null) return;
    final matrix = Matrix.of(context);
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.setDisplayname(matrix.client.userID, displayname),
    );
    if (success != false) {
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
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.setAvatar(file),
    );
    if (success != false) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  void setWallpaperAction(BuildContext context) async {
    final wallpaper = await ImagePicker().getImage(source: ImageSource.gallery);
    if (wallpaper == null) return;
    Matrix.of(context).wallpaper = File(wallpaper.path);
    await Matrix.of(context)
        .store
        .setItem(SettingKeys.wallpaper, wallpaper.path);
    setState(() => null);
  }

  void deleteWallpaperAction(BuildContext context) async {
    Matrix.of(context).wallpaper = null;
    await Matrix.of(context).store.deleteItem(SettingKeys.wallpaper);
    setState(() => null);
  }

  Future<void> requestSSSSCache(BuildContext context) async {
    final handle = Matrix.of(context).client.encryption.ssss.open();
    final str = await SimpleDialogs(context).enterText(
      titleText: L10n.of(context).askSSSSCache,
      hintText: L10n.of(context).passphraseOrKey,
      password: true,
    );
    if (str != null) {
      SimpleDialogs(context).showLoadingDialog(context);
      // make sure the loading spinner shows before we test the keys
      await Future.delayed(Duration(milliseconds: 100));
      var valid = false;
      try {
        handle.unlock(recoveryKey: str);
        valid = true;
      } catch (e, s) {
        debugPrint('Couldn\'t use recovery key: ' + e.toString());
        debugPrint(s.toString());
        try {
          handle.unlock(passphrase: str);
          valid = true;
        } catch (e, s) {
          debugPrint('Couldn\'t use recovery passphrase: ' + e.toString());
          debugPrint(s.toString());
          valid = false;
        }
      }
      await Navigator.of(context)?.pop();
      if (valid) {
        await handle.maybeCacheAll();
        await SimpleDialogs(context).inform(
          contentText: L10n.of(context).cachedKeys,
        );
        setState(() {
          crossSigningCachedFuture = null;
          crossSigningCached = null;
          megolmBackupCachedFuture = null;
          megolmBackupCached = null;
        });
      } else {
        await SimpleDialogs(context).inform(
          contentText: L10n.of(context).incorrectPassphraseOrKey,
        );
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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).appBarTheme.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                L10n.of(context).settings,
                style: TextStyle(
                    color: Theme.of(context)
                        .appBarTheme
                        .textTheme
                        .headline6
                        .color),
              ),
              background: ContentBanner(
                profile?.avatarUrl,
                height: 300,
                defaultIcon: Icons.account_circle,
                loading: profile == null,
                onEdit: () => setAvatarAction(context),
              ),
            ),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                L10n.of(context).changeTheme,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ThemesSettings(),
            if (!kIsWeb && Matrix.of(context).store != null)
              Divider(thickness: 1),
            if (!kIsWeb && Matrix.of(context).store != null)
              ListTile(
                title: Text(
                  L10n.of(context).wallpaper,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (Matrix.of(context).wallpaper != null)
              ListTile(
                title: Image.file(
                  Matrix.of(context).wallpaper,
                  height: 38,
                  fit: BoxFit.cover,
                ),
                trailing: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                onTap: () => deleteWallpaperAction(context),
              ),
            if (!kIsWeb && Matrix.of(context).store != null)
              Builder(builder: (context) {
                return ListTile(
                  title: Text(L10n.of(context).changeWallpaper),
                  trailing: Icon(Icons.wallpaper),
                  onTap: () => setWallpaperAction(context),
                );
              }),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).chat,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).renderRichContent),
              trailing: Switch(
                value: AppConfig.renderHtml,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool newValue) async {
                  AppConfig.renderHtml = newValue;
                  await Matrix.of(context)
                      .store
                      .setItem(SettingKeys.renderHtml, newValue.toString());
                  setState(() => null);
                },
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).hideRedactedEvents),
              trailing: Switch(
                value: AppConfig.hideRedactedEvents,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool newValue) async {
                  AppConfig.hideRedactedEvents = newValue;
                  await Matrix.of(context).store.setItem(
                      SettingKeys.hideRedactedEvents, newValue.toString());
                  setState(() => null);
                },
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).hideUnknownEvents),
              trailing: Switch(
                value: AppConfig.hideUnknownEvents,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool newValue) async {
                  AppConfig.hideUnknownEvents = newValue;
                  await Matrix.of(context).store.setItem(
                      SettingKeys.hideUnknownEvents, newValue.toString());
                  setState(() => null);
                },
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).emoteSettings),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  EmotesSettingsView(),
                ),
              ),
              trailing: Icon(Icons.insert_emoticon),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).account,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.edit),
              title: Text(L10n.of(context).editDisplayname),
              subtitle: Text(profile?.displayname ?? client.userID.localpart),
              onTap: () => setDisplaynameAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.phone),
              title: Text(L10n.of(context).editJitsiInstance),
              subtitle: Text(Matrix.of(context).jitsiInstance),
              onTap: () => setJitsiInstanceAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.devices_other),
              title: Text(L10n.of(context).devices),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  DevicesSettingsView(),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.block),
              title: Text(L10n.of(context).ignoredUsers),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  SettingsIgnoreListView(),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.account_circle),
              title: Text(L10n.of(context).accountInformation),
              onTap: () => Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  AppInfoView(),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.bug_report),
              title: Text(L10n.of(context).sendBugReports),
              onTap: () => SentryController.toggleSentryAction(context),
            ),
            Divider(thickness: 1),
            ListTile(
              trailing: Icon(Icons.vpn_key),
              title: Text(
                'Change password',
              ),
              onTap: () => _changePasswordAccountAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.exit_to_app),
              title: Text(L10n.of(context).logout),
              onTap: () => logoutAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.delete_forever),
              title: Text(
                L10n.of(context).deleteAccount,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _deleteAccountAction(context),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).encryption,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.compare_arrows),
              title: Text(client.encryption.crossSigning.enabled
                  ? L10n.of(context).crossSigningEnabled
                  : L10n.of(context).crossSigningDisabled),
              subtitle: client.encryption.crossSigning.enabled
                  ? Text(client.isUnknownSession
                      ? L10n.of(context).unknownSessionVerify
                      : L10n.of(context).sessionVerified +
                          ', ' +
                          (crossSigningCached == null
                              ? '⌛'
                              : (crossSigningCached
                                  ? L10n.of(context).keysCached
                                  : L10n.of(context).keysMissing)))
                  : null,
              onTap: () async {
                if (!client.encryption.crossSigning.enabled) {
                  await SimpleDialogs(context).inform(
                    contentText: L10n.of(context).noCrossSignBootstrap,
                  );
                  return;
                }
                if (client.isUnknownSession) {
                  final str = await SimpleDialogs(context).enterText(
                    titleText: L10n.of(context).askSSSSVerify,
                    hintText: L10n.of(context).passphraseOrKey,
                    password: true,
                  );
                  if (str != null) {
                    SimpleDialogs(context).showLoadingDialog(context);
                    // make sure the loading spinner shows before we test the keys
                    await Future.delayed(Duration(milliseconds: 100));
                    var valid = false;
                    try {
                      await client.encryption.crossSigning
                          .selfSign(recoveryKey: str);
                      valid = true;
                    } catch (_) {
                      try {
                        await client.encryption.crossSigning
                            .selfSign(passphrase: str);
                        valid = true;
                      } catch (_) {
                        valid = false;
                      }
                    }
                    await Navigator.of(context)?.pop();
                    if (valid) {
                      await SimpleDialogs(context).inform(
                        contentText: L10n.of(context).verifiedSession,
                      );
                      setState(() {
                        crossSigningCachedFuture = null;
                        crossSigningCached = null;
                        megolmBackupCachedFuture = null;
                        megolmBackupCached = null;
                      });
                    } else {
                      await SimpleDialogs(context).inform(
                        contentText: L10n.of(context).incorrectPassphraseOrKey,
                      );
                    }
                  }
                }
                if (!(await client.encryption.crossSigning.isCached())) {
                  await requestSSSSCache(context);
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.wb_cloudy),
              title: Text(client.encryption.keyManager.enabled
                  ? L10n.of(context).onlineKeyBackupEnabled
                  : L10n.of(context).onlineKeyBackupDisabled),
              subtitle: client.encryption.keyManager.enabled
                  ? Text(megolmBackupCached == null
                      ? '⌛'
                      : (megolmBackupCached
                          ? L10n.of(context).keysCached
                          : L10n.of(context).keysMissing))
                  : null,
              onTap: () async {
                if (!client.encryption.keyManager.enabled) {
                  await SimpleDialogs(context).inform(
                    contentText: L10n.of(context).noMegolmBootstrap,
                  );
                  return;
                }
                if (!(await client.encryption.keyManager.isCached())) {
                  await requestSSSSCache(context);
                }
              },
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).about,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.help),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              trailing: Icon(Icons.privacy_tip_rounded),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              trailing: Icon(Icons.link),
              title: Text(L10n.of(context).license),
              onTap: () => showLicensePage(
                context: context,
                applicationIcon:
                    Image.asset('assets/logo.png', width: 100, height: 100),
                applicationName: AppConfig.applicationName,
              ),
            ),
            ListTile(
              trailing: Icon(Icons.code),
              title: Text(L10n.of(context).sourceCode),
              onTap: () => launch(AppConfig.sourceCodeUrl),
            ),
          ],
        ),
      ),
    );
  }
}
