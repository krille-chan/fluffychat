import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' hide Client;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../../widgets/matrix.dart';
import 'import_archive_dialog.dart';
import 'settings_emotes_view.dart';

import 'package:archive/archive.dart'
    if (dart.library.io) 'package:archive/archive_io.dart';

class EmotesSettings extends StatefulWidget {
  final String? roomId;
  const EmotesSettings({required this.roomId, super.key});

  @override
  EmotesSettingsController createState() => EmotesSettingsController();
}

class EmotesSettingsController extends State<EmotesSettings> {
  late final Room? room;

  String? stateKey;

  List<String>? get packKeys {
    final room = this.room;
    if (room == null) return null;
    final keys = room.states['im.ponies.room_emotes']?.keys.toList() ?? [];
    keys.sort();
    return keys;
  }

  @override
  void initState() {
    super.initState();
    room = widget.roomId != null
        ? Matrix.of(context).client.getRoomById(widget.roomId!)
        : null;
    setStateKey(packKeys?.firstOrNull, reset: false);
  }

  void setStateKey(String? key, {reset = true}) {
    stateKey = key;

    final event = key == null
        ? null
        : room?.getState(
            'im.ponies.room_emotes',
            key,
          );
    final eventPack = event?.content.tryGetMap<String, Object?>('pack');
    packDisplayNameController.text =
        eventPack?.tryGet<String>('display_name') ?? '';
    packAttributionController.text =
        eventPack?.tryGet<String>('attribution') ?? '';
    if (reset) resetAction();
  }

  bool showSave = false;

  ImagePackContent _getPack() {
    final client = Matrix.of(context).client;
    final event = (room != null
            ? room!.getState('im.ponies.room_emotes', stateKey ?? '')
            : client.accountData['im.ponies.user_emotes']) ??
        BasicEvent(
          type: 'm.dummy',
          content: {},
        );
    // make sure we work on a *copy* of the event
    return BasicEvent.fromJson(event.toJson()).parsedImagePackContent;
  }

  ImagePackContent? _pack;

  ImagePackContent? get pack {
    if (_pack != null) {
      return _pack;
    }
    _pack = _getPack();
    return _pack;
  }

  Future<void> save(BuildContext context) async {
    if (readonly) {
      return;
    }
    final client = Matrix.of(context).client;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => room != null
          ? client.setRoomStateWithKey(
              room!.id,
              'im.ponies.room_emotes',
              stateKey ?? '',
              pack!.toJson(),
            )
          : client.setAccountData(
              client.userID!,
              'im.ponies.user_emotes',
              pack!.toJson(),
            ),
    );
    if (!result.isError) {
      setState(() {
        showSave = false;
      });
    }
  }

  Future<void> setIsGloballyActive(bool active) async {
    if (room == null) {
      return;
    }
    final client = Matrix.of(context).client;
    final content = client.accountData['im.ponies.emote_rooms']?.content ??
        <String, dynamic>{};
    if (active) {
      if (content['rooms'] is! Map) {
        content['rooms'] = <String, dynamic>{};
      }
      if (content['rooms'][room!.id] is! Map) {
        content['rooms'][room!.id] = <String, dynamic>{};
      }
      if (content['rooms'][room!.id][stateKey ?? ''] is! Map) {
        content['rooms'][room!.id][stateKey ?? ''] = <String, dynamic>{};
      }
    } else if (content['rooms'] is Map && content['rooms'][room!.id] is Map) {
      content['rooms'][room!.id].remove(stateKey ?? '');
    }
    // and save
    await showFutureLoadingDialog(
      context: context,
      future: () => client.setAccountData(
        client.userID!,
        'im.ponies.emote_rooms',
        content,
      ),
    );
    setState(() {});
  }

  final TextEditingController packDisplayNameController =
      TextEditingController();

  final TextEditingController packAttributionController =
      TextEditingController();

  void removeImageAction(String oldImageCode) => setState(() {
        pack!.images.remove(oldImageCode);
        showSave = true;
      });

  void toggleUsage(String imageCode, ImagePackUsage usage) {
    setState(() {
      final usages =
          pack!.images[imageCode]!.usage ??= List.from(ImagePackUsage.values);
      if (!usages.remove(usage)) usages.add(usage);
      showSave = true;
    });
  }

  void submitDisplaynameAction() {
    if (readonly) return;
    packDisplayNameController.text = packDisplayNameController.text.trim();
    final input = packDisplayNameController.text;

    setState(() {
      pack!.pack.displayName = input;
      showSave = true;
    });
  }

  void submitAttributionAction() {
    if (readonly) return;
    packAttributionController.text = packAttributionController.text.trim();
    final input = packAttributionController.text;

    setState(() {
      pack!.pack.attribution = input;
      showSave = true;
    });
  }

  void submitImageAction(
    String oldImageCode,
    ImagePackImageContent image,
    TextEditingController controller,
  ) {
    controller.text = controller.text.trim().replaceAll(' ', '-');
    final imageCode = controller.text;
    if (imageCode == oldImageCode) return;
    if (pack!.images.keys.any((k) => k == imageCode && k != oldImageCode)) {
      controller.text = oldImageCode;
      showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context).emoteExists,
        okLabel: L10n.of(context).ok,
      );
      return;
    }
    if (!RegExp(r'^[-\w]+$').hasMatch(imageCode)) {
      controller.text = oldImageCode;
      showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context).emoteInvalid,
        okLabel: L10n.of(context).ok,
      );
      return;
    }
    setState(() {
      pack!.images[imageCode] = image;
      pack!.images.remove(oldImageCode);
      showSave = true;
    });
  }

  bool isGloballyActive(Client? client) =>
      room != null &&
      client!.accountData['im.ponies.emote_rooms']?.content
              .tryGetMap<String, Object?>('rooms')
              ?.tryGetMap<String, Object?>(room!.id)
              ?.tryGetMap<String, Object?>(stateKey ?? '') !=
          null;

  bool get readonly => room == null
      ? false
      : room?.canChangeStateEvent('im.ponies.room_emotes') == false;

  void resetAction() {
    setState(() {
      _pack = _getPack();
      showSave = false;
    });
  }

  void createImagePack() async {
    final room = this.room;
    if (room == null) throw Exception('Cannot create image pack without room');

    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).newStickerPack,
      hintText: L10n.of(context).name,
      okLabel: L10n.of(context).create,
    );
    final name = input?.trim();
    if (name == null || name.isEmpty) return;
    if (!mounted) return;

    final keyName = name.toLowerCase().replaceAll(' ', '_');

    if (packKeys?.contains(name) ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).stickerPackNameAlreadyExists),
        ),
      );
      return;
    }

    await showFutureLoadingDialog(
      context: context,
      future: () => room.client.setRoomStateWithKey(
        room.id,
        'im.ponies.room_emotes',
        keyName,
        {
          'images': {},
          'pack': {'display_name': name},
        },
      ),
    );
    if (!mounted) return;
    setState(() {});
    await room.client.oneShotSync();
    if (!mounted) return;
    setState(() {});
  }

  void saveAction() async {
    await save(context);
    setState(() {
      showSave = false;
    });
  }

  void createStickers() async {
    final pickedFiles = await selectFiles(
      context,
      type: FileSelectorType.images,
      allowMultiple: true,
    );
    if (pickedFiles.isEmpty) return;
    if (!mounted) return;

    await showFutureLoadingDialog(
      context: context,
      futureWithProgress: (setProgress) async {
        for (final (i, pickedFile) in pickedFiles.indexed) {
          setProgress(i / pickedFiles.length);
          var file = MatrixImageFile(
            bytes: await pickedFile.readAsBytes(),
            name: pickedFile.name,
          );
          file = await file.generateThumbnail(
                nativeImplementations: ClientManager.nativeImplementations,
              ) ??
              file;
          final uri = await Matrix.of(context).client.uploadContent(
                file.bytes,
                filename: file.name,
                contentType: file.mimeType,
              );

          setState(() {
            final info = <String, dynamic>{
              ...file.info,
            };
            // normalize width / height to 256, required for stickers
            if (info['w'] is int && info['h'] is int) {
              final ratio = info['w'] / info['h'];
              if (info['w'] > info['h']) {
                info['w'] = 256;
                info['h'] = (256.0 / ratio).round();
              } else {
                info['h'] = 256;
                info['w'] = (ratio * 256.0).round();
              }
            }
            final imageCode = pickedFile.name.split('.').first;
            pack!.images[imageCode] =
                ImagePackImageContent.fromJson(<String, dynamic>{
              'url': uri.toString(),
              'info': info,
            });
          });
        }
      },
    );

    setState(() {
      showSave = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return EmotesSettingsView(this);
  }

  Future<void> importEmojiZip() async {
    final result = await selectFiles(
      context,
      type: FileSelectorType.zip,
    );

    if (result.isEmpty) return;

    final buffer = InputMemoryStream(await result.single.readAsBytes());

    final archive = ZipDecoder().decodeStream(buffer);

    await showDialog(
      context: context,
      // breaks [Matrix.of] calls otherwise
      useRootNavigator: false,
      builder: (context) => ImportEmoteArchiveDialog(
        controller: this,
        archive: archive,
      ),
    );
    setState(() {});
  }

  Future<void> exportAsZip() async {
    final client = Matrix.of(context).client;

    await showFutureLoadingDialog(
      context: context,
      future: () async {
        final pack = _getPack();
        final archive = Archive();
        for (final entry in pack.images.entries) {
          final emote = entry.value;
          final name = entry.key;
          final url = await emote.url.getDownloadUri(client);
          final response = await get(
            url,
            headers: {'authorization': 'Bearer ${client.accessToken}'},
          );

          archive.addFile(
            ArchiveFile(
              name,
              response.bodyBytes.length,
              response.bodyBytes,
            ),
          );
        }
        final fileName =
            '${pack.pack.displayName ?? client.userID?.localpart ?? 'emotes'}.zip';
        final output = ZipEncoder().encode(archive);

        MatrixFile(
          name: fileName,
          bytes: Uint8List.fromList(output),
        ).save(context);
      },
    );
  }
}
