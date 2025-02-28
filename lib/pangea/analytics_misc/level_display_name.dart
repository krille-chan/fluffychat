import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/user/models/profile_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LevelDisplayName extends StatefulWidget {
  final String userId;
  const LevelDisplayName({
    required this.userId,
    super.key,
  });

  @override
  State<LevelDisplayName> createState() => LevelDisplayNameState();
}

class LevelDisplayNameState extends State<LevelDisplayName> {
  PublicProfileModel? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final userController = MatrixState.pangeaController.userController;
      _profile = await userController.getPublicProfile(widget.userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId == BotName.byEnvironment) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Row(
        children: <Widget>[
          if (_loading)
            const CircularProgressIndicator()
          else if (_error != null || _profile == null)
            const SizedBox()
          else
            Row(
              spacing: 4.0,
              children: [
                if (_profile?.targetLanguage != null)
                  Text(
                    _profile!.targetLanguage!.langCode.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                if (_profile?.level != null) const Text("⭐"),
                if (_profile?.level != null)
                  Text(
                    "${_profile!.level!}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
