import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/msc_extensions/msc_3381_polls/models/poll_event_content.dart';

import 'package:fluffychat/config/app_config.dart';

class PollEditBottomSheet extends StatefulWidget {
  final PollStartContent? oldPoll;
  const PollEditBottomSheet({this.oldPoll, super.key});

  @override
  State<PollEditBottomSheet> createState() => _PollEditBottomSheetState();
}

class _PollEditBottomSheetState extends State<PollEditBottomSheet> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerController = [
    TextEditingController(),
    TextEditingController(),
  ];
  PollKind _kind = PollKind.disclosed;
  int _maxSelection = 1;

  bool _canFinish = false;

  @override
  void initState() {
    final oldPoll = widget.oldPoll;
    if (oldPoll != null) {
      _questionController.text = oldPoll.question.mText;
      _answerController.clear();
      _answerController.addAll(
        oldPoll.answers.map(
          (answer) => TextEditingController(text: answer.mText),
        ),
      );
      _kind = oldPoll.kind ?? _kind;
      _maxSelection = oldPoll.maxSelections;
    }
    super.initState();
  }

  void _checkCanFinish([_]) {
    final canFinish = _questionController.text.isNotEmpty &&
        _answerController.length >= 2 &&
        !_answerController.any((c) => c.text.isEmpty);
    if (canFinish != _canFinish) {
      setState(() {
        _canFinish = canFinish;
      });
    }
  }

  void _deleteAnswer(int i) {
    setState(() {
      _answerController.removeAt(i);
      if (_maxSelection > _answerController.length) _maxSelection--;
    });
    _checkCanFinish();
  }

  void _addAnswer() {
    setState(() {
      _answerController.add(TextEditingController());
    });
  }

  void _updateMaxSelection(int? maxSelection) {
    if (maxSelection == null) return;
    setState(() {
      _maxSelection = maxSelection;
    });
  }

  void _updateKind(PollKind? kind) {
    if (kind == null) return;
    setState(() {
      _kind = kind;
    });
  }

  void _finish() {
    _checkCanFinish();
    context.pop(
      PollStartContent(
        maxSelections: _maxSelection,
        question: PollQuestion(
          mText: _questionController.text,
        ),
        kind: _kind,
        answers: _answerController
            .map((c) => c.text)
            .where((text) => text.isNotEmpty)
            .mapIndexed(
              (i, text) => PollAnswer(
                mText: text,
                id: '$i$text'.hashCode.toString(),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () => context.pop(null),
        ),
        title: Text(L10n.of(context).poll),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: _canFinish ? _finish : null,
              child: Text(L10n.of(context).send),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _questionController,
            minLines: 1,
            maxLines: 4,
            maxLength: 1024,
            onChanged: _checkCanFinish,
            decoration: InputDecoration(
              counterText: '',
              labelText: L10n.of(context).question,
            ),
          ),
          const SizedBox(height: 32),
          for (var i = 0; i < _answerController.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _answerController[i],
                maxLength: 128,
                onChanged: _checkCanFinish,
                decoration: InputDecoration(
                  labelText: L10n.of(context).answer,
                  counterText: '',
                  suffixIcon: i > 1
                      ? IconButton(
                          icon: const Icon(Icons.delete_outlined),
                          tooltip: L10n.of(context).deleteAnswer,
                          onPressed: () => _deleteAnswer(i),
                        )
                      : null,
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addAnswer(),
              icon: const Icon(Icons.add_outlined),
              label: Text(L10n.of(context).addAnswer),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            children: [
              DropdownButton<PollKind>(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
                underline: const SizedBox.shrink(),
                value: _kind,
                items: PollKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(kind.getLocalizedString(context)),
                      ),
                    )
                    .toList(),
                onChanged: _updateKind,
              ),
              const SizedBox(
                width: 16,
                height: 16,
              ),
              DropdownButton<int>(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
                underline: const SizedBox.shrink(),
                value: _maxSelection,
                items: [
                  for (var i = 1; i <= _answerController.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text('Max selection: $i'),
                    ),
                ],
                onChanged: _updateMaxSelection,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension on PollKind {
  String getLocalizedString(BuildContext context) {
    switch (this) {
      case PollKind.disclosed:
        return L10n.of(context).resultsDisclosed;
      case PollKind.undisclosed:
        return L10n.of(context).resultsUndisclosed;
    }
  }
}
