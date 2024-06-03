import 'package:fluffychat/pangea/models/analytics_event.dart';
import 'package:fluffychat/pangea/models/constructs_model.dart';
import 'package:matrix/matrix.dart';

import '../constants/pangea_event_types.dart';

class ConstructAnalyticsEvent extends AnalyticsEvent {
  ConstructAnalyticsEvent({required Event event}) : super(event: event) {
    if (event.type != PangeaEventTypes.construct) {
      throw Exception(
        "${event.type} should not be used to make a ConstructAnalyticsEvent",
      );
    }
  }

  @override
  ConstructAnalyticsModel get content {
    contentCache ??= ConstructAnalyticsModel.fromJson(event.content);
    return contentCache as ConstructAnalyticsModel;
  }

  // void addAll(List<OneConstructUse> uses) {
  //   for (final use in uses) {
  //     if (content.uses.any((element) => element.id == use.id)) {
  //       continue;
  //     }
  //     debugPrint("${use.toJson()}");
  //     content.uses.add(use);
  //   }
  //   event.content = content.toJson();
  // }

  // Future<void> removeEdittedUses(
  //   List<String> removeIds,
  //   Client client,
  // ) async {
  //   _contentCache ??= ConstructUses.fromJson(event.content);
  //   if (_contentCache == null || _event.stateKey == null) return;
  //   final previousLength = _contentCache!.uses.length;
  //   _contentCache!.uses.removeWhere(
  //     (element) => removeIds.contains(element.msgId),
  //   );
  //   if (previousLength > _contentCache!.uses.length) {
  //     await client.setRoomStateWithKey(
  //       _event.room.id,
  //       _event.type,
  //       _event.stateKey!,
  //       _contentCache!.toJson(),
  //     );
  //   }
  // }
}
