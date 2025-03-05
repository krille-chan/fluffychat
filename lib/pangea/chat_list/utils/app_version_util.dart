import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AppVersionUtil {
  static final GetStorage _versionBox = GetStorage("version_storage");

  static Future<AppVersionResponse> _getAppVersion(
    String accessToken,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;

    final Requests request = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: accessToken,
    );

    Map<String, dynamic> json = {};
    final Response res = await request.post(
      url: PApiUrls.appVersion,
      body: {
        "current_version": currentVersion,
        "current_build_number": currentBuildNumber,
      },
    );

    json = jsonDecode(res.body);
    return AppVersionResponse.fromJson(json);
  }

  static Future<void> showAppVersionDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;

    final accessToken = MatrixState.pangeaController.userController.accessToken;

    AppVersionResponse? resp;
    try {
      resp = await _getAppVersion(accessToken);
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s, data: {});
      return;
    }

    final remoteVersion = resp.latestVersion;
    final remoteBuildNumber = resp.latestBuildNumber;
    bool mandatoryUpdate = resp.mandatoryUpdate;

    if (currentVersion == remoteVersion &&
        currentBuildNumber == remoteBuildNumber) {
      return;
    }

    // convert the version number string into a list of ints
    // and the build number string into an int
    final currentVersionParts =
        currentVersion.split(".").map((e) => int.parse(e)).toList();
    final remoteVersionParts =
        remoteVersion.split(".").map((e) => int.parse(e)).toList();
    final currentBuildNumberInt = int.parse(currentBuildNumber);
    final remoteBuildNumberInt = int.parse(remoteBuildNumber);

    if (currentVersionParts[0] > remoteVersionParts[0]) {
      return;
    }

    if (currentVersionParts[0] == remoteVersionParts[0] &&
        currentVersionParts[1] > remoteVersionParts[1]) {
      return;
    }

    // indicates if the current version is older than the remote version
    bool isOlderCurrentVersion = false;
    bool isDifferentVersion = false;

    // Loop through the remote and current version parts
    // and compare them. If a part of the current version
    // if less than the remote version, then the current
    // version is older than the remote version.
    // If a part of the current version is greater than the
    // remote version, then the current version is newer than
    // the remote version.
    for (int i = 0;
        i < min(currentVersionParts.length, remoteVersionParts.length);
        i++) {
      if (currentVersionParts[i] < remoteVersionParts[i]) {
        isOlderCurrentVersion = true;
        isDifferentVersion = true;
        break;
      } else if (currentVersionParts[i] > remoteVersionParts[i]) {
        isOlderCurrentVersion = false;
        isDifferentVersion = true;
        break;
      }
    }

    // if the first or second number in the remote version is greater than
    // the first or second number in the current version, then the current
    // then this is a mandatory update
    if (remoteVersionParts[0] > currentVersionParts[0] ||
        remoteVersionParts[1] > currentVersionParts[1]) {
      mandatoryUpdate = true;
    }

    // also compare the build numbers
    if (!isDifferentVersion && currentBuildNumberInt < remoteBuildNumberInt) {
      isOlderCurrentVersion = true;
    }

    if (!isOlderCurrentVersion) {
      return;
    }

    if (!mandatoryUpdate &&
        showedUpdateDialog != null &&
        DateTime.now().difference(showedUpdateDialog!) <
            const Duration(days: 1)) {
      return;
    }

    final OkCancelResult? dialogResponse = await _showDialog(
      context,
      mandatoryUpdate,
      currentVersion,
      remoteVersion,
      currentBuildNumber,
      remoteBuildNumber,
    );

    if (!mandatoryUpdate && dialogResponse != OkCancelResult.ok) {
      await _versionBox.write(
        PLocalKey.showedUpdateDialog,
        DateTime.now().toIso8601String(),
      );
    }

    if (dialogResponse == OkCancelResult.ok) {
      _launchUpdate();
    }
  }

  static Future<OkCancelResult?> _showDialog(
    BuildContext context,
    bool mandatoryUpdate,
    String currentVersion,
    String remoteVersion,
    String currentBuildNumber,
    String remoteBuildNumber,
  ) async {
    return mandatoryUpdate
        ? showOkAlertDialog(
            context: context,
            title: L10n.of(context).pleaseUpdateApp,
            okLabel: L10n.of(context).updateNow,
          )
        : showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).pleaseUpdateApp,
            okLabel: L10n.of(context).updateNow,
            cancelLabel: L10n.of(context).updateLater,
          );
  }

  static Future<void> _launchUpdate() async {
    if (kIsWeb) {
      html.window.location.reload();
      return;
    }

    final String url = PlatformInfos.isIOS
        ? AppConfig.iosUpdateURL
        : AppConfig.androidUpdateURL;
    await launchUrlString(url);
  }

  static DateTime? get showedUpdateDialog {
    final entry = _versionBox.read(PLocalKey.showedUpdateDialog);
    if (entry == null) return null;
    try {
      return DateTime.parse(entry);
    } catch (e) {
      return null;
    }
  }
}

class AppVersionResponse {
  final String latestVersion;
  final String latestBuildNumber;
  final bool mandatoryUpdate;

  AppVersionResponse({
    required this.latestVersion,
    required this.latestBuildNumber,
    required this.mandatoryUpdate,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    if (json[ModelKey.mandatoryUpdate] is! bool) {
      throw Exception("mandatory_update is not a boolean");
    }
    if (json[ModelKey.latestVersion] is! String) {
      throw Exception("latest_version is not a string");
    }
    if (json[ModelKey.latestBuildNumber] is! String) {
      throw Exception("latest_build_number is not a string");
    }

    return AppVersionResponse(
      latestVersion: json[ModelKey.latestVersion],
      latestBuildNumber: json[ModelKey.latestBuildNumber],
      mandatoryUpdate: json[ModelKey.mandatoryUpdate],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ModelKey.latestVersion: latestVersion,
      ModelKey.latestBuildNumber: latestBuildNumber,
      ModelKey.mandatoryUpdate: mandatoryUpdate,
    };
  }
}
