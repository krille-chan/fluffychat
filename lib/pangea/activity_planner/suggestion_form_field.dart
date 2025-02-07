import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/activity_planner/list_request_schema.dart';

class SuggestionFormField extends StatelessWidget {
  final Future<List<ActivitySettingResponseSchema>> suggestions;
  final String? Function(String?)? validator;
  final String label;
  final String placeholder;
  final TextEditingController controller;

  const SuggestionFormField({
    super.key,
    required this.suggestions,
    required this.placeholder,
    this.validator,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (TextEditingValue textEditingValue) async {
        return (await suggestions)
            .where((ActivitySettingResponseSchema option) {
          return option.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        }).map((ActivitySettingResponseSchema e) => e.name);
      },
      onSelected: (val) => controller.text = val,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        textEditingController.value = controller.value;
        textEditingController.addListener(() {
          controller.value = textEditingController.value;
        });
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
          ),
          validator: validator,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        );
      },
    );
  }
}
