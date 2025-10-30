import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_details_popup/morph_analytics_list_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_details_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_details_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_view.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/morphs/default_morph_mapping.dart';
import 'package:fluffychat/pangea/morphs/morph_models.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ConstructAnalyticsView extends StatefulWidget {
  const ConstructAnalyticsView({
    super.key,
    required this.view,
    this.construct,
  });

  final ConstructTypeEnum view;
  final ConstructIdentifier? construct;

  @override
  ConstructAnalyticsViewState createState() => ConstructAnalyticsViewState();
}

class ConstructAnalyticsViewState extends State<ConstructAnalyticsView> {
  final TextEditingController searchController = TextEditingController();

  MorphFeaturesAndTags morphs = defaultMorphMapping;
  List<MorphFeature> features = defaultMorphMapping.displayFeatures;

  bool isSearching = false;
  ConstructLevelEnum? selectedConstructLevel;

  @override
  void initState() {
    super.initState();
    _setMorphs();
    searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _setMorphs() async {
    try {
      final resp = await MorphsRepo.get();
      morphs = resp;
      features = resp.displayFeatures;
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {"l2": MatrixState.pangeaController.languageController.userL2},
      );
    } finally {
      features.sort(
        (a, b) => morphFeatureSortOrder
            .indexOf(a.feature)
            .compareTo(morphFeatureSortOrder.indexOf(b.feature)),
      );
      if (mounted) setState(() {});
    }
  }

  void setSelectedConstructLevel(ConstructLevelEnum level) {
    setState(() {
      selectedConstructLevel = selectedConstructLevel == level ? null : level;
    });
  }

  void toggleSearching() {
    setState(() {
      isSearching = !isSearching;
      selectedConstructLevel = null;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.view == ConstructTypeEnum.morph
        ? widget.construct == null
            ? MorphAnalyticsListView(controller: this)
            : MorphDetailsView(constructId: widget.construct!)
        : widget.construct == null
            ? VocabAnalyticsListView(controller: this)
            : VocabDetailsView(constructId: widget.construct!);
  }
}
