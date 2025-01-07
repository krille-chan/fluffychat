import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:matrix/matrix.dart';

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({
    super.key,
  });

  @override
  AddRoomDialogState createState() => AddRoomDialogState();
}

class AddRoomDialogState extends State<AddRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _roomDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      style: Theme.of(context).textTheme.headlineSmall,
                      L10n.of(context).createChat,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _roomNameController,
                      decoration: InputDecoration(
                        hintText: L10n.of(context).chatName,
                      ),
                      minLines: 1,
                      maxLines: 1,
                      maxLength: 64,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return L10n.of(context).pleaseChoose;
                        }
                        return null;
                      },
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _roomDescriptionController,
                      decoration: InputDecoration(
                        hintText: L10n.of(context).chatDescription,
                      ),
                      minLines: 4,
                      maxLines: 8,
                      maxLength: 255,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Text(L10n.of(context).cancel),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) return;
                        Navigator.of(context).pop(
                          RoomResponse(
                            roomName: _roomNameController.text,
                            roomDescription: _roomDescriptionController.text,
                            joinRules: JoinRules.public,
                            visibility: matrix.Visibility.private,
                          ),
                        );
                      },
                      child: Text(L10n.of(context).confirm),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomResponse {
  final String roomName;
  final String roomDescription;
  final JoinRules joinRules;
  final matrix.Visibility visibility;

  RoomResponse({
    required this.roomName,
    required this.roomDescription,
    required this.joinRules,
    required this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'roomDescripion': roomDescription,
      'joinRules': joinRules,
      'visibility': visibility,
    };
  }
}
