// // ignore_for_file: depend_on_referenced_packages

// import 'package:flutter/material.dart';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
// import 'package:go_router/go_router.dart';
// import 'package:material_symbols_icons/symbols.dart';

// import 'package:fluffychat/config/themes.dart';
// import 'package:fluffychat/l10n/l10n.dart';
// import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
// import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
// import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
// import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
// import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
// import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
// import 'package:fluffychat/widgets/avatar.dart';
// import 'package:fluffychat/widgets/future_loading_dialog.dart';
// import 'package:fluffychat/widgets/matrix.dart';

// class ActivityPlanCard extends StatelessWidget {
//   final VoidCallback regenerate;
//   final ActivityPlannerBuilderState controller;

//   const ActivityPlanCard({
//     super.key,
//     required this.regenerate,
//     required this.controller,
//   });

//   static const double itemPadding = 12;

//   Future<void> _onLaunch(BuildContext context) async {
//     final resp = await showFutureLoadingDialog(
//       context: context,
//       future: () async {
//         if (!controller.room.isSpace) {
//           throw Exception(
//             "Cannot launch activity in a non-space room",
//           );
//         }

//         final ids = await controller.launchToSpace();
//         ids.length == 1
//             ? context.go("/rooms/spaces/${controller.room.id}/${ids.first}")
//             : context.go("/rooms/spaces/${controller.room.id}/details");
//         Navigator.of(context).pop();
//       },
//     );

//     if (!resp.isError) {
//       context.go("/rooms/spaces/${controller.room.id}/details");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final l10n = L10n.of(context);
//     return Center(
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 400),
//         child: Card(
//           margin: const EdgeInsets.symmetric(vertical: itemPadding),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               children: [
//                 AnimatedSize(
//                   duration: FluffyThemes.animationDuration,
//                   child: Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       Container(
//                         width: 200.0,
//                         padding: const EdgeInsets.all(16.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         clipBehavior: Clip.hardEdge,
//                         alignment: Alignment.center,
//                         child: controller.isLaunching
//                             ? Avatar(
//                                 mxContent: controller.room.avatar,
//                                 name: controller.room.getLocalizedDisplayname(
//                                   MatrixLocals(
//                                     L10n.of(context),
//                                   ),
//                                 ),
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 size: 200.0,
//                               )
//                             : controller.imageURL != null ||
//                                     controller.avatar != null
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                     child: controller.avatar == null
//                                         ? CachedNetworkImage(
//                                             fit: BoxFit.cover,
//                                             imageUrl: controller.imageURL!,
//                                             imageRenderMethodForWeb:
//                                                 ImageRenderMethodForWeb.HttpGet,
//                                             httpHeaders: {
//                                               'Authorization':
//                                                   'Bearer ${MatrixState.pangeaController.userController.accessToken}',
//                                             },
//                                             placeholder: (context, url) {
//                                               return const Center(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               );
//                                             },
//                                             errorWidget: (context, url, error) {
//                                               return const Padding(
//                                                 padding: EdgeInsets.all(28.0),
//                                               );
//                                             },
//                                           )
//                                         : Image.memory(
//                                             controller.avatar!,
//                                             fit: BoxFit.cover,
//                                           ),
//                                   )
//                                 : const Padding(
//                                     padding: EdgeInsets.all(28.0),
//                                   ),
//                       ),
//                       if (controller.isEditing)
//                         InkWell(
//                           borderRadius: BorderRadius.circular(90),
//                           onTap: controller.selectAvatar,
//                           child: CircleAvatar(
//                             backgroundColor:
//                                 Theme.of(context).colorScheme.secondary,
//                             radius: 20.0,
//                             child: Icon(
//                               Icons.add_a_photo_outlined,
//                               size: 20.0,
//                               color: Theme.of(context).colorScheme.onSecondary,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: controller.isLaunching
//                         ? [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Avatar(
//                                   mxContent: controller.room.avatar,
//                                   name: controller.room.getLocalizedDisplayname(
//                                     MatrixLocals(L10n.of(context)),
//                                   ),
//                                   size: 24.0,
//                                   borderRadius: BorderRadius.circular(4.0),
//                                 ),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: Text(
//                                     controller.room.getLocalizedDisplayname(
//                                       MatrixLocals(L10n.of(context)),
//                                     ),
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 ImageByUrl(
//                                   imageUrl: controller.updatedActivity.imageURL,
//                                   width: 24.0,
//                                   borderRadius: BorderRadius.circular(4.0),
//                                   replacement: const Icon(
//                                     Icons.event_note_outlined,
//                                     size: 24.0,
//                                   ),
//                                 ),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: Text(
//                                     controller.updatedActivity.title,
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 const Icon(Icons.groups, size: 24.0),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: Text(
//                                     L10n.of(context)
//                                         .maximumActivityParticipants(
//                                       controller.updatedActivity.req
//                                           .numberOfParticipants,
//                                     ),
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 const Icon(Icons.radar, size: 24.0),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: Column(
//                                     spacing: 4.0,
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         L10n.of(context).numberOfActivities,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge,
//                                       ),
//                                       NumberCounter(
//                                         count: controller.numActivities,
//                                         update: controller.setNumActivities,
//                                         min: 1,
//                                         max: 5,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     theme.colorScheme.primaryContainer,
//                                 foregroundColor:
//                                     theme.colorScheme.onPrimaryContainer,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12.0,
//                                 ),
//                               ),
//                               onPressed: () => _onLaunch(context),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.send_outlined),
//                                   Expanded(
//                                     child: Text(
//                                       L10n.of(context).launchToSpace,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ]
//                         : [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 const Icon(Icons.event_note_outlined),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: controller.isEditing
//                                       ? TextField(
//                                           controller:
//                                               controller.titleController,
//                                           decoration: InputDecoration(
//                                             labelText:
//                                                 L10n.of(context).activityTitle,
//                                           ),
//                                           maxLines: null,
//                                         )
//                                       : Text(
//                                           controller.updatedActivity.title,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge,
//                                         ),
//                                 ),
//                                 if (!controller.isEditing)
//                                   IconButton(
//                                     onPressed:
//                                         controller.toggleBookmarkedActivity,
//                                     icon: Icon(
//                                       controller.isBookmarked
//                                           ? Icons.save
//                                           : Icons.save_outlined,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Symbols.target,
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: controller.isEditing
//                                       ? TextField(
//                                           controller: controller
//                                               .learningObjectivesController,
//                                           decoration: InputDecoration(
//                                             labelText:
//                                                 l10n.learningObjectiveLabel,
//                                           ),
//                                           maxLines: null,
//                                         )
//                                       : Text(
//                                           controller.updatedActivity
//                                               .learningObjective,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium,
//                                         ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Symbols.steps_rounded,
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: controller.isEditing
//                                       ? TextField(
//                                           controller:
//                                               controller.instructionsController,
//                                           decoration: InputDecoration(
//                                             labelText: l10n.instructions,
//                                           ),
//                                           maxLines: null,
//                                         )
//                                       : Text(
//                                           controller
//                                               .updatedActivity.instructions,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium,
//                                         ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.school_outlined,
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                                 const SizedBox(width: itemPadding),
//                                 Expanded(
//                                   child: controller.isEditing
//                                       ? LanguageLevelDropdown(
//                                           initialLevel:
//                                               controller.languageLevel,
//                                           onChanged:
//                                               controller.setLanguageLevel,
//                                         )
//                                       : Text(
//                                           controller
//                                               .updatedActivity.req.cefrLevel
//                                               .title(context),
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodyMedium,
//                                         ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: itemPadding),
//                             if (controller.vocab.isNotEmpty) ...[
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Symbols.dictionary,
//                                     color:
//                                         Theme.of(context).colorScheme.secondary,
//                                   ),
//                                   const SizedBox(width: itemPadding),
//                                   Expanded(
//                                     child: Wrap(
//                                       spacing: 4.0,
//                                       runSpacing: 4.0,
//                                       children: List<Widget>.generate(
//                                           controller.vocab.length, (int index) {
//                                         return controller.isEditing
//                                             ? Chip(
//                                                 label: Text(
//                                                   controller.vocab[index].lemma,
//                                                 ),
//                                                 onDeleted: () => controller
//                                                     .removeVocab(index),
//                                                 backgroundColor:
//                                                     Colors.transparent,
//                                                 visualDensity:
//                                                     VisualDensity.compact,
//                                                 shape: const StadiumBorder(
//                                                   side: BorderSide(
//                                                     color: Colors.transparent,
//                                                   ),
//                                                 ),
//                                               )
//                                             : Chip(
//                                                 label: Text(
//                                                   controller.vocab[index].lemma,
//                                                 ),
//                                                 backgroundColor:
//                                                     Colors.transparent,
//                                                 visualDensity:
//                                                     VisualDensity.compact,
//                                                 shape: const StadiumBorder(
//                                                   side: BorderSide(
//                                                     color: Colors.transparent,
//                                                   ),
//                                                 ),
//                                               );
//                                       }).toList(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                             if (controller.isEditing) ...[
//                               const SizedBox(height: itemPadding),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(top: itemPadding),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: TextField(
//                                         controller: controller.vocabController,
//                                         decoration: InputDecoration(
//                                           labelText: l10n.addVocabulary,
//                                         ),
//                                         onSubmitted: (value) {
//                                           controller.addVocab();
//                                         },
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.add),
//                                       onPressed: controller.addVocab,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: itemPadding),
//                               Row(
//                                 spacing: 12.0,
//                                 children: [
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             theme.colorScheme.primaryContainer,
//                                         foregroundColor: theme
//                                             .colorScheme.onPrimaryContainer,
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 12.0,
//                                         ),
//                                       ),
//                                       onPressed: controller.saveEdits,
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.save),
//                                           Expanded(
//                                             child: Text(
//                                               L10n.of(context).save,
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             theme.colorScheme.primaryContainer,
//                                         foregroundColor: theme
//                                             .colorScheme.onPrimaryContainer,
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 12.0,
//                                         ),
//                                       ),
//                                       onPressed: controller.clearEdits,
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.cancel),
//                                           Expanded(
//                                             child: Text(
//                                               L10n.of(context).cancel,
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ] else
//                               Column(
//                                 spacing: 12.0,
//                                 children: [
//                                   const SizedBox(),
//                                   Row(
//                                     spacing: 12.0,
//                                     children: [
//                                       Expanded(
//                                         child: ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: theme
//                                                 .colorScheme.primaryContainer,
//                                             foregroundColor: theme
//                                                 .colorScheme.onPrimaryContainer,
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 12.0,
//                                             ),
//                                           ),
//                                           onPressed: controller.startEditing,
//                                           child: Row(
//                                             children: [
//                                               const Icon(Icons.edit),
//                                               Expanded(
//                                                 child: Text(
//                                                   L10n.of(context).edit,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: theme
//                                                 .colorScheme.primaryContainer,
//                                             foregroundColor: theme
//                                                 .colorScheme.onPrimaryContainer,
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 12.0,
//                                             ),
//                                           ),
//                                           onPressed: regenerate,
//                                           child: Row(
//                                             children: [
//                                               const Icon(
//                                                 Icons.lightbulb_outline,
//                                               ),
//                                               Expanded(
//                                                 child: Text(
//                                                   L10n.of(context).regenerate,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: theme
//                                                 .colorScheme.primaryContainer,
//                                             foregroundColor: theme
//                                                 .colorScheme.onPrimaryContainer,
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 12.0,
//                                             ),
//                                           ),
//                                           onPressed: () {
//                                             controller.setLaunchState(
//                                               ActivityLaunchState.launching,
//                                             );
//                                           },
//                                           child: Row(
//                                             children: [
//                                               const Icon(Icons.save_outlined),
//                                               Expanded(
//                                                 child: Text(
//                                                   L10n.of(context)
//                                                       .saveAndLaunch,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                           ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
