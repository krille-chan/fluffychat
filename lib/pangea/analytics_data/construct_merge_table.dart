import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';

class ConstructMergeTable {
  Map<String, Set<ConstructIdentifier>> lemmaTypeGroups = {};
  final Map<ConstructIdentifier, ConstructIdentifier> caseInsensitive = {};

  void addConstructs(
    List<ConstructUses> constructs,
    Set<ConstructIdentifier> exclude,
  ) {
    addConstructsByUses(
      constructs.expand((c) => c.cappedUses).toList(),
      exclude,
    );
  }

  void addConstructsByUses(
    List<OneConstructUse> uses,
    Set<ConstructIdentifier> exclude,
  ) {
    for (final use in uses) {
      final id = use.identifier;
      if (exclude.contains(id) || id.isInvalid) continue;

      final composite = id.compositeKey;
      (lemmaTypeGroups[composite] ??= {}).add(id);
    }

    for (final use in uses) {
      final id = use.identifier;
      if (exclude.contains(id) || id.isInvalid) continue;

      final group = lemmaTypeGroups[id.compositeKey];
      if (group == null) continue;
      final matches = group.where((m) => m != id && m.string == id.string);
      for (final match in matches) {
        caseInsensitive[match] = id;
        caseInsensitive[id] = id;
      }
    }
  }

  void removeConstruct(ConstructIdentifier id) {
    final composite = id.compositeKey;
    final group = lemmaTypeGroups[composite];
    if (group == null) return;

    group.remove(id);
    if (group.isEmpty) {
      lemmaTypeGroups.remove(composite);
    }

    final caseEntry = caseInsensitive[id];
    if (caseEntry != null && caseEntry != id) {
      caseInsensitive.remove(caseEntry);
    }
    caseInsensitive.remove(id);
  }

  ConstructIdentifier resolve(ConstructIdentifier key) {
    return caseInsensitive[key] ?? key;
  }

  List<ConstructIdentifier> groupedIds(
    ConstructIdentifier id,
    Set<ConstructIdentifier> exclude,
  ) {
    final keys = <ConstructIdentifier>[];
    if (exclude.contains(id) || id.isInvalid) {
      return keys;
    }

    keys.add(id);

    // if this key maps to a different case variant, include that as well
    final differentCase = caseInsensitive[id];
    if (differentCase != null && differentCase != id) {
      if (!exclude.contains(differentCase)) {
        keys.add(differentCase);
      }
    }

    return keys;
  }

  int uniqueConstructsByType(ConstructTypeEnum type) {
    final keys = lemmaTypeGroups.keys.where(
      (composite) => composite.endsWith('|${type.name}'),
    );

    final Set<ConstructIdentifier> unique = {};
    for (final composite in keys) {
      final group = lemmaTypeGroups[composite]!;
      unique.addAll(group.map((c) => resolve(c)));
    }

    return unique.length;
  }

  bool constructUsed(ConstructIdentifier id) =>
      lemmaTypeGroups[id.compositeKey]?.contains(id) ?? false;

  void clear() {
    lemmaTypeGroups.clear();
    caseInsensitive.clear();
  }
}
