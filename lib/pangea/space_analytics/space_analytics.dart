import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_downloads/space_analytics_summary_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_list_model.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/space_analytics/analytics_download_model.dart';
import 'package:fluffychat/pangea/space_analytics/analytics_requests_repo.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics_download_enum.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics_inactive_dialog.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics_request_dialog.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics_view.dart';
import 'package:fluffychat/pangea/user/models/analytics_profile_model.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

// enum DownloadStatus {
//   loading,
//   available,
//   unavailable,
//   notFound;
// }

// enum RequestStatus {
//   available,
//   unrequested,
//   requested,
//   notFound;

// static RequestStatus? fromString(String value) {
//   switch (value) {
//     case 'available':
//       return RequestStatus.available;
//     case 'unrequested':
//       return RequestStatus.unrequested;
//     case 'requested':
//       return RequestStatus.requested;
//     case 'notFound':
//       return RequestStatus.notFound;
//     default:
//       return null;
//   }
// }

// IconData get icon {
//   switch (this) {
//     case RequestStatus.available:
//       return Icons.check_circle;
//     case RequestStatus.unrequested:
//       return Symbols.approval_delegation;
//     case RequestStatus.requested:
//       return Icons.mark_email_read_outlined;
//     case RequestStatus.notFound:
//       return Symbols.approval_delegation;
//   }
// }

// String label(BuildContext context) {
//   final l10n = L10n.of(context);
//   switch (this) {
//     case RequestStatus.available:
//       return l10n.available;
//     case RequestStatus.unrequested:
//       return l10n.request;
//     case RequestStatus.requested:
//       return l10n.pending;
//     case RequestStatus.notFound:
//       return l10n.inactive;
//   }
// }

// Color backgroundColor(BuildContext context) {
//   final theme = Theme.of(context);
//   switch (this) {
//     case RequestStatus.available:
//     case RequestStatus.unrequested:
//       return theme.colorScheme.primaryContainer;
//     case RequestStatus.notFound:
//     case RequestStatus.requested:
//       return theme.disabledColor;
//   }
// }

// bool get showButton => this != RequestStatus.available;

// bool get enabled => this == RequestStatus.unrequested;
// }

// class AnalyticsDownload {
//   DownloadStatus status;
//   SpaceAnalyticsSummaryModel? summary;

//   AnalyticsDownload({
//     required this.status,
//     this.summary,
//   });
// }

class SpaceAnalytics extends StatefulWidget {
  final String roomId;
  const SpaceAnalytics({super.key, required this.roomId});

  @override
  SpaceAnalyticsState createState() => SpaceAnalyticsState();
}

class SpaceAnalyticsState extends State<SpaceAnalytics> {
  bool initialized = false;
  LanguageModel? selectedLanguage;
  Map<User, AnalyticsDownload> downloads = {};

  DateTime? _lastUpdated;
  final Map<User, AnalyticsProfileModel> _profiles = {};
  final Map<LanguageModel, List<User>> _langsToUsers = {};

  Room? get room => Matrix.of(context).client.getRoomById(widget.roomId);

  LanguageModel? get _userL2 {
    final l2 = MatrixState.pangeaController.languageController.userL2;
    if (l2 == null) return null;

    // Attempt to find the language model by its short code, since analytics
    // aren't divided by full language model but by short code.
    return PLanguageStore.byLangCode(l2.langCodeShort) ?? l2;
  }

  List<User> get _availableUsers =>
      room
          ?.getParticipants()
          .where(
            (member) =>
                member.id != BotName.byEnvironment &&
                member.membership == Membership.join,
          )
          .toList() ??
      [];

  List<User> get _availableUsersForLang =>
      _langsToUsers[selectedLanguage] ?? [];

  List<Room> get availableAnalyticsRooms => _availableUsersForLang
      .map((user) => _analyticsRoomOfUser(user))
      .whereType<Room>()
      .toList();

  List<LanguageModel> get availableLanguages => _langsToUsers.keys.toList()
    ..sort(
      (a, b) => (a.getDisplayName(context) ?? a.displayName)
          .compareTo(b.getDisplayName(context) ?? b.displayName),
    );

  int get completedDownloads =>
      downloads.values.where((d) => d.summary != null).length;

  List<MapEntry<User, AnalyticsDownload>> get sortedDownloads {
    final entries = downloads.entries.toList();
    entries.sort((a, b) {
      final aStatus = a.value.requestStatus;
      final bStatus = b.value.requestStatus;

      // sort available downloads first
      if (aStatus == RequestStatus.available &&
          bStatus != RequestStatus.available) {
        return -1;
      } else if (aStatus != RequestStatus.available &&
          bStatus == RequestStatus.available) {
        return 1;
      }

      // then requestable users
      if (aStatus == RequestStatus.unrequested &&
          bStatus != RequestStatus.unrequested) {
        return -1;
      } else if (aStatus != RequestStatus.unrequested &&
          bStatus == RequestStatus.unrequested) {
        return 1;
      }

      // then sort not found to the end
      if (aStatus == RequestStatus.unavailable &&
          bStatus != RequestStatus.unavailable) {
        return 1;
      } else if (aStatus != RequestStatus.unavailable &&
          bStatus == RequestStatus.unavailable) {
        return -1;
      }

      return 0;
    });
    return entries;
  }

  String? get lastUpdatedString {
    if (_lastUpdated == null) return null;
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated!);

    return difference.inDays > 0
        ? DateFormat('yyyy-MM-dd').format(_lastUpdated!)
        : DateFormat('HH:mm a').format(_lastUpdated!);
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await room?.requestParticipants(
      [Membership.join, Membership.invite, Membership.knock],
      false,
      true,
    );

    final List<Future> futures = [
      GetStorage.init('analytics_request_storage'),
      _loadProfiles(),
    ];
    await Future.wait(futures);

    selectedLanguage = availableLanguages.contains(_userL2)
        ? _userL2
        : availableLanguages.firstOrNull;

    await refresh();
    if (mounted) {
      setState(() => initialized = true);
    }
  }

  Future<void> _loadProfiles() async {
    final futures = _availableUsers.map((u) async {
      final resp = await MatrixState.pangeaController.userController
          .getPublicAnalyticsProfile(u.id);

      _profiles[u] = resp;
      if (resp.languageAnalytics == null) return;

      for (final lang in resp.languageAnalytics!.entries) {
        if (lang.value.analyticsRoomId == null) continue;
        _langsToUsers[lang.key] ??= [];
        _langsToUsers[lang.key]!.add(u);
      }
    });

    await Future.wait(futures);
  }

  Future<void> refresh() async {
    if (room == null || !room!.isSpace || selectedLanguage == null) return;

    setState(() {
      downloads = Map.fromEntries(
        _availableUsers.map(
          (user) {
            final room = _analyticsRoomOfUser(user);
            final hasLangData = _availableUsersForLang.contains(user);

            RequestStatus? requestStatus;
            if (room != null) {
              requestStatus = RequestStatus.available;
            } else if (!hasLangData) {
              requestStatus = RequestStatus.unavailable;
            } else {
              requestStatus = AnalyticsRequestsRepo.get(
                    user.id,
                    selectedLanguage!,
                  ) ??
                  RequestStatus.unrequested;
            }

            final DownloadStatus downloadStatus =
                requestStatus == RequestStatus.available
                    ? DownloadStatus.loading
                    : DownloadStatus.unavailable;

            return MapEntry(
              user,
              AnalyticsDownload(
                requestStatus: requestStatus,
                downloadStatus: downloadStatus,
              ),
            );
          },
        ),
      );
    });

    for (final user in _availableUsers) {
      final analyticsRoom = _analyticsRoomOfUser(user);
      if (analyticsRoom == null) {
        continue;
      }
      await _setAnalyticsModel(analyticsRoom);
    }

    if (mounted) {
      setState(() {
        _lastUpdated = DateTime.now();
      });
    }
  }

  Future<void> _setAnalyticsModel(
    Room analyticsRoom,
  ) async {
    final String? userID = analyticsRoom.creatorId;
    final user =
        room?.getParticipants().firstWhereOrNull((p) => p.id == userID);
    if (user == null) return;

    SpaceAnalyticsSummaryModel? summary;
    final constructEvents = await analyticsRoom.getAnalyticsEvents(
      userId: userID!,
    );

    if (constructEvents == null) {
      downloads[user] = AnalyticsDownload(
        requestStatus: RequestStatus.available,
        downloadStatus: DownloadStatus.complete,
        summary: SpaceAnalyticsSummaryModel.emptyModel(userID),
      );
    } else {
      final List<OneConstructUse> uses = [];
      for (final event in constructEvents) {
        uses.addAll(event.content.uses);
      }

      final constructs = ConstructListModel(uses: uses);
      summary = SpaceAnalyticsSummaryModel.fromConstructListModel(
        userID,
        constructs,
        analyticsRoom.activityRoomIds.length,
        (use) =>
            getGrammarCopy(
              category: use.category,
              lemma: use.lemma,
              context: context,
            ) ??
            use.lemma,
        context,
      );

      downloads[user] = AnalyticsDownload(
        requestStatus: RequestStatus.available,
        downloadStatus: DownloadStatus.complete,
        summary: summary,
      );
    }

    if (mounted) setState(() {});
  }

  Future<void> _requestAnalytics(User user) async {
    RequestStatus? status = downloads[user]?.requestStatus;
    if (status == RequestStatus.unavailable ||
        status == RequestStatus.available) {
      return;
    }

    try {
      final roomId = _analyticsRoomIdOfUser(user);
      if (roomId == null) return;
      await Matrix.of(context).client.knockRoom(roomId);
      status = RequestStatus.requested;
    } catch (e) {
      status = RequestStatus.unavailable;
      if (!AnalyticsRequestsRepo.getAll().any(
        (status) => status == RequestStatus.unavailable,
      )) {
        showDialog(
          context: context,
          builder: (_) {
            return const SpaceAnalyticsInactiveDialog();
          },
        );
      }
    } finally {
      if (status != null) {
        await AnalyticsRequestsRepo.set(
          user.id,
          selectedLanguage!,
          status,
        );

        downloads[user]?.requestStatus = status;
      }

      if (mounted) setState(() {});
    }
  }

  Future<void> requestAnalytics(User user) async {
    final status = downloads[user]?.requestStatus;
    if (status != RequestStatus.unrequested) return;

    await showFutureLoadingDialog(
      context: context,
      future: () => _requestAnalytics(user),
    );
  }

  Future<void> requestAllAnalytics() async {
    final resp = await showDialog(
      context: context,
      builder: (_) {
        return const SpaceAnalyticsRequestDialog();
      },
    );

    if (resp != true) return;
    final users = _availableUsersForLang
        .where(
          (user) => downloads[user]?.requestStatus == RequestStatus.unrequested,
        )
        .toList();

    final futures = users.map((user) => _requestAnalytics(user));
    await showFutureLoadingDialog(
      context: context,
      future: () => Future.wait(futures),
    );
  }

  String? _analyticsRoomIdOfUser(User user) {
    final profile = _profiles[user];
    if (profile == null || profile.languageAnalytics == null) return null;

    final entry = profile.languageAnalytics![selectedLanguage];
    return entry?.analyticsRoomId;
  }

  Room? _analyticsRoomOfUser(User user) {
    return Matrix.of(context).client.rooms.firstWhereOrNull(
          (r) =>
              r.isAnalyticsRoomOfUser(user.id) &&
              r.madeForLang == selectedLanguage?.langCodeShort,
        );
  }

  void setSelectedLanguage(LanguageModel? lang) {
    selectedLanguage = lang;
    refresh();
  }

  @override
  Widget build(BuildContext context) => SpaceAnalyticsView(controller: this);
}
