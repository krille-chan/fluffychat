import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/user/models/analytics_profile_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LoadParticipantsBuilder extends StatefulWidget {
  final Room room;
  final bool loadProfiles;
  final Widget Function(
    BuildContext context,
    LoadParticipantsBuilderState,
  ) builder;

  const LoadParticipantsBuilder({
    required this.room,
    required this.builder,
    this.loadProfiles = false,
    super.key,
  });

  @override
  State<LoadParticipantsBuilder> createState() =>
      LoadParticipantsBuilderState();
}

class LoadParticipantsBuilderState extends State<LoadParticipantsBuilder> {
  bool loading = true;
  String? error;

  final Map<String, AnalyticsProfileModel> _levelsCache = {};

  List<User> get participants => widget.room.getParticipants();

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  @override
  void didUpdateWidget(LoadParticipantsBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room.id != widget.room.id) {
      _loadParticipants();
    }
  }

  Future<void> _loadParticipants() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      await widget.room.requestParticipants(
        [Membership.join, Membership.invite, Membership.knock],
        false,
        true,
      );

      if (widget.loadProfiles) await _cacheLevels();
    } catch (err, s) {
      error = err.toString();
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          'roomId': widget.room.id,
        },
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  List<User> get sortedParticipants {
    participants.sort((a, b) {
      if (a.id == BotName.byEnvironment) {
        return 1;
      }
      if (b.id == BotName.byEnvironment) {
        return -1;
      }

      if (a.membership != Membership.join && b.membership != Membership.join) {
        return a.displayName?.compareTo(b.displayName ?? '') ?? 0;
      } else if (a.membership != Membership.join) {
        return 1;
      } else if (b.membership != Membership.join) {
        return -1;
      }

      final AnalyticsProfileModel? aProfile = _levelsCache[a.id];
      final AnalyticsProfileModel? bProfile = _levelsCache[b.id];

      return (bProfile?.level ?? 0).compareTo(aProfile?.level ?? 0);
    });

    return participants;
  }

  Future<void> _cacheLevels() async {
    for (final user in participants) {
      if (_levelsCache[user.id] == null && user.membership == Membership.join) {
        _levelsCache[user.id] = await MatrixState
            .pangeaController.userController
            .getPublicAnalyticsProfile(user.id);
      }
    }
  }

  AnalyticsProfileModel? getAnalyticsProfile(String userId) {
    return _levelsCache[userId];
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }
}

extension LeaderboardGradient on int {
  LinearGradient? get leaderboardGradient {
    final Color? color = this == 0
        ? AppConfig.gold
        : this == 1
            ? Colors.grey[400]!
            : this == 2
                ? Colors.brown[400]!
                : null;

    if (color == null) return null;

    return LinearGradient(
      colors: [
        color,
        Colors.white,
        color,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
