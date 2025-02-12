import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_analytics_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/morph_details_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_analytics_view.dart';
import 'package:fluffychat/pangea/analytics_details_popup/vocab_details_view.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    localView = widget.view;
    setConstructZoom(widget.constructZoom);
  }

  void setConstructZoom(ConstructIdentifier? id) {
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
          title: Text(
            localView == ConstructTypeEnum.morph
                ? ConstructTypeEnum.morph.indicator.tooltip(context)
                : ConstructTypeEnum.vocab.indicator.tooltip(context),
          ),
          leading: IconButton(
            icon: localConstructZoom == null
                ? const Icon(Icons.close)
                : const Icon(Icons.arrow_back),
            onPressed: localConstructZoom == null
                ? () => Navigator.of(context).pop()
                : () => setConstructZoom(null),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30.0,
                width: 30.0,
                child: InkWell(
                  child: Image.network(
                    '${AppConfig.assetsBaseURL}/${AnalyticsConstants.vocabIconFileName}',
                  ),
                  onTap: () => setState(() {
                    localView = ConstructTypeEnum.vocab;
                    localConstructZoom = null;
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 30.0,
                width: 30.0,
                child: InkWell(
                  child: Image.network(
                    '${AppConfig.assetsBaseURL}/${AnalyticsConstants.morphIconFileName}',
                  ),
                  onTap: () => setState(() {
                    localView = ConstructTypeEnum.morph;
                    localConstructZoom = null;
                  }),
                ),
              ),
            ),
          ],
        ),
        body: localView == ConstructTypeEnum.morph
            ? localConstructZoom == null
                ? MorphAnalyticsView(onConstructZoom: setConstructZoom)
                : MorphDetailsView(constructId: localConstructZoom!)
            : localConstructZoom == null
                ? VocabAnalyticsView(onConstructZoom: setConstructZoom)
                : VocabDetailsView(constructId: localConstructZoom!),
      ),
      maxWidth: 600,
      maxHeight: 800,
    );
  }
}
