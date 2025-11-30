import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';

class StartPollBottomSheet extends StatefulWidget {
  final Room room;
  const StartPollBottomSheet({required this.room, super.key});

  @override
  State<StartPollBottomSheet> createState() => _StartPollBottomSheetState();
}

class _StartPollBottomSheetState extends State<StartPollBottomSheet> {
  final TextEditingController _bodyController = TextEditingController();
  bool _allowMultipleAnswers = false;
  final List<TextEditingController> _answers = [
    TextEditingController(),
    TextEditingController(),
  ];
  PollKind _pollKind = PollKind.disclosed;

  bool _canCreate = false;

  bool isLoading = false;

  String? _txid;

  void _createPoll() async {
    try {
      var id = 0;
      _txid ??= widget.room.client.generateUniqueTransactionId();
      await widget.room.startPoll(
        question: _bodyController.text.trim(),
        answers: _answers
            .map(
              (answerController) => PollAnswer(
                id: (++id).toString(),
                mText: answerController.text.trim(),
              ),
            )
            .toList(),
        kind: _pollKind,
        maxSelections: _allowMultipleAnswers ? _answers.length : 1,
        txid: _txid,
      );
      Navigator.of(context).pop();
    } catch (e, s) {
      Logs().w('Unable to create poll', e, s);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toLocalizedString(context))),
      );
    }
  }

  void _updateCanCreate([dynamic _]) {
    final newCanCreate = _bodyController.text.trim().isNotEmpty &&
        !_answers.any((controller) => controller.text.trim().isEmpty);
    if (_canCreate != newCanCreate) {
      setState(() {
        _canCreate = newCanCreate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const maxAnswers = 10;
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: Navigator.of(context).pop,
        ),
        title: Text(L10n.of(context).startPoll),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        children: [
          TextField(
            controller: _bodyController,
            minLines: 2,
            maxLines: 4,
            maxLength: 1024,
            onChanged: _updateCanCreate,
            decoration: InputDecoration(
              hintText: L10n.of(context).pollQuestion,
              counter: const SizedBox.shrink(),
            ),
          ),
          const Divider(height: 32),
          ..._answers.map(
            (answerController) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: answerController,
                onChanged: _updateCanCreate,
                maxLength: 64,
                decoration: InputDecoration(
                  counter: const SizedBox.shrink(),
                  hintText: L10n.of(context).answerOption,
                  suffixIcon: _answers.length == 2
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: () => setState(() {
                            _answers.remove(answerController..dispose());
                          }),
                        ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.add_outlined),
              onPressed: _answers.length < maxAnswers
                  ? () => setState(() {
                        _answers.add(TextEditingController());
                      })
                  : null,
              label: Text(L10n.of(context).addAnswerOption),
            ),
          ),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Switch.adaptive(
              value: _pollKind == PollKind.disclosed,
              onChanged: (allow) => setState(() {
                _pollKind = allow ? PollKind.disclosed : PollKind.undisclosed;
              }),
            ),
            title: Text(L10n.of(context).answersVisible),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Switch.adaptive(
              value: _allowMultipleAnswers,
              onChanged: (allow) => setState(() {
                _allowMultipleAnswers = allow;
              }),
            ),
            title: Text(L10n.of(context).allowMultipleAnswers),
          ),
          ElevatedButton(
            onPressed: !isLoading && _canCreate ? _createPoll : null,
            child: isLoading
                ? const LinearProgressIndicator()
                : Text(L10n.of(context).startPoll),
          ),
        ],
      ),
    );
  }
}
