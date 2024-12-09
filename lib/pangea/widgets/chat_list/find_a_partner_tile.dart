// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';
// import 'package:vrouter/vrouter.dart';

// import '../../../pages/chat_list/chat_list.dart';

// class FindALanguagePartnerTile extends StatelessWidget {
//   const FindALanguagePartnerTile({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final ChatListController controller;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(
//         Icons.add_circle_outline,
//         color: Theme.of(context).colorScheme.onBackground,
//       ),
//       title: Text(L10n.of(context).findALanguagePartner),
//       onTap: () {
//         if (controller
//             .pangeaController.permissionsController.isPublic) {
//           Scaffold.of(context).closeDrawer();
//           VRouter.of(context).to('/partner');
//         } else {
//           showDialog(
//             context: context,
//             useRootNavigator: false,
//             builder: (context) => AlertDialog(
//               title: Text(L10n.of(context).setToPublicSettingsTitle),
//               content: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 250),
//                 child: Text(L10n.of(context).setToPublicSettingsDesc),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: Navigator.of(context).pop,
//                   child: Text(L10n.of(context).cancel),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     VRouter.of(context).to('/settings/account');
//                   },
//                   child: Text(L10n.of(context).accountSettings),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }
