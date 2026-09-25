// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/recent_stickers_store.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/avatar.dart';

class StickerPickerDialog extends StatefulWidget {
  final Room room;
  final ImagePackUsage usage;
  final void Function(ImagePackImageContent) onSelected;

  const StickerPickerDialog({
    required this.onSelected,
    required this.room,
    this.usage = ImagePackUsage.sticker,
    super.key,
  });

  @override
  StickerPickerDialogState createState() => StickerPickerDialogState();
}

class StickerPickerDialogState extends State<StickerPickerDialog> {
  String? searchFilter;

  void _selectSticker(ImagePackImageContent image, String fallbackBody) {
    final imageCopy = ImagePackImageContent.fromJson(image.toJson().copy());
    imageCopy.body ??= fallbackBody;
    widget.onSelected(imageCopy);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stickerPacks = widget.room.getImagePacks(widget.usage);
    final packSlugs = stickerPacks.keys.toList();
    final currentStickersByUrl = <String, _StickerEntry>{};

    for (final pack in stickerPacks.values) {
      for (final entry in pack.images.entries) {
        currentStickersByUrl.putIfAbsent(
          entry.value.url.toString(),
          () => _StickerEntry(key: entry.key, image: entry.value),
        );
      }
    }

    final recentStickers =
        RecentStickersStore.read(
              Matrix.of(context).store,
              widget.room.client.userID,
            )
            .map((url) => currentStickersByUrl[url])
            .whereType<_StickerEntry>()
            .toList(growable: false);

    return Material(
      color: theme.colorScheme.onInverseSurface,
      child: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: <Widget>[
            if (recentStickers.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 88,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: recentStickers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final recentSticker = recentStickers[index];
                      return SizedBox(
                        width: 72,
                        child: Tooltip(
                          message:
                              recentSticker.image.body ?? recentSticker.key,
                          child: InkWell(
                            radius: AppConfig.borderRadius,
                            key: ValueKey('recent_${recentSticker.image.url}'),
                            onTap: () => _selectSticker(
                              recentSticker.image,
                              recentSticker.key,
                            ),
                            child: AbsorbPointer(
                              absorbing: true,
                              child: MxcImage(
                                uri: recentSticker.image.url,
                                fit: BoxFit.contain,
                                width: 72,
                                height: 72,
                                animated: true,
                                isThumbnail: false,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            SliverAppBar(
              floating: true,
              primary: false,
              toolbarHeight: 72,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.secondaryContainer,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  contentPadding: EdgeInsets.zero,
                  hintText: L10n.of(context).search,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.normal,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: const Icon(Icons.search_outlined),
                ),
                onChanged: (s) => setState(() => searchFilter = s),
              ),
            ),
            if (packSlugs.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      Text(L10n.of(context).noEmotesFound),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => UrlLauncher(
                          context,
                          AppConfig.howDoIGetStickersTutorial,
                        ).launchUrl(),
                        icon: const Icon(Icons.explore_outlined),
                        label: Text(L10n.of(context).discover),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList.builder(
                itemCount: packSlugs.length,
                itemBuilder: (BuildContext context, int packIndex) {
                  final pack = stickerPacks[packSlugs[packIndex]]!;
                  final filteredImagePackImageEntried = pack.images.entries
                      .toList();
                  if (searchFilter?.isNotEmpty ?? false) {
                    filteredImagePackImageEntried.removeWhere(
                      (e) =>
                          !(e.key.toLowerCase().contains(
                                searchFilter!.toLowerCase(),
                              ) ||
                              (e.value.body?.toLowerCase().contains(
                                    searchFilter!.toLowerCase(),
                                  ) ??
                                  false)),
                    );
                  }
                  final imageKeys = filteredImagePackImageEntried
                      .map((e) => e.key)
                      .toList();
                  if (imageKeys.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final packName =
                      pack.pack.displayName ?? packSlugs[packIndex];
                  return Column(
                    children: <Widget>[
                      if (packIndex != 0) const SizedBox(height: 20),
                      if (packName != 'user')
                        ListTile(
                          leading: Avatar(
                            mxContent: pack.pack.avatarUrl,
                            name: packName,
                            client: widget.room.client,
                          ),
                          title: Text(packName),
                        ),
                      const SizedBox(height: 6),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: imageKeys.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 84,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int imageIndex) {
                          final image = pack.images[imageKeys[imageIndex]]!;
                          return Tooltip(
                            message: image.body ?? imageKeys[imageIndex],
                            child: InkWell(
                              radius: AppConfig.borderRadius,
                              key: ValueKey(image.url.toString()),
                              onTap: () =>
                                  _selectSticker(image, imageKeys[imageIndex]),
                              child: AbsorbPointer(
                                absorbing: true,
                                child: MxcImage(
                                  uri: image.url,
                                  fit: BoxFit.contain,
                                  width: 128,
                                  height: 128,
                                  animated: true,
                                  isThumbnail: false,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _StickerEntry {
  final String key;
  final ImagePackImageContent image;

  const _StickerEntry({required this.key, required this.image});
}
