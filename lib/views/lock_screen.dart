import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FlutterSecureStorage().read(key: SettingKeys.appLockKey),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.data?.isNotEmpty ?? false) {
              showLockScreen(
                context: context,
                correctString: snapshot.data,
                onUnlocked: () => AppLock.of(context).didUnlock(),
                canBiometric: true,
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
