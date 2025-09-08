// import 'package:flutter/material.dart';

// import 'package:fluffychat/pangea/activity_generator/list_request_schema.dart';

// class SuggestionFormField extends StatelessWidget {
//   final List<ActivitySettingResponseSchema>? suggestions;
//   final String? Function(String?)? validator;
//   final int? maxLength;
//   final String label;
//   final String placeholder;
//   final TextEditingController controller;

//   const SuggestionFormField({
//     super.key,
//     this.suggestions,
//     required this.placeholder,
//     this.validator,
//     this.maxLength,
//     required this.label,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Autocomplete<String>(
//       initialValue: TextEditingValue(text: controller.text),
//       optionsBuilder: (TextEditingValue textEditingValue) {
//         return (suggestions ?? [])
//             .where((ActivitySettingResponseSchema option) {
//           return option.name
//               .toLowerCase()
//               .contains(textEditingValue.text.toLowerCase());
//         }).map((ActivitySettingResponseSchema e) => e.name);
//       },
//       onSelected: (val) => controller.text = val,
//       fieldViewBuilder: (
//         BuildContext context,
//         TextEditingController textEditingController,
//         FocusNode focusNode,
//         VoidCallback onFieldSubmitted,
//       ) {
//         textEditingController.value = controller.value;
//         textEditingController.addListener(() {
//           controller.value = textEditingController.value;
//         });
//         return TextFormField(
//           controller: textEditingController,
//           focusNode: focusNode,
//           decoration: InputDecoration(
//             labelText: label,
//             hintText: placeholder,
//           ),
//           validator: validator,
//           maxLength: maxLength,
//           onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
//         );
//       },
//     );
//   }
// }
