import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../components/matrix.dart';

class EmotesSettings extends StatefulWidget {
  final Room room;
  final String stateKey;

  EmotesSettings({this.room, this.stateKey});

  @override
  _EmotesSettingsState createState() => _EmotesSettingsState();
}

class _EmoteEntry {
  String emote;
  String mxc;
  _EmoteEntry({this.emote, this.mxc});

  String get emoteClean => emote.substring(1, emote.length - 1);
}

class _EmotesSettingsState extends State<EmotesSettings> {
  List<_EmoteEntry> emotes;
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
    if (widget.room != null) {
      content = widget.room
              .getState('im.ponies.room_emotes', widget.stateKey ?? '')
              ?.content ??
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
    if (widget.room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () => client.sendState(widget.room.id, 'im.ponies.room_emotes',
            content, widget.stateKey ?? ''),
      );
    } else {
      await showFutureLoadingDialog(
        context: context,
        future: () => client.setAccountData(
            client.userID, 'im.ponies.user_emotes', content),
      );
    }
  }

  Future<void> _setIsGloballyActive(BuildContext context, bool active) async {
    if (widget.room == null) {
      return;
    }
    final client = Matrix.of(context).client;
    final content = client.accountData['im.ponies.emote_rooms']?.content ??
        <String, dynamic>{};
    if (active) {
      if (!(content['rooms'] is Map)) {
        content['rooms'] = <String, dynamic>{};
      }
      if (!(content['rooms'][widget.room.id] is Map)) {
        content['rooms'][widget.room.id] = <String, dynamic>{};
      }
      if (!(content['rooms'][widget.room.id][widget.stateKey ?? ''] is Map)) {
        content['rooms'][widget.room.id]
            [widget.stateKey ?? ''] = <String, dynamic>{};
      }
    } else if (content['rooms'] is Map &&
        content['rooms'][widget.room.id] is Map) {
      content['rooms'][widget.room.id].remove(widget.stateKey ?? '');
    }
    // and save
    await showFutureLoadingDialog(
      context: context,
      future: () => client.setAccountData(
          client.userID, 'im.ponies.emote_rooms', content),
    );
  }

  bool isGloballyActive(Client client) =>
      widget.room != null &&
      client.accountData['im.ponies.emote_rooms']?.content is Map &&
      client.accountData['im.ponies.emote_rooms'].content['rooms'] is Map &&
      client.accountData['im.ponies.emote_rooms'].content['rooms']
          [widget.room.id] is Map &&
      client.accountData['im.ponies.emote_rooms'].content['rooms']
          [widget.room.id][widget.stateKey ?? ''] is Map;

  bool get readonly => widget.room == null
      ? false
      : !(widget.room.canSendEvent('im.ponies.room_emotes'));

  @override
  Widget build(BuildContext context) {
    var client = Matrix.of(context).client;
    if (emotes == null) {
      emotes = <_EmoteEntry>[];
      Map<String, dynamic> emoteSource;
      if (widget.room != null) {
        emoteSource = widget.room
            .getState('im.ponies.room_emotes', widget.stateKey ?? '')
            ?.content;
      } else {
        emoteSource = client.accountData['im.ponies.user_emotes']?.content;
      }
      if (emoteSource != null) {
        if (emoteSource['emoticons'] is Map) {
          emoteSource['emoticons'].forEach((key, value) {
            if (key is String &&
                value is Map &&
                value['url'] is String &&
                value['url'].startsWith('mxc://')) {
              emotes.add(_EmoteEntry(emote: key, mxc: value['url']));
            }
          });
        } else if (emoteSource['short'] is Map) {
          emoteSource['short'].forEach((key, value) {
            if (key is String &&
                value is String &&
                value.startsWith('mxc://')) {
              emotes.add(_EmoteEntry(emote: key, mxc: value));
            }
          });
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).emoteSettings),
      ),
      floatingActionButton: showSave
          ? FloatingActionButton(
              child: Icon(Icons.save_outlined, color: Colors.white),
              onPressed: () async {
                await _save(context);
                setState(() {
                  showSave = false;
                });
              },
            )
          : null,
      body: StreamBuilder(
          stream: widget.room?.onUpdate?.stream,
          builder: (context, snapshot) {
            return Column(
              children: <Widget>[
                if (!readonly)
                  Container(
                    child: ListTile(
                      leading: Container(
                        width: 180.0,
                        height: 38,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        child: TextField(
                          controller: newEmoteController,
                          autocorrect: false,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: L10n.of(context).emoteShortcode,
                            prefixText: ': ',
                            suffixText: ':',
                            prefixStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            suffixStyle: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      title: _EmoteImagePicker(newMxcController),
                      trailing: InkWell(
                        child: Icon(
                          Icons.add_outlined,
                          color: Colors.green,
                          size: 32.0,
                        ),
                        onTap: () async {
                          if (newEmoteController.text == null ||
                              newEmoteController.text.isEmpty ||
                              newMxcController.text == null ||
                              newMxcController.text.isEmpty) {
                            await showOkAlertDialog(
                              context: context,
                              message: L10n.of(context).emoteWarnNeedToPick,
                              okLabel: L10n.of(context).ok,
                              useRootNavigator: false,
                            );
                            return;
                          }
                          final emoteCode = ':${newEmoteController.text}:';
                          final mxc = newMxcController.text;
                          if (emotes.indexWhere((e) =>
                                  e.emote == emoteCode && e.mxc != mxc) !=
                              -1) {
                            await showOkAlertDialog(
                              context: context,
                              message: L10n.of(context).emoteExists,
                              okLabel: L10n.of(context).ok,
                              useRootNavigator: false,
                            );
                            return;
                          }
                          if (!RegExp(r'^:[-\w]+:$').hasMatch(emoteCode)) {
                            await showOkAlertDialog(
                              context: context,
                              message: L10n.of(context).emoteInvalid,
                              okLabel: L10n.of(context).ok,
                              useRootNavigator: false,
                            );
                            return;
                          }
                          emotes.add(_EmoteEntry(emote: emoteCode, mxc: mxc));
                          await _save(context);
                          setState(() {
                            newEmoteController.text = '';
                            newMxcController.text = '';
                            showSave = false;
                          });
                        },
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                  ),
                if (widget.room != null)
                  ListTile(
                    title: Text(L10n.of(context).enableEmotesGlobally),
                    trailing: Switch(
                      value: isGloballyActive(client),
                      onChanged: (bool newValue) async {
                        await _setIsGloballyActive(context, newValue);
                        setState(() => null);
                      },
                    ),
                  ),
                if (!readonly || widget.room != null)
                  Divider(
                    height: 2,
                    thickness: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                Expanded(
                  child: emotes.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              L10n.of(context).noEmotesFound,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (BuildContext context, int i) =>
                              Container(),
                          itemCount: emotes.length + 1,
                          itemBuilder: (BuildContext context, int i) {
                            if (i >= emotes.length) {
                              return Container(height: 70);
                            }
                            final emote = emotes[i];
                            final controller = TextEditingController();
                            controller.text = emote.emoteClean;
                            return ListTile(
                              leading: Container(
                                width: 180.0,
                                height: 38,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                child: TextField(
                                  readOnly: readonly,
                                  controller: controller,
                                  autocorrect: false,
                                  minLines: 1,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: L10n.of(context).emoteShortcode,
                                    prefixText: ': ',
                                    suffixText: ':',
                                    prefixStyle: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    suffixStyle: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (s) {
                                    final emoteCode = ':${s}:';
                                    if (emotes.indexWhere((e) =>
                                            e.emote == emoteCode &&
                                            e.mxc != emote.mxc) !=
                                        -1) {
                                      controller.text = emote.emoteClean;
                                      showOkAlertDialog(
                                        context: context,
                                        message: L10n.of(context).emoteExists,
                                        okLabel: L10n.of(context).ok,
                                        useRootNavigator: false,
                                      );
                                      return;
                                    }
                                    if (!RegExp(r'^:[-\w]+:$')
                                        .hasMatch(emoteCode)) {
                                      controller.text = emote.emoteClean;
                                      showOkAlertDialog(
                                        context: context,
                                        message: L10n.of(context).emoteInvalid,
                                        okLabel: L10n.of(context).ok,
                                        useRootNavigator: false,
                                      );
                                      return;
                                    }
                                    setState(() {
                                      emote.emote = emoteCode;
                                      showSave = true;
                                    });
                                  },
                                ),
                              ),
                              title: _EmoteImage(emote.mxc),
                              trailing: readonly
                                  ? null
                                  : InkWell(
                                      child: Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                        size: 32.0,
                                      ),
                                      onTap: () => setState(() {
                                        emotes.removeWhere(
                                            (e) => e.emote == emote.emote);
                                        showSave = true;
                                      }),
                                    ),
                            );
                          },
                        ),
                ),
              ],
            );
          }),
    );
  }
}

class _EmoteImage extends StatelessWidget {
  final String mxc;
  _EmoteImage(this.mxc);

  @override
  Widget build(BuildContext context) {
    final size = 38.0;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final url = Uri.parse(mxc)?.getThumbnail(
      Matrix.of(context).client,
      width: size * devicePixelRatio,
      height: size * devicePixelRatio,
      method: ThumbnailMethod.scale,
    );
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      width: size,
      height: size,
    );
  }
}

class _EmoteImagePicker extends StatefulWidget {
  final TextEditingController controller;

  _EmoteImagePicker(this.controller);

  @override
  _EmoteImagePickerState createState() => _EmoteImagePickerState();
}

class _EmoteImagePickerState extends State<_EmoteImagePicker> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller.text == null || widget.controller.text.isEmpty) {
      return RaisedButton(
        color: Theme.of(context).primaryColor,
        elevation: 5,
        textColor: Colors.white,
        child: Text(L10n.of(context).pickImage),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          if (kIsWeb) {
            await FlushbarHelper.createError(
                    message: L10n.of(context).notSupportedInWeb)
                .show(context);
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
            final result = await FilePickerCross.importFromStorage(
                type: FileTypeCross.image);
            if (result == null) return;
            file = MatrixFile(
              bytes: result.toUint8List(),
              name: result.fileName,
            );
          }
          final uploadResp = await showFutureLoadingDialog(
            context: context,
            future: () =>
                Matrix.of(context).client.upload(file.bytes, file.name),
          );
          if (uploadResp.error == null) {
            setState(() {
              widget.controller.text = uploadResp.result;
            });
          }
        },
      );
    } else {
      return _EmoteImage(widget.controller.text);
    }
  }
}
