import 'package:fluffychat/pangea/models/constructs_analytics_model.dart';
import 'package:matrix/matrix.dart';

import '../constants/pangea_event_types.dart';

class ConstructEvent {
  late Event _event;
  ConstructUses? _contentCache;

  ConstructEvent({required Event event}) {
    if (event.type != PangeaEventTypes.vocab) {
      throw Exception(
        "${event.type} should not be used to make a StudentAnalyticsEvent",
      );
    }
    _event = event;
  }

  Event get event => _event;

  ConstructUses get content {
    _contentCache ??= ConstructUses.fromJson(event.content);
    if (_contentCache!.lemma.isEmpty) {
      _contentCache!.lemma = event.stateKey!;
    }
    return _contentCache!;
  }

  void addAll(List<OneConstructUse> uses) {
    content.uses.addAll(uses);
    event.content = content.toJson();
  }

  Future<void> removeEdittedUses(
    List<String> removeIds,
    Client client,
  ) async {
    _contentCache ??= ConstructUses.fromJson(event.content);
    final previousLength = _contentCache!.uses.length;
    _contentCache!.uses.removeWhere(
      (element) => removeIds.contains(element.msgId),
    );
    if (previousLength > _contentCache!.uses.length) {
      await client.setRoomStateWithKey(
        _event.room.id,
        _event.type,
        _event.stateKey!,
        _contentCache!.toJson(),
      );
    }
  }
}
