// import 'package:fluffychat/pangea/models/language_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';
// import 'package:future_loading_dialog/future_loading_dialog.dart';

// import '../../../widgets/matrix.dart';
// import '../../controllers/pangea_controller.dart';

// class LanguagesISpeakTile extends StatelessWidget {
//   final PangeaController pangeaController = MatrixState.pangeaController;

//   LanguagesISpeakTile({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       trailing: const Icon(Icons.edit_outlined),
//       title: Text(L10n.of(context).languagesISpeak),
//       //PTODO - make a nice display of flags
//       // subtitle: Text(
//       //   pangeaController.userController.userModel?.profile?.speaks
//       //           ?.toString() ??
//       //       "",
//       // ),
//       onTap: () => showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return const MultiSelectDialog();
//         },
//       ),
//     );
//   }
// }

// class MultiSelectDialog extends StatefulWidget {
//   const MultiSelectDialog({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _MultiSelectDialogState();
// }

// class _MultiSelectDialogState extends State<MultiSelectDialog> {
//   final List<String> _selectedValues = [];
//   PangeaController pangeaController = MatrixState.pangeaController;

//   @override
//   void initState() {
//     super.initState();
//     // _selectedValues.addAll(
//     //     pangeaController.userController.userModel?.profile?.speaks ?? []);
//   }

//   void _onItemCheckedChange(LanguageModel itemValue, bool? checked) {
//     if (checked == null) return;
//     setState(() {
//       if (checked) {
//         _selectedValues.add(itemValue.langCode);
//       } else {
//         _selectedValues.remove(itemValue.langCode);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(L10n.of(context).languagesISpeak),
//       contentPadding: const EdgeInsets.only(top: 12.0),
//       content: SingleChildScrollView(
//         child: ListTileTheme(
//           contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
//           child: ListBody(
//             children:
//                 pangeaController.pLanguageStore.baseOptions.map((language) {
//               return CheckboxListTile(
//                 value: _selectedValues.contains(language.langCode),
//                 //PTODO - show flag with name
//                 title: Text(language.displayName),
//                 controlAffinity: ListTileControlAffinity.leading,
//                 onChanged: (checked) => _onItemCheckedChange(language, checked),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(L10n.of(context).cancel),
//         ),
//         TextButton(
//           onPressed: () => showFutureLoadingDialog(
//             context: context,
//             future: (() async {
//               await pangeaController.userController
//                   .updateUserProfile(speaks: _selectedValues);
//               Navigator.pop(context);
//             }),
//           ),
//           child: Text(L10n.of(context).ok),
//         )
//       ],
//     );
//   }
// }
