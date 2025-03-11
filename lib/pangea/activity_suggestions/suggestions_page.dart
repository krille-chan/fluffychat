import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicators.dart';

class SuggestionsPage extends StatelessWidget {
  const SuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              child: LearningProgressIndicators(),
            ),
            Expanded(
              child: ActivitySuggestionsArea(),
            ),
          ],
        ),
      ),
    );
  }
}
