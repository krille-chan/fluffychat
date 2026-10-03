package chat.fluffy.fluffychat

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint

import android.content.Context
import android.content.Intent
import android.os.Bundle

class MainActivity : FlutterFragmentActivity() {

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // The engine must be cached before super.onCreate(), because a
        // restored FlutterFragment looks it up while it is attached.
        val engineIsRunning = FlutterEngineCache.getInstance().contains(ENGINE_ID)
        val deepLink = intent.data?.toString()?.takeIf { shouldHandleDeeplinking() }
        val engine = provideEngine(this, deepLink)

        // The embedding sends the deep link of the launch intent only when it
        // starts the engine itself, which it never does for a cached engine.
        val isNewLaunch = savedInstanceState == null &&
            (intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) == 0
        if (engineIsRunning && deepLink != null && isNewLaunch) {
            engine.navigationChannel.pushRouteInformation(deepLink)
        }

        super.onCreate(savedInstanceState)
    }

    // A cached engine is not destroyed together with the activity, so that
    // the activity can be opened again and push messages are still processed.
    override fun getCachedEngineId(): String = ENGINE_ID

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // do nothing, because the engine was been configured in provideEngine
    }

    companion object {
        private const val ENGINE_ID = "main"

        /**
         * Returns the running FlutterEngine of the app or starts it. There
         * must be only one engine, because a second engine in the same process
         * opens the database from a second isolate, which closes the database
         * connection of the other engine.
         */
        fun provideEngine(context: Context, initialRoute: String? = null): FlutterEngine {
            val cache = FlutterEngineCache.getInstance()
            cache.get(ENGINE_ID)?.let { return it }

            val engine = FlutterEngine(context.applicationContext, emptyArray(), true, false)
            engine.localizationPlugin.sendLocalesToFlutter(
                context.resources.configuration
            )
            initialRoute?.let { engine.navigationChannel.setInitialRoute(it) }
            engine.dartExecutor.executeDartEntrypoint(DartEntrypoint.createDefault())
            cache.put(ENGINE_ID, engine)
            return engine
        }
    }
}
