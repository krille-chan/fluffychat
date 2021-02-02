import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/string_color.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SetStatusView extends StatefulWidget {
  final String initialText;

  const SetStatusView({Key key, this.initialText}) : super(key: key);

  @override
  _SetStatusViewState createState() => _SetStatusViewState();
}

class _SetStatusViewState extends State<SetStatusView> {
  Color _color;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
  }

  void _setStatusAction(BuildContext context, [String message]) async {
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.sendPresence(
            Matrix.of(context).client.userID,
            PresenceType.online,
            statusMsg: message ?? _controller.text,
          ),
    );
    if (result.error == null) AdaptivePageLayout.of(context).pop();
  }

  void _setCameraImageStatusAction(BuildContext context) async {
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    }
    final uploadResp = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.upload(file.bytes, file.name),
    );
    if (uploadResp.error == null) {
      return _setStatusAction(context, uploadResp.result);
    }
  }

  void _setImageStatusAction(BuildContext context) async {
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName,
      );
    }
    final uploadResp = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.upload(file.bytes, file.name),
    );
    if (uploadResp.error == null) {
      return _setStatusAction(context, uploadResp.result);
    }
  }

  @override
  Widget build(BuildContext context) {
    _color ??= Theme.of(context).primaryColor;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        title: Text(L10n.of(context).statusExampleMessage),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outlined),
            onPressed: () => showOkAlertDialog(
              context: context,
              title: L10n.of(context).setStatus,
              message:
                  'Show your status to all users you share a room. Every status will replace the previous one. Be aware that statuses are public and therefore not end-to-end encrypted.',
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        alignment: Alignment.center,
        color: _color,
        child: SingleChildScrollView(
          child: TextField(
            minLines: 1,
            maxLines: 10,
            autofocus: true,
            textAlign: TextAlign.center,
            controller: _controller,
            onChanged: (s) => setState(() => _color = s.color),
            style: TextStyle(fontSize: 40, color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (PlatformInfos.isMobile) ...{
            FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.camera_alt_outlined),
              onPressed: () => _setCameraImageStatusAction(context),
            ),
            SizedBox(height: 12),
          },
          FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.image_outlined),
            onPressed: () => _setImageStatusAction(context),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            child: Icon(Icons.send_outlined),
            onPressed: () => _setStatusAction(context),
          ),
        ],
      ),
    );
  }
}
