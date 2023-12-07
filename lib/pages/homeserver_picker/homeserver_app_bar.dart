import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';

import 'homeserver_bottom_sheet.dart';
import 'homeserver_picker.dart';

class HomeserverAppBar extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // DropdownButton instead of TypeAheadField
        Expanded(
          child: DropdownButton<String>(
            value: controller.selectedServer,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              controller.setSelectedServer(newValue);
            },
            items: <String>['loveto.party', 'alpha.tawkie', 'matrix.org']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.checkHomeserverAction();
          },
        ),
      ],
    );
  }
}
