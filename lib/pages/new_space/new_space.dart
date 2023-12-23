import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/new_space/new_space_view.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewSpace extends StatefulWidget {
  const NewSpace({super.key});

  @override
  NewSpaceController createState() => NewSpaceController();
}

class NewSpaceController extends State<NewSpace> {
  TextEditingController nameController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  bool publicGroup = false;
  bool loading = false;
  String? nameError;
  String? topicError;

  Uint8List? avatar;

  Uri? avatarUrl;

  void selectPhoto() async {
    final photo = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    setState(() {
      avatarUrl = null;
      avatar = photo?.files.singleOrNull?.bytes;
    });
  }

  void setPublicGroup(bool b) => setState(() => publicGroup = b);

  void submitAction([_]) async {
    final client = Matrix.of(context).client;
    setState(() {
      nameError = topicError = null;
    });
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = L10n.of(context)!.pleaseChoose;
      });
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      final avatar = this.avatar;
      avatarUrl ??= avatar == null ? null : await client.uploadContent(avatar);

      final spaceId = await client.createRoom(
        preset: publicGroup
            ? sdk.CreateRoomPreset.publicChat
            : sdk.CreateRoomPreset.privateChat,
        creationContent: {'type': RoomCreationTypes.mSpace},
        visibility: publicGroup ? sdk.Visibility.public : null,
        roomAliasName: publicGroup
            ? nameController.text.trim().toLowerCase().replaceAll(' ', '_')
            : null,
        name: nameController.text.trim(),
        topic: topicController.text.isEmpty ? null : topicController.text,
        powerLevelContentOverride: {'events_default': 100},
        initialState: [
          if (avatar != null)
            sdk.StateEvent(
              type: sdk.EventTypes.RoomAvatar,
              content: {'url': avatarUrl.toString()},
            ),
        ],
      );
      if (!mounted) return;
      context.pop<String>(spaceId);
    } catch (e) {
      setState(() {
        topicError = e.toLocalizedString(context);
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
    // TODO: Go to spaces
  }

  @override
  Widget build(BuildContext context) => NewSpaceView(this);
}
