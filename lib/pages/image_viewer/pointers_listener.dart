// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:material_ui/material_ui.dart';

class PointersListener extends StatefulWidget {
  final Function(BuildContext context, bool moreThanOnePointer) builder;

  const PointersListener({super.key, required this.builder});

  @override
  State<PointersListener> createState() => _PointersListenerState();
}

class _PointersListenerState extends State<PointersListener> {
  final Set<int> _touchIndexes = {};

  bool get _moreThanOnePointer => _touchIndexes.length > 1;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _savePointerIndex(event.pointer);
      },
      onPointerMove: (event) {
        _savePointerIndex(event.pointer);
      },
      onPointerCancel: (event) {
        _clearPointerIndex(event.pointer);
      },
      onPointerUp: (event) {
        _clearPointerIndex(event.pointer);
      },
      child: widget.builder(context, _moreThanOnePointer),
    );
  }

  void _savePointerIndex(int index) {
    _actionHandler(() => _touchIndexes.add(index));
  }

  void _clearPointerIndex(int index) {
    _actionHandler(() => _touchIndexes.remove(index));
  }

  void _actionHandler(VoidCallback action) {
    final prev = _moreThanOnePointer;

    action();

    final next = _moreThanOnePointer;

    if (prev != next) {
      setState(() {});
    }
  }
}
