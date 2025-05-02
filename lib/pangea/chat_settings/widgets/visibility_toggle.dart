import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class VisibilityToggle extends StatefulWidget {
  final Room room;
  final Color? iconColor;
  final Future<void> Function(matrix.Visibility) setVisibility;
  final Future<void> Function(JoinRules) setJoinRules;

  const VisibilityToggle({
    required this.setVisibility,
    required this.setJoinRules,
    required this.room,
    this.iconColor,
    super.key,
  });

  @override
  State<VisibilityToggle> createState() => VisibilityToggleState();
}

class VisibilityToggleState extends State<VisibilityToggle> {
  Room get room => widget.room;

  bool get _isPublic => room.joinRules == matrix.JoinRules.public;

  matrix.Visibility? _visibility;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getVisibility();
  }

  Future<void> _getVisibility() async {
    try {
      final resp = await Matrix.of(context).client.getRoomVisibilityOnDirectory(
            room.id,
          );
      _visibility = resp ?? matrix.Visibility.private;
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _setVisibility(matrix.Visibility visibility) async {
    try {
      await widget.setVisibility(visibility);
      _visibility = visibility;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile.adaptive(
          activeColor: AppConfig.activeToggleColor,
          title: Text(
            L10n.of(context).requireCodeToJoin,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          secondary: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: widget.iconColor,
            child: const Icon(Icons.key_outlined),
          ),
          value: !_isPublic,
          onChanged: (value) =>
              widget.setJoinRules(value ? JoinRules.knock : JoinRules.public),
        ),
        ListTile(
          title: Text(
            L10n.of(context).canFindInSearch,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: widget.iconColor,
            child: const Icon(Icons.search_outlined),
          ),
          onTap: _visibility != null
              ? () => showFutureLoadingDialog(
                    future: () async {
                      _setVisibility(
                        _visibility == matrix.Visibility.public
                            ? matrix.Visibility.private
                            : matrix.Visibility.public,
                      );
                    },
                    context: context,
                  )
              : null,
          trailing: _loading || _error != null
              ? SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: _error != null
                      ? Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.error,
                        )
                      : const CircularProgressIndicator.adaptive(),
                )
              : Switch.adaptive(
                  activeColor: AppConfig.activeToggleColor,
                  value: _visibility == matrix.Visibility.public,
                  onChanged: (value) => showFutureLoadingDialog(
                    future: () async {
                      _setVisibility(
                        value
                            ? matrix.Visibility.public
                            : matrix.Visibility.private,
                      );
                    },
                    context: context,
                  ),
                ),
        ),
      ],
    );
  }
}
