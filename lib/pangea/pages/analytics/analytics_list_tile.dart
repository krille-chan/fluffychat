// import 'dart:async';


// import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
// import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/l10n.dart';
// import 'package:go_router/go_router.dart';
// import 'package:matrix/matrix.dart';

// import '../../../../utils/date_time_extension.dart';
// import '../../../widgets/avatar.dart';
// import '../../../widgets/matrix.dart';
// import '../../models/analytics/chart_analytics_model.dart';
// import 'base_analytics.dart';
// import 'list_summary_analytics.dart';

// class AnalyticsListTile extends StatefulWidget {
//   const AnalyticsListTile({
//     super.key,
//     required this.defaultSelected,
//     required this.selected,
//     required this.avatar,
//     required this.allowNavigateOnSelect,
//     required this.isSelected,
//     required this.onTap,
//     required this.pangeaController,
//     this.controller,
//     this.refreshStream,
//   });

//   final void Function(AnalyticsSelected) onTap;

//   final AnalyticsSelected defaultSelected;
//   final AnalyticsSelected selected;

//   final Uri? avatar;

//   final bool allowNavigateOnSelect;
//   final bool isSelected;

//   final PangeaController pangeaController;
//   final BaseAnalyticsController? controller;
//   final StreamController? refreshStream;

//   @override
//   AnalyticsListTileState createState() => AnalyticsListTileState();
// }

// class AnalyticsListTileState extends State<AnalyticsListTile> {
//   ChartAnalyticsModel? tileData;
//   StreamSubscription? refreshSubscription;

//   @override
//   void initState() {
//     super.initState();
//     setTileData();
//     refreshSubscription = widget.refreshStream?.stream.listen((forceUpdate) {
//       setTileData(forceUpdate: forceUpdate);
//     });
//   }

//   @override
//   void didUpdateWidget(covariant AnalyticsListTile oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.selected != widget.selected) {
//       setTileData();
//     }
//   }

//   @override
//   void dispose() {
//     refreshSubscription?.cancel();
//     super.dispose();
//   }

//   Future<void> setTileData({forceUpdate = false}) async {
//     tileData = await MatrixState.pangeaController.analytics.getAnalytics(
//       defaultSelected: widget.defaultSelected,
//       selected: widget.selected,
//       forceUpdate: forceUpdate,
//     );
//     if (mounted) setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Room? room =
//         Matrix.of(context).client.getRoomById(widget.selected.id);
//     return Material(
//       color: widget.isSelected
//           ? Theme.of(context).colorScheme.secondaryContainer
//           : Colors.transparent,
//       child: ListTile(
//         leading: widget.selected.type == AnalyticsEntryType.privateChats
//             ? CircleAvatar(
//                 backgroundColor: Theme.of(context).primaryColor,
//                 foregroundColor: Colors.white,
//                 radius: Avatar.defaultSize / 2,
//                 child: const Icon(Icons.forum),
//               )
//             : Avatar(
//                 mxContent: widget.avatar,
//                 name: widget.selected.displayName,
//                 littleIcon: room?.roomTypeIcon,
//               ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 widget.selected.displayName,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: false,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).textTheme.bodyLarge!.color,
//                 ),
//               ),
//             ),
//             Tooltip(
//               message: L10n.of(context).timeOfLastMessage,
//               child: Text(
//                 tileData?.lastMessageTime?.localizedTimeShort(context) ?? "",
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Theme.of(context).textTheme.bodyMedium!.color,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         subtitle: ListSummaryAnalytics(
//           chartAnalytics: tileData,
//         ),
//         selected: widget.isSelected,
//         onTap: () {
//           if (widget.controller?.widget.selectedView == null) {
//             widget.onTap(widget.selected);
//             return;
//           }
//           if ((room?.isSpace ?? false) && widget.allowNavigateOnSelect) {
//             context.go('/rooms/analytics/${room!.id}');
//             return;
//           }
//           widget.onTap(widget.selected);
//         },
//         trailing: (room?.isSpace ?? false) &&
//                 widget.selected.type != AnalyticsEntryType.privateChats &&
//                 widget.allowNavigateOnSelect
//             ? const Icon(Icons.chevron_right)
//             : null,
//       ),
//     );
//   }
// }
