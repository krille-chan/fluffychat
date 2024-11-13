import 'package:fluffychat/pages/chat_list/space_view.dart';
import 'package:fluffychat/pangea/widgets/chat/visibility_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart' as matrix;

class AddRoomDialog extends StatefulWidget {
  final AddRoomType? roomType;

  const AddRoomDialog({
    required this.roomType,
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

  matrix.Visibility visibility = matrix.Visibility.public;

  Future<void> setVisibility(matrix.Visibility newVisibility) async {
    setState(() => visibility = newVisibility);
  }

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
                      widget.roomType == AddRoomType.subspace
                          ? L10n.of(context)!.createNewSpace
                          : L10n.of(context)!.createChat,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _roomNameController,
                      decoration: InputDecoration(
                        hintText: widget.roomType == AddRoomType.subspace
                            ? L10n.of(context)!.spaceName
                            : L10n.of(context)!.chatName,
                      ),
                      minLines: 1,
                      maxLines: 1,
                      maxLength: 64,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return L10n.of(context)!.pleaseChoose;
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
                        hintText: L10n.of(context)!.chatDescription,
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
              VisibilityToggle(
                setVisibility: setVisibility,
                spaceMode: widget.roomType == AddRoomType.subspace,
                visibility: visibility,
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
                      child: Text(L10n.of(context)!.cancel),
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
                            visibility: visibility,
                          ),
                        );
                      },
                      child: Text(L10n.of(context)!.confirm),
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
  final matrix.Visibility visibility;

  RoomResponse({
    required this.roomName,
    required this.roomDescription,
    required this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'roomDescripion': roomDescription,
      'visibility': visibility,
    };
  }
}
