package chat.fluffy.fluffychat

import io.flutter.embedding.engine.FlutterEngine
import android.content.Context

// Replaces the service of the unifiedpush plugin so that it does not spawn its
// own FlutterEngine (and isolate) but uses the one of the app.
// https://codeberg.org/UnifiedPush/flutter-connector/src/branch/main/unifiedpush_android/android/src/main/kotlin/org/unifiedpush/flutter/connector/UnifiedPushService.kt#L17-L32
class UnifiedPushService : org.unifiedpush.flutter.connector.UnifiedPushService() {
    override fun getEngine(context: Context): FlutterEngine {
        return MainActivity.provideRunningEngine(getApplicationContext())
    }
}
