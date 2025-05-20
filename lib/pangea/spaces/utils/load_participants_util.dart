import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/user/models/profile_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LoadParticipantsUtil extends StatefulWidget {
  final Room space;
  final Widget Function(LoadParticipantsUtilState) builder;

  const LoadParticipantsUtil({
    required this.space,
    required this.builder,
    super.key,
  });

  @override
  State<LoadParticipantsUtil> createState() => LoadParticipantsUtilState();
}

class LoadParticipantsUtilState extends State<LoadParticipantsUtil> {
  bool loading = true;
  String? error;

  final Map<String, PublicProfileModel> _levelsCache = {};

  List<User> get participants => widget.space.getParticipants();

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  @override
  void didUpdateWidget(LoadParticipantsUtil oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.space != widget.space) {
      _loadParticipants();
    }
  }

  Future<void> _loadParticipants() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      await widget.space.requestParticipants(
        [Membership.join, Membership.invite, Membership.knock],
        false,
        true,
      );

      await _cacheLevels();
    } catch (err, s) {
      error = err.toString();
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          'spaceId': widget.space.id,
        },
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  List<User> filteredParticipants(String filter) {
    final searchText = filter.toLowerCase();
    final filtered = participants.where((user) {
      final displayName = user.displayName?.toLowerCase() ?? '';
      return displayName.contains(searchText) ||
          user.id.toLowerCase().contains(searchText);
    }).toList();

    filtered.sort((a, b) {
      if (a.id == BotName.byEnvironment) {
        return 1;
      }
      if (b.id == BotName.byEnvironment) {
        return -1;
      }

      final PublicProfileModel? aProfile = _levelsCache[a.id];
      final PublicProfileModel? bProfile = _levelsCache[b.id];

      return (bProfile?.level ?? 0).compareTo(aProfile?.level ?? 0);
    });

    return filtered;
  }

  Future<void> _cacheLevels() async {
    for (final user in participants) {
      if (_levelsCache[user.id] == null) {
        _levelsCache[user.id] = await MatrixState
            .pangeaController.userController
            .getPublicProfile(user.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}
