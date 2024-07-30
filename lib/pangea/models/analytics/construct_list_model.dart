import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';

/// A wrapper around a list of [OneConstructUse]s, used to simplify
/// the process of filtering / sorting / displaying the events.
/// Takes a construct type and a list of events
class ConstructListModel {
  ConstructTypeEnum type;
  List<OneConstructUse> uses;

  ConstructListModel({
    required this.type,
    required this.uses,
  });

  /// All unique lemmas used in the construct events
  List<String> get lemmas => constructs.map((e) => e.lemma).toSet().toList();

  /// A list of ConstructUses, each of which contains a lemma and
  /// a list of uses, sorted by the number of uses
  List<ConstructUses> get constructs {
    final List<OneConstructUse> filtered =
        uses.where((use) => use.constructType == type).toList();

    final Map<String, List<OneConstructUse>> lemmaToUses = {};
    for (final use in filtered) {
      if (use.lemma == null) continue;
      lemmaToUses[use.lemma!] ??= [];
      lemmaToUses[use.lemma!]!.add(use);
    }

    final constructUses = lemmaToUses.entries
        .map(
          (entry) => ConstructUses(
            lemma: entry.key,
            uses: entry.value,
            constructType: type,
          ),
        )
        .toList();

    constructUses.sort((a, b) {
      final comp = b.uses.length.compareTo(a.uses.length);
      if (comp != 0) return comp;
      return a.lemma.compareTo(b.lemma);
    });

    return constructUses;
  }
}
