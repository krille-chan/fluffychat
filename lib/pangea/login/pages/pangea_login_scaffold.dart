import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class PangeaLoginScaffold extends StatelessWidget {
  final String mainAssetPath;
  final Uint8List? mainAssetBytes;
  final Uri? mainAssetUrl;
  final List<Widget> children;
  final bool showAppName;
  final AppBar? customAppBar;
  final List<Widget>? actions;

  const PangeaLoginScaffold({
    required this.children,
    this.mainAssetPath = "assets/pangea/PangeaChat_Glow_Logo.png",
    this.mainAssetBytes,
    this.mainAssetUrl,
    this.showAppName = true,
    this.customAppBar,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar ??
            AppBar(
              toolbarHeight: isColumnMode ? null : 40.0,
              actions: actions,
            ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: isColumnMode ? 175 : 125,
                          height: isColumnMode ? 175 : 125,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: ClipOval(
                            child: mainAssetBytes != null
                                ? Image.memory(
                                    mainAssetBytes!,
                                    fit: BoxFit.cover,
                                  )
                                : mainAssetUrl != null
                                    ? mainAssetUrl!.toString().startsWith("mxc")
                                        ? MxcImage(
                                            uri: mainAssetUrl,
                                            fit: BoxFit.cover,
                                            width: isColumnMode ? 175 : 125,
                                            height: isColumnMode ? 175 : 125,
                                          )
                                        : Image.network(
                                            mainAssetUrl.toString(),
                                            fit: BoxFit.cover,
                                          )
                                    : Image.asset(
                                        mainAssetPath,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        if (showAppName)
                          Text(
                            AppConfig.applicationName,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        const SizedBox(height: 12),
                        ...children,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
