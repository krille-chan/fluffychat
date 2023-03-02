import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/avatar.dart';
import 'events/image_bubble.dart';

class StickerPickerDialog extends StatefulWidget {
  final Room room;

  const StickerPickerDialog({required this.room, Key? key}) : super(key: key);

  @override
  StickerPickerDialogState createState() => StickerPickerDialogState();
}

class StickerPickerDialogState extends State<StickerPickerDialog> {
  String? searchFilter;

  @override
  Widget build(BuildContext context) {
    final stickerPacks = widget.room.getImagePacks(ImagePackUsage.sticker);
    final packSlugs = stickerPacks.keys.toList();

    // ignore: prefer_function_declarations_over_variables
    final packBuilder = (BuildContext context, int packIndex) {
      final pack = stickerPacks[packSlugs[packIndex]]!;
      final filteredImagePackImageEntried = pack.images.entries.toList();
      if (searchFilter?.isNotEmpty ?? false) {
        filteredImagePackImageEntried.removeWhere(
          (e) => !(e.key.toLowerCase().contains(searchFilter!.toLowerCase()) ||
              (e.value.body
                      ?.toLowerCase()
                      .contains(searchFilter!.toLowerCase()) ??
                  false)),
        );
      }
      final imageKeys =
          filteredImagePackImageEntried.map((e) => e.key).toList();
      if (imageKeys.isEmpty) {
        return Container();
      }
      final packName = pack.pack.displayName ?? packSlugs[packIndex];
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
            itemCount: imageKeys.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int imageIndex) {
              final image = pack.images[imageKeys[imageIndex]]!;
              final fakeEvent = Event(
                type: EventTypes.Sticker,
                content: {
                  'url': image.url.toString(),
                  'info': image.info,
                },
                originServerTs: DateTime.now(),
                room: widget.room,
                eventId: 'fake_event',
                senderId: widget.room.client.userID!,
              );
              return InkWell(
                key: ValueKey(image.url.toString()),
                onTap: () {
                  // copy the image
                  final imageCopy =
                      ImagePackImageContent.fromJson(image.toJson().copy());
                  // set the body, if it doesn't exist, to the key
                  imageCopy.body ??= imageKeys[imageIndex];
                  Navigator.of(context, rootNavigator: false)
                      .pop<ImagePackImageContent>(imageCopy);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: ImageBubble(
                    fakeEvent,
                    tapToView: false,
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                  ),
                ),
              );
            },
          ),
        ],
      );
    };

    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context, rootNavigator: false).pop,
              ),
              title: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: L10n.of(context)!.search,
                  suffix: const Icon(Icons.search_outlined),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (s) => setState(() => searchFilter = s),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                packBuilder,
                childCount: packSlugs.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
