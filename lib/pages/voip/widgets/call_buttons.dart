import 'package:flutter/material.dart';

class CallButton extends StatefulWidget {
  final IconData selectedIcon;
  final IconData unSelectedIcon;
  final bool selected;
  final Function onPressed;
  final bool extendedView;
  final bool doLoadingAnimation;
  const CallButton({
    super.key,
    required this.onPressed,
    required this.selectedIcon,
    required this.selected,
    required this.unSelectedIcon,
    this.extendedView = false,
    this.doLoadingAnimation = true,
  });

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (loading) return;
        setState(() {
          loading = true;
        });
        await widget.onPressed();
        setState(() {
          loading = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: widget.selected
              ? Colors.white
              : widget.extendedView
                  ? null
                  : Colors.white10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: loading && widget.doLoadingAnimation
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: widget.selected ? Colors.black : Colors.white,
                    ),
                  )
                : Icon(
                    widget.selected
                        ? widget.selectedIcon
                        : widget.unSelectedIcon,
                    color: widget.selected ? Colors.black : Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
