import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showModalActionPopup<T>({
  required BuildContext context,
  required List<AdaptiveModalAction<T>> actions,
  String? title,
  String? message,
  String? cancelLabel,
  bool useRootNavigator = true,
}) {
  final theme = Theme.of(context);

  switch (theme.platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: useRootNavigator,
        context: context,
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(
          maxWidth: 512,
          maxHeight: MediaQuery.of(context).size.height - 32,
        ),
        builder: (context) => ListView(
          shrinkWrap: true,
          children: [
            if (title != null || message != null) ...[
              ListTile(
                title: title == null
                    ? null
                    : Text(
                        title,
                        style: theme.textTheme.labelSmall,
                      ),
                subtitle: message == null ? null : Text(message),
              ),
              const Divider(height: 1),
            ],
            ...actions.map(
              (action) => ListTile(
                leading: action.icon,
                title: Text(
                  action.label,
                  maxLines: 1,
                  style: action.isDestructive
                      ? TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight:
                              action.isDefaultAction ? FontWeight.bold : null,
                        )
                      : null,
                ),
                onTap: () => Navigator.of(context).pop<T>(action.value),
              ),
            ),
            if (cancelLabel != null) ...[
              const Divider(height: 1),
              ListTile(
                title: Text(cancelLabel),
                onTap: () => Navigator.of(context).pop(null),
              ),
            ],
          ],
        ),
      );
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return showCupertinoModalPopup<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (context) => ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: CupertinoActionSheet(
            title: title == null ? null : Text(title),
            message: message == null ? null : Text(message),
            cancelButton: cancelLabel == null
                ? null
                : CupertinoActionSheetAction(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: Text(cancelLabel),
                  ),
            actions: actions
                .map(
                  (action) => CupertinoActionSheetAction(
                    isDestructiveAction: action.isDestructive,
                    isDefaultAction: action.isDefaultAction,
                    onPressed: () => Navigator.of(context).pop<T>(action.value),
                    child: Text(action.label, maxLines: 1),
                  ),
                )
                .toList(),
          ),
        ),
      );
  }
}

class AdaptiveModalAction<T> {
  final String label;
  final T value;
  Icon? icon;
  final bool isDefaultAction;
  final bool isDestructive;

  AdaptiveModalAction({
    required this.label,
    required this.value,
    this.icon,
    this.isDefaultAction = false,
    this.isDestructive = false,
  });
}
