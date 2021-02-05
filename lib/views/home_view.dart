import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/views/home_view_parts/discover.dart';
import 'package:fluffychat/views/share_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../components/matrix.dart';
import '../utils/matrix_file_extension.dart';
import '../utils/url_launcher.dart';
import 'home_view_parts/chat_list.dart';
import 'home_view_parts/settings.dart';
import 'home_view_parts/contact_list.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum SelectMode { normal, share, select }

class HomeView extends StatefulWidget {
  final String activeChat;

  const HomeView({this.activeChat, Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  void initState() {
    _initReceiveSharingIntent();
    _pageController = TabController(length: 4, vsync: this, initialIndex: 1);
    _pageController.addListener(_updateCurrentIndex);
    super.initState();
  }

  void _updateCurrentIndex() =>
      setState(() => currentIndex = _pageController.index);

  int currentIndex = 1;

  StreamSubscription _intentDataStreamSubscription;

  StreamSubscription _intentFileStreamSubscription;

  StreamSubscription _onShareContentChanged;

  AppBar appBar;

  TabController _pageController;

  void _onShare(Map<String, dynamic> content) {
    if (content != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShareView(),
          ),
        ),
      );
    }
  }

  void _processIncomingSharedFiles(List<SharedMediaFile> files) {
    if (files?.isEmpty ?? true) return;
    AdaptivePageLayout.of(context).popUntilIsFirst();
    final file = File(files.first.path);

    Matrix.of(context).shareContent = {
      'msgtype': 'chat.fluffy.shared_file',
      'file': MatrixFile(
        bytes: file.readAsBytesSync(),
        name: file.path,
      ).detectFileType,
    };
  }

  void _processIncomingSharedText(String text) {
    if (text == null) return;
    AdaptivePageLayout.of(context).popUntilIsFirst();
    if (text.toLowerCase().startsWith(AppConfig.inviteLinkPrefix) ||
        (text.toLowerCase().startsWith(AppConfig.schemePrefix) &&
            !RegExp(r'\s').hasMatch(text))) {
      UrlLauncher(context, text).openMatrixToUrl();
      return;
    }
    Matrix.of(context).shareContent = {
      'msgtype': 'm.text',
      'body': text,
    };
  }

  void _initReceiveSharingIntent() {
    if (!PlatformInfos.isMobile) return;

    // For sharing images coming from outside the app while the app is in the memory
    _intentFileStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen(_processIncomingSharedFiles, onError: print);

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then(_processIncomingSharedFiles);

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream()
        .listen(_processIncomingSharedText, onError: print);

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then(_processIncomingSharedText);
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentFileStreamSubscription?.cancel();
    _pageController.removeListener(_updateCurrentIndex);
    super.dispose();
  }

  String _server;

  void _setServer(BuildContext context) async {
    final newServer = await showTextInputDialog(
        title: L10n.of(context).changeTheHomeserver,
        context: context,
        textFields: [
          DialogTextField(
            prefixText: 'https://',
            hintText: Matrix.of(context).client.homeserver.host,
            initialText: _server,
            keyboardType: TextInputType.url,
          )
        ]);
    if (newServer == null) return;
    setState(() {
      _server = newServer.single;
    });
  }

  void _setStatus() async {
    final input = await showTextInputDialog(
        context: context,
        title: L10n.of(context).setStatus,
        textFields: [
          DialogTextField(
            hintText: L10n.of(context).statusExampleMessage,
          ),
        ]);
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.sendPresence(
            Matrix.of(context).client.userID,
            PresenceType.online,
            statusMsg: input.single,
          ),
    );
  }

  void _onFabTab() {
    switch (currentIndex) {
      case 0:
        _setStatus();
        break;
      case 1:
        AdaptivePageLayout.of(context)
            .pushNamedAndRemoveUntilIsFirst('/newprivatechat');
        break;
      case 2:
        _setServer(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _onShareContentChanged ??=
        Matrix.of(context).onShareContentChanged.stream.listen(_onShare);
    IconData fabIcon;
    switch (currentIndex) {
      case 0:
        fabIcon = Icons.edit_outlined;
        break;
      case 1:
        fabIcon = Icons.add_outlined;
        break;
      case 2:
        fabIcon = Icons.domain_outlined;
        break;
    }

    return Scaffold(
      appBar: appBar ??
          AppBar(
              centerTitle: false,
              actions: [
                PopupMenuButton(
                  onSelected: (action) {
                    switch (action) {
                      case 'invite':
                        FluffyShare.share(
                            L10n.of(context).inviteText(
                                Matrix.of(context).client.userID,
                                'https://matrix.to/#/${Matrix.of(context).client.userID}'),
                            context);
                        break;
                      case 'archive':
                        AdaptivePageLayout.of(context).pushNamed('/archive');
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'invite',
                      child: Text(L10n.of(context).inviteContact),
                    ),
                    PopupMenuItem(
                      value: 'archive',
                      child: Text(L10n.of(context).archive),
                    ),
                  ],
                ),
              ],
              title: Text(AppConfig.applicationName)),
      body: TabBarView(
        controller: _pageController,
        children: [
          ContactList(),
          ChatList(
            onCustomAppBar: (appBar) => setState(() => this.appBar = appBar),
          ),
          Discover(server: _server),
          Settings(),
        ],
      ),
      floatingActionButton: fabIcon == null
          ? null
          : FloatingActionButton(
              child: Icon(fabIcon),
              onPressed: _onFabTab,
              foregroundColor:
                  currentIndex == 2 ? Theme.of(context).accentColor : null,
              backgroundColor: currentIndex == 2
                  ? Theme.of(context).scaffoldBackgroundColor
                  : null,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).textTheme.bodyText1.color,
        currentIndex: currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        backgroundColor: Theme.of(context).appBarTheme.color,
        onTap: (i) {
          _pageController.animateTo(i);
          setState(() => currentIndex = i);
        },
        items: [
          BottomNavigationBarItem(
            label: L10n.of(context).contacts,
            icon: Icon(Icons.people_outlined),
          ),
          BottomNavigationBarItem(
            label: L10n.of(context).messages,
            icon: Icon(CupertinoIcons.chat_bubble_2),
          ),
          BottomNavigationBarItem(
            label: L10n.of(context).discover,
            icon: Icon(CupertinoIcons.search_circle),
          ),
          BottomNavigationBarItem(
            label: L10n.of(context).settings,
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
    );
  }
}
