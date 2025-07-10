import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_analytics_list_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_details_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_details_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_view.dart';
import 'package:fluffychat/pangea/analytics_downloads/analytics_download_button.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/morphs/default_morph_mapping.dart';
import 'package:fluffychat/pangea/morphs/morph_models.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsPopupWrapper extends StatefulWidget {
  const AnalyticsPopupWrapper({
    super.key,
    this.constructZoom,
    required this.view,
    this.backButtonOverride,
    this.showAppBar = true,
  });

  final ConstructTypeEnum view;
  final ConstructIdentifier? constructZoom;
  final Widget? backButtonOverride;
  final bool showAppBar;

  @override
  AnalyticsPopupWrapperState createState() => AnalyticsPopupWrapperState();
}

class AnalyticsPopupWrapperState extends State<AnalyticsPopupWrapper> {
  ConstructIdentifier? localConstructZoom;
  ConstructTypeEnum localView = ConstructTypeEnum.vocab;

  MorphFeaturesAndTags morphs = defaultMorphMapping;
  List<MorphFeature> features = defaultMorphMapping.displayFeatures;

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  ConstructLevelEnum? selectedConstructLevel;

  @override
  void initState() {
    super.initState();
    localView = widget.view;
    setConstructZoom(widget.constructZoom);
    _setMorphs();
    searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant AnalyticsPopupWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.constructZoom != oldWidget.constructZoom) {
      setConstructZoom(widget.constructZoom);
    }
    if (widget.view != oldWidget.view) {
      localView = widget.view;
      localConstructZoom = null;
      setState(() {});
    }
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

  void setConstructZoom(ConstructIdentifier? id) {
    if (id != null && id.type != localView) {
      localView = id.type;
    }
    localConstructZoom = id;
    setState(() => {});
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
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: kIsWeb
                  ? Text(
                      localView == ConstructTypeEnum.morph
                          ? ConstructTypeEnum.morph.indicator.tooltip(context)
                          : ConstructTypeEnum.vocab.indicator.tooltip(context),
                    )
                  : null,
              leading: widget.backButtonOverride ??
                  IconButton(
                    icon: localConstructZoom == null
                        ? const Icon(Icons.close)
                        : const Icon(Icons.arrow_back),
                    onPressed: localConstructZoom == null
                        ? () => Navigator.of(context).pop()
                        : () => setConstructZoom(null),
                  ),
              actions: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: localView == ConstructTypeEnum.vocab
                        ? Theme.of(context).colorScheme.primary.withAlpha(50)
                        : Theme.of(context).colorScheme.surface,
                  ),
                  label: Text(L10n.of(context).vocab),
                  icon: const Icon(Symbols.dictionary),
                  onPressed: () => setState(() {
                    localView = ConstructTypeEnum.vocab;
                    localConstructZoom = null;
                  }),
                ),
                const SizedBox(width: 4.0),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: localView == ConstructTypeEnum.morph
                        ? Theme.of(context).colorScheme.primary.withAlpha(50)
                        : Theme.of(context).colorScheme.surface,
                  ),
                  label: Text(L10n.of(context).grammar),
                  icon: const Icon(Symbols.toys_and_games),
                  onPressed: () => setState(() {
                    localView = ConstructTypeEnum.morph;
                    localConstructZoom = null;
                  }),
                ),
                const SizedBox(width: 4.0),
                if (kIsWeb) const DownloadAnalyticsButton(),
                if (kIsWeb) const SizedBox(width: 4.0),
              ],
            )
          : null,
      body: Stack(
        children: [
          localView == ConstructTypeEnum.morph
              ? localConstructZoom == null
                  ? MorphAnalyticsListView(controller: this)
                  : MorphDetailsView(constructId: localConstructZoom!)
              : localConstructZoom == null
                  ? VocabAnalyticsListView(controller: this)
                  : VocabDetailsView(constructId: localConstructZoom!),
          if (localConstructZoom != null)
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setConstructZoom(null);
                },
              ),
            ),
        ],
      ),
    );
  }
}
