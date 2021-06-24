import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:matrix/matrix.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'views/settings_emotes_view.dart';
import '../widgets/matrix.dart';

class EmotesSettings extends StatefulWidget {
  EmotesSettings({Key key}) : super(key: key);

  @override
  EmotesSettingsController createState() => EmotesSettingsController();
}

class EmoteEntry {
  String emote;
  String mxc;
  EmoteEntry({this.emote, this.mxc});

  String get emoteClean => emote.substring(1, emote.length - 1);
}

class EmotesSettingsController extends State<EmotesSettings> {
  String get roomId => VRouter.of(context).pathParameters['roomid'];
  Room get room =>
      roomId != null ? Matrix.of(context).client.getRoomById(roomId) : null;
  String get stateKey => VRouter.of(context).pathParameters['state_key'];

  List<EmoteEntry> emotes;
  bool showSave = false;
  TextEditingController newEmoteController = TextEditingController();
  TextEditingController newMxcController = TextEditingController();

  Future<void> _save(BuildContext context) async {
    if (readonly) {
      return;
    }
    final client = Matrix.of(context).client;
    // be sure to preserve any data not in "short"
    Map<String, dynamic> content;
    if (room != null) {
      content =
          room.getState('im.ponies.room_emotes', stateKey ?? '')?.content ??
              <String, dynamic>{};
    } else {
      content = client.accountData['im.ponies.user_emotes']?.content ??
          <String, dynamic>{};
    }
    if (!(content['emoticons'] is Map)) {
      content['emoticons'] = <String, dynamic>{};
    }
    // add / update changed emotes
    final allowedShortcodes = <String>{};
    for (final emote in emotes) {
      allowedShortcodes.add(emote.emote);
      if (!(content['emoticons'][emote.emote] is Map)) {
        content['emoticons'][emote.emote] = <String, dynamic>{};
      }
      content['emoticons'][emote.emote]['url'] = emote.mxc;
    }
    // remove emotes no more needed
    // we make the iterator .toList() here so that we don't get into trouble modifying the very
    // thing we are iterating over
    for (final shortcode in content['emoticons'].keys.toList()) {
      if (!allowedShortcodes.contains(shortcode)) {
        content['emoticons'].remove(shortcode);
      }
    }
    // remove the old "short" key
    content.remove('short');
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () => client.setRoomStateWithKey(
            room.id, 'im.ponies.room_emotes', content, stateKey ?? ''),
      );
    } else {
      await showFutureLoadingDialog(
        context: context,
        future: () => client.setAccountData(
            client.userID, 'im.ponies.user_emotes', content),
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
      if (!(content['rooms'] is Map)) {
        content['rooms'] = <String, dynamic>{};
      }
      if (!(content['rooms'][room.id] is Map)) {
        content['rooms'][room.id] = <String, dynamic>{};
      }
      if (!(content['rooms'][room.id][stateKey ?? ''] is Map)) {
        content['rooms'][room.id][stateKey ?? ''] = <String, dynamic>{};
      }
    } else if (content['rooms'] is Map && content['rooms'][room.id] is Map) {
      content['rooms'][room.id].remove(stateKey ?? '');
    }
    // and save
    await showFutureLoadingDialog(
      context: context,
      future: () => client.setAccountData(
          client.userID, 'im.ponies.emote_rooms', content),
    );
    setState(() => null);
  }

  void removeEmoteAction(EmoteEntry emote) => setState(() {
        emotes.removeWhere((e) => e.emote == emote.emote);
        showSave = true;
      });

  void submitEmoteAction(
    String s,
    EmoteEntry emote,
    TextEditingController controller,
  ) {
    final emoteCode = ':$s:';
    if (emotes.indexWhere((e) => e.emote == emoteCode && e.mxc != emote.mxc) !=
        -1) {
      controller.text = emote.emoteClean;
      showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context).emoteExists,
        okLabel: L10n.of(context).ok,
      );
      return;
    }
    if (!RegExp(r'^:[-\w]+:$').hasMatch(emoteCode)) {
      controller.text = emote.emoteClean;
      showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context).emoteInvalid,
        okLabel: L10n.of(context).ok,
      );
      return;
    }
    setState(() {
      emote.emote = emoteCode;
      showSave = true;
    });
  }

  bool isGloballyActive(Client client) =>
      room != null &&
      client.accountData['im.ponies.emote_rooms']?.content is Map &&
      client.accountData['im.ponies.emote_rooms'].content['rooms'] is Map &&
      client.accountData['im.ponies.emote_rooms'].content['rooms'][room.id]
          is Map &&
      client.accountData['im.ponies.emote_rooms'].content['rooms'][room.id]
          [stateKey ?? ''] is Map;

  bool get readonly =>
      room == null ? false : !(room.canSendEvent('im.ponies.room_emotes'));

  void saveAction() async {
    await _save(context);
    setState(() {
      showSave = false;
    });
  }

  void addEmoteAction() async {
    if (newEmoteController.text == null ||
        newEmoteController.text.isEmpty ||
        newMxcController.text == null ||
        newMxcController.text.isEmpty) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context).emoteWarnNeedToPick,
        okLabel: L10n.of(context).ok,
      );
      return;
    }
    final emoteCode = ':${newEmoteController.text}:';
    final mxc = newMxcController.text;
    if (emotes.indexWhere((e) => e.emote == emoteCode && e.mxc != mxc) != -1) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context).emoteExists,
        okLabel: L10n.of(context).ok,
      );
      return;
    }
    if (!RegExp(r'^:[-\w]+:$').hasMatch(emoteCode)) {
      await showOkAlertDialog(
        useRootNavigator: false,
        context: context,
        message: L10n.of(context).emoteInvalid,
        okLabel: L10n.of(context).ok,
      );
      return;
    }
    emotes.add(EmoteEntry(emote: emoteCode, mxc: mxc));
    await _save(context);
    setState(() {
      newEmoteController.text = '';
      newMxcController.text = '';
      showSave = false;
    });
  }

  void emoteImagePickerAction(TextEditingController controller) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).notSupportedInWeb)));
      return;
    }
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName,
      );
    }
    final uploadResp = await showFutureLoadingDialog(
      context: context,
      future: () =>
          Matrix.of(context).client.uploadContent(file.bytes, file.name),
    );
    if (uploadResp.error == null) {
      setState(() {
        controller.text = uploadResp.result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (emotes == null) {
      emotes = <EmoteEntry>[];
      Map<String, dynamic> emoteSource;
      if (room != null) {
        emoteSource =
            room.getState('im.ponies.room_emotes', stateKey ?? '')?.content;
      } else {
        emoteSource = Matrix.of(context)
            .client
            .accountData['im.ponies.user_emotes']
            ?.content;
      }
      if (emoteSource != null) {
        if (emoteSource['emoticons'] is Map) {
          emoteSource['emoticons'].forEach((key, value) {
            if (key is String &&
                value is Map &&
                value['url'] is String &&
                value['url'].startsWith('mxc://')) {
              emotes.add(EmoteEntry(emote: key, mxc: value['url']));
            }
          });
        } else if (emoteSource['short'] is Map) {
          emoteSource['short'].forEach((key, value) {
            if (key is String &&
                value is String &&
                value.startsWith('mxc://')) {
              emotes.add(EmoteEntry(emote: key, mxc: value));
            }
          });
        }
      }
    }
    return EmotesSettingsView(this);
  }
}
