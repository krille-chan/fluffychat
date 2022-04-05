package chat.fluffy.fluffychat

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import org.unifiedpush.flutter.connector.UnifiedPushReceiver

import android.content.Context

class UnifiedPushReceiver : UnifiedPushReceiver() {
    override fun getEngine(context: Context): FlutterEngine {
        var engine = MainActivity.engine
        if (engine == null) {
            engine = MainActivity.provideEngine(context)
            engine.localizationPlugin.sendLocalesToFlutter(
                context.resources.configuration
            )
            engine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        }
        return engine
    }
}