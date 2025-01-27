import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

class ActivityPlannerSettingsSearchWidget extends StatelessWidget {
  const ActivityPlannerSettingsSearchWidget({
    super.key,
    required TextEditingController searchController,
  }) : _objectiveSearchController = searchController;

  final TextEditingController _objectiveSearchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 4,
        right: 8,
        left: 8,
      ),
      child: TextFormField(
        controller: _objectiveSearchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          hintText: L10n.of(context).search,
          icon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
