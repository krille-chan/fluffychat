import 'dart:math';

import 'package:tawkie/pages/chat_list/add_chat_network.dart';
import 'package:flutter/material.dart';
import 'package:tawkie/utils/platform_infos.dart';

class EmptyPage extends StatelessWidget {
  static const double _width = 400;
  const EmptyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyPage._width) / 2;
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: 'info-logo',
              child: Image.asset(
                'assets/favicon.png',
                width: width,
                height: width,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
          if (loading)
            Center(
              child: SizedBox(
                width: width,
                child: const LinearProgressIndicator(),
              ),
            ),

          // Button for add bridge when no conversation
          if (PlatformInfos.isWeb ||
              PlatformInfos.isDesktop ||
              PlatformInfos.isLinux ||
              PlatformInfos.isMacOS)
            const AddChatNetwork(),
        ],
      ),
    );
  }
}
