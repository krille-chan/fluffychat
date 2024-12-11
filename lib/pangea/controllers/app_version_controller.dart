import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/config/environment.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/network/requests.dart';
import 'package:fluffychat/pangea/network/urls.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

class AppVersionController {
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
    final AppVersionResponse resp = await _getAppVersion(accessToken);

    final remoteVersion = resp.latestVersion;
    final remoteBuildNumber = resp.latestBuildNumber;
    final mandatoryUpdate = resp.mandatoryUpdate;

    if (currentVersion == remoteVersion &&
        currentBuildNumber == remoteBuildNumber) {
      return;
    }

    if (!mandatoryUpdate &&
        showedUpdateDialog != null &&
        DateTime.now().difference(showedUpdateDialog!) <
            const Duration(days: 1)) {
      return;
    }

    final OkCancelResult dialogResponse =
        await _showDialog(context, mandatoryUpdate);

    if (!mandatoryUpdate && dialogResponse != OkCancelResult.ok) {
      await MatrixState.pangeaController.pStoreService.save(
        PLocalKey.showedUpdateDialog,
        DateTime.now().toIso8601String(),
      );
    }

    if (dialogResponse == OkCancelResult.ok) {
      _launchUpdate();
    }
  }

  static Future<OkCancelResult> _showDialog(
    BuildContext context,
    bool mandatoryUpdate,
  ) async {
    final title = mandatoryUpdate
        ? L10n.of(context).mandatoryUpdateRequired
        : L10n.of(context).updateAvailable;
    final message = mandatoryUpdate
        ? L10n.of(context).mandatoryUpdateRequiredDesc
        : L10n.of(context).updateAvailableDesc;
    return mandatoryUpdate
        ? showOkAlertDialog(
            context: context,
            title: title,
            message: message,
            canPop: false,
            barrierDismissible: false,
            okLabel: L10n.of(context).updateNow,
          )
        : showOkCancelAlertDialog(
            context: context,
            title: title,
            message: message,
            canPop: false,
            barrierDismissible: false,
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
    final entry = MatrixState.pangeaController.pStoreService
        .read(PLocalKey.showedUpdateDialog);
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
