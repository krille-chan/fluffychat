import 'package:flutter/material.dart';
import 'homeserver_picker.dart';

class HomeserverAppBar extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // List of Tawkie servers (development mode)
    final List<String> serversTawkie = [
      'alpha.tawkie.fr',
      'loveto.party',
    ];

    return Row(
      children: [
        // DropdownButton instead of TypeAheadField
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedServer,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              controller.setSelectedServer(newValue);
            },
            items: serversTawkie.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                alignment: Alignment.center,
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
