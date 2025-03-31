import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/practice_activities/activity_display_instructions_enum.dart';

/// For those activities with a relevant span, this class will hold the details
/// of the span and how it should be displayed
/// e.g. hide the span for conjugation activities
class RelevantSpanDisplayDetails {
  final int offset;
  final int length;
  final ActivityDisplayInstructionsEnum displayInstructions;

  RelevantSpanDisplayDetails({
    required this.offset,
    required this.length,
    required this.displayInstructions,
  });

  factory RelevantSpanDisplayDetails.fromJson(Map<String, dynamic> json) {
    final ActivityDisplayInstructionsEnum? display =
        ActivityDisplayInstructionsEnum.values.firstWhereOrNull(
      (e) => e.string == json['display_instructions'],
    );
    if (display == null) {
      debugger(when: kDebugMode);
    }
    return RelevantSpanDisplayDetails(
      offset: json['offset'] as int,
      length: json['length'] as int,
      displayInstructions: display ?? ActivityDisplayInstructionsEnum.nothing,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'length': length,
      'display_instructions': displayInstructions.string,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RelevantSpanDisplayDetails &&
        other.offset == offset &&
        other.length == length &&
        other.displayInstructions == displayInstructions;
  }

  @override
  int get hashCode {
    return offset.hashCode ^ length.hashCode ^ displayInstructions.hashCode;
  }
}
