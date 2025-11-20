import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import '../../widgets/matrix.dart';
import 'settings_emotes.dart';

enum PopupMenuEmojiActions { import, export }

class EmotesSettingsView extends StatelessWidget {
  final EmotesSettingsController controller;

  const EmotesSettingsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final client = Matrix.of(context).client;
    final imageKeys = controller.pack!.images.keys.toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !controller.showSave,
        title: controller.showSave
            ? TextButton(
                onPressed: controller.resetAction,
                child: Text(L10n.of(context).cancel),
              )
            : Text(L10n.of(context).customEmojisAndStickers),
        actions: [
          if (controller.showSave)
            ElevatedButton(
              onPressed: () => controller.save(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: Text(L10n.of(context).saveChanges),
            )
          else
            PopupMenuButton<PopupMenuEmojiActions>(
              useRootNavigator: true,
              onSelected: (value) {
                switch (value) {
                  case PopupMenuEmojiActions.export:
                    controller.exportAsZip();
                    break;
                  case PopupMenuEmojiActions.import:
                    controller.importEmojiZip();
                    break;
                }
              },
              enabled: !controller.readonly,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: PopupMenuEmojiActions.import,
                  child: Text(L10n.of(context).importFromZipFile),
                ),
                PopupMenuItem(
                  value: PopupMenuEmojiActions.export,
                  child: Text(L10n.of(context).exportEmotePack),
                ),
              ],
            ),
        ],
      ),
      body: MaxWidthBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!controller.readonly)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: controller.createStickers,
                  icon: const Icon(Icons.upload_outlined),
                  label: Text(L10n.of(context).createSticker),
                ),
              ),
            if (controller.room != null)
              SwitchListTile.adaptive(
                title: Text(L10n.of(context).enableEmotesGlobally),
                value: controller.isGloballyActive(client),
                onChanged: controller.setIsGloballyActive,
              ),
            if (!controller.readonly || controller.room != null)
              const Divider(),
            imageKeys.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        L10n.of(context).noEmotesFound,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int i) =>
                        const SizedBox.shrink(),
                    itemCount: imageKeys.length + 1,
                    itemBuilder: (BuildContext context, int i) {
                      if (i >= imageKeys.length) {
                        return Container(height: 70);
                      }
                      final imageCode = imageKeys[i];
                      final image = controller.pack!.images[imageCode]!;
                      final textEditingController = TextEditingController();
                      textEditingController.text = imageCode;
                      final useShortCuts =
                          (PlatformInfos.isWeb || PlatformInfos.isDesktop);
                      return ListTile(
                        title: Shortcuts(
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
                                    SubmitLineIntent: CallbackAction(
                                      onInvoke: (i) {
                                        controller.submitImageAction(
                                          imageCode,
                                          textEditingController.text,
                                          image,
                                          textEditingController,
                                        );
                                        return null;
                                      },
                                    ),
                                  },
                            child: TextField(
                              readOnly: controller.readonly,
                              controller: textEditingController,
                              autocorrect: false,
                              minLines: 1,
                              maxLines: 1,
                              maxLength: 128,
                              decoration: InputDecoration(
                                hintText: L10n.of(context).emoteShortcode,
                                prefixText: ': ',
                                suffixText: ':',
                                counter: const SizedBox.shrink(),
                                filled: false,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              onSubmitted: (s) => controller.submitImageAction(
                                imageCode,
                                s,
                                image,
                                textEditingController,
                              ),
                            ),
                          ),
                        ),
                        leading: _EmoteImage(image.url),
                        trailing: controller.readonly
                            ? null
                            : IconButton(
                                tooltip: L10n.of(context).delete,
                                onPressed: () =>
                                    controller.removeImageAction(imageCode),
                                icon: const Icon(Icons.delete_outlined),
                              ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _EmoteImage extends StatelessWidget {
  final Uri mxc;

  const _EmoteImage(this.mxc);

  @override
  Widget build(BuildContext context) {
    const size = 38.0;
    return SizedBox.square(
      dimension: size,
      child: MxcImage(
        uri: mxc,
        fit: BoxFit.contain,
        width: size,
        height: size,
        isThumbnail: false,
      ),
    );
  }
}

class SubmitLineIntent extends Intent {}
