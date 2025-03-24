// // presents choices from vocab_bank_repo
// // displays them as emoji choices
// // once selection, these words are inserted into the input bar

// import 'dart:async';

// import 'package:fluffychat/config/themes.dart';
// import 'package:fluffychat/pages/chat/chat.dart';
// import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
// import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
// import 'package:fluffychat/pangea/emojis/emoji_stack.dart';
// import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
// import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_emoji_choice_item.dart';
// import 'package:fluffychat/pangea/word_bank/vocab_bank_repo.dart';
// import 'package:fluffychat/pangea/word_bank/vocab_request.dart';
// import 'package:fluffychat/pangea/word_bank/vocab_response.dart';
// import 'package:fluffychat/widgets/matrix.dart';
// import 'package:flutter/material.dart';

// class WritingAssistanceInputRow extends StatefulWidget {
//   final ChatController controller;

//   const WritingAssistanceInputRow(
//     this.controller, {
//     super.key,
//   });

//   @override
//   WritingAssistanceInputRowState createState() =>
//       WritingAssistanceInputRowState();
// }

// class WritingAssistanceInputRowState extends State<WritingAssistanceInputRow> {
//   List<ConstructIdentifier> suggestions = [];

//   StreamSubscription? _choreoSub;

//   Choreographer get choreographer => widget.controller.choreographer;

//   @override
//   void initState() {
//     // Rebuild the widget each time there's an update from choreo
//     _choreoSub = choreographer.stateListener.stream.listen((_) {
//       setSuggestions();
//     });
//     setSuggestions();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _choreoSub?.cancel();
//     super.dispose();
//   }

//   Future<void> setSuggestions() async {
//     final String currentText = choreographer.currentText;

//     final VocabRequest request = VocabRequest(
//       langCode: MatrixState
//               .pangeaController.languageController.userL2?.langCodeShort ??
//           LanguageKeys.defaultLanguage,
//       level: MatrixState
//           .pangeaController.userController.profile.userSettings.cefrLevel,
//       prefix: currentText,
//     );

//     final VocabResponse response = await VocabRepo.get(request);

//     setState(() {
//       suggestions = response.vocab;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: FluffyThemes.animationDuration,
//       curve: FluffyThemes.animationCurve,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: suggestions
//               .map(
//                 (suggestion) => MessageEmojiChoiceItem(
//                   topContent: EmojiStack(
//                     emoji: suggestion.userSetEmoji,
//                     // suggestion.userSetEmoji ??
//                     //     MatrixState
//                     //         .pangeaController.getAnalytics.constructListModel
//                     //         .getConstructUses(suggestion)
//                     //         ?.xpEmoji ??
//                     //     AnalyticsConstants.emojiForSeed,
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   content: suggestion.lemma,
//                   onTap: () {
//                     choreographer.onPredictorSelect(suggestion.lemma);
//                     // setState(() {
//                     //   suggestions = [];
//                     // });
//                   },
//                   isSelected: false,
//                   textSize: 16,
//                   greenHighlight: false,
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
