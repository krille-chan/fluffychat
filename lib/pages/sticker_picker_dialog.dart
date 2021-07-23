import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../widgets/event_content/image_bubble.dart';
import '../widgets/avatar.dart';
import '../widgets/default_app_bar_search_field.dart';

class StickerPickerDialog extends StatefulWidget {
  final Room room;

  const StickerPickerDialog({this.room, Key key}) : super(key: key);

  @override
  StickerPickerDialogState createState() => StickerPickerDialogState();
}

class StickerPickerDialogState extends State<StickerPickerDialog> {
  String searchFilter;

  @override
  Widget build(BuildContext context) {
    final stickerPacks = widget.room.getImagePacks(ImagePackUsage.sticker);
    final packSlugs = stickerPacks.keys.toList();

    final _packBuilder = (BuildContext context, int packIndex) {
      final pack = stickerPacks[packSlugs[packIndex]];
      final filteredImagePackImageEntried = pack.images.entries.toList();
      if (searchFilter?.isNotEmpty ?? false) {
        filteredImagePackImageEntried.removeWhere((e) =>
            !(e.key.toLowerCase().contains(searchFilter.toLowerCase()) ||
                (e.value.body
                        ?.toLowerCase()
                        ?.contains(searchFilter.toLowerCase()) ??
                    false)));
      }
      final imageKeys =
          filteredImagePackImageEntried.map((e) => e.key).toList();
      if (imageKeys.isEmpty) {
        return Container();
      }
      final packName = pack.pack.displayName ?? packSlugs[packIndex];
      return Column(
        children: <Widget>[
          if (packIndex != 0) SizedBox(height: 20),
          if (packName != 'user')
            ListTile(
              leading: Avatar(
                pack.pack.avatarUrl,
                packName,
                client: widget.room.client,
              ),
              title: Text(packName),
            ),
          SizedBox(height: 6),
          GridView.builder(
            itemCount: imageKeys.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int imageIndex) {
              final image = pack.images[imageKeys[imageIndex]];
              final fakeEvent = Event.fromJson(<String, dynamic>{
                'type': EventTypes.Sticker,
                'content': <String, dynamic>{
                  'url': image.url.toString(),
                  'info': image.info,
                },
                'event_id': 'fake_event',
              }, widget.room);
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
      body: Container(
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
                icon: Icon(Icons.close),
                onPressed: Navigator.of(context, rootNavigator: false).pop,
              ),
              title: DefaultAppBarSearchField(
                autofocus: false,
                hintText: L10n.of(context).search,
                suffix: Icon(Icons.search_outlined),
                onChanged: (s) => setState(() => searchFilter = s),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              _packBuilder,
              childCount: packSlugs.length,
            )),
          ],
        ),
      ),
    );
  }
}
