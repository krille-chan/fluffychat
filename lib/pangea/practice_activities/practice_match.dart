import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';

class PracticeMatch {
  /// The constructIdenfifiers involved in the activity
  /// and the forms that are acceptable answers
  final Map<ConstructIdentifier, List<String>> matchInfo;

  List<ConstructForm> displayForms = List.empty(growable: true);

  PracticeMatch({
    required this.matchInfo,
  }) {
    // if there are multiple forms for a construct, pick one to display
    // each cosntruct will have ~3 forms
    // sometimes a form could be in multiple constructs
    // so we need to make sure we don't display the same form twice
    // if we get to one that is already displayed, we can pick a different form
    // either from that construct's options, or returning to the previous construct
    // and picking a different form from there
    for (final ith in matchInfo.entries) {
      for (final form in ith.value) {
        if (!displayForms.any((element) => element.form == form)) {
          displayForms.add(ConstructForm(form, ith.key));
          break;
        }
        // TODO: if none found, we can probably pick a different form for the other one
      }
    }

    // remove any items from matchInfo that don't have an item in displayForms
    for (final ith in matchInfo.keys) {
      if (!displayForms.any((element) => element.cId == ith)) {
        matchInfo.remove(ith);
      }
    }
  }

  bool isCorrect(ConstructIdentifier cId, String value) {
    return matchInfo[cId]!.contains(value);
  }

  factory PracticeMatch.fromJson(Map<String, dynamic> json) {
    final Map<ConstructIdentifier, List<String>> matchInfo = {};
    for (final constructJson in json['match_info']) {
      final ConstructIdentifier cId =
          ConstructIdentifier.fromJson(constructJson['cId']);
      final List<String> surfaceForms =
          List<String>.from(constructJson['forms']);
      matchInfo[cId] = surfaceForms;
    }

    return PracticeMatch(
      matchInfo: matchInfo,
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> matchInfo = [];
    for (final cId in this.matchInfo.keys) {
      matchInfo.add({
        'cId': cId.toJson(),
        'forms': this.matchInfo[cId],
      });
    }

    return {
      'match_info': matchInfo,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeMatch &&
        const MapEquality().equals(other.matchInfo, matchInfo);
  }

  @override
  int get hashCode => const MapEquality().hash(matchInfo);
}
