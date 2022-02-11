import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:video_player/video_player.dart';

import 'add_story.dart';

class AddStoryView extends StatelessWidget {
  final AddStoryController controller;
  const AddStoryView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final video = controller.videoPlayerController;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          L10n.of(context)!.addToStory,
          style: const TextStyle(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(0, 0),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        actions: [
          if (controller.hasMedia)
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: controller.reset,
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (video != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: FutureBuilder(
                future: video.initialize().then((_) => video.play()),
                builder: (_, __) => Center(child: VideoPlayer(video)),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 80.0,
            ),
            decoration: BoxDecoration(
              image: controller.image == null
                  ? null
                  : DecorationImage(
                      image: MemoryImage(controller.image!.bytes),
                      fit: BoxFit.contain,
                      opacity: 0.75,
                    ),
              gradient: controller.hasMedia
                  ? null
                  : LinearGradient(
                      colors: [
                        controller.backgroundColorDark,
                        controller.backgroundColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
            ),
            child: Center(
              child: TextField(
                controller: controller.controller,
                focusNode: controller.focusNode,
                minLines: 1,
                maxLines: 15,
                maxLength: 500,
                autofocus: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  backgroundColor: !controller.hasMedia
                      ? null
                      : Colors.black.withOpacity(0.5),
                ),
                onChanged: (_) => controller.updateColors(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: controller.hasMedia
                      ? L10n.of(context)!.addDescription
                      : L10n.of(context)!.whatIsGoingOn,
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!controller.hasMedia && !controller.textFieldHasFocus) ...[
            FloatingActionButton(
              onPressed: controller.captureVideo,
              backgroundColor: controller.backgroundColorDark,
              foregroundColor: Colors.white,
              heroTag: null,
              child: const Icon(Icons.video_camera_front_outlined),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: controller.capturePhoto,
              backgroundColor: controller.backgroundColorDark,
              foregroundColor: Colors.white,
              heroTag: null,
              child: const Icon(Icons.camera_alt_outlined),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: controller.importMedia,
              backgroundColor: controller.backgroundColorDark,
              foregroundColor: Colors.white,
              heroTag: null,
              child: const Icon(Icons.photo_outlined),
            ),
          ],
          if (controller.hasMedia || controller.hasText) ...[
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: controller.postStory,
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              child: const Icon(Icons.send_rounded),
            ),
          ],
        ],
      ),
    );
  }
}
