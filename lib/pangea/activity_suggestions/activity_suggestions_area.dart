// // shows n rows of activity suggestions vertically, where n is the number of rows
// // as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

// import 'package:flutter/material.dart';

// import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
// import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';

// class ActivitySuggestionsArea extends StatefulWidget {
//   const ActivitySuggestionsArea({super.key});

//   @override
//   ActivitySuggestionsAreaState createState() => ActivitySuggestionsAreaState();
// }

// class ActivitySuggestionsAreaState extends State<ActivitySuggestionsArea> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> fetchMoreSuggestions() async {
//     ActivitySearchRepo.get(
//       ActivityPlanRequest(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//         scrollDirection: Axis.vertical,
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Container(
//             height: 100,
//             width: 100,
//             color: Colors.blue,
//             margin: const EdgeInsets.all(10),
//           );
//         },
//       ),
//     );
//   }
// }
