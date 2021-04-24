import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_screen_lock/functions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final applock = FlutterSecureStorage().read(key: SettingKeys.appLockKey);
    return FutureBuilder<String>(
      future: applock,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.data?.isNotEmpty ?? false) {
              screenLock(
                context: context,
                correctString: snapshot.data,
                didConfirmed: (_) => AppLock.of(context).didUnlock(),
                canCancel: false,
              );
            } else {
              AppLock.of(context).didUnlock();
              AppLock.of(context).disable();
            }
          });
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
