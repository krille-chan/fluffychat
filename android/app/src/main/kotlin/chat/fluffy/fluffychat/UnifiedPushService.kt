package chat.fluffy.fluffychat

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import org.unifiedpush.flutter.connector.UnifiedPushService as UnifiedPushConnectorService

import android.content.Context

/**
 * Reuses the FlutterEngine of the MainActivity instead of the default
 * behavior of the plugin, which starts a new FlutterEngine for push messages
 * received while the app is closed. A second engine in the same process opens
 * the database from a second isolate, which closes the database connection of
 * the other engine.
 */
class UnifiedPushService : UnifiedPushConnectorService() {
    override fun getEngine(context: Context): FlutterEngine {
        var engine = MainActivity.engine
        if (engine == null) {
            engine = MainActivity.provideEngine(context.applicationContext)
            engine.localizationPlugin.sendLocalesToFlutter(
                context.resources.configuration
            )
            engine.dartExecutor.executeDartEntrypoint(
                DartEntrypoint.createDefault()
            )
        }
        return engine
    }
}
