import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_page/analytics_page_view.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/widgets/matrix.dart';

class AnalyticsPage extends StatefulWidget {
  final ProgressIndicatorEnum? selectedIndicator;
  final ConstructIdentifier? constructZoom;
  const AnalyticsPage({
    super.key,
    this.selectedIndicator,
    this.constructZoom,
  });

  @override
  AnalyticsPageState createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  ProgressIndicatorEnum? selectedIndicator = ProgressIndicatorEnum.wordsUsed;

  @override
  void initState() {
    super.initState();
    // init the analytics controllers
    MatrixState.pangeaController.initControllers();
    selectedIndicator = widget.selectedIndicator ??
        ProgressIndicatorEnum.wordsUsed; // Default to wordsUsed if not set
  }

  @override
  void didUpdateWidget(covariant AnalyticsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndicator != widget.selectedIndicator &&
        widget.selectedIndicator != null) {
      setState(
        () => selectedIndicator = widget.selectedIndicator!,
      ); // Update to new value
    }
  }

  @override
  Widget build(BuildContext context) => AnalyticsPageView(controller: this);
}
