import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoverCopyWrapper extends StatefulWidget {
  const HoverCopyWrapper({
    super.key,
    required this.child,
    required this.rawText,
    this.iconSize = 18,
    this.innerPadding = const EdgeInsets.all(4),
  });

  final Widget child;
  final String rawText;
  final double iconSize;
  final EdgeInsets innerPadding;

  @override
  State<HoverCopyWrapper> createState() => _HoverCopyWrapperState();
}

class _HoverCopyWrapperState extends State<HoverCopyWrapper> {
  bool _hovering = false;
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.rawText));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // ★ shows pointer on hover
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          widget.child,
          Positioned(
            top: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _hovering || _copied ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Padding(
                padding: widget.innerPadding,
                child: GestureDetector(
                  onTap: _copy,
                  child: Tooltip(
                    message: _copied ? 'Copied!' : 'Copy',
                    child: Icon(
                      _copied ? Icons.check : Icons.copy,
                      size: widget.iconSize,
                      color: _copied
                          ? Colors.greenAccent
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
