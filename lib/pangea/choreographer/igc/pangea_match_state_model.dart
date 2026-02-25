import 'package:fluffychat/pangea/choreographer/igc/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/span_choice_type_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/span_data_model.dart';

class PangeaMatchState {
  final PangeaMatch _original;
  SpanData _match;
  PangeaMatchStatusEnum _status;

  PangeaMatchState({
    required PangeaMatch original,
    required SpanData match,
    required PangeaMatchStatusEnum status,
  }) : _original = original,
       _match = match,
       _status = status;

  PangeaMatch get originalMatch => _original;

  PangeaMatch get updatedMatch => PangeaMatch(match: _match, status: _status);

  void setStatus(PangeaMatchStatusEnum status) {
    _status = status;
  }

  void setMatch(SpanData match) {
    _match = match;
  }

  void selectChoice(int index) {
    final choices = List<SpanChoice>.from(_match.choices ?? []);
    choices[index] = choices[index].copyWith(
      selected: true,
      timestamp: DateTime.now(),
    );
    setMatch(_match.copyWith(choices: choices));
  }

  void selectBestChoice() {
    if (_match.choices == null) {
      throw Exception('No choices available to select best choice from.');
    }
    selectChoice(
      updatedMatch.match.choices!.indexWhere((c) => c.type.isSuggestion),
    );
  }

  void resetChoices() {
    if (_match.choices == null) {
      throw Exception('No choices available to reset.');
    }
    final resetChoices = _match.choices!
        .map(
          (c) => SpanChoice(
            value: c.value,
            type: c.type,
            feedback: c.feedback,
            selected: false,
            timestamp: null,
          ),
        )
        .toList();
    setMatch(_match.copyWith(choices: resetChoices));
  }

  Map<String, dynamic> toJson() {
    return {
      'originalMatch': _original.toJson(),
      'match': _match.toJson(),
      'status': _status.toString(),
    };
  }
}
