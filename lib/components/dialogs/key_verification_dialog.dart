import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'adaptive_flat_button.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../../utils/string_color.dart';

class KeyVerificationDialog extends StatefulWidget {
  Future<void> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  final KeyVerification request;

  final L10n l10n;

  KeyVerificationDialog({
    this.request,
    @required this.l10n,
  });

  @override
  _KeyVerificationPageState createState() => _KeyVerificationPageState();
}

class _KeyVerificationPageState extends State<KeyVerificationDialog> {
  void Function() originalOnUpdate;
  final _scrollController = ScrollController();

  @override
  void initState() {
    originalOnUpdate = widget.request.onUpdate;
    widget.request.onUpdate = () {
      if (originalOnUpdate != null) {
        originalOnUpdate();
      }
      setState(() => null);
    };
    widget.request.client.getProfileFromUserId(widget.request.userId).then((p) {
      profile = p;
      setState(() => null);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.request.onUpdate =
        originalOnUpdate; // don't want to get updates anymore
    if (![KeyVerificationState.error, KeyVerificationState.done]
        .contains(widget.request.state)) {
      widget.request.cancel('m.user');
    }
    _scrollController.dispose();
    super.dispose();
  }

  Profile profile;

  @override
  Widget build(BuildContext context) {
    Widget body;
    final buttons = <Widget>[];
    switch (widget.request.state) {
      case KeyVerificationState.askSSSS:
        // prompt the user for their ssss passphrase / key
        final textEditingController = TextEditingController();
        String input;
        final checkInput = () async {
          if (input == null || input.isEmpty) {
            return;
          }
          final valid = await showFutureLoadingDialog(
              context: context,
              future: () async {
                // make sure the loading spinner shows before we test the keys
                await Future.delayed(Duration(milliseconds: 100));
                var valid = false;
                try {
                  await widget.request.openSSSS(keyOrPassphrase: input);
                  valid = true;
                } catch (_) {
                  valid = false;
                }
                return valid;
              });
          if (valid.error != null) {
            await showOkAlertDialog(
              context: context,
              message: widget.l10n.incorrectPassphraseOrKey,
            );
          }
        };
        body = Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              Text(widget.l10n.askSSSSSign, style: TextStyle(fontSize: 20)),
              Container(height: 10),
              TextField(
                controller: textEditingController,
                autofocus: false,
                autocorrect: false,
                onSubmitted: (s) {
                  input = s;
                  checkInput();
                },
                minLines: 1,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: widget.l10n.passphraseOrKey,
                  prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
                  suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.submit),
          onPressed: () {
            input = textEditingController.text;
            checkInput();
          },
        ));
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.skip),
          onPressed: () => widget.request.openSSSS(skip: true),
        ));
        break;
      case KeyVerificationState.askAccept:
        body = Container(
          child: Text(widget.l10n.askVerificationRequest(widget.request.userId),
              style: TextStyle(fontSize: 20)),
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.accept),
          onPressed: () => widget.request.acceptVerification(),
        ));
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.reject),
          onPressed: () {
            widget.request.rejectVerification().then((_) {
              Navigator.of(context).pop();
            });
          },
        ));
        break;
      case KeyVerificationState.waitingAccept:
        body = Column(
          children: <Widget>[
            PlatformInfos.isCupertinoStyle
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              widget.l10n.waitingPartnerAcceptRequest,
              textAlign: TextAlign.center,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        break;
      case KeyVerificationState.askSas:
        TextSpan compareWidget;
        // maybe add a button to switch between the two and only determine default
        // view for if "emoji" is a present sasType or not?
        String compareText;
        if (widget.request.sasTypes.contains('emoji')) {
          compareText = widget.l10n.compareEmojiMatch;
          compareWidget = TextSpan(
            children: widget.request.sasEmojis
                .map((e) => WidgetSpan(child: _Emoji(e)))
                .toList(),
          );
        } else {
          compareText = widget.l10n.compareNumbersMatch;
          final numbers = widget.request.sasNumbers;
          final numbstr = '${numbers[0]}-${numbers[1]}-${numbers[2]}';
          compareWidget =
              TextSpan(text: numbstr, style: TextStyle(fontSize: 40));
        }
        body = Column(
          children: <Widget>[
            Center(
              child: Text(
                compareText,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Text.rich(
              compareWidget,
              textAlign: TextAlign.center,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(AdaptiveFlatButton(
          textColor: Colors.red,
          child: Text(widget.l10n.theyDontMatch),
          onPressed: () => widget.request.rejectSas(),
        ));
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.theyMatch),
          onPressed: () => widget.request.acceptSas(),
        ));
        break;
      case KeyVerificationState.waitingSas:
        var acceptText = widget.request.sasTypes.contains('emoji')
            ? widget.l10n.waitingPartnerEmoji
            : widget.l10n.waitingPartnerNumbers;
        body = Column(
          children: <Widget>[
            PlatformInfos.isCupertinoStyle
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              acceptText,
              textAlign: TextAlign.center,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        break;
      case KeyVerificationState.done:
        body = Column(
          children: <Widget>[
            Icon(Icons.check_circle_outlined, color: Colors.green, size: 200.0),
            SizedBox(height: 10),
            Text(
              widget.l10n.verifySuccess,
              textAlign: TextAlign.center,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(widget.l10n.close),
          onPressed: () => Navigator.of(context).pop(),
        ));
        break;
      case KeyVerificationState.error:
        body = Column(
          children: <Widget>[
            Icon(Icons.cancel, color: Colors.red, size: 200.0),
            SizedBox(height: 10),
            Text(
              'Error ${widget.request.canceledCode}: ${widget.request.canceledReason}',
              textAlign: TextAlign.center,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(FlatButton(
          child: Text(widget.l10n.close),
          onPressed: () => Navigator.of(context).pop(),
        ));
        break;
    }
    body ??= Text('ERROR: Unknown state ' + widget.request.state.toString());
    final otherName = profile?.displayname ?? widget.request.userId;
    var bottom;
    if (widget.request.deviceId != null) {
      final deviceName = widget
              .request
              .client
              .userDeviceKeys[widget.request.userId]
              ?.deviceKeys[widget.request.deviceId]
              ?.deviceDisplayName ??
          '';
      bottom = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text('$deviceName (${widget.request.deviceId})',
            style: TextStyle(color: Theme.of(context).textTheme.caption.color)),
      );
    }
    final userNameTitle = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          otherName,
          maxLines: 1,
          style: TextStyle(
            color: otherName.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (otherName != widget.request.userId)
          Text(
            ' - ' + widget.request.userId,
            maxLines: 1,
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
    final title = Text(widget.l10n.verifyTitle);
    final content = Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (PlatformInfos.isCupertinoStyle) ...[
              SizedBox(height: 8),
              Center(child: userNameTitle),
              SizedBox(height: 12),
            ],
            body,
            if (bottom != null) bottom,
          ],
        ),
      ),
    );
    if (PlatformInfos.isCupertinoStyle) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: buttons,
      );
    }
    return AlertDialog(
      title: title,
      content: content,
      actions: buttons,
    );
  }
}

class _Emoji extends StatelessWidget {
  final KeyVerificationEmoji emoji;

  _Emoji(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(emoji.emoji, style: TextStyle(fontSize: 50)),
        Text(emoji.name),
        Container(height: 10, width: 5),
      ],
    );
  }
}
