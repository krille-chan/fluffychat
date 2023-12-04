import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

class PInputTextField extends StatelessWidget {
  TextEditingController controller;
  Function(String) onSubmit;
  String labelText;
  String hintText;
  PInputTextField(
      {Key? key,
      required this.controller,
      required this.onSubmit,
      required this.labelText,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        autofocus: true,
        autocorrect: false,
        textInputAction: TextInputAction.go,
        onSubmitted: onSubmit,
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: const Icon(Icons.people_outlined),
            hintText: hintText),
      ),
    );
  }
}
