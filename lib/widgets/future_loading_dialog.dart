import 'dart:async';

import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';

/// Displays a loading dialog which reacts to the given [future]. The dialog
/// will be dismissed and the value will be returned when the future completes.
/// If an error occured, then [onError] will be called and this method returns
/// null.
Future<Result<T>> showFutureLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() future,
  String? title,
  String? backLabel,
  bool barrierDismissible = false,
  bool delay = true,
  ExceptionContext? exceptionContext,
  bool ignoreError = false,
  // #Pangea
  Object? Function(Object, StackTrace?)? onError,
  String? Function()? onSuccess,
  VoidCallback? onDismiss,
  // Pangea#
}) async {
  final futureExec = future();
  final resultFuture = ResultFuture(futureExec);

  if (delay) {
    var i = 3;
    while (i > 0) {
      final result = resultFuture.result;
      if (result != null) {
        if (result.isError) break;
        return result;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      i--;
    }
  }

  // #Pangea
  if (context.mounted) {
    // Pangea#
    final result = await showAdaptiveDialog<Result<T>>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => LoadingDialog<T>(
        future: futureExec,
        title: title,
        backLabel: backLabel,
        exceptionContext: exceptionContext,
        // #Pangea
        onError: onError,
        onDismiss: onDismiss,
        onSuccess: onSuccess,
        // Pangea#
      ),
    );
    return result ??
        Result.error(
          Exception('FutureDialog canceled'),
          StackTrace.current,
        );
  }

  // #Pangea
  return Result.error(
    Exception('FutureDialog canceled'),
    StackTrace.current,
  );
  // Pangea#
}

class LoadingDialog<T> extends StatefulWidget {
  final String? title;
  final String? backLabel;
  final Future<T> future;
  final ExceptionContext? exceptionContext;
  // #Pangea
  final Object? Function(Object, StackTrace?)? onError;
  final String? Function()? onSuccess;
  final VoidCallback? onDismiss;
  // Pangea#

  const LoadingDialog({
    super.key,
    required this.future,
    this.title,
    this.backLabel,
    this.exceptionContext,
    // #Pangea
    this.onError,
    this.onSuccess,
    this.onDismiss,
    // Pangea#
  });

  @override
  LoadingDialogState<T> createState() => LoadingDialogState<T>();
}

class LoadingDialogState<T> extends State<LoadingDialog> {
  Object? exception;
  StackTrace? stackTrace;
  // #Pangea
  Object? _result;
  String? _successMessage;
  // Pangea#

  @override
  void initState() {
    super.initState();
    // #Pangea
    // widget.future.then(
    //   (result) => Navigator.of(context).pop<Result<T>>(Result.value(result)),
    //   onError: (e, s) => setState(() {
    //     exception = e;
    //     stackTrace = s;
    //   }),
    // );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.future.then(
        (result) {
          if (mounted && widget.onSuccess != null) {
            _successMessage = widget.onSuccess!();
            _result = result;
            setState(() {});
          } else if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop<Result<T>>(Result.value(result));
          }
        },
        onError: (e, s) {
          if (mounted) {
            setState(() {
              exception = widget.onError?.call(e, s) ?? e;
              stackTrace = s;
            });
          }
        },
      ),
    );
    // Pangea#
  }

  @override
  Widget build(BuildContext context) {
    final exception = this.exception;
    // #Pangea
    // final titleLabel = exception != null
    //     ? exception.toLocalizedString(context, widget.exceptionContext)
    //     : widget.title ?? L10n.of(context).loadingPleaseWait;
    final titleLabel = exception != null
        ? exception.toLocalizedString(context, widget.exceptionContext)
        : _successMessage ?? widget.title ?? L10n.of(context).loadingPleaseWait;
    // Pangea#

    return AlertDialog.adaptive(
      title: exception == null
          ? null
          : Icon(
              Icons.error_outline_outlined,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // #Pangea
            // if (exception == null) ...[
            if (exception == null && _successMessage == null) ...[
              // Pangea#
              const CircularProgressIndicator.adaptive(),
              const SizedBox(width: 20),
            ],
            Expanded(
              child: Text(
                titleLabel,
                maxLines: 4,
                // #Pangea
                // textAlign: exception == null ? TextAlign.left : null,
                textAlign: exception == null && _successMessage == null
                    ? TextAlign.left
                    : null,
                // Pangea#
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // #Pangea
      // actions: exception == null
      //     ? null
      //     : [
      //         AdaptiveDialogAction(
      //           onPressed: () => Navigator.of(context).pop<Result<T>>(
      //             Result.error(
      //               exception,
      //               stackTrace,
      //             ),
      //           ),
      //           child: Text(widget.backLabel ?? L10n.of(context).close),
      //         ),
      //       ],
      actions: _successMessage != null
          ? [
              AdaptiveDialogAction(
                onPressed: () => Navigator.of(context).pop<Result<T>>(
                  Result.value(_result as T),
                ),
                child: Text(L10n.of(context).close),
              ),
            ]
          : exception == null
              ? widget.onDismiss != null
                  ? [
                      AdaptiveDialogAction(
                        onPressed: () {
                          widget.onDismiss!();
                          Navigator.of(context).pop();
                        },
                        child: Text(L10n.of(context).cancel),
                      ),
                    ]
                  : null
              : [
                  AdaptiveDialogAction(
                    onPressed: () => Navigator.of(context).pop<Result<T>>(
                      Result.error(
                        exception,
                        stackTrace,
                      ),
                    ),
                    child: Text(widget.backLabel ?? L10n.of(context).close),
                  ),
                ],
      // Pangea#
    );
  }
}

extension DeprecatedApiAccessExtension<T> on Result<T> {
  T? get result => asValue?.value;

  Object? get error => asError?.error;
}
