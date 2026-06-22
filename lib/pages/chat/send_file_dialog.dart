// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:async/async.dart' show Result;
import 'package:crop_image/crop_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/image_edit_geometry.dart';
import 'package:fluffychat/pages/chat/trust_user_key_dialog.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/utils/other_party_can_receive.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/size_string.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/dialog_text_field.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart' hide Result;
import 'package:mime/mime.dart';

import '../../utils/resize_video.dart';

class SendFileDialog extends StatefulWidget {
  final Room room;
  final List<XFile> files;
  final BuildContext outerContext;
  final String? threadLastEventId, threadRootEventId;

  const SendFileDialog({
    required this.room,
    required this.files,
    required this.outerContext,
    required this.threadLastEventId,
    required this.threadRootEventId,
    super.key,
  });

  @override
  SendFileDialogState createState() => SendFileDialogState();
}

class SendFileDialogState extends State<SendFileDialog> {
  bool compress = true;

  /// Images smaller than 20kb don't need compression.
  static const int minSizeToCompress = 20 * 1000;

  final TextEditingController _labelTextController = TextEditingController();

  /// Holds edited image bytes by file index. If an entry exists, it overrides
  /// the original file bytes for preview and upload.
  final Map<int, Uint8List> _editedBytes = {};

  Future<Uint8List> _readBytes(int index) async {
    final edited = _editedBytes[index];
    if (edited != null) return edited;
    return widget.files[index].readAsBytes();
  }

  Future<void> _editImage(int index) async {
    final bytes = await _readBytes(index);
    if (!mounted) return;
    final result = await Navigator.of(context).push<Uint8List?>(
      MaterialPageRoute(builder: (_) => _ImageEditPage(bytes: bytes)),
    );
    if (!mounted || result == null) return;
    setState(() {
      _editedBytes[index] = result;
    });
  }

  Future<void> _send() async {
    final l10n = L10n.of(context);

    final proceed = await showTrustUserInRoomDialog(context, widget.room);
    if (!context.mounted || !proceed) return;

    Future<void> sendAction(setProgress) async {
      if (!widget.room.otherPartyCanReceiveMessages) {
        throw OtherPartyCanNotReceiveMessages();
      }
      Navigator.of(context, rootNavigator: false).pop();
      final clientConfig = await Result.capture(widget.room.client.getConfig());
      final maxUploadSize =
          clientConfig.asValue?.value.mUploadSize ?? 100 * 1000 * 1000;

      var sentFiles = 0;

        for (var i = 0; i < widget.files.length; i++) {
          final xfile = widget.files[i];
          final MatrixFile file;
          MatrixImageFile? thumbnail;
          final mimeType = xfile.mimeType ?? lookupMimeType(xfile.path);

        // Generate video thumbnail
        if (PlatformInfos.isMobile &&
            mimeType != null &&
            mimeType.startsWith('video')) {
          setProgress(sentFiles / widget.files.length + 0.2);
          thumbnail = await xfile.getVideoThumbnail();
        }

          // If file is a video, shrink it!
          if (PlatformInfos.isMobile &&
              mimeType != null &&
              mimeType.startsWith('video')) {
            setProgress(sentFiles / widget.files.length + 0.2);
            final lengthResult = await Result.capture(xfile.length());
            final length = lengthResult.asValue?.value;
            file = await xfile.getVideoInfo(
              compress:
                  length != null && length > minSizeToCompress && compress,
            );
          } else {
            // Else we just create a MatrixFile
            file = MatrixFile(
              bytes: await _readBytes(i),
              name: xfile.name,
              mimeType: mimeType,
            ).detectFileType;
          }

        if (file.bytes.length > maxUploadSize) {
          throw FileTooBigMatrixException(file.bytes.length, maxUploadSize);
        }

        if (widget.files.length > 1) {
          setProgress(sentFiles / widget.files.length + 0.4);
        }

        final label = _labelTextController.text.trim();

        try {
          await widget.room.sendFileEvent(
            file,
            thumbnail: thumbnail,
            shrinkImageMaxDimension: compress ? 1600 : null,
            extraContent: label.isEmpty ? null : {'body': label},
            threadRootEventId: widget.threadRootEventId,
            threadLastEventId: widget.threadLastEventId,
          );
        } on MatrixException catch (e) {
          final retryAfterMs = e.retryAfterMs;
          if (e.error != MatrixError.M_LIMIT_EXCEEDED || retryAfterMs == null) {
            rethrow;
          }
          final retryAfterDuration = Duration(
            milliseconds: retryAfterMs + 1000,
          );

          setProgress(sentFiles / widget.files.length + 0.2);
          await Future.delayed(retryAfterDuration);

          await widget.room.sendFileEvent(
            file,
            thumbnail: thumbnail,
            shrinkImageMaxDimension: compress ? 1600 : null,
            extraContent: label.isEmpty ? null : {'body': label},
          );
        }
        sentFiles++;
      }
    }

    if (widget.files.length == 1) {
      await sendAction(VoidCallback);
    } else {
      showFutureLoadingDialog(
        context: widget.outerContext,
        title: l10n.sendingAttachment,
        futureWithProgress: sendAction,
      );
    }

    return;
  }

  Future<String> _calcCombinedFileSize() async {
    final lengths = await Future.wait(
      widget.files.map((file) => file.length()),
    );
    return lengths.fold<double>(0, (p, length) => p + length).sizeString;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var sendStr = L10n.of(context).sendFile;
    final uniqueFileType = widget.files
        .map((file) => file.mimeType ?? lookupMimeType(file.name))
        .map((mimeType) => mimeType?.split('/').first)
        .toSet()
        .singleOrNull;

    final fileName = widget.files.length == 1
        ? widget.files.single.name
        : L10n.of(context).countFiles(widget.files.length);
    final fileTypes = widget.files
        .map((file) => file.name.split('.').last)
        .toSet()
        .join(', ')
        .toUpperCase();

    if (uniqueFileType == 'image') {
      if (widget.files.length == 1) {
        sendStr = L10n.of(context).sendImage;
      } else {
        sendStr = L10n.of(context).sendImages(widget.files.length);
      }
    } else if (uniqueFileType == 'audio') {
      sendStr = L10n.of(context).sendAudio;
    } else if (uniqueFileType == 'video') {
      sendStr = L10n.of(context).sendVideo;
    }

    final compressionSupported =
        uniqueFileType != 'video' || PlatformInfos.isMobile;

    return FutureBuilder<String>(
      future: _calcCombinedFileSize(),
      builder: (context, snapshot) {
        final sizeString =
            snapshot.data ?? L10n.of(context).calculatingFileSize;

        return AlertDialog.adaptive(
          title: Text(sendStr),
          content: SizedBox(
            width: 256,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: .min,
                children: [
                  const SizedBox(height: 12),
                  if (uniqueFileType == 'image')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        height: 256,
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.files.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  Material(
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 2,
                                    ),
                                    color: Colors.black,
                                    clipBehavior: Clip.hardEdge,
                                    child: FutureBuilder(
                                      future: _readBytes(i),
                                      builder: (context, snapshot) {
                                        final bytes = snapshot.data;
                                        if (bytes == null) {
                                          return const Center(
                                            child:
                                                CircularProgressIndicator.adaptive(),
                                          );
                                        }
                                        if (snapshot.error != null) {
                                          Logs().w(
                                            'Unable to preview image',
                                            snapshot.error,
                                            snapshot.stackTrace,
                                          );
                                          return const Center(
                                            child: SizedBox(
                                              width: 256,
                                              height: 256,
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                                size: 64,
                                              ),
                                            ),
                                          );
                                        }
                                        return Image.memory(
                                          bytes,
                                          height: 256,
                                          width: widget.files.length == 1
                                              ? 256 - 36
                                              : null,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, e, s) {
                                            Logs().w(
                                              'Unable to preview image',
                                              e,
                                              s,
                                            );
                                            return const Center(
                                              child: SizedBox(
                                                width: 256,
                                                height: 256,
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  size: 64,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Material(
                                      color: Colors.black54,
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        tooltip: L10n.of(context).editImage,
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () => _editImage(i),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (uniqueFileType != 'image')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            uniqueFileType == null
                                ? Icons.description_outlined
                                : uniqueFileType == 'video'
                                ? Icons.video_file_outlined
                                : uniqueFileType == 'audio'
                                ? Icons.audio_file_outlined
                                : Icons.description_outlined,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  fileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '$sizeString - $fileTypes',
                                  style: theme.textTheme.labelSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.files.length == 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DialogTextField(
                        controller: _labelTextController,
                        labelText: L10n.of(context).optionalMessage,
                        minLines: 1,
                        maxLines: 1,
                        maxLength: 255,
                        counterText: '',
                      ),
                    ),
                  // Workaround for SwitchListTile.adaptive crashes in CupertinoDialog
                  if ({'image', 'video'}.contains(uniqueFileType))
                    Row(
                      crossAxisAlignment: .center,
                      children: [
                        if ({
                          TargetPlatform.iOS,
                          TargetPlatform.macOS,
                        }.contains(theme.platform))
                          CupertinoSwitch(
                            value: compressionSupported && compress,
                            onChanged: compressionSupported
                                ? (v) => setState(() => compress = v)
                                : null,
                          )
                        else
                          Switch.adaptive(
                            value: compressionSupported && compress,
                            onChanged: compressionSupported
                                ? (v) => setState(() => compress = v)
                                : null,
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                mainAxisSize: .min,
                                children: [
                                  Text(
                                    L10n.of(context).compress,
                                    style: theme.textTheme.titleMedium,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              if (!compress)
                                Text(
                                  ' ($sizeString)',
                                  style: theme.textTheme.labelSmall,
                                ),
                              if (!compressionSupported)
                                Text(
                                  L10n.of(context).notSupportedOnThisDevice,
                                  style: theme.textTheme.labelSmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            AdaptiveDialogAction(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: false).pop(),
              child: Text(L10n.of(context).cancel),
            ),
            AdaptiveDialogAction(
              onPressed: _send,
              child: Text(L10n.of(context).send),
            ),
          ],
        );
      },
    );
  }
}

enum _EditMode { crop, draw }

/// Full-screen, non-destructive image editor offering crop, 90° rotation and
/// freehand drawing (with eraser and adjustable stroke width).
///
/// The source image is decoded once and never mutated. The crop (a normalized
/// rectangle held by [CropController]), the rotation (quarter turns) and the
/// drawn strokes are kept as lightweight state and only composited into a single
/// full-resolution bitmap when the user saves. Switching between crop and draw
/// is therefore instant and lossless, and the crop can be widened again at any
/// time.
///
/// Returns the edited image bytes (PNG) via [Navigator.pop], or null if the user
/// cancelled or made no changes (in which case the original file is kept).
class _ImageEditPage extends StatefulWidget {
  final Uint8List bytes;

  const _ImageEditPage({required this.bytes});

  @override
  State<_ImageEditPage> createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<_ImageEditPage> {
  static const List<Color> _palette = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.black,
    Colors.white,
  ];

  static const Rect _fullCrop = Rect.fromLTWH(0, 0, 1, 1);

  final CropController _cropController = CropController();

  /// Source image, decoded once at full resolution. Never mutated.
  ui.Image? _image;
  Object? _decodeError;

  _EditMode _mode = _EditMode.crop;

  /// Clockwise quarter turns applied on top of the crop. Kept separate from the
  /// crop controller so the crop rectangle always stays in the un-rotated image
  /// coordinate space, which keeps all stroke math rotation-free.
  int _quarterTurns = 0;

  /// Strokes, stored in source-image pixel coordinates (crop- and
  /// rotation-independent) so they stay anchored to the image content.
  final List<_Stroke> _strokes = [];
  Color _color = Colors.red;
  double _strokeWidth = 4.0;
  bool _eraser = false;
  bool _saving = false;

  /// View transform for the draw surface (two-finger pinch to zoom). Drawing
  /// happens with one finger; two fingers zoom via [InteractiveViewer].
  final TransformationController _drawTransform = TransformationController();

  /// The stroke the current one-finger gesture is drawing, or null when no
  /// stroke is active (e.g. during a two-finger zoom). Held by reference so a
  /// stroke can be fully discarded if the gesture turns into a pinch.
  _Stroke? _activeStroke;

  /// Currently active (touching) pointer ids on the draw surface.
  final Set<int> _pointers = {};

  /// True once a second finger has touched, until all fingers lift again. While
  /// set, drawing is suppressed so a pinch never draws — not at its start and
  /// not when lifting back down to one finger on release.
  bool _multiTouch = false;

  /// Horizontal mirror (flip), applied together with rotation at save time.
  bool _mirror = false;

  @override
  void initState() {
    super.initState();
    _decode();
  }

  @override
  void dispose() {
    _cropController.dispose();
    _drawTransform.dispose();
    // Note: [_image] is intentionally not disposed here. A save may still be
    // rasterizing from it asynchronously when this page is popped; the engine's
    // finalizer reclaims the decoded image once it is no longer referenced.
    super.dispose();
  }

  Future<void> _decode() async {
    try {
      final codec = await ui.instantiateImageCodec(widget.bytes);
      final frame = await codec.getNextFrame();
      if (!mounted) {
        frame.image.dispose();
        return;
      }
      setState(() => _image = frame.image);
    } catch (e, s) {
      Logs().w('Unable to decode image for editing', e, s);
      if (mounted) setState(() => _decodeError = e);
    }
  }

  Rect _cropRectPx(ui.Image image) {
    final c = _cropController.crop;
    return Rect.fromLTRB(
      c.left * image.width,
      c.top * image.height,
      c.right * image.width,
      c.bottom * image.height,
    );
  }

  bool get _hasEdits =>
      _strokes.isNotEmpty ||
      _quarterTurns % 4 != 0 ||
      _mirror ||
      _cropController.crop != _fullCrop;

  void _rotate(int direction) {
    if (_saving) return;
    setState(() => _quarterTurns += direction);
  }

  void _toggleMirror() {
    if (_saving) return;
    setState(() => _mirror = !_mirror);
  }

  /// Returns a horizontally mirrored copy of [image] (lossless, axis-aligned).
  Future<ui.Image> _flippedHorizontally(ui.Image image) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.translate(image.width.toDouble(), 0);
    canvas.scale(-1, 1);
    canvas.drawImage(image, Offset.zero, Paint());
    return recorder.endRecording().toImage(image.width, image.height);
  }

  /// Composites the current edits into a single full-resolution PNG.
  Future<Uint8List?> _compose(ui.Image image) async {
    // 1. Bake strokes onto the full-resolution image (only if there are any).
    var painted = image;
    if (_strokes.isNotEmpty) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(image.width.toDouble(), image.height.toDouble());
      canvas.drawImage(image, Offset.zero, Paint());
      _StrokePainter(
        strokes: _strokes,
        sourceRect: Offset.zero & size,
      ).paint(canvas, size);
      painted = await recorder.endRecording().toImage(
        image.width,
        image.height,
      );
    }

    // 2. Crop (without rotation — the crop rect lives in the un-rotated frame).
    final cropped = await CropController.getCroppedBitmap(
      crop: _cropController.crop,
      rotation: CropRotation.up,
      image: painted,
    );
    if (!identical(painted, image)) painted.dispose();

    // 3. Mirror, then rotation — both lossless and in the same order as the
    //    on-screen preview (flip inside, rotation outside).
    var staged = cropped;
    if (_mirror) {
      staged = await _flippedHorizontally(cropped);
      cropped.dispose();
    }

    final rotation = imageEditorRotationForQuarterTurns(_quarterTurns);
    var output = staged;
    if (rotation != CropRotation.up) {
      output = await CropController.getCroppedBitmap(
        crop: _fullCrop,
        rotation: rotation,
        image: staged,
      );
      staged.dispose();
    }

    // 4. Encode to PNG.
    final data = await output.toByteData(format: ui.ImageByteFormat.png);
    output.dispose();
    return data?.buffer.asUint8List();
  }

  Future<void> _save() async {
    if (_saving) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final image = _image;
    // Nothing was changed: keep the original file untouched (pop with null).
    if (image == null || !_hasEdits) {
      navigator.pop();
      return;
    }
    setState(() => _saving = true);
    try {
      final result = await _compose(image);
      if (!mounted) return;
      navigator.pop(result);
    } catch (e, s) {
      Logs().w('Unable to save edited image', e, s);
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editImage),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              tooltip: l10n.save,
              icon: const Icon(Icons.check),
              onPressed: _image == null ? null : _save,
            ),
        ],
        bottom: _image == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SegmentedButton<_EditMode>(
                    segments: [
                      ButtonSegment(
                        value: _EditMode.crop,
                        icon: const Icon(Icons.crop),
                        label: Text(l10n.crop),
                      ),
                      ButtonSegment(
                        value: _EditMode.draw,
                        icon: const Icon(Icons.brush_outlined),
                        label: Text(l10n.draw),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: _saving
                        ? null
                        : (s) => setState(() {
                            _mode = s.first;
                            // Start each draw session at the un-zoomed fit.
                            _drawTransform.value = Matrix4.identity();
                            _activeStroke = null;
                            _pointers.clear();
                            _multiTouch = false;
                          }),
                  ),
                ),
              ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_decodeError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.broken_image_outlined, size: 64),
              const SizedBox(height: 16),
              Text(L10n.of(context).oopsSomethingWentWrong),
            ],
          ),
        ),
      );
    }
    final image = _image;
    if (image == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return Column(
      children: [
        Expanded(
          // Inset from the screen edges so dragging crop handles / drawing near
          // the border doesn't trigger the system back-swipe gesture.
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: RotatedBox(
              quarterTurns: _quarterTurns,
              child: Transform.flip(
                flipX: _mirror,
                child: _mode == _EditMode.crop
                    ? _buildCrop(image)
                    : _buildDraw(image),
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: _mode == _EditMode.crop
              ? _buildCropTools()
              : _buildDrawTools(),
        ),
      ],
    );
  }

  Widget _buildCrop(ui.Image image) {
    return CropImage(
      controller: _cropController,
      // Decode a separate image from the original bytes for the crop widget.
      // Sharing our [_image] via UiImageProvider is unsafe: when CropImage is
      // unmounted (switching to draw), its Image widget disposes the underlying
      // ui.Image — which would be our [_image], breaking draw mode and save.
      image: Image.memory(widget.bytes),
      overlayPainter: _strokes.isEmpty
          ? null
          : _StrokePainter(
              strokes: _strokes,
              sourceRect:
                  Offset.zero &
                  Size(image.width.toDouble(), image.height.toDouble()),
            ),
    );
  }

  Widget _buildDraw(ui.Image image) {
    final cropPx = _cropRectPx(image);
    return Center(
      child: AspectRatio(
        aspectRatio: cropPx.width / cropPx.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            // Map a pointer position (viewport pixels) to source-image pixels,
            // going through the current zoom transform first.
            Offset toImagePx(Offset viewportPoint) => imageEditorLocalToImagePx(
              _drawTransform.toScene(viewportPoint),
              size,
              cropPx,
            );
            // Drawing is driven from raw pointer events (not InteractiveViewer's
            // gesture phases) so the real finger count decides draw vs. zoom.
            // The Listener is passive: it never enters the gesture arena, so
            // InteractiveViewer below still handles the two-finger pinch.
            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (e) {
                _pointers.add(e.pointer);
                if (_pointers.length >= 2) {
                  // A pinch: this gesture is a zoom. Drop any stroke it started
                  // and block drawing until every finger has lifted again.
                  _multiTouch = true;
                  final active = _activeStroke;
                  if (active != null) {
                    setState(() {
                      _strokes.remove(active);
                      _activeStroke = null;
                    });
                  }
                  return;
                }
                if (_multiTouch) return;
                final stroke = _Stroke(
                  color: _color,
                  width: _strokeWidth * (cropPx.width / size.width),
                  eraser: _eraser,
                  points: [toImagePx(e.localPosition)],
                );
                setState(() {
                  _activeStroke = stroke;
                  _strokes.add(stroke);
                });
              },
              onPointerMove: (e) {
                final active = _activeStroke;
                if (active == null || _multiTouch || _pointers.length != 1) {
                  return;
                }
                setState(() => active.points.add(toImagePx(e.localPosition)));
              },
              onPointerUp: (e) => _endPointer(e.pointer),
              onPointerCancel: (e) => _endPointer(e.pointer),
              child: InteractiveViewer(
                transformationController: _drawTransform,
                // One finger draws (via the Listener); two fingers pinch-zoom.
                panEnabled: false,
                minScale: 1,
                maxScale: 8,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: _CroppedImagePainter(
                        image: image,
                        sourceRect: cropPx,
                      ),
                    ),
                    CustomPaint(
                      painter: _StrokePainter(
                        strokes: _strokes,
                        sourceRect: cropPx,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Removes a lifted pointer. Once all fingers are up, the multi-touch lock is
  /// released so a fresh single touch can draw again.
  void _endPointer(int pointer) {
    _pointers.remove(pointer);
    if (_pointers.isEmpty) {
      _multiTouch = false;
      _activeStroke = null;
    }
  }

  Widget _buildCropTools() {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: l10n.rotateLeft,
            icon: const Icon(Icons.rotate_left),
            onPressed: () => _rotate(-1),
          ),
          IconButton(
            tooltip: l10n.rotateRight,
            icon: const Icon(Icons.rotate_right),
            onPressed: () => _rotate(1),
          ),
          IconButton(
            tooltip: l10n.mirror,
            isSelected: _mirror,
            icon: const Icon(Icons.flip),
            onPressed: _toggleMirror,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawTools() {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.draw,
              isSelected: !_eraser,
              icon: const Icon(Icons.brush_outlined),
              selectedIcon: const Icon(Icons.brush),
              onPressed: () => setState(() => _eraser = false),
            ),
            IconButton(
              tooltip: l10n.eraser,
              isSelected: _eraser,
              icon: const Icon(Icons.cleaning_services_outlined),
              selectedIcon: const Icon(Icons.cleaning_services),
              onPressed: () => setState(() => _eraser = true),
            ),
            Expanded(
              child: Slider(
                min: 1,
                max: 30,
                value: _strokeWidth,
                onChanged: (v) => setState(() => _strokeWidth = v),
              ),
            ),
            IconButton(
              tooltip: l10n.undo,
              icon: const Icon(Icons.undo),
              onPressed: _strokes.isEmpty
                  ? null
                  : () => setState(_strokes.removeLast),
            ),
            IconButton(
              tooltip: l10n.clear,
              icon: const Icon(Icons.delete_outline),
              onPressed: _strokes.isEmpty
                  ? null
                  : () => setState(_strokes.clear),
            ),
          ],
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: [
              for (final color in _palette)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _color = color;
                      _eraser = false;
                    }),
                    child: Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: !_eraser && _color == color
                              ? theme.colorScheme.primary
                              : Colors.grey,
                          width: !_eraser && _color == color ? 3 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stroke {
  final Color color;

  /// Stroke width, in source-image pixels.
  final double width;
  final bool eraser;

  /// Points, in source-image pixel coordinates.
  final List<Offset> points;

  _Stroke({
    required this.color,
    required this.width,
    required this.eraser,
    required this.points,
  });
}

/// Paints the [sourceRect] region (in image pixels) of [image] to fill the
/// canvas. Only repaints when the image or the crop changes, so freehand
/// drawing doesn't continuously re-rasterize the background.
class _CroppedImagePainter extends CustomPainter {
  final ui.Image image;
  final Rect sourceRect;

  const _CroppedImagePainter({required this.image, required this.sourceRect});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      sourceRect,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _CroppedImagePainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.sourceRect != sourceRect;
}

/// Paints freehand [strokes] (stored in source-image pixel coordinates) onto a
/// canvas that shows the image region [sourceRect] scaled to fill the canvas.
class _StrokePainter extends CustomPainter {
  final List<_Stroke> strokes;
  final Rect sourceRect;

  const _StrokePainter({required this.strokes, required this.sourceRect});

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty) return;
    final scale = size.width / sourceRect.width;
    // saveLayer so eraser strokes (BlendMode.clear) only erase prior strokes
    // within this layer, not whatever is painted below it.
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.translate(-sourceRect.left * scale, -sourceRect.top * scale);
    canvas.scale(scale);
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (stroke.eraser) {
        paint
          ..color = const Color(0xFF000000)
          ..blendMode = BlendMode.clear;
      } else {
        paint.color = stroke.color;
      }
      // A single point (a tap) renders as a dot.
      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first,
          stroke.width / 2,
          Paint()
            ..color = paint.color
            ..blendMode = paint.blendMode
            ..style = PaintingStyle.fill,
        );
        continue;
      }
      final path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (final p in stroke.points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) => true;
}
