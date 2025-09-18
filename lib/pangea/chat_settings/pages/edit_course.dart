import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_plans/map_clipper.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class EditCourse extends StatefulWidget {
  final String roomId;
  const EditCourse({super.key, required this.roomId});

  @override
  EditCourseController createState() => EditCourseController();
}

class EditCourseController extends State<EditCourse> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  MatrixFile? _avatar;

  @override
  void initState() {
    super.initState();
    if (_room != null) {
      _titleController.text = _room!.name;
      _descController.text = _room!.topic;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Room? get _room => Matrix.of(context).client.getRoomById(widget.roomId);

  Future<void> _saveChanges() async {
    if (_room == null) return;
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isNotEmpty && title != _room!.name) {
      await _room!.setName(title);
    }
    if (desc.isNotEmpty && desc != _room!.topic) {
      await _room!.setDescription(desc);
    }
    if (_avatar != null) {
      await _room!.setAvatar(_avatar!);
    }
  }

  Future<void> _setAvatarAction() async {
    if (_room == null) return;
    final actions = [
      if (PlatformInfos.isMobile)
        AdaptiveModalAction(
          value: AvatarAction.camera,
          label: L10n.of(context).openCamera,
          isDefaultAction: true,
          icon: const Icon(Icons.camera_alt_outlined),
        ),
      AdaptiveModalAction(
        value: AvatarAction.file,
        label: L10n.of(context).openGallery,
        icon: const Icon(Icons.photo_outlined),
      ),
    ];
    final action = actions.length == 1
        ? actions.single.value
        : await showModalActionPopup<AvatarAction>(
            context: context,
            title: L10n.of(context).editRoomAvatar,
            cancelLabel: L10n.of(context).cancel,
            actions: actions,
          );
    if (action == null) return;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().pickImage(
        source: action == AvatarAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 50,
      );
      if (result == null) return;
      _avatar = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final picked = await selectFiles(
        context,
        allowMultiple: false,
        type: FileSelectorType.images,
      );
      final pickedFile = picked.firstOrNull;
      if (pickedFile == null) return;
      _avatar = MatrixFile(
        bytes: await pickedFile.readAsBytes(),
        name: pickedFile.name,
      );
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(L10n.of(context).editing),
      ),
      body: StreamBuilder(
        stream: Matrix.of(context).client.onRoomState.stream.where(
              (u) => u.roomId == widget.roomId,
            ),
        builder: (context, snapshot) {
          return SafeArea(
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: _room == null || !_room!.isSpace
                    ? Center(child: Text(L10n.of(context).noRoomsFound))
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 16.0,
                                children: [
                                  Stack(
                                    children: [
                                      ClipPath(
                                        clipper: MapClipper(),
                                        child: _avatar != null
                                            ? Image.memory(
                                                _avatar!.bytes,
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              )
                                            : ImageByUrl(
                                                imageUrl:
                                                    _room?.avatar?.toString(),
                                                width: 200.0,
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                replacement: Container(
                                                  width: 200.0,
                                                  height: 200.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainerHighest,
                                                ),
                                              ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: FloatingActionButton.small(
                                          onPressed: _setAvatarAction,
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      hintText: L10n.of(context).courseTitle,
                                    ),
                                  ),
                                  TextField(
                                    controller: _descController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      hintText: L10n.of(context).courseDesc,
                                    ),
                                    maxLines: null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                    child: Text(
                                      L10n.of(context).editsComingSoon,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () => showFutureLoadingDialog(
                                context: context,
                                future: _saveChanges,
                              ),
                              child: Row(
                                spacing: 8.0,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.save_outlined),
                                  Text(L10n.of(context).saveChanges),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
