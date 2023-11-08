# fcm_shared_isolate

Firebase Messaging Plugin for Flutter supporting shared isolate

## Installing the library
After adding the library to your `pubspec.yaml` do the following things:

1. Modify the main activity on the android side of your app to look like the following
   (typically in `android/app/src/main/kotlin/your/app/id/MainActivity.kt`):

```kotlin
package your.app.id

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.WindowManager

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    };

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return provideEngine(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // do nothing, because the engine was been configured in provideEngine
    }

    companion object {
        var engine: FlutterEngine? = null
        fun provideEngine(context: Context): FlutterEngine {
            var eng = engine ?: FlutterEngine(context, emptyArray(), true, false)
            engine = eng
            return eng
        }
    }
```

2. Add an `FcmPushService` (typically in `android/app/src/main/kotlin/your/app/id/FcmPushService.kt`)

```kotlin
package your.app.id

import com.famedly.fcm_shared_isolate.FcmSharedIsolateService

import your.app.id.MainActivity

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.view.FlutterMain
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.WindowManager

class FcmPushService : FcmSharedIsolateService() {
    override fun getEngine(): FlutterEngine {
        return provideEngine(getApplicationContext())
    }

    companion object {
        fun provideEngine(context: Context): FlutterEngine {
            var engine = MainActivity.engine
            if (engine == null) {
                engine = MainActivity.provideEngine(context)
                engine.getLocalizationPlugin().sendLocalesToFlutter(
                    context.getResources().getConfiguration())
                engine.getDartExecutor().executeDartEntrypoint(
                    DartEntrypoint.createDefault())
            }
            return engine
        }
    }
}

```

3. Add the intent filters to your `AndroidManifest.xml` (typically in `android/app/src/main/AndroidManifest.xml`):

```xml
<service android:name=".FcmPushService"
  android:exported="false">
  <intent-filter>
	<action android:name="com.google.firebase.MESSAGING_EVENT"/>
  </intent-filter>
</service>
```

Note that the `.FcmPushService` has to match the class name defined in the file above

## Usage

```dart
// Create the instance
final fcm = FcmSharedIsolate();

// Only for iOS you need to request permissions:
if (Platform.isIOS) {
    await fcm.requestPermission();
}

// Get the push token:
await fcm.getToken();

// Set the listeners
fcm.setListeners(
    onMessage: onMessage,
    onNewToken: onNewToken,
);

Future<void> onMessage(Map<dynamic, dynamic> message) async {
    print('Got a new message from firebase cloud messaging: $message');
}
```