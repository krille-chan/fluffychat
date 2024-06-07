import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/analytics_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:matrix/matrix.dart';

import '../../constants/pangea_event_types.dart';

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

  static Future<String?> sendConstructsEvent(
    Room analyticsRoom,
    List<OneConstructUse> uses,
  ) async {
    // create a map of lemmas to their uses
    final Map<String, List<OneConstructUse>> lemmasToUses = {};
    for (final use in uses) {
      if (use.lemma == null) {
        ErrorHandler.logError(
          e: "use has no lemma in sendConstructsEvent",
          s: StackTrace.current,
        );
        continue;
      }
      lemmasToUses[use.lemma!] ??= [];
      lemmasToUses[use.lemma]!.add(use);
    }

    // convert the map of lemmas to uses into a list of LemmaConstructsModel
    // each entry in this list contains one lemma to many uses
    final List<LemmaConstructsModel> lemmaUses = lemmasToUses.entries
        .map(
          (entry) => LemmaConstructsModel(
            lemma: entry.key,
            uses: entry.value,
          ),
        )
        .toList();

    // finally, send the construct analytics event to the analytics room
    final ConstructAnalyticsModel constructsModel = ConstructAnalyticsModel(
      type: ConstructType.grammar,
      uses: lemmaUses,
    );

    final String? eventId = await analyticsRoom.sendEvent(
      constructsModel.toJson(),
      type: PangeaEventTypes.construct,
    );
    return eventId;
  }
}
