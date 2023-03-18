import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/client_manager.dart';
import '../../widgets/matrix.dart';
import 'settings_emotes_view.dart';

class EmotesSettings extends StatefulWidget {
  const EmotesSettings({Key? key}) : super(key: key);

  @override
  EmotesSettingsController createState() => EmotesSettingsController();
}

class EmotesSettingsController extends State<EmotesSettings> {
  String? get roomId => VRouter.of(context).pathParameters['roomid'];
  Room? get room =>
      roomId != null ? Matrix.of(context).client.getRoomById(roomId!) : null;
  String? get stateKey => VRouter.of(context).pathParameters['state_key'];

  bool showSave = false;
  TextEditingController newImageCodeController = TextEditingController();
  ValueNotifier<ImagePackImageContent?> newImageController =
      ValueNotifier<ImagePackImageContent?>(null);

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

  Future<void> _save(BuildContext context) async {
    if (readonly) {
      return;
    }
    final client = Matrix.of(context).client;
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () => client.setRoomStateWithKey(
          room!.id,
          'im.ponies.room_emotes',
          stateKey ?? '',
          pack!.toJson(),
        ),
      );
    } else {
      await showFutureLoadingDialog(
        context: context,
        future: () => client.setAccountData(
          client.userID!,
          'im.ponies.user_emotes',
          pack!.toJson(),
        ),
      );
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

  void removeImageAction(String oldImageCode) => setState(() {
        pack!.images.remove(oldImageCode);
        showSave = true;
      });

  void submitImageAction(
    String oldImageCode,
    String imageCode,
    ImagePackImageContent image,
    TextEditingController controller,
  ) {
    if (pack!.images.keys.any((k) => k == imageCode && k != oldImageCode)) {
      controller.text = oldImageCode;
      showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context)!.emoteExists,
        okLabel: L10n.of(context)!.ok,
      );
      return;
    }
    if (!RegExp(r'^[-\w]+$').hasMatch(imageCode)) {
      controller.text = oldImageCode;
      showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context)!.emoteInvalid,
        okLabel: L10n.of(context)!.ok,
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
      client!.accountData['im.ponies.emote_rooms']?.content is Map &&
      client.accountData['im.ponies.emote_rooms']!.content['rooms'] is Map &&
      client.accountData['im.ponies.emote_rooms']!.content['rooms'][room!.id]
          is Map &&
      client.accountData['im.ponies.emote_rooms']!.content['rooms'][room!.id]
          [stateKey ?? ''] is Map;

  bool get readonly =>
      room == null ? false : !(room!.canSendEvent('im.ponies.room_emotes'));

  void saveAction() async {
    await _save(context);
    setState(() {
      showSave = false;
    });
  }

  void addImageAction() async {
    if (newImageCodeController.text.isEmpty ||
        newImageController.value == null) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context)!.emoteWarnNeedToPick,
        okLabel: L10n.of(context)!.ok,
      );
      return;
    }
    final imageCode = newImageCodeController.text;
    if (pack!.images.containsKey(imageCode)) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context)!.emoteExists,
        okLabel: L10n.of(context)!.ok,
      );
      return;
    }
    if (!RegExp(r'^[-\w]+$').hasMatch(imageCode)) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context)!.emoteInvalid,
        okLabel: L10n.of(context)!.ok,
      );
      return;
    }
    pack!.images[imageCode] = newImageController.value!;
    await _save(context);
    setState(() {
      newImageCodeController.text = '';
      newImageController.value = null;
      showSave = false;
    });
  }

  void imagePickerAction(
    ValueNotifier<ImagePackImageContent?> controller,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    final pickedFile = result?.files.firstOrNull;
    if (pickedFile == null) return;
    var file = MatrixImageFile(
      bytes: pickedFile.bytes!,
      name: pickedFile.name,
    );
    try {
      file = (await file.generateThumbnail(
        nativeImplementations: ClientManager.nativeImplementations,
      ))!;
    } catch (e, s) {
      Logs().w('Unable to create thumbnail', e, s);
    }
    final uploadResp = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.uploadContent(
            file.bytes,
            filename: file.name,
            contentType: file.mimeType,
          ),
    );
    if (uploadResp.error == null) {
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
        controller.value = ImagePackImageContent.fromJson(<String, dynamic>{
          'url': uploadResp.result.toString(),
          'info': info,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EmotesSettingsView(this);
  }
}
