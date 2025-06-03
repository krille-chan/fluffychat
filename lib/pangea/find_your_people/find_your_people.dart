import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/find_your_people/find_your_people_view.dart';
import 'package:fluffychat/widgets/matrix.dart';

class FindYourPeople extends StatefulWidget {
  const FindYourPeople({super.key});

  @override
  State<FindYourPeople> createState() => FindYourPeopleState();
}

class FindYourPeopleState extends State<FindYourPeople> {
  final TextEditingController searchController = TextEditingController();

  String? error;
  bool loading = true;

  Timer? _coolDown;

  final List<PublicRoomsChunk> spaceItems = [];

  @override
  void initState() {
    super.initState();
    setSpaceItems();
  }

  @override
  void dispose() {
    searchController.dispose();
    _coolDown?.cancel();
    super.dispose();
  }

  void onSearchEnter(String text, {bool globalSearch = true}) {
    if (text.isEmpty) {
      setSpaceItems();
      return;
    }

    _coolDown?.cancel();
    _coolDown = Timer(const Duration(milliseconds: 500), setSpaceItems);
  }

  Future<void> setSpaceItems() async {
    setState(() {
      loading = true;
      error = null;
      spaceItems.clear();
    });

    try {
      final resp = await Matrix.of(context).client.queryPublicRooms(
            filter: PublicRoomQueryFilter(
              roomTypes: ['m.space'],
              genericSearchTerm: searchController.text,
            ),
            limit: 100,
          );
      spaceItems.addAll(resp.chunk);
      spaceItems.sort((a, b) {
        int getPriority(item) {
          final bool hasTopic = item.topic != null && item.topic!.isNotEmpty;
          final bool hasAvatar = item.avatarUrl != null;

          if (hasTopic && hasAvatar) return 0; // Highest priority
          if (hasAvatar) return 1; // Second priority
          if (hasTopic) return 2; // Third priority
          return 3; // Lowest priority
        }

        return getPriority(a).compareTo(getPriority(b));
      });
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'searchText': searchController.text,
        },
      );
      error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FindYourPeopleView(controller: this);
  }
}
