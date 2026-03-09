import 'package:fluffychat/pages/settings_profile/settings_profile_page.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class SettingsProfilePresenter extends StatefulWidget {
  const SettingsProfilePresenter({super.key});

  @override
  State<SettingsProfilePresenter> createState() =>
      _SettingsProfilePresenterState();
}

class _SettingsProfilePresenterState extends State<SettingsProfilePresenter> {
  static const String pronounsKey = 'io.fsky.nyx.pronouns';
  static const String timezoneFallbackKey = 'us.cloke.msc4175.tz';

  TextEditingController? _pronounsController;
  String? _timezone;
  bool _isLoading = false;

  @override
  void initState() {
    _loadProfile();
    super.initState();
  }

  Future<void> _loadProfile() async {
    final client = Matrix.of(context).client;
    final cachedProfile = await client.getUserProfile(
      client.userID!,
      maxCacheAge: Duration.zero,
    );
    print(cachedProfile.additionalProperties);
    setState(() {
      _timezone =
          cachedProfile.mTz ??
          cachedProfile.additionalProperties.tryGet<String>(
            timezoneFallbackKey,
          );
      _pronounsController = TextEditingController(
        text: cachedProfile.additionalProperties.tryGet<String>(pronounsKey),
      );
    });
  }

  Future<void> _save() async {
    final client = Matrix.of(context).client;
    final cachedProfile = await client.getUserProfile(client.userID!);
    setState(() {
      _isLoading = true;
    });
    try {
      final newPronouns = _pronounsController!.text.trim();
      if (newPronouns !=
          cachedProfile.additionalProperties.tryGet<String>(pronounsKey)) {
        await client.setProfileField(client.userID!, pronounsKey, {
          pronounsKey: newPronouns,
        });
      }

      if (cachedProfile.mTz != _timezone) {
        await client.setProfileField(client.userID!, 'm.tz', {
          'm.tz': _timezone,
        });
      }
    } catch (e, s) {
      Logs().e('Unable to update profile', e, s);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => SettingsProfilePage(
    pronounsController: _pronounsController,
    save: _save,
    timezone: _timezone,
    isLoading: _isLoading,
  );
}
