import 'package:flutter/material.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/matrix_api.dart';
import 'chat_list.dart';
import '../components/adaptive_page_layout.dart';
import '../components/avatar.dart';
import '../components/dialogs/simple_dialogs.dart';
import '../l10n/l10n.dart';

class KeyVerificationView extends StatelessWidget {
  final KeyVerification request;

  KeyVerificationView({this.request});

  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: KeyVerificationPage(request: request),
    );
  }
}

class KeyVerificationPage extends StatefulWidget {
  final KeyVerification request;

  KeyVerificationPage({this.request});

  @override
  _KeyVerificationPageState createState() => _KeyVerificationPageState();
}

class _KeyVerificationPageState extends State<KeyVerificationPage> {
  void Function() originalOnUpdate;

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
          if (input == null) {
            return;
          }
          SimpleDialogs(context).showLoadingDialog(context);
          // make sure the loading spinner shows before we test the keys
          await Future.delayed(Duration(milliseconds: 100));
          var valid = false;
          try {
            await widget.request.openSSSS(recoveryKey: input);
            valid = true;
          } catch (_) {
            try {
              await widget.request.openSSSS(passphrase: input);
              valid = true;
            } catch (_) {
              valid = false;
            }
          }
          await Navigator.of(context)?.pop();
          if (!valid) {
            await SimpleDialogs(context).inform(
              contentText: L10n.of(context).incorrectPassphraseOrKey,
            );
          }
        };
        body = Container(
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
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
            mainAxisSize: MainAxisSize.min,
          ),
        );
        buttons.add(RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 5,
          textColor: Colors.white,
          child: Text(L10n.of(context).submit),
          onPressed: () {
            input = textEditingController.text;
            checkInput();
          },
        ));
        buttons.add(RaisedButton(
          textColor: Theme.of(context).primaryColor,
          elevation: 5,
          color: Colors.white,
          child: Text(L10n.of(context).skip),
          onPressed: () => widget.request.openSSSS(skip: true),
        ));
        break;
      case KeyVerificationState.askAccept:
        body = Container(
          child: Text(
              L10n.of(context).askVerificationRequest(widget.request.userId),
              style: TextStyle(fontSize: 20)),
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
        );
        buttons.add(RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 5,
          textColor: Colors.white,
          child: Text(L10n.of(context).accept),
          onPressed: () => widget.request.acceptVerification(),
        ));
        buttons.add(RaisedButton(
          textColor: Theme.of(context).primaryColor,
          elevation: 5,
          color: Colors.white,
          child: Text(L10n.of(context).reject),
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
            CircularProgressIndicator(),
            Container(height: 10),
            Text(L10n.of(context).waitingPartnerAcceptRequest),
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
          children: <Widget>[
            Container(
              child: Text(compareText, style: TextStyle(fontSize: 20)),
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
            ),
            Container(height: 10),
            Text.rich(
              compareWidget,
              textAlign: TextAlign.center,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 5,
          textColor: Colors.white,
          child: Text(L10n.of(context).theyMatch),
          onPressed: () => widget.request.acceptSas(),
        ));
        buttons.add(RaisedButton(
          textColor: Theme.of(context).primaryColor,
          elevation: 5,
          color: Colors.white,
          child: Text(L10n.of(context).theyDontMatch),
          onPressed: () => widget.request.rejectSas(),
        ));
        break;
      case KeyVerificationState.waitingSas:
        var acceptText = widget.request.sasTypes.contains('emoji')
            ? L10n.of(context).waitingPartnerEmoji
            : L10n.of(context).waitingPartnerNumbers;
        body = Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Container(height: 10),
            Text(acceptText),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        break;
      case KeyVerificationState.done:
        body = Column(
          children: <Widget>[
            Icon(Icons.check_circle, color: Colors.green, size: 200.0),
            Container(height: 10),
            Text(L10n.of(context).verifySuccess),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 5,
          textColor: Colors.white,
          child: Text(L10n.of(context).close),
          onPressed: () => Navigator.of(context).pop(),
        ));
        break;
      case KeyVerificationState.error:
        body = Column(
          children: <Widget>[
            Icon(Icons.cancel, color: Colors.red, size: 200.0),
            Container(height: 10),
            Text(
                'Error ${widget.request.canceledCode}: ${widget.request.canceledReason}'),
          ],
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 5,
          textColor: Colors.white,
          child: Text(L10n.of(context).close),
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
      bottom = PreferredSize(
        child: Text('$deviceName (${widget.request.deviceId})',
            style: TextStyle(color: Theme.of(context).textTheme.caption.color)),
        preferredSize: Size(0.0, 20.0),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: Avatar(profile?.avatarUrl, otherName),
          contentPadding: EdgeInsets.zero,
          title: Text(L10n.of(context).verifyTitle),
          isThreeLine: otherName != widget.request.userId,
          subtitle: Column(
            children: <Widget>[
              Text(otherName),
              if (otherName != widget.request.userId)
                Text(widget.request.userId),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        elevation: 0,
        bottom: bottom,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: body,
      ),
      persistentFooterButtons: buttons.isEmpty ? null : buttons,
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
