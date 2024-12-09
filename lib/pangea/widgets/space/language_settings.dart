// import 'dart:developer';

// import 'package:fluffychat/pangea/models/space_model.dart';
// import 'package:fluffychat/pangea/widgets/space/language_level_dropdown.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';
// import 'package:future_loading_dialog/future_loading_dialog.dart';
// import 'package:matrix/matrix.dart';

// import '../../../widgets/matrix.dart';
// import '../../constants/language_keys.dart';
// import '../../constants/pangea_event_types.dart';
// import '../../controllers/language_list_controller.dart';
// import '../../controllers/pangea_controller.dart';
// import '../../extensions/pangea_room_extension/pangea_room_extension.dart';
// import '../../models/language_model.dart';
// import '../../utils/error_handler.dart';
// import '../user_settings/p_language_dropdown.dart';
// import '../user_settings/p_question_container.dart';

// class LanguageSettings extends StatefulWidget {
//   final String? roomId;
//   final bool startOpen;
//   final LanguageSettingsModel? initialSettings;

//   const LanguageSettings({
//     super.key,
//     this.roomId,
//     this.startOpen = false,
//     this.initialSettings,
//   });

//   @override
//   LanguageSettingsState createState() => LanguageSettingsState();
// }

// class LanguageSettingsState extends State<LanguageSettings> {
//   Room? room;
//   late LanguageSettingsModel languageSettings;
//   late bool isOpen;
//   final PangeaController pangeaController = MatrixState.pangeaController;

//   final cityController = TextEditingController();
//   final countryController = TextEditingController();
//   final schoolController = TextEditingController();

//   LanguageSettingsState({Key? key});

//   @override
//   void initState() {
//     room = widget.roomId != null
//         ? Matrix.of(context).client.getRoomById(widget.roomId!)
//         : null;

//     languageSettings = room?.languageSettings ??
//         widget.initialSettings ??
//         LanguageSettingsModel();

//     isOpen = widget.startOpen;

//     super.initState();
//   }

//   bool get sameLanguages =>
//       languageSettings.targetLanguage == languageSettings.dominantLanguage;

//   LanguageModel getLanguage({required bool isBase, required String? langCode}) {
//     final LanguageModel backup = isBase
//         ? pangeaController.pLanguageStore.baseOptions.first
//         : pangeaController.pLanguageStore.targetOptions.first;
//     if (langCode == null) return backup;
//     final LanguageModel byCode = PangeaLanguage.byLangCode(langCode);
//     return byCode.langCode != LanguageKeys.unknownLanguage ? byCode : backup;
//   }

//   Future<void> updatePermission(void Function() makeLocalRuleChange) async {
//     makeLocalRuleChange();
//     if (room != null) {
//       await showFutureLoadingDialog(
//         context: context,
//         future: () => setLanguageSettings(room!.id),
//       );
//     }
//     setState(() {});
//   }

//   void setTextControllerValues() {
//     languageSettings.city = cityController.text;
//     languageSettings.country = countryController.text;
//     languageSettings.schoolName = schoolController.text;
//   }

//   Future<void> setLanguageSettings(String roomId) async {
//     try {
//       setTextControllerValues();

//       await Matrix.of(context).client.setRoomStateWithKey(
//             roomId,
//             PangeaEventTypes.languageSettings,
//             '',
//             languageSettings.toJson(),
//           );
//     } catch (err, stack) {
//       debugger(when: kDebugMode);
//       ErrorHandler.logError(e: err, s: stack);
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Column(
//         children: [
//           ListTile(
//             title: Text(
//               L10n.of(context).languageSettings,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.secondary,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(L10n.of(context).languageSettingsDesc),
//             leading: CircleAvatar(
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
//               child: const Icon(Icons.language),
//             ),
//             trailing: Icon(
//               isOpen
//                   ? Icons.keyboard_arrow_down_outlined
//                   : Icons.keyboard_arrow_right_outlined,
//             ),
//             onTap: () => setState(() => isOpen = !isOpen),
//           ),
//           if (isOpen)
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               height: isOpen ? null : 0,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
//                 child: Column(
//                   children: [
//                     PQuestionContainer(
//                       title: L10n.of(context).selectSpaceDominantLanguage,
//                     ),
//                     PLanguageDropdown(
//                       onChange: (p0) => updatePermission(() {
//                         languageSettings.dominantLanguage = p0.langCode;
//                       }),
//                       initialLanguage: getLanguage(
//                         isBase: true,
//                         langCode: languageSettings.dominantLanguage,
//                       ),
//                       languages: pangeaController.pLanguageStore.baseOptions,
//                       showMultilingual: true,
//                     ),
//                     PQuestionContainer(
//                       title: L10n.of(context).selectSpaceTargetLanguage,
//                     ),
//                     PLanguageDropdown(
//                       onChange: (p0) => updatePermission(() {
//                         languageSettings.targetLanguage = p0.langCode;
//                       }),
//                       initialLanguage: getLanguage(
//                         isBase: false,
//                         langCode: languageSettings.targetLanguage,
//                       ),
//                       languages: pangeaController.pLanguageStore.targetOptions,
//                     ),
//                     PQuestionContainer(
//                       title: L10n.of(context).whatIsYourSpaceLanguageLevel,
//                     ),
//                     LanguageLevelDropdown(
//                       initialLevel: languageSettings.languageLevel,
//                       onChanged: (int? newValue) => updatePermission(() {
//                         languageSettings.languageLevel = newValue!;
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       );
// }
