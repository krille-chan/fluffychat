import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/add_story/add_story_view.dart';
import 'package:fluffychat/pages/add_story/invite_story_page.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/utils/resize_image.dart';
import 'package:fluffychat/utils/story_theme_data.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/matrix_sdk_extensions/client_stories_extension.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({Key? key}) : super(key: key);

  @override
  AddStoryController createState() => AddStoryController();
}

class AddStoryController extends State<AddStoryPage> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late Color backgroundColor;
  late Color backgroundColorDark;
  MatrixImageFile? image;
  MatrixVideoFile? video;

  VideoPlayerController? videoPlayerController;

  bool get hasMedia => image != null || video != null;

  bool hasText = false;

  bool textFieldHasFocus = false;

  BoxFit fit = BoxFit.contain;

  int alignmentX = 0;
  int alignmentY = 0;

  void toggleBoxFit() {
    if (fit == BoxFit.contain) {
      setState(() {
        fit = BoxFit.cover;
      });
    } else {
      setState(() {
        fit = BoxFit.contain;
      });
    }
  }

  void updateHasText(String text) {
    if (hasText != text.isNotEmpty) {
      setState(() {
        hasText = text.isNotEmpty;
      });
    }
  }

  void importMedia() async {
    final picked = await FilePickerCross.importFromStorage(
      type: FileTypeCross.image,
    );
    final fileName = picked.fileName;
    if (fileName == null) return;
    final matrixFile = MatrixImageFile(
      bytes: picked.toUint8List(),
      name: fileName,
    );
    setState(() {
      image = matrixFile;
    });
  }

  void capturePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (picked == null) return;
    final matrixFile = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final bytes = await picked.readAsBytes();
        return MatrixImageFile(
          bytes: bytes,
          name: picked.name,
        );
      },
    );

    setState(() {
      image = matrixFile.result;
    });
  }

  void updateColor() {
    final rand = Random().nextInt(1000).toString();
    setState(() {
      backgroundColor = rand.color;
      backgroundColorDark = rand.darkColor;
    });
  }

  void captureVideo() async {
    final picked = await ImagePicker().pickVideo(
      source: ImageSource.camera,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();

    setState(() {
      video = MatrixVideoFile(bytes: bytes, name: picked.name);
      videoPlayerController = VideoPlayerController.file(File(picked.path))
        ..setLooping(true);
    });
  }

  void reset() => setState(() {
        image = video = null;
        alignmentX = alignmentY = 0;
        controller.clear();
      });

  void postStory() async {
    if (video == null && image == null && controller.text.isEmpty) return;
    final client = Matrix.of(context).client;
    var storiesRoom = await client.getStoriesRoom(context);

    // Invite contacts if necessary
    final undecided = await showFutureLoadingDialog(
      context: context,
      future: () => client.getUndecidedContactsForStories(storiesRoom),
    );
    final result = undecided.result;
    if (result == null) return;
    if (result.isNotEmpty) {
      final created = await showDialog<bool>(
        context: context,
        useRootNavigator: false,
        builder: (context) => InviteStoryPage(storiesRoom: storiesRoom),
      );
      if (created != true) return;
      storiesRoom ??= await client.getStoriesRoom(context);
    }

    // Post story
    final postResult = await showFutureLoadingDialog(
      context: context,
      future: () async {
        if (storiesRoom == null) throw ('Stories room is null');
        var video = this.video?.detectFileType;
        if (video != null) {
          video = await video.resizeVideo();
          final thumbnail = await video.getVideoThumbnail();
          await storiesRoom.sendFileEvent(
            video,
            extraContent: {
              'body': controller.text,
              StoryThemeData.contentKey: StoryThemeData(
                fit: fit,
                alignmentX: alignmentX,
                alignmentY: alignmentY,
              ).toJson(),
            },
            thumbnail: thumbnail,
          );
          return;
        }
        final image = this.image;
        if (image != null) {
          await storiesRoom.sendFileEvent(
            image,
            extraContent: {
              'body': controller.text,
              StoryThemeData.contentKey: StoryThemeData(
                fit: fit,
                alignmentX: alignmentX,
                alignmentY: alignmentY,
              ).toJson(),
            },
          );
          return;
        }
        await storiesRoom.sendEvent(<String, dynamic>{
          'msgtype': MessageTypes.Text,
          'body': controller.text,
          StoryThemeData.contentKey: StoryThemeData(
            color1: backgroundColor,
            color2: backgroundColorDark,
            fit: fit,
            alignmentX: alignmentX,
            alignmentY: alignmentY,
          ).toJson(),
        });
      },
    );
    if (postResult.error == null) {
      VRouter.of(context).pop();
    }
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta;
    if (delta == null) return;
    if (delta > 0 && alignmentY < 100) {
      setState(() {
        alignmentY += 1;
      });
    } else if (delta < 0 && alignmentY > -100) {
      setState(() {
        alignmentY -= 1;
      });
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta;
    if (delta == null) return;
    if (delta > 0 && alignmentX < 100) {
      setState(() {
        alignmentX += 1;
      });
    } else if (delta < 0 && alignmentX > -100) {
      setState(() {
        alignmentX -= 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final rand = Random().nextInt(1000).toString();
    backgroundColor = rand.color;
    backgroundColorDark = rand.darkColor;
    focusNode.addListener(() {
      if (textFieldHasFocus != focusNode.hasFocus) {
        setState(() {
          textFieldHasFocus = focusNode.hasFocus;
        });
      }
    });

    final shareContent = Matrix.of(context).shareContent;
    if (shareContent != null) {
      controller.text = shareContent.tryGet<String>('body') ?? '';
      final shareFile = shareContent.tryGet<MatrixFile>('file')?.detectFileType;

      if (shareFile is MatrixImageFile) {
        setState(() {
          image = shareFile;
        });
      } else if (shareFile is MatrixVideoFile) {
        setState(() {
          video = shareFile;
        });
      }

      final msgType = shareContent.tryGet<String>('msgtype');
      if (msgType == MessageTypes.Image) {
        Event(
          content: shareContent,
          type: EventTypes.Message,
          room: Room(id: '!tmproom', client: Matrix.of(context).client),
          eventId: 'tmpevent',
          senderId: '@tmpsender:example',
          originServerTs: DateTime.now(),
        ).downloadAndDecryptAttachment().then((file) {
          setState(() {
            image = file.detectFileType as MatrixImageFile;
          });
        });
      } else if (msgType == MessageTypes.Video) {
        Event(
          content: shareContent,
          type: EventTypes.Message,
          room: Room(id: '!tmproom', client: Matrix.of(context).client),
          eventId: 'tmpevent',
          senderId: '@tmpsender:example',
          originServerTs: DateTime.now(),
        ).downloadAndDecryptAttachment().then((file) {
          setState(() {
            video = file.detectFileType as MatrixVideoFile;
          });
        });
      }
      Matrix.of(context).shareContent = null;
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AddStoryView(this);
}
