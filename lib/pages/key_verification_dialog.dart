import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../widgets/adaptive_flat_button.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../utils/string_color.dart';
import '../utils/beautify_string_extension.dart';

class KeyVerificationDialog extends StatefulWidget {
  Future<void> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => this,
          useRootNavigator: false,
        )
      : showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => this,
          useRootNavigator: false,
        );

  final KeyVerification request;

  KeyVerificationDialog({
    this.request,
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
              message: L10n.of(context).incorrectPassphraseOrKey,
              useRootNavigator: false,
            );
          }
        };
        body = Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(L10n.of(context).askSSSSSign,
                  style: TextStyle(fontSize: 20)),
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
                  hintText: L10n.of(context).passphraseOrKey,
                  prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
                  suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );
        buttons.add(AdaptiveFlatButton(
          label: L10n.of(context).submit,
          onPressed: () {
            input = textEditingController.text;
            checkInput();
          },
        ));
        buttons.add(AdaptiveFlatButton(
          label: L10n.of(context).skip,
          onPressed: () => widget.request.openSSSS(skip: true),
        ));
        break;
      case KeyVerificationState.askAccept:
        body = Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
              L10n.of(context).askVerificationRequest(widget.request.userId),
              style: TextStyle(fontSize: 20)),
        );
        buttons.add(AdaptiveFlatButton(
          label: L10n.of(context).accept,
          onPressed: () => widget.request.acceptVerification(),
        ));
        buttons.add(AdaptiveFlatButton(
          label: L10n.of(context).reject,
          onPressed: () {
            widget.request.rejectVerification().then((_) {
              Navigator.of(context, rootNavigator: false).pop();
            });
          },
        ));
        break;
      case KeyVerificationState.waitingAccept:
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PlatformInfos.isCupertinoStyle
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              L10n.of(context).waitingPartnerAcceptRequest,
              textAlign: TextAlign.center,
            ),
          ],
        );
        final key = widget.request.client.userDeviceKeys[widget.request.userId]
            .deviceKeys[widget.request.deviceId];
        if (key != null) {
          buttons.add(AdaptiveFlatButton(
            label: L10n.of(context).verifyManual,
            onPressed: () async {
              final result = await showOkCancelAlertDialog(
                context: context,
                useRootNavigator: false,
                title: L10n.of(context).verifyManual,
                message: key.ed25519Key.beautified,
              );
              if (result == OkCancelResult.ok) {
                await key.setVerified(true);
              }
              await widget.request.cancel();
              Navigator.of(context, rootNavigator: false).pop();
            },
          ));
        }

        break;
      case KeyVerificationState.askSas:
        TextSpan compareWidget;
        // maybe add a button to switch between the two and only determine default
        // view for if "emoji" is a present sasType or not?
        String compareText;
        if (widget.request.sasTypes.contains('emoji')) {
          compareText = L10n.of(context).compareEmojiMatch;
          compareWidget = TextSpan(
            children: widget.request.sasEmojis
                .map((e) => WidgetSpan(child: _Emoji(e)))
                .toList(),
          );
        } else {
          compareText = L10n.of(context).compareNumbersMatch;
          final numbers = widget.request.sasNumbers;
          final numbstr = '${numbers[0]}-${numbers[1]}-${numbers[2]}';
          compareWidget =
              TextSpan(text: numbstr, style: TextStyle(fontSize: 40));
        }
        body = Column(
          mainAxisSize: MainAxisSize.min,
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
        );
        buttons.add(AdaptiveFlatButton(
          textColor: Colors.red,
          label: L10n.of(context).theyDontMatch,
          onPressed: () => widget.request.rejectSas(),
        ));
        buttons.add(AdaptiveFlatButton(
          label: L10n.of(context).theyMatch,
          onPressed: () => widget.request.acceptSas(),
        ));
        break;
      case KeyVerificationState.waitingSas:
        final acceptText = widget.request.sasTypes.contains('emoji')
            ? L10n.of(context).waitingPartnerEmoji
            : L10n.of(context).waitingPartnerNumbers;
        body = Column(
          mainAxisSize: MainAxisSize.min,
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
        );
        break;
      case KeyVerificationState.done:
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check_circle_outlined, color: Colors.green, size: 200.0),
            SizedBox(height: 10),
            Text(
              L10n.of(context).verifySuccess,
              textAlign: TextAlign.center,
            ),
          ],
        );
        buttons.add(AdaptiveFlatButton(
          label: L10n.of(context).close,
          onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
        ));
        break;
      case KeyVerificationState.error:
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.cancel, color: Colors.red, size: 200.0),
            SizedBox(height: 10),
            Text(
              'Error ${widget.request.canceledCode}: ${widget.request.canceledReason}',
              textAlign: TextAlign.center,
            ),
          ],
        );
        buttons.add(AdaptiveFlatButton(
          label: L10n.of(context).close,
          onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
    final title = Text(L10n.of(context).verifyTitle);
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
