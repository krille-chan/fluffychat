import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_repo.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_request.dart';
import 'package:fluffychat/pangea/phonetic_transcription/phonetic_transcription_response.dart';

class PhoneticTranscription extends StatefulWidget {
  final String text;
  final String l1;
  final String l2;

  const PhoneticTranscription({
    super.key,
    required this.text,
    required this.l1,
    required this.l2,
  });

  @override
  State<PhoneticTranscription> createState() => PhoneticTranscriptionState();
}

class PhoneticTranscriptionState extends State<PhoneticTranscription> {
  bool _loading = false;
  String? error;

  PhoneticTranscriptionResponse? _response;

  @override
  void initState() {
    super.initState();
    _fetchPhoneticTranscription();
  }

  @override
  void didUpdateWidget(covariant PhoneticTranscription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.l1 != widget.l1 ||
        oldWidget.l2 != widget.l2) {
      _fetchPhoneticTranscription();
    }
  }

  Future<void> _fetchPhoneticTranscription() async {
    final PhoneticTranscriptionRequest request = PhoneticTranscriptionRequest(
      l1: widget.l1,
      l2: widget.l2,
      content: widget.text,
    );

    try {
      setState(() {
        _loading = true;
        error = null;
      });

      _response = await PhoneticTranscriptionRepo.get(request);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: request.toJson(),
      );
      error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 16.0,
          ),
          const SizedBox(width: 8),
          Text(
            L10n.of(context).phoneticTranscriptionError,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    }

    if (_loading || _response == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return Text(
      'Phonetic transcription for "${widget.text}" in ${widget.l2}',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
