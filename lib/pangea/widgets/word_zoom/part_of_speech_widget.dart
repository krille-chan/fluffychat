import 'package:flutter/material.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';

class PartOfSpeechWidget extends StatefulWidget {
  final PangeaToken token;

  const PartOfSpeechWidget({super.key, required this.token});

  @override
  _PartOfSpeechWidgetState createState() => _PartOfSpeechWidgetState();
}

class _PartOfSpeechWidgetState extends State<PartOfSpeechWidget> {
  late Future<String> _partOfSpeech;

  @override
  void initState() {
    super.initState();
    _partOfSpeech = _fetchPartOfSpeech();
  }

  Future<String> _fetchPartOfSpeech() async {
    if (widget.token.shouldDoPosActivity) {
      return '?';
    } else {
      return widget.token.pos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _partOfSpeech,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ActionChip(
            avatar: const Icon(Icons.label),
            label: Text(snapshot.data ?? 'No part of speech found'),
            onPressed: () {
              // Handle chip click
            },
          );
        }
      },
    );
  }
}
