import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/pages/views/homeserver_picker_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../utils/localized_exception_extension.dart';

class HomeserverPicker extends StatefulWidget {
  @override
  HomeserverPickerController createState() => HomeserverPickerController();
}

class HomeserverPickerController extends State<HomeserverPicker> {
  bool isLoading = false;
  String domain = AppConfig.defaultHomeserver;
  final TextEditingController homeserverController =
      TextEditingController(text: AppConfig.defaultHomeserver);

  /// Starts an analysis of the given homeserver. It uses the current domain and
  /// makes sure that it is prefixed with https. Then it searches for the
  /// well-known information and forwards to the login page depending on the
  /// login type. For SSO login only the app opens the page and otherwise it
  /// forwards to the route `/signup`.
  void checkHomeserverAction() async {
    try {
      if (domain.isEmpty) throw L10n.of(context).changeTheHomeserver;
      var homeserver = domain;

      if (!homeserver.startsWith('https://')) {
        homeserver = 'https://$homeserver';
      }

      setState(() => isLoading = true);
      final wellKnown =
          await Matrix.of(context).client.checkHomeserver(homeserver);

      var jitsi = wellKnown?.content
          ?.tryGet<Map<String, dynamic>>('im.vector.riot.jitsi')
          ?.tryGet<String>('preferredDomain');
      if (jitsi != null) {
        if (!jitsi.endsWith('/')) {
          jitsi += '/';
        }
        Logs().v('Found custom jitsi instance $jitsi');
        await Matrix.of(context)
            .store
            .setItem(SettingKeys.jitsiInstance, jitsi);
        AppConfig.jitsiInstance = jitsi;
      }

      await AdaptivePageLayout.of(context)
          .pushNamed(AppConfig.enableRegistration ? '/signup' : '/login');
    } catch (e) {
      AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(content: Text((e as Object).toLocalizedString(context))));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => HomeserverPickerView(this);
}
