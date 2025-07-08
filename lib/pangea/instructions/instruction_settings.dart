import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// The user's settings for whether or not to show instuction messages.
class InstructionSettings {
  Map<String, bool> _instructions = {};

  InstructionSettings([Map<String, bool>? instructions]) {
    if (instructions != null) {
      _instructions = instructions;
    } else {
      for (final key in InstructionsEnum.values) {
        _instructions[key.toString()] = false;
      }
    }
  }

  factory InstructionSettings.fromJson(Map<String, dynamic> json) {
    final Map<String, bool> instructions = {};
    for (final key in InstructionsEnum.values) {
      instructions[key.toString()] = json[key.toString()] ?? false;
    }
    return InstructionSettings(instructions);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    for (final key in InstructionsEnum.values) {
      data[key.toString()] = _instructions[key.toString()];
    }
    return data;
  }

  factory InstructionSettings.migrateFromAccountData() {
    final accountData =
        MatrixState.pangeaController.matrixState.client.accountData;
    final Map<String, bool> instructions = {};
    for (final key in InstructionsEnum.values) {
      instructions[key.toString()] =
          (accountData[key.toString()]?.content[key.toString()] as bool?) ??
              false;
    }
    return InstructionSettings(instructions);
  }

  bool getStatus(InstructionsEnum instruction) {
    return _instructions[instruction.toString()] ?? false;
  }

  void setStatus(InstructionsEnum instruction, bool status) {
    _instructions[instruction.toString()] = status;
  }

  InstructionSettings copy() {
    return InstructionSettings(Map<String, bool>.from(_instructions));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InstructionSettings) return false;

    final entries = _instructions.entries.toList()
      ..sort((a, b) => a.key.hashCode.compareTo(b.key.hashCode));

    final otherEntries = other._instructions.entries.toList()
      ..sort((a, b) => a.key.hashCode.compareTo(b.key.hashCode));

    return listEquals(
          entries.map((e) => e.key).toList(),
          otherEntries.map((e) => e.key).toList(),
        ) &&
        listEquals(
          entries.map((e) => e.value).toList(),
          otherEntries.map((e) => e.value).toList(),
        );
  }

  @override
  int get hashCode {
    final entries = _instructions.entries.toList()
      ..sort((a, b) => a.key.hashCode.compareTo(b.key.hashCode));

    return Object.hashAll(
      entries.map((e) => Object.hash(e.key, e.value)),
    );
  }
}
