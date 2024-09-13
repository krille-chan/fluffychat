// import 'dart:async';

// import 'package:fluffychat/pangea/enum/time_span.dart';
// import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
// import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
// import 'package:fluffychat/pangea/models/language_model.dart';
// import 'package:fluffychat/pangea/pages/analytics/space_list/space_list_view.dart';
// import 'package:flutter/material.dart';
// import 'package:matrix/matrix.dart';

// import '../../../../widgets/matrix.dart';
// import '../../../controllers/pangea_controller.dart';
// import '../../../utils/sync_status_util_v2.dart';
// import '../../../widgets/common/list_placeholder.dart';

// class AnalyticsSpaceList extends StatefulWidget {
//   const AnalyticsSpaceList({super.key});

//   @override
//   State<AnalyticsSpaceList> createState() => AnalyticsSpaceListController();
// }

// class AnalyticsSpaceListController extends State<AnalyticsSpaceList> {
//   PangeaController pangeaController = MatrixState.pangeaController;
//   List<Room> spaces = [];
//   StreamSubscription? stateSub;
//   List<LanguageModel> targetLanguages = [];

//   @override
//   void initState() {
//     super.initState();
//     setSpaceList().then((_) => setTargetLanguages());

//     // reload dropdowns when their values change in analytics page
//     stateSub = pangeaController.analytics.stateStream.listen(
//       (_) => setState(() {}),
//     );
//   }

//   @override
//   void dispose() {
//     stateSub?.cancel();
//     super.dispose();
//   }

//   StreamController refreshStream = StreamController.broadcast();

//   Future<void> setSpaceList() async {
//     final spaceList = Matrix.of(context).client.spacesImTeaching;
//     spaces = spaceList
//         .where(
//           (space) => !spaceList.any(
//             (parentSpace) => parentSpace.spaceChildren
//                 .any((child) => child.roomId == space.id),
//           ),
//         )
//         .toList();
//     setState(() {});
//   }

//   Future<void> setTargetLanguages() async {
//     if (spaces.isEmpty) return;
//     final Map<LanguageModel, int> langCounts = {};
//     for (final Room space in spaces) {
//       final List<LanguageModel> targetLangs = await space.targetLanguages();
//       for (final LanguageModel lang in targetLangs) {
//         langCounts[lang] ??= 0;
//         langCounts[lang] = langCounts[lang]! + 1;
//       }
//     }
//     targetLanguages = langCounts.entries.map((entry) => entry.key).toList()
//       ..sort(
//         (a, b) => langCounts[b]!.compareTo(langCounts[a]!),
//       );
//     setState(() {});
//   }

//   void toggleTimeSpan(BuildContext context, TimeSpan timeSpan) {
//     pangeaController.analytics.setCurrentAnalyticsTimeSpan(timeSpan);
//     refreshStream.add(false);
//     setState(() {});
//   }

//   Future<void> toggleSpaceLang(LanguageModel lang) async {
//     await pangeaController.analytics.setCurrentAnalyticsLang(lang);
//     refreshStream.add(false);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PLoadingStatusV2(
//       shimmerChild: const ListPlaceholder(),
//       child: AnalyticsSpaceListView(this),
//       onFinish: () {
//         // getAllClassAnalytics(context);
//       },
//     );
//   }
// }
