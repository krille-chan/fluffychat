import 'package:flutter/material.dart';

class SearchTitle extends StatelessWidget {
  final String title;
  final Widget icon;
  final Widget? trailing;
  final void Function()? onTap;
  final Color? color;

  const SearchTitle({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        shape: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        color: color ?? Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          splashColor: Theme.of(context).colorScheme.surface,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: IconTheme(
                data: Theme.of(context).iconTheme.copyWith(size: 16),
                child: Row(
                  children: [
                    icon,
                    const SizedBox(width: 16),
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (trailing != null)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: trailing!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
