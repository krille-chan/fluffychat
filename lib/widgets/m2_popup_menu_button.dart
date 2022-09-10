import 'package:flutter/material.dart';

class M2PopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final T? initialValue;
  final void Function(T)? onSelected;
  final void Function()? onCanceled;
  final Widget? icon;
  final Color? color;
  final Widget? child;

  const M2PopupMenuButton({
    Key? key,
    required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.icon,
    this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        useMaterial3: false,
        popupMenuTheme: PopupMenuThemeData(
          color: theme.colorScheme.surface,
          elevation: theme.appBarTheme.scrolledUnderElevation,
          textStyle: theme.textTheme.bodyText1,
        ),
      ),
      child: PopupMenuButton<T>(
        itemBuilder: itemBuilder,
        initialValue: initialValue,
        onSelected: onSelected,
        onCanceled: onCanceled,
        icon: icon,
        color: color,
        child: child,
      ),
    );
  }
}
