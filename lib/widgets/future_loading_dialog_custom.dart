import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import 'notifier_state.dart';

// ShowDialogLoading widget with message content updated with ChangeNotifier
class CustomLoadingDialog<T> extends StatefulWidget {
  final Future<T> Function() future;

  const CustomLoadingDialog({
    super.key,
    required this.future,
  });

  @override
  State<CustomLoadingDialog<T>> createState() => _CustomLoadingDialogState<T>();
}

class _CustomLoadingDialogState<T> extends State<CustomLoadingDialog<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.future();
  }

  @override
  Widget build(BuildContext context) {
    final notifierMessage =
        Provider.of<ConnectionStateModel>(context, listen: true);

    return AlertDialog(
      content: FutureBuilder<T>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Logs().v(
                "ChangeNotifier loading: ${notifierMessage.connectionTitle}");
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                notifierMessage.loading
                    ? const CircularProgressIndicator.adaptive()
                    : const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 40,
                      ),
                const SizedBox(height: 20),
                Text(
                  notifierMessage.connectionTitle ??
                      L10n.of(context)!.loadingPleaseWait,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                ),
                const SizedBox(height: 20),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            Navigator.of(context).pop(snapshot.data);
            return const SizedBox
                .shrink(); // To return any widget here as required
          }
        },
      ),
    );
  }
}

Future<T?> showCustomLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() future,
  String? title,
}) async {
  return await showDialog<T>(
    context: context,
    builder: (context) => CustomLoadingDialog<T>(
      future: future,
    ),
  );
}
