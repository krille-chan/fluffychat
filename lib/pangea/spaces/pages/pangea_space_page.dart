import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/spaces/pages/pangea_space_page_view.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';

class PangeaSpacePage extends StatefulWidget {
  final Room space;

  const PangeaSpacePage({
    required this.space,
    super.key,
  });

  @override
  State<PangeaSpacePage> createState() => PangeaSpacePageState();
}

class PangeaSpacePageState extends State<PangeaSpacePage> {
  bool expanded = true;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void startSearch() {
    setState(() {});
    searchFocusNode.requestFocus();
  }

  void cancelSearch({bool unfocus = true}) {
    setState(() {
      searchController.clear();
    });
    if (unfocus) searchFocusNode.unfocus();
  }

  void toggleExpanded() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadParticipantsUtil(
      space: widget.space,
      builder: (util) => PangeaSpacePageView(
        this,
        participantsLoader: util,
      ),
    );
  }
}
