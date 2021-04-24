import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/layouts/max_width_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../widgets/matrix.dart';
import '../settings_emotes.dart';

class EmotesSettingsUI extends StatelessWidget {
  final EmotesSettingsController controller;

  const EmotesSettingsUI(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).emoteSettings),
      ),
      floatingActionButton: controller.showSave
          ? FloatingActionButton(
              onPressed: controller.saveAction,
              child: Icon(Icons.save_outlined, color: Colors.white),
            )
          : null,
      body: MaxWidthBody(
        child: StreamBuilder(
            stream: controller.widget.room?.onUpdate?.stream,
            builder: (context, snapshot) {
              return Column(
                children: <Widget>[
                  if (!controller.readonly)
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
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
                            controller: controller.newEmoteController,
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
                        title: _EmoteImagePicker(
                          controller: controller.newMxcController,
                          onPressed: controller.emoteImagePickerAction,
                        ),
                        trailing: InkWell(
                          onTap: controller.addEmoteAction,
                          child: Icon(
                            Icons.add_outlined,
                            color: Colors.green,
                            size: 32.0,
                          ),
                        ),
                      ),
                    ),
                  if (controller.widget.room != null)
                    ListTile(
                      title: Text(L10n.of(context).enableEmotesGlobally),
                      trailing: Switch(
                        value: controller.isGloballyActive(client),
                        onChanged: controller.setIsGloballyActive,
                      ),
                    ),
                  if (!controller.readonly || controller.widget.room != null)
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  Expanded(
                    child: controller.emotes.isEmpty
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
                            itemCount: controller.emotes.length + 1,
                            itemBuilder: (BuildContext context, int i) {
                              if (i >= controller.emotes.length) {
                                return Container(height: 70);
                              }
                              final emote = controller.emotes[i];
                              final textEditingController =
                                  TextEditingController();
                              textEditingController.text = emote.emoteClean;
                              return ListTile(
                                leading: Container(
                                  width: 180.0,
                                  height: 38,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                  child: TextField(
                                    readOnly: controller.readonly,
                                    controller: textEditingController,
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
                                    onSubmitted: (s) =>
                                        controller.submitEmoteAction(
                                      s,
                                      emote,
                                      textEditingController,
                                    ),
                                  ),
                                ),
                                title: _EmoteImage(emote.mxc),
                                trailing: controller.readonly
                                    ? null
                                    : InkWell(
                                        onTap: () =>
                                            controller.removeEmoteAction(emote),
                                        child: Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.red,
                                          size: 32.0,
                                        ),
                                      ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }),
      ),
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
      imageUrl: url.toString(),
      fit: BoxFit.contain,
      width: size,
      height: size,
    );
  }
}

class _EmoteImagePicker extends StatefulWidget {
  final TextEditingController controller;

  final void Function(TextEditingController) onPressed;

  _EmoteImagePicker({@required this.controller, @required this.onPressed});

  @override
  _EmoteImagePickerState createState() => _EmoteImagePickerState();
}

class _EmoteImagePickerState extends State<_EmoteImagePicker> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller.text == null || widget.controller.text.isEmpty) {
      return ElevatedButton(
        onPressed: () async {},
        child: Text(L10n.of(context).pickImage),
      );
    } else {
      return _EmoteImage(widget.controller.text);
    }
  }
}
