import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'video_viewer.dart';

class VideoViewerView extends StatelessWidget {
  final VideoViewerController controller;

  const VideoViewerView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(context).pop,
          color: Colors.white,
          tooltip: L10n.of(context).close,
        ),
        backgroundColor: const Color(0x44000000),
        actions: [
          IconButton(
            icon: const Icon(Icons.reply_outlined),
            onPressed: controller.forwardAction,
            color: Colors.white,
            tooltip: L10n.of(context).share,
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: controller.saveFileAction,
            color: Colors.white,
            tooltip: L10n.of(context).downloadFile,
          ),
        ],
      ),
      body: Center(
        child: controller.error != null
            ? Text(controller.error.toString())
            : (controller.chewieController == null
                ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                : Chewie(
                    controller: controller.chewieController,
                  )),
      ),
    );
  }
}
