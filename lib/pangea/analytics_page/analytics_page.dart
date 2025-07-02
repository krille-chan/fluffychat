import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_page/analytics_page_view.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  AnalyticsPageState createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  ProgressIndicatorEnum? selectedIndicator = ProgressIndicatorEnum.wordsUsed;

  void onIndicatorSelected(ProgressIndicatorEnum indicator) => setState(() {
        selectedIndicator = indicator;
      });

  @override
  Widget build(BuildContext context) => AnalyticsPageView(controller: this);
}
