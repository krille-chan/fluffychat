import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_details_popup/morph_analytics_list_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_details_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_details_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_list_view.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/morphs/default_morph_mapping.dart';
import 'package:fluffychat/pangea/morphs/morph_models.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsPopupWrapper extends StatefulWidget {
  const AnalyticsPopupWrapper({
    super.key,
    this.constructZoom,
    required this.view,
  });

  final ConstructTypeEnum view;
  final ConstructIdentifier? constructZoom;

  @override
  AnalyticsPopupWrapperState createState() => AnalyticsPopupWrapperState();
}

class AnalyticsPopupWrapperState extends State<AnalyticsPopupWrapper> {
  ConstructIdentifier? localConstructZoom;
  ConstructTypeEnum localView = ConstructTypeEnum.vocab;

  MorphFeaturesAndTags morphs = defaultMorphMapping;
  List<MorphFeature> features = defaultMorphMapping.displayFeatures;

  @override
  void initState() {
    super.initState();
    localView = widget.view;
    _setConstructZoom(widget.constructZoom);
    _setMorphs();
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

  void _setConstructZoom(ConstructIdentifier? id) {
    if (id != null && id.type != localView) {
      localView = id.type;
    }
    localConstructZoom = id;
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return FullWidthDialog(
      dialogContent: Scaffold(
        appBar: AppBar(
          title: kIsWeb
              ? Text(
                  localView == ConstructTypeEnum.morph
                      ? ConstructTypeEnum.morph.indicator.tooltip(context)
                      : ConstructTypeEnum.vocab.indicator.tooltip(context),
                )
              : null,
          leading: IconButton(
            icon: localConstructZoom == null
                ? const Icon(Icons.close)
                : const Icon(Icons.arrow_back),
            onPressed: localConstructZoom == null
                ? () => Navigator.of(context).pop()
                : () => _setConstructZoom(null),
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
          ],
        ),
        body: localView == ConstructTypeEnum.morph
            ? localConstructZoom == null
                ? MorphAnalyticsListView(
                    onConstructZoom: _setConstructZoom,
                    controller: this,
                  )
                : MorphDetailsView(constructId: localConstructZoom!)
            : localConstructZoom == null
                ? VocabAnalyticsListView(onConstructZoom: _setConstructZoom)
                : VocabDetailsView(constructId: localConstructZoom!),
      ),
      maxWidth: 600,
      maxHeight: 800,
    );
  }
}
