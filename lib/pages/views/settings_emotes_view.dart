import 'package:fluffychat/utils/platform_infos.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../widgets/matrix.dart';
import '../settings_emotes.dart';

class EmotesSettingsView extends StatelessWidget {
  final EmotesSettingsController controller;

  const EmotesSettingsView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final imageKeys = controller.pack.images.keys.toList();
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
        child: Column(
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
                      controller: controller.newImageCodeController,
                      autocorrect: false,
                      minLines: 1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: L10n.of(context).emoteShortcode,
                        prefixText: ': ',
                        suffixText: ':',
                        prefixStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        suffixStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  title: _ImagePicker(
                    controller: controller.newImageController,
                    onPressed: controller.imagePickerAction,
                  ),
                  trailing: InkWell(
                    onTap: controller.addImageAction,
                    child: Icon(
                      Icons.add_outlined,
                      color: Colors.green,
                      size: 32.0,
                    ),
                  ),
                ),
              ),
            if (controller.room != null)
              ListTile(
                title: Text(L10n.of(context).enableEmotesGlobally),
                trailing: Switch(
                  value: controller.isGloballyActive(client),
                  onChanged: controller.setIsGloballyActive,
                ),
              ),
            if (!controller.readonly || controller.room != null)
              Divider(
                height: 2,
                thickness: 2,
                color: Theme.of(context).primaryColor,
              ),
            Expanded(
              child: imageKeys.isEmpty
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
                      itemCount: imageKeys.length + 1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i >= imageKeys.length) {
                          return Container(height: 70);
                        }
                        final imageCode = imageKeys[i];
                        final image = controller.pack.images[imageCode];
                        final textEditingController = TextEditingController();
                        textEditingController.text = imageCode;
                        final useShortCuts =
                            (PlatformInfos.isWeb || PlatformInfos.isDesktop);
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
                            child: Shortcuts(
                              shortcuts: !useShortCuts
                                  ? {}
                                  : {
                                      LogicalKeySet(LogicalKeyboardKey.enter):
                                          SubmitLineIntent(),
                                    },
                              child: Actions(
                                actions: !useShortCuts
                                    ? {}
                                    : {
                                        SubmitLineIntent:
                                            CallbackAction(onInvoke: (i) {
                                          controller.submitImageAction(
                                            imageCode,
                                            textEditingController.text,
                                            image,
                                            textEditingController,
                                          );
                                          return null;
                                        }),
                                      },
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    suffixStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (s) =>
                                      controller.submitImageAction(
                                    imageCode,
                                    s,
                                    image,
                                    textEditingController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: _EmoteImage(image.url),
                          trailing: controller.readonly
                              ? null
                              : InkWell(
                                  onTap: () =>
                                      controller.removeImageAction(imageCode),
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
        ),
      ),
    );
  }
}

class _EmoteImage extends StatelessWidget {
  final Uri mxc;
  _EmoteImage(this.mxc);

  @override
  Widget build(BuildContext context) {
    final size = 38.0;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final url = mxc?.getThumbnail(
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

class _ImagePicker extends StatefulWidget {
  final ValueNotifier<ImagePackImageContent> controller;

  final void Function(ValueNotifier<ImagePackImageContent>) onPressed;

  _ImagePicker({@required this.controller, @required this.onPressed});

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<_ImagePicker> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller.value == null) {
      return ElevatedButton(
        onPressed: () => widget.onPressed(widget.controller),
        child: Text(L10n.of(context).pickImage),
      );
    } else {
      return _EmoteImage(widget.controller.value.url);
    }
  }
}

class SubmitLineIntent extends Intent {}
