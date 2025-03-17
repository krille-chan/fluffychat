import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/toolbar/utils/shrinkable_text.dart';

class VocabAnalyticsListTile extends StatefulWidget {
  const VocabAnalyticsListTile({
    super.key,
    required this.constructUse,
    required this.onTap,
  });

  final void Function() onTap;
  final ConstructUses constructUse;

  @override
  VocabAnalyticsListTileState createState() => VocabAnalyticsListTileState();
}

class VocabAnalyticsListTileState extends State<VocabAnalyticsListTile> {
  bool _isHovered = false;

  final double maxWidth = 100;
  final double padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: widget.onTap,
        child: Container(
          height: maxWidth,
          width: maxWidth,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.constructUse.constructLevel
                    .color(context)
                    .withAlpha(20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: (maxWidth - padding * 2) * 0.6,
                child: Opacity(
                  opacity:
                      widget.constructUse.id.userSetEmoji == null ? 0.2 : 1,
                  child: widget.constructUse.id.userSetEmoji != null
                      ? Text(
                          widget.constructUse.id.userSetEmoji!,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        )
                      : widget.constructUse.constructLevel.icon(36.0),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 4),
                height: (maxWidth - padding * 2) * 0.4,
                child: ShrinkableText(
                  text: widget.constructUse.lemma,
                  maxWidth: maxWidth - padding * 2,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.light
                        ? widget.constructUse.constructLevel.darkColor(context)
                        : widget.constructUse.constructLevel.color(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
