import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/lock_screen.dart';

class AppLockWidget extends StatefulWidget {
  const AppLockWidget({
    required this.child,
    required this.pincode,
    super.key,
  });

  final String? pincode;
  final Widget child;

  @override
  State<AppLockWidget> createState() => AppLock();
}

class AppLock extends State<AppLockWidget> with WidgetsBindingObserver {
  String? _pincode;
  bool _isLocked = false;
  bool get isActive => _pincode != null;

  @override
  void initState() {
    _pincode = widget.pincode;
    _isLocked = widget.pincode != null;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (isActive && state == AppLifecycleState.hidden && !_isLocked) {
      setState(() {
        _isLocked = true;
      });
    }
  }

  bool get isLocked => _isLocked;
  CrossFadeState get _crossFadeState =>
      _isLocked ? CrossFadeState.showSecond : CrossFadeState.showFirst;

  Future<void> changePincode(String? pincode) async {
    await const FlutterSecureStorage().write(
      key: SettingKeys.appLockKey,
      value: pincode,
    );
    _pincode = pincode;
    return;
  }

  bool unlock(String pincode) {
    final isCorrect = pincode == _pincode;
    if (isCorrect) {
      setState(() {
        _isLocked = false;
      });
    }
    return isCorrect;
  }

  void showLockScreen() => setState(() {
        _isLocked = true;
      });

  static AppLock of(BuildContext context) => Provider.of<AppLock>(
        context,
        listen: false,
      );

  @override
  Widget build(BuildContext context) => Provider<AppLock>(
        create: (_) => this,
        child: AnimatedCrossFade(
          firstChild: widget.child,
          secondChild: const LockScreen(),
          crossFadeState: _crossFadeState,
          duration: FluffyThemes.animationDuration,
        ),
      );
}
