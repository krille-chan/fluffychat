import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';

class MessageMorphChoiceItem extends StatefulWidget {
  const MessageMorphChoiceItem({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.isGold,
    required this.cId,
  });

  final ConstructIdentifier cId;
  final void Function() onTap;
  final bool isSelected;
  final bool? isGold;

  @override
  MessageMorphChoiceItemState createState() => MessageMorphChoiceItemState();
}

class MessageMorphChoiceItemState extends State<MessageMorphChoiceItem> {
  bool _isHovered = false;

  @override
  void didUpdateWidget(covariant MessageMorphChoiceItem oldWidget) {
    if (oldWidget.isSelected != widget.isSelected ||
        oldWidget.isGold != widget.isGold) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> onTap() async {
    widget.onTap();
  }

  Color get _color {
    if (widget.isGold != null) {
      return widget.isGold!
          ? AppConfig.success.withAlpha((0.4 * 255).toInt())
          : AppConfig.warning.withAlpha((0.4 * 255).toInt());
    }
    if (widget.isSelected) {
      return Theme.of(context)
          .colorScheme
          .primary
          .withAlpha((0.4 * 255).toInt());
    }
    return _isHovered
        ? Theme.of(context).colorScheme.primary.withAlpha((0.2 * 255).toInt())
        : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final iconSize = FluffyThemes.isColumnMode(context) ? 32.0 : 24.0;
    final style = FluffyThemes.isColumnMode(context)
        ? Theme.of(context).textTheme.bodyLarge
        : Theme.of(context).textTheme.bodySmall;
    return InkWell(
      onHover: (isHovered) => setState(() => _isHovered = isHovered),
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            border: Border.all(
              color:
                  widget.isSelected || _isHovered ? color : Colors.transparent,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.0,
            children: [
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: MorphIcon(
                  morphFeature: MorphFeaturesEnumExtension.fromString(
                    widget.cId.category,
                  ),
                  morphTag: widget.cId.lemma,
                  size: Size(iconSize, iconSize),
                  showTooltip: false,
                ),
              ),
              Text(
                getGrammarCopy(
                      category: widget.cId.category,
                      lemma: widget.cId.lemma,
                      context: context,
                    ) ??
                    widget.cId.lemma,
                style: style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
