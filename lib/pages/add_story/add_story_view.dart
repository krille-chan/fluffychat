//@dart=2.12

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:video_player/video_player.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'add_story.dart';

class AddStoryView extends StatelessWidget {
  final AddStoryController controller;
  const AddStoryView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final video = controller.videoPlayerController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5),
        title: Text(L10n.of(context)!.addToStory),
        actions: controller.hasMedia
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.photo_outlined),
                  onPressed: controller.importMedia,
                ),
                if (PlatformInfos.isMobile)
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: controller.capturePhoto,
                  ),
                if (PlatformInfos.isMobile)
                  IconButton(
                    icon: const Icon(Icons.video_camera_back_outlined),
                    onPressed: controller.captureVideo,
                  ),
              ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (video != null)
            FutureBuilder(
              future: video.initialize().then((_) => video.play()),
              builder: (_, __) => Center(child: VideoPlayer(video)),
            ),
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              image: controller.image == null
                  ? null
                  : DecorationImage(
                      image: MemoryImage(controller.image!.bytes),
                      fit: BoxFit.cover,
                      opacity: 0.75,
                    ),
              gradient: controller.hasMedia
                  ? null
                  : LinearGradient(
                      colors: [
                        controller.backgroundColor,
                        controller.backgroundColorDark,
                        controller.backgroundColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: Center(
              child: TextField(
                controller: controller.controller,
                minLines: 1,
                maxLines: 20,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  backgroundColor: !controller.hasMedia ? null : Colors.black,
                ),
                onChanged: controller.updateColors,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      controller.hasMedia ? 'Add description' : 'How are you?',
                  filled: false,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    backgroundColor: Colors.transparent,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          controller.controller.text.isEmpty && !controller.hasMedia
              ? null
              : FloatingActionButton.extended(
                  onPressed: controller.postStory,
                  label: Text(L10n.of(context)!.publish),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  icon: const Icon(Icons.check_circle),
                ),
    );
  }
}
