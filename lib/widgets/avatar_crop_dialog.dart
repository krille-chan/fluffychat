import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:crop_image/crop_image.dart';

import 'package:fluffychat/l10n/l10n.dart';

class AvatarCropDialog extends StatefulWidget {
  final Uint8List image;

  const AvatarCropDialog({super.key, required this.image});

  @override
  AvatarCropDialogController createState() => AvatarCropDialogController();
}

class AvatarCropDialogController extends State<AvatarCropDialog> {
  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTWH(0.1, 0.1, 0.8, 0.8),
  );

  void onCancelAction() => Navigator.of(context).pop();

  Future<void> onCropAction() async {
    final image = await controller.croppedBitmap();
    if (mounted) {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      Navigator.of(context).pop(data?.buffer.asUint8List());
    }
  }

  @override
  Widget build(BuildContext context) => AvatarCropDialogView(this);
}

class AvatarCropDialogView extends StatelessWidget {
  final AvatarCropDialogController controller;

  const AvatarCropDialogView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.of(context).changeYourAvatar),
      content: SizedBox(
        width: 400,
        height: 400,
        child: CropImage(
          controller: controller.controller,
          image: Image.memory(controller.widget.image),
          gridColor: Colors.white,
          gridCornerSize: 20,
          touchSize: 20,
          alwaysShowThirdLines: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: controller.onCancelAction,
          child: Text(L10n.of(context).cancel),
        ),
        TextButton(
          onPressed: controller.onCropAction,
          child: Text(L10n.of(context).ok),
        ),
      ],
    );
  }
}
